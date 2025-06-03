class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @boards = @user.boards.order(created_at: :desc)
    @bookmarked_boards = @user.bookmarked_boards.includes(:user).order("bookmarks.created_at DESC")
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: t("users.create.success")
    else
      flash.now[:alert] = t("users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @original_profile_image = @user.profile_image if @user.profile_image.attached?

    if @user.update(user_params)
      redirect_to user_path(@user), notice: t("users.update.success")
    else
      flash.now[:alert] = t("users.update.failure")

      @user.reload

      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :profile,
      :profile_image,
      :password,
      :password_confirmation
    )
  end
end