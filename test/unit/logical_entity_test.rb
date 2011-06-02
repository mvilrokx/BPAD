require 'test_helper'

class LogicalEntityTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert LogicalEntity.new.valid?
  end
end
