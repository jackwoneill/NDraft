class DepositsController < ApplicationController
  require 'paypal-sdk-rest'
  require 'json'
  include PayPal::SDK::REST


  before_action :set_deposit, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin, only: [:index, :show]


  # GET /deposits
  # GET /deposits.json
  def index
    @deposits = Deposit.all
    
  end

  # GET /deposits/1
  # GET /deposits/1.json
  def show
  end

  # GET /deposits/new
  def new
    @deposit = Deposit.new

  end

  # GET /deposits/1/edit
  # def edit
  # end

  def verify
    deposit = Deposit.where(user_id: current_user.id).where(completed: false).where(payment_id: params[:paymentId]).first
    if !deposit.nil?
      @payment = PayPal::SDK::REST::Payment.find("#{deposit.payment_id}")

      if ((@payment.transactions[0].amount.total).to_f == deposit.amount) 
        if @payment.execute( :payer_id => "#{params[:PayerID]}" )
          #PAYMENT WILL ONLY EXECUTE IF IT IS APPROVED ON PAYPALS END
          deposit.completed = true
          current_user.balance += deposit.amount
          bal = Balance.where(user_id: current_user.id).take
          bal.amount += deposit.amount

          deposit.save
          current_user.save
          bal.save

          redirect_to contests_path and return
        end
        
      end
    end

  end

  # POST /deposits
  # POST /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)

    if @deposit.amount < 5

      redirect_to :back, notice: "Sorry! Unfortunately we can't accept deposits of less than $5.00" and return
    
    end

    if @deposit.amount > 1000

      redirect_to :back, notice: "Sorry! Unfortunately we can't accept increments of greater than $1000.00" and return
    
    end
    #@deposit.user_id = current_user.id

    PayPal::SDK.configure({
      :mode => "sandbox",
      :client_id => "",
      :client_secret => ""
    })

    @payment = PayPal::SDK::REST::Payment.new({
        :intent => "sale",
        "experience_profile_id": "",
        :payer => {
          :payment_method => "paypal" },
        :redirect_urls => {
          :return_url => "http://dfsesports.herokuapp.com/deposits/verify",
          :cancel_url => "http://dfsesports.herokuapp.com/deposits/new" },
        :transactions => [ {
          :item_list => { 
            :items => [{
              :name => "$#{@deposit.amount} Deposit",
              :sku => "10001",
              :price => "#{@deposit.amount}",
              :currency => "USD",
              :quantity => 1 } ] },
          :amount => {
            :total => "#{@deposit.amount}",
            :currency => "USD" },
          :description => "creating a payment" } ] } )

    if @payment.create
      @deposit.payment_id = @payment.id
      @deposit.user_id = current_user.id
      @deposit.completed = false

      @deposit.save

      redirect_to @payment.links[1].href and return
    else
      @payment.error  # Error Hash
      redirect_to new_deposit_path
    end  


  end

  # PATCH/PUT /deposits/1
  # PATCH/PUT /deposits/1.json
  def update
    respond_to do |format|
      if @deposit.update(deposit_params)
        format.html { redirect_to @deposit, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposit }
      else
        format.html { render :edit }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1
  # DELETE /deposits/1.json
  def destroy
    @deposit.destroy
    respond_to do |format|
      format.html { redirect_to deposits_url, notice: 'Deposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposit
      @deposit = Deposit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deposit_params
      params.require(:deposit).permit(:amount, :user_id)
    end
end
