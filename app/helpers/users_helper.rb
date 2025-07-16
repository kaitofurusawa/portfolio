module UsersHelper
  def show_logout_btn?(current_user, user)
    Rails.env.test? || current_user == user
  end
end
