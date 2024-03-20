require "test_helper"

class ResetPasswordMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  def setup
    @user = users(:user1)
  end

  test "reset" do
    assert_emails 1 do
      mail = ResetPasswordMailer.with(user: @user).reset.deliver_now

      assert_equal "Reset", mail.subject
      assert_equal [@user.email], mail.to
      assert_equal ["from@example.com"], mail.from
    end
  end
end
