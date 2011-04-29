require 'test_helper'

class BamToFamFeatureTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BamToFamFeature.new.valid?
  end
end
