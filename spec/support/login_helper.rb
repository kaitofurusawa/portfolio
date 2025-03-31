module LoginHelper
  def login(user)
    post login_path, params: { email: user.email, password: 'password' }
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :request
end
