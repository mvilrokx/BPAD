require 'test_helper'

class BamToFamMapTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BamToFamMap.new.valid?
  end
end
