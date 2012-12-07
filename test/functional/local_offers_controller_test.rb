require 'test_helper'

class LocalOffersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:local_offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create local_offer" do
    assert_difference('LocalOffer.count') do
      post :create, :local_offer => { }
    end

    assert_redirected_to local_offer_path(assigns(:local_offer))
  end

  test "should show local_offer" do
    get :show, :id => local_offers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => local_offers(:one).to_param
    assert_response :success
  end

  test "should update local_offer" do
    put :update, :id => local_offers(:one).to_param, :local_offer => { }
    assert_redirected_to local_offer_path(assigns(:local_offer))
  end

  test "should destroy local_offer" do
    assert_difference('LocalOffer.count', -1) do
      delete :destroy, :id => local_offers(:one).to_param
    end

    assert_redirected_to local_offers_path
  end
end
