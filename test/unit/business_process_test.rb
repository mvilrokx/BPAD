require 'test_helper'

class BusinessProcessTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BusinessProcess.new.valid?
  end
end
