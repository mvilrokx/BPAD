require 'test_helper'

class BamToFamMapsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BamToFamMap.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BamToFamMap.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BamToFamMap.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bam_to_fam_map_url(assigns(:bam_to_fam_map))
  end

  def test_edit
    get :edit, :id => BamToFamMap.first
    assert_template 'edit'
  end

  def test_update_invalid
    BamToFamMap.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BamToFamMap.first
    assert_template 'edit'
  end

  def test_update_valid
    BamToFamMap.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BamToFamMap.first
    assert_redirected_to bam_to_fam_map_url(assigns(:bam_to_fam_map))
  end

  def test_destroy
    bam_to_fam_map = BamToFamMap.first
    delete :destroy, :id => bam_to_fam_map
    assert_redirected_to bam_to_fam_maps_url
    assert !BamToFamMap.exists?(bam_to_fam_map.id)
  end
end
