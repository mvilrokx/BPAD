require 'test_helper'

class BuildFeaturesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BuildFeature.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BuildFeature.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BuildFeature.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to build_feature_url(assigns(:build_feature))
  end

  def test_edit
    get :edit, :id => BuildFeature.first
    assert_template 'edit'
  end

  def test_update_invalid
    BuildFeature.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BuildFeature.first
    assert_template 'edit'
  end

  def test_update_valid
    BuildFeature.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BuildFeature.first
    assert_redirected_to build_feature_url(assigns(:build_feature))
  end

  def test_destroy
    build_feature = BuildFeature.first
    delete :destroy, :id => build_feature
    assert_redirected_to build_features_url
    assert !BuildFeature.exists?(build_feature.id)
  end
end
