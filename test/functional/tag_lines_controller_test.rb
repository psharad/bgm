require 'test_helper'

class TagLinesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tag_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag_line" do
    assert_difference('TagLine.count') do
      post :create, :tag_line => { }
    end

    assert_redirected_to tag_line_path(assigns(:tag_line))
  end

  test "should show tag_line" do
    get :show, :id => tag_lines(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tag_lines(:one).to_param
    assert_response :success
  end

  test "should update tag_line" do
    put :update, :id => tag_lines(:one).to_param, :tag_line => { }
    assert_redirected_to tag_line_path(assigns(:tag_line))
  end

  test "should destroy tag_line" do
    assert_difference('TagLine.count', -1) do
      delete :destroy, :id => tag_lines(:one).to_param
    end

    assert_redirected_to tag_lines_path
  end
end
