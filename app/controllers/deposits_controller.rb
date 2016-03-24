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
      print "lool"
      print "#{(@payment.transactions[0].amount.total).to_f}"
      #ENSURE AMOUNt PAID WAS AMOUNT CLAIMED TO BE DEPOSITED



      #STRING FLOAT COMPARISON HERE, PRINT IT JUST TO BE SURE THO
      if ((@payment.transactions[0].amount.total).to_f == deposit.amount) #LIKELY DIFFERENCE IN STRING->FLOAT COMPARISON
        print "in hur"
        if @payment.execute( :payer_id => "#{params[:PayerID]}" )
          "print executed"
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

    if @deposit.amount < 1000

      redirect_to :back, notice: "Sorry! Unfortunately we can't accept increments of greater than $1000.00" and return
    
    end
    #@deposit.user_id = current_user.id

    PayPal::SDK.configure({
      :mode => "sandbox",
      :client_id => "AbX1ZA9XsdUGnVRNDJwvyzURE9BLbmDAuM1DxExjvJDEgAVdNMHZXUP_IOnGnZVqOL6_s0PlQ2yBSy7p",
      :client_secret => "ECTW0SNazTtQPF7pO7jB0v8xLOQhPv6wWZXGaTDyQr0sIwQUAlqCrsuQB-NqFjT2DC6p0TwmoZj4N3n-"
    })

    # web_prof = PayPal::SDK::REST::WebProfile.new({
    #   "name": "BattleDraft",
    #   "presentation": {
    #       "brand_name": "BattleDraft",
    #       "logo_image": "http://s17.postimg.org/he1udwv7z/pepe2.png",
    #       "locale_code": "US"
    #   },
    #   "input_fields": {
    #       "allow_note": false,
    #       "no_shipping": 1,
    #       "address_override": 1
    #   },
    #   "flow_config": {
    #       "landing_page_type": "billing",
    #   }
    # })
    # web_prof.create

    @payment = PayPal::SDK::REST::Payment.new({
        :intent => "sale",
        "experience_profile_id": "XP-RNK5-HFBU-6X9Q-WL5X",
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
