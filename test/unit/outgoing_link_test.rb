require 'test_helper'

class OutgoingLinkTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert OutgoingLink.new.valid?
  end
end
