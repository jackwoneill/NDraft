require 'test_helper'

class SlatesControllerTest < ActionController::TestCase
  setup do
    @slate = slates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create slate" do
    assert_difference('Slate.count') do
      post :create, slate: { name: @slate.name, start_time: @slate.start_time }
    end

    assert_redirected_to slate_path(assigns(:slate))
  end

  test "should show slate" do
    get :show, id: @slate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @slate
    assert_response :success
  end

  test "should update slate" do
    patch :update, id: @slate, slate: { name: @slate.name, start_time: @slate.start_time }
    assert_redirected_to slate_path(assigns(:slate))
  end

  test "should destroy slate" do
    assert_difference('Slate.count', -1) do
      delete :destroy, id: @slate
    end

    assert_redirected_to slates_path
  end
end
