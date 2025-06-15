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
    email = auth.info.email
    provider = auth.provider
    uid = auth.uid

    user = User.find_by(email: email)

    if user
      user.update(provider: provider, uid: uid) if user.provider.blank? || user.uid.blank?
    else
      user = User.new(
        email: email,
        name: auth.info.name,
        password: SecureRandom.hex(10),
        provider: provider,
        uid: uid
      )
      user.profile = auth.info.description if user.respond_to?(:profile) && auth.info.respond_to?(:description)
      if auth.info.image.present? && user.respond_to?(:profile_image)
        user.profile_image.attach(
          io: URI.open(auth.info.image),
          filename: 'profile.jpg'
        )
      end
      user.save!
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: "#{provider.titleize}でログインしました！"
  end
end
