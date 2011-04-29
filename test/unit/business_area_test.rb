require 'test_helper'

class BusinessAreaTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BusinessArea.new.valid?
  end
end
