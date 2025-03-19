class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to root_path, notice: t('sessions.create.success')
    else
      flash.now[:alert] = t('sessions.create.failure')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t('sessions.destroy.success')
  end
end
