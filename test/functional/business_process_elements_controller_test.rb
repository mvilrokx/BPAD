require 'test_helper'

class BusinessProcessElementsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BusinessProcessElement.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BusinessProcessElement.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BusinessProcessElement.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_process_element_url(assigns(:business_process_element))
  end

  def test_edit
    get :edit, :id => BusinessProcessElement.first
    assert_template 'edit'
  end

  def test_update_invalid
    BusinessProcessElement.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BusinessProcessElement.first
    assert_template 'edit'
  end

  def test_update_valid
    BusinessProcessElement.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BusinessProcessElement.first
    assert_redirected_to business_process_element_url(assigns(:business_process_element))
  end

  def test_destroy
    business_process_element = BusinessProcessElement.first
    delete :destroy, :id => business_process_element
    assert_redirected_to business_process_elements_url
    assert !BusinessProcessElement.exists?(business_process_element.id)
  end
end
