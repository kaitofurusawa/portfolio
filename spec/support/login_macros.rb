module LoginMacros
  def login_user(user)
    post login_path, params: { email: user.email, password: user.password }
  end
end
