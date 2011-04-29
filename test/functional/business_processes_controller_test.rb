require 'test_helper'

class BusinessProcessesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BusinessProcess.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BusinessProcess.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BusinessProcess.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to business_process_url(assigns(:business_process))
  end

  def test_edit
    get :edit, :id => BusinessProcess.first
    assert_template 'edit'
  end

  def test_update_invalid
    BusinessProcess.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BusinessProcess.first
    assert_template 'edit'
  end

  def test_update_valid
    BusinessProcess.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BusinessProcess.first
    assert_redirected_to business_process_url(assigns(:business_process))
  end

  def test_destroy
    business_process = BusinessProcess.first
    delete :destroy, :id => business_process
    assert_redirected_to business_processes_url
    assert !BusinessProcess.exists?(business_process.id)
  end
end
