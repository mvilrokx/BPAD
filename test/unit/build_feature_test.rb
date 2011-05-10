require 'test_helper'

class BuildFeatureTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BuildFeature.new.valid?
  end
end
