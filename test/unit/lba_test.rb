require 'test_helper'

class LbaTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Lba.new.valid?
  end
end
