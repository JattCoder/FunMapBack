require 'test_helper'

class AccountMailerTest < ActionMailer::TestCase
  test "pin_confirmation" do
    mail = AccountMailer.pin_confirmation
    assert_equal "Pin confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
