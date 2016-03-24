class WithdrawalsController < ApplicationController
  before_action :set_withdrawal, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_admin, only: [:edit, :update, :destroy]

  # GET /withdrawals
  # GET /withdrawals.json
  def index
    if current_user.permissions == 2
      @withdrawals = Withdrawal.order(completed: "DESC")
    else
      @withdrawals = Withdrawal.where(user_id: current_user.id)
    end
  end

  # GET /withdrawals/1
  # GET /withdrawals/1.json
  def show
    if current_user.permissions == 2
      @transactions = Transaction.where(user_id: @withdrawal.user_id)  
      @supposedBal = Transaction.where(user_id: @withdrawal.user_id).sum :amount
      #@email = User.find(@withdrawal.user_id).
    end
  end

  # GET /withdrawals/new
  def new
    if current_user.permissions == 2
      redirect_to withdrawals_path and return
    end
    @withdrawal = Withdrawal.new
  end

  # GET /withdrawals/1/edit
  def edit
    redirect_to new_withdrawals_path
  end

  def setCompleted
    @withdrawal.completed = true
    @withdrawal.save
    bal = (User.find(@withdrawal.user_id)).balance
    @withdrawalTrans = Transaction.new(user_id: @withdrawal.user_id, amount: 0.0, description: "WITHDRAWAL APPROVED", current_balance: bal)
  end

  # POST /withdrawals
  # POST /withdrawals.json
  def create
    @withdrawal = current_user.withdrawals.create(withdrawal_params)
    #@withdrawal = Withdrawal.new(withdrawal_params)
    @withdrawal.completed = false
    #@withdrawal.user_id = 

      #INLINE THIS PART
    if @withdrawal.amount > current_user.balance || @withdrawal.amount < 5

      redirect_to :back, notice: "You dont have that much in your account available to withdraw!" and return
    
    end


    respond_to do |format|
      if @withdrawal.save
          current_user.balance -= @withdrawal.amount
          current_user.save

          bal = Balance.where(user_id: current_user.id).take
          bal.amount -= @withdrawal.amount
          bal.save

          withdrawTrans = Transaction.new(user_id: current_user.id, amount: @withdrawal.amount, description: "Withdrawal Request for User=#{current_user.id} : #{@withdrawal.amount}", current_balance: current_user.balance)
          withdrawTrans.save

        format.html { redirect_to withdrawals_path, notice: 'Your withdrawal request has been submitted.' }
        format.json { render :show, status: :created, location: @withdrawal }
      else
        format.html { render :new }
        format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /withdrawals/1
  # PATCH/PUT /withdrawals/1.json
  def update
    respond_to do |format|
      if @withdrawal.update(withdrawal_params)
        format.html { redirect_to @withdrawal, notice: 'Withdrawal was successfully updated.' }
        format.json { render :show, status: :ok, location: @withdrawal }
      else
        format.html { render :edit }
        format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /withdrawals/1
  # DELETE /withdrawals/1.json
  def destroy
    @withdrawal.destroy
    respond_to do |format|
      format.html { redirect_to withdrawals_url, notice: 'Withdrawal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_withdrawal
      @withdrawal = Withdrawal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def withdrawal_params
      params.require(:withdrawal).permit(:user_id, :amount, :completed)
    end
end
