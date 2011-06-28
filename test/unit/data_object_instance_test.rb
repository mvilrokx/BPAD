require 'test_helper'

class DataObjectInstanceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert DataObjectInstance.new.valid?
  end
end
