class PasswordResetsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params.dig(:user, :email))

    if @user
      @user.generate_password_reset_token!
      PasswordMailer.with(user: @user).password_reset.deliver_now
      flash[:notice] = t('password_resets.create.sent')
      redirect_to root_path
    else
      @user = User.new(email: params.dig(:user, :email)) # バリデーション表示用
      flash.now[:alert] = t('password_resets.create.email_not_found')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:id])
    unless @user&.password_reset_token_valid?
      flash[:alert] = t('password_resets.edit.expired')
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:id])
  
    if @user.nil? || !@user.password_reset_token_valid?
      flash[:alert] = t('password_resets.edit.expired_token')
      redirect_to new_password_reset_path
      return
    end
  
    if @user.update(user_params)
      @user.clear_password_reset_token!
      flash[:notice] = t('password_resets.update.success')
  
      if logged_in?
        redirect_to user_path(@user)
      else
        redirect_to login_path
      end
    else
      flash.now[:alert] = t('password_resets.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end