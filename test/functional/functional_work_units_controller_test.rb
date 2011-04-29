require 'test_helper'

class FunctionalWorkUnitsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => FunctionalWorkUnit.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    FunctionalWorkUnit.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    FunctionalWorkUnit.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to functional_work_unit_url(assigns(:functional_work_unit))
  end

  def test_edit
    get :edit, :id => FunctionalWorkUnit.first
    assert_template 'edit'
  end

  def test_update_invalid
    FunctionalWorkUnit.any_instance.stubs(:valid?).returns(false)
    put :update, :id => FunctionalWorkUnit.first
    assert_template 'edit'
  end

  def test_update_valid
    FunctionalWorkUnit.any_instance.stubs(:valid?).returns(true)
    put :update, :id => FunctionalWorkUnit.first
    assert_redirected_to functional_work_unit_url(assigns(:functional_work_unit))
  end

  def test_destroy
    functional_work_unit = FunctionalWorkUnit.first
    delete :destroy, :id => functional_work_unit
    assert_redirected_to functional_work_units_url
    assert !FunctionalWorkUnit.exists?(functional_work_unit.id)
  end
end
