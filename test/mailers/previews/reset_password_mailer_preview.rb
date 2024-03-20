# Preview all emails at http://localhost:3000/rails/mailers/reset_password_mailer
class ResetPasswordMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reset_password_mailer/reset
  def reset
    ResetPasswordMailer.reset
  end

end
