require 'test_helper'

class LbasControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Lba.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Lba.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Lba.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to lba_url(assigns(:lba))
  end

  def test_edit
    get :edit, :id => Lba.first
    assert_template 'edit'
  end

  def test_update_invalid
    Lba.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Lba.first
    assert_template 'edit'
  end

  def test_update_valid
    Lba.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Lba.first
    assert_redirected_to lba_url(assigns(:lba))
  end

  def test_destroy
    lba = Lba.first
    delete :destroy, :id => lba
    assert_redirected_to lbas_url
    assert !Lba.exists?(lba.id)
  end
end
