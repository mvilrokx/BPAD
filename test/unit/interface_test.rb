require 'test_helper'

class InterfaceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Interface.new.valid?
  end
end
