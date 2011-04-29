require 'test_helper'

class IterationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Iteration.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Iteration.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Iteration.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to iteration_url(assigns(:iteration))
  end

  def test_edit
    get :edit, :id => Iteration.first
    assert_template 'edit'
  end

  def test_update_invalid
    Iteration.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Iteration.first
    assert_template 'edit'
  end

  def test_update_valid
    Iteration.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Iteration.first
    assert_redirected_to iteration_url(assigns(:iteration))
  end

  def test_destroy
    iteration = Iteration.first
    delete :destroy, :id => iteration
    assert_redirected_to iterations_url
    assert !Iteration.exists?(iteration.id)
  end
end
