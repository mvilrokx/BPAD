require 'test_helper'

class WatchingTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Watching.new.valid?
  end
end
