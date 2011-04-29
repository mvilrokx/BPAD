require 'test_helper'

class LboTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Lbo.new.valid?
  end
end
