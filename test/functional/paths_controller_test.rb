require 'test_helper'

class PathsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Path.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Path.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Path.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to path_url(assigns(:path))
  end

  def test_edit
    get :edit, :id => Path.first
    assert_template 'edit'
  end

  def test_update_invalid
    Path.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Path.first
    assert_template 'edit'
  end

  def test_update_valid
    Path.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Path.first
    assert_redirected_to path_url(assigns(:path))
  end

  def test_destroy
    path = Path.first
    delete :destroy, :id => path
    assert_redirected_to paths_url
    assert !Path.exists?(path.id)
  end
end
