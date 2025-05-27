class PasswordsMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    mail subject: I18n.t("passwords_mailer.reset_password_email.subject"), to: user.email_address
  end
end
