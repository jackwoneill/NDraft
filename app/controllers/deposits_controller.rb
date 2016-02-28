class DepositsController < ApplicationController
  require 'paypal-sdk-rest'
  require 'json'
  include PayPal::SDK::REST

  before_action :set_deposit, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin, except: [:new, :verify]
  skip_before_filter :authenticate_user!, only: :ipn

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

    PayPal::SDK.configure({
      :mode => "sandbox",
      :client_id => "AUoxo6GUZgd97HRGOeZlskhpURkTgR3VEYcowjTjyxFbPf6BSwIdcQjBe_RkU4b8DtxJxT3B2bFaEp0b",
      :client_secret => "ENMJrALA4a0P9CysZBRiWn-aOkQn0DGw7pJQhYCcLPW9azzmVLF8N1eUsxvHWBBhooPh5KZFk-PnT2Mk"
    })

    # :return_url => "https://devtools-paypal.com/guide/pay_paypal/ruby?success=true",
    # :cancel_url => "https://devtools-paypal.com/guide/pay_paypal/ruby?cancel=true" 


    @payment = PayPal::SDK::REST::Payment.new({
      :intent => "sale",
      :payer => {
        :payment_method => "paypal" },
      :redirect_urls => {
        :return_url => "http://aqueous-wave-13758.herokuapp.com/deposits/verify",
        :cancel_url => "https://devtools-paypal.com/guide/pay_paypal/ruby?cancel=true" },
      :transactions => [ {
        :amount => {
          :total => "12",
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
    end  

  end

  # GET /deposits/1/edit
  def edit
  end

  def verify
    print("mool")
    pay_id = params[:paymentId]
    p_payer_id = params[:PayerID]
    print("pay_id=#{pay_id}")
    print("payer_id=#{p_payer_id}")

    #deposit = Deposit.where(payment_id: pay_id).where(user_id: current_user.id).where(completed: false)
    #puts deposit.id
    @payment = PayPal::SDK::REST::Payment.new({
      :paymentId => "#{pay_id}"})

    puts "lool"
    puts "yzy"

    if @payment.execute( :payer_id => "#{p_payer_id}" )
      print("ay we made it")
    else
      @payment.error
    end
      # deposit.completed = true
      # deposit.save
    print("a")

  end

  # POST /deposits
  # POST /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)
    @deposit.user_id = current_user.id

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to @deposit, notice: 'Deposit was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { render :new }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
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
