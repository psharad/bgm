require 'test_helper'

class HeightsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:heights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create height" do
    assert_difference('Height.count') do
      post :create, :height => { }
    end

    assert_redirected_to height_path(assigns(:height))
  end

  test "should show height" do
    get :show, :id => heights(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => heights(:one).to_param
    assert_response :success
  end

  test "should update height" do
    put :update, :id => heights(:one).to_param, :height => { }
    assert_redirected_to height_path(assigns(:height))
  end

  test "should destroy height" do
    assert_difference('Height.count', -1) do
      delete :destroy, :id => heights(:one).to_param
    end

    assert_redirected_to heights_path
  end
end
