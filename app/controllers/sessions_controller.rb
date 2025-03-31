class SessionsController < ApplicationController
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
end
