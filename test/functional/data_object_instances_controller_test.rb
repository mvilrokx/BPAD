require 'test_helper'

class DataObjectInstancesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => DataObjectInstance.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    DataObjectInstance.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    DataObjectInstance.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to data_object_instance_url(assigns(:data_object_instance))
  end

  def test_edit
    get :edit, :id => DataObjectInstance.first
    assert_template 'edit'
  end

  def test_update_invalid
    DataObjectInstance.any_instance.stubs(:valid?).returns(false)
    put :update, :id => DataObjectInstance.first
    assert_template 'edit'
  end

  def test_update_valid
    DataObjectInstance.any_instance.stubs(:valid?).returns(true)
    put :update, :id => DataObjectInstance.first
    assert_redirected_to data_object_instance_url(assigns(:data_object_instance))
  end

  def test_destroy
    data_object_instance = DataObjectInstance.first
    delete :destroy, :id => data_object_instance
    assert_redirected_to data_object_instances_url
    assert !DataObjectInstance.exists?(data_object_instance.id)
  end
end
