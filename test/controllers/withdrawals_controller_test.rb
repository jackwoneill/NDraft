require 'test_helper'

class WithdrawalsControllerTest < ActionController::TestCase
  setup do
    @withdrawal = withdrawals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:withdrawals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create withdrawal" do
    assert_difference('Withdrawal.count') do
      post :create, withdrawal: { amount: @withdrawal.amount, completed: @withdrawal.completed, user_id: @withdrawal.user_id }
    end

    assert_redirected_to withdrawal_path(assigns(:withdrawal))
  end

  test "should show withdrawal" do
    get :show, id: @withdrawal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @withdrawal
    assert_response :success
  end

  test "should update withdrawal" do
    patch :update, id: @withdrawal, withdrawal: { amount: @withdrawal.amount, completed: @withdrawal.completed, user_id: @withdrawal.user_id }
    assert_redirected_to withdrawal_path(assigns(:withdrawal))
  end

  test "should destroy withdrawal" do
    assert_difference('Withdrawal.count', -1) do
      delete :destroy, id: @withdrawal
    end

    assert_redirected_to withdrawals_path
  end
end
