require 'test_helper'

class FamToTamMapsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => FamToTamMap.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    FamToTamMap.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    FamToTamMap.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to fam_to_tam_map_url(assigns(:fam_to_tam_map))
  end

  def test_edit
    get :edit, :id => FamToTamMap.first
    assert_template 'edit'
  end

  def test_update_invalid
    FamToTamMap.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FamToTamMap.first
    assert_template 'edit'
  end

  def test_update_valid
    FamToTamMap.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FamToTamMap.first
    assert_redirected_to fam_to_tam_map_url(assigns(:fam_to_tam_map))
  end

  def test_destroy
    fam_to_tam_map = FamToTamMap.first
    delete :destroy, :id => fam_to_tam_map
    assert_redirected_to fam_to_tam_maps_url
    assert !FamToTamMap.exists?(fam_to_tam_map.id)
  end
end
