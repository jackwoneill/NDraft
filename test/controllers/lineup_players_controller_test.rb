require 'test_helper'

class LineupPlayersControllerTest < ActionController::TestCase
  setup do
    @lineup_player = lineup_players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lineup_players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lineup_player" do
    assert_difference('LineupPlayer.count') do
      post :create, lineup_player: { lineup_id: @lineup_player.lineup_id, player_id: @lineup_player.player_id }
    end

    assert_redirected_to lineup_player_path(assigns(:lineup_player))
  end

  test "should show lineup_player" do
    get :show, id: @lineup_player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lineup_player
    assert_response :success
  end

  test "should update lineup_player" do
    patch :update, id: @lineup_player, lineup_player: { lineup_id: @lineup_player.lineup_id, player_id: @lineup_player.player_id }
    assert_redirected_to lineup_player_path(assigns(:lineup_player))
  end

  test "should destroy lineup_player" do
    assert_difference('LineupPlayer.count', -1) do
      delete :destroy, id: @lineup_player
    end

    assert_redirected_to lineup_players_path
  end
end
