# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  private

  def account_activation
    UserMailerMailer.account_activation
  end

  def password_reset
    UserMailerMailer.password_reset
  end

end
