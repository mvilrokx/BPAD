require 'test_helper'

class LogicalEntityAttributeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert LogicalEntityAttribute.new.valid?
  end
end
