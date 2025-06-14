class SessionsController < ApplicationController
  require 'open-uri'

  def new
    @user = User.new
  end

  def create
    @user = User.new(email: params[:email])
    user = login(params[:email], params[:password])
    if user
      redirect_to root_path, notice: t("sessions.create.success")
    else
      @user.errors.add(:email, t("activerecord.errors.models.user.attributes.email.blank")) if params[:email].blank?
      @user.errors.add(:password, t("activerecord.errors.models.user.attributes.password.blank")) if params[:password].blank?
      flash.now[:alert] = t("sessions.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t("sessions.destroy.success")
  end
  def omniauth
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(email: auth.info.email) do |u|
      u.name = auth.info.name
      u.password = SecureRandom.hex(10)
      u.profile = auth.info.description if u.respond_to?(:profile) && auth.info.respond_to?(:description)
      u.profile_image.attach(
        io: URI.open(auth.info.image),
        filename: 'profile.jpg'
      ) if auth.info.image.present?
    end
  
    session[:user_id] = user.id
    redirect_to root_path, notice: "Googleログインしました！"
  end
end
