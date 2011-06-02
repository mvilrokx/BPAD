require 'test_helper'

class LogicalEntityAttributesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => LogicalEntityAttribute.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    LogicalEntityAttribute.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    LogicalEntityAttribute.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to logical_entity_attribute_url(assigns(:logical_entity_attribute))
  end

  def test_edit
    get :edit, :id => LogicalEntityAttribute.first
    assert_template 'edit'
  end

  def test_update_invalid
    LogicalEntityAttribute.any_instance.stubs(:valid?).returns(false)
    put :update, :id => LogicalEntityAttribute.first
    assert_template 'edit'
  end

  def test_update_valid
    LogicalEntityAttribute.any_instance.stubs(:valid?).returns(true)
    put :update, :id => LogicalEntityAttribute.first
    assert_redirected_to logical_entity_attribute_url(assigns(:logical_entity_attribute))
  end

  def test_destroy
    logical_entity_attribute = LogicalEntityAttribute.first
    delete :destroy, :id => logical_entity_attribute
    assert_redirected_to logical_entity_attributes_url
    assert !LogicalEntityAttribute.exists?(logical_entity_attribute.id)
  end
end
