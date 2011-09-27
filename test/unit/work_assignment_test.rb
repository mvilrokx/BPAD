require 'test_helper'

class WorkAssignmentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert WorkAssignment.new.valid?
  end
end
