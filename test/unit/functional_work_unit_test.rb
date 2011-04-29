require 'test_helper'

class FunctionalWorkUnitTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FunctionalWorkUnit.new.valid?
  end
end
