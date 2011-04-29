require 'test_helper'

class BamToFamFeaturesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BamToFamFeature.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BamToFamFeature.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BamToFamFeature.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bam_to_fam_feature_url(assigns(:bam_to_fam_feature))
  end

  def test_edit
    get :edit, :id => BamToFamFeature.first
    assert_template 'edit'
  end

  def test_update_invalid
    BamToFamFeature.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BamToFamFeature.first
    assert_template 'edit'
  end

  def test_update_valid
    BamToFamFeature.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BamToFamFeature.first
    assert_redirected_to bam_to_fam_feature_url(assigns(:bam_to_fam_feature))
  end

  def test_destroy
    bam_to_fam_feature = BamToFamFeature.first
    delete :destroy, :id => bam_to_fam_feature
    assert_redirected_to bam_to_fam_features_url
    assert !BamToFamFeature.exists?(bam_to_fam_feature.id)
  end
end
