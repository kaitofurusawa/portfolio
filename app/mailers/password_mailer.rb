class PasswordMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    @url  = edit_password_reset_url(@user.password_reset_token)
    mail(to: @user.email, subject: t('mailers.password_reset.subject'))
  end
end
