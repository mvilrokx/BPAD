require 'test_helper'

class ApprovalTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Approval.new.valid?
  end
end
