require 'test_helper'

class LbosControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Lbo.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Lbo.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Lbo.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to lbo_url(assigns(:lbo))
  end

  def test_edit
    get :edit, :id => Lbo.first
    assert_template 'edit'
  end

  def test_update_invalid
    Lbo.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Lbo.first
    assert_template 'edit'
  end

  def test_update_valid
    Lbo.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Lbo.first
    assert_redirected_to lbo_url(assigns(:lbo))
  end

  def test_destroy
    lbo = Lbo.first
    delete :destroy, :id => lbo
    assert_redirected_to lbos_url
    assert !Lbo.exists?(lbo.id)
  end
end
