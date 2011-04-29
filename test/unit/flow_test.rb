require 'test_helper'

class FlowTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Flow.new.valid?
  end
end
