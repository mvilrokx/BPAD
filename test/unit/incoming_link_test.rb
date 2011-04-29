require 'test_helper'

class IncomingLinkTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert IncomingLink.new.valid?
  end
end
