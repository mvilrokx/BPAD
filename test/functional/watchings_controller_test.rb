require 'test_helper'

class WatchingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Watching.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Watching.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Watching.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to watching_url(assigns(:watching))
  end

  def test_edit
    get :edit, :id => Watching.first
    assert_template 'edit'
  end

  def test_update_invalid
    Watching.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Watching.first
    assert_template 'edit'
  end

  def test_update_valid
    Watching.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Watching.first
    assert_redirected_to watching_url(assigns(:watching))
  end

  def test_destroy
    watching = Watching.first
    delete :destroy, :id => watching
    assert_redirected_to watchings_url
    assert !Watching.exists?(watching.id)
  end
end
