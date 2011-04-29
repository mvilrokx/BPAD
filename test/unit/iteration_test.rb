require 'test_helper'

class IterationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Iteration.new.valid?
  end
end
