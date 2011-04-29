require 'test_helper'

class BusinessAreasControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BusinessArea.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BusinessArea.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BusinessArea.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_area_url(assigns(:business_area))
  end

  def test_edit
    get :edit, :id => BusinessArea.first
    assert_template 'edit'
  end

  def test_update_invalid
    BusinessArea.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BusinessArea.first
    assert_template 'edit'
  end

  def test_update_valid
    BusinessArea.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BusinessArea.first
    assert_redirected_to business_area_url(assigns(:business_area))
  end

  def test_destroy
    business_area = BusinessArea.first
    delete :destroy, :id => business_area
    assert_redirected_to business_areas_url
    assert !BusinessArea.exists?(business_area.id)
  end
end
