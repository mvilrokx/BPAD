require 'test_helper'

class BusinessProcessElementTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BusinessProcessElement.new.valid?
  end
end
