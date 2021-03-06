class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @locale = I18n.locale
    mail to: user.email,
      subject: t(".subject")
  end

  def password_reset user
    @user = user
    @locale = I18n.locale
    mail to: user.email,
      subject: t(".subject")
  end

  def send_password_reset_email user
    password_reset(user).deliver_now
  end
end
