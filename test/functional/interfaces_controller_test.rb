require 'test_helper'

class InterfacesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Interface.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Interface.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Interface.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to interface_url(assigns(:interface))
  end

  def test_edit
    get :edit, :id => Interface.first
    assert_template 'edit'
  end

  def test_update_invalid
    Interface.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Interface.first
    assert_template 'edit'
  end

  def test_update_valid
    Interface.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Interface.first
    assert_redirected_to interface_url(assigns(:interface))
  end

  def test_destroy
    interface = Interface.first
    delete :destroy, :id => interface
    assert_redirected_to interfaces_url
    assert !Interface.exists?(interface.id)
  end
end
