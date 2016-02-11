require 'test_helper'

class LineupsControllerTest < ActionController::TestCase
  setup do
    @lineup = lineups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lineups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lineup" do
    assert_difference('Lineup.count') do
      post :create, lineup: { adc: @lineup.adc, contest_id: @lineup.contest_id, flex_1: @lineup.flex_1, flex_2: @lineup.flex_2, flex_3: @lineup.flex_3, jungler: @lineup.jungler, mid: @lineup.mid, support: @lineup.support, top: @lineup.top, user_id: @lineup.user_id }
    end

    assert_redirected_to lineup_path(assigns(:lineup))
  end

  test "should show lineup" do
    get :show, id: @lineup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lineup
    assert_response :success
  end

  test "should update lineup" do
    patch :update, id: @lineup, lineup: { adc: @lineup.adc, contest_id: @lineup.contest_id, flex_1: @lineup.flex_1, flex_2: @lineup.flex_2, flex_3: @lineup.flex_3, jungler: @lineup.jungler, mid: @lineup.mid, support: @lineup.support, top: @lineup.top, user_id: @lineup.user_id }
    assert_redirected_to lineup_path(assigns(:lineup))
  end

  test "should destroy lineup" do
    assert_difference('Lineup.count', -1) do
      delete :destroy, id: @lineup
    end

    assert_redirected_to lineups_path
  end
end
