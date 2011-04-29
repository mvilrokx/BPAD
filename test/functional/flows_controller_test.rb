require 'test_helper'

class FlowsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Flow.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Flow.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Flow.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to flow_url(assigns(:flow))
  end

  def test_edit
    get :edit, :id => Flow.first
    assert_template 'edit'
  end

  def test_update_invalid
    Flow.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Flow.first
    assert_template 'edit'
  end

  def test_update_valid
    Flow.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Flow.first
    assert_redirected_to flow_url(assigns(:flow))
  end

  def test_destroy
    flow = Flow.first
    delete :destroy, :id => flow
    assert_redirected_to flows_url
    assert !Flow.exists?(flow.id)
  end
end
