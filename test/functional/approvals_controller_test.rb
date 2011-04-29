require 'test_helper'

class ApprovalsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Approval.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Approval.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Approval.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to approval_url(assigns(:approval))
  end

  def test_edit
    get :edit, :id => Approval.first
    assert_template 'edit'
  end

  def test_update_invalid
    Approval.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Approval.first
    assert_template 'edit'
  end

  def test_update_valid
    Approval.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Approval.first
    assert_redirected_to approval_url(assigns(:approval))
  end

  def test_destroy
    approval = Approval.first
    delete :destroy, :id => approval
    assert_redirected_to approvals_url
    assert !Approval.exists?(approval.id)
  end
end
