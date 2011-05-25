require 'test_helper'

class FamToTamMapTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert FamToTamMap.new.valid?
  end
end
