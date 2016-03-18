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
    @payment = PayPal::SDK::REST::Payment.find("#{deposit.payment_id}")

    #ENSURE AMOUNt PAID WAS AMOUNT CLAIMED TO BE DEPOSITED
    if (@payment.amount == deposit.amount)
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
    

    #@payment.execute( :payer_id => "M8QH3DSTB4WX4" ) # GET PAYMENT INFO FROM DATABASE
  # Retrieve the payment object by calling the
  # `find` method
  # on the Payment class by passing Payment ID

    #Change to use ipn and not execute payment in here
    #Create ipn that does the payment execution after webhook
    #Create a verify that takes the payment id and checks if it has been executed("state:executed -> See paypal for other states")
    #In ipn grab paypal transaction information and ensure deposit amount is same as when it was created
    #In verify maybe just do a bunch of checks against system to ensure everything good
    #Or just use verify as a confirmation page?

  end

  # POST /deposits
  # POST /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)
    #@deposit.user_id = current_user.id

    PayPal::SDK.configure({
      :mode => "sandbox",
      :client_id => "AbX1ZA9XsdUGnVRNDJwvyzURE9BLbmDAuM1DxExjvJDEgAVdNMHZXUP_IOnGnZVqOL6_s0PlQ2yBSy7p",
      :client_secret => "ECTW0SNazTtQPF7pO7jB0v8xLOQhPv6wWZXGaTDyQr0sIwQUAlqCrsuQB-NqFjT2DC6p0TwmoZj4N3n-"
    })
    web_profile = PayPal::SDK::REST::WebProfile.find("XP-3W7L-S5BX-ETUY-J8W2")
    if web_profile.delete
      @payment = PayPal::SDK::REST::Payment.new({
          :intent => "sale",
          "experience_profile_id": "XP-QXNH-VK3M-M48R-BD7N",

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

      print("Web Profile[%s] created successfully" % (web_profile.id))
    else
      print "error"
    end


  end

  def webhookIPN
    pay_id = params[:paymentId]
    p_payer_id = params[:PayerID]
    print("pay_id=#{pay_id}")
    print("payer_id=#{p_payer_id}")

    #puts deposit.id
    @payment = PayPal::SDK::REST::Payment.find(pay_id)
    puts @payment.state
    puts "STATE PRIOR"
    @deposit = Deposit.where(payment_id: @payment.id)
    if @deposit.completed == false
      if @payment.execute( :payer_id => "#{p_payer_id}" )
        user = User.find(@deposit.user_id)
        user.balance += @payment.transactions[0].amount.total
        user.save

        balance = Balance.where(user_id: @deposit.user_id).first
        balance.amount += @payment.transactions[0].amount.total
        balance.save
       
        @deposit.completed = true
        @deposit.save

        puts @payment.transactions[0].amount.total
      else
        @payment.error
      end
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
