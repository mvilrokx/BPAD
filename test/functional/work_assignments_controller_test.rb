require 'test_helper'

class WorkAssignmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
end
