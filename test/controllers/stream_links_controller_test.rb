require 'test_helper'

class StreamLinksControllerTest < ActionController::TestCase
  setup do
    @stream_link = stream_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stream_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stream_link" do
    assert_difference('StreamLink.count') do
      post :create, stream_link: { slate_id: @stream_link.slate_id, url: @stream_link.url }
    end

    assert_redirected_to stream_link_path(assigns(:stream_link))
  end

  test "should show stream_link" do
    get :show, id: @stream_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stream_link
    assert_response :success
  end

  test "should update stream_link" do
    patch :update, id: @stream_link, stream_link: { slate_id: @stream_link.slate_id, url: @stream_link.url }
    assert_redirected_to stream_link_path(assigns(:stream_link))
  end

  test "should destroy stream_link" do
    assert_difference('StreamLink.count', -1) do
      delete :destroy, id: @stream_link
    end

    assert_redirected_to stream_links_path
  end
end
