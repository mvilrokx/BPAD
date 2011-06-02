require 'test_helper'

class LogicalEntitiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => LogicalEntity.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    LogicalEntity.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    LogicalEntity.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to logical_entity_url(assigns(:logical_entity))
  end

  def test_edit
    get :edit, :id => LogicalEntity.first
    assert_template 'edit'
  end

  def test_update_invalid
    LogicalEntity.any_instance.stubs(:valid?).returns(false)
    put :update, :id => LogicalEntity.first
    assert_template 'edit'
  end

  def test_update_valid
    LogicalEntity.any_instance.stubs(:valid?).returns(true)
    put :update, :id => LogicalEntity.first
    assert_redirected_to logical_entity_url(assigns(:logical_entity))
  end

  def test_destroy
    logical_entity = LogicalEntity.first
    delete :destroy, :id => logical_entity
    assert_redirected_to logical_entities_url
    assert !LogicalEntity.exists?(logical_entity.id)
  end
end
