require 'capybara/rspec'

Capybara.configure do |config|
  config.default_driver = :selenium_chrome_headless
  config.server_port = 3001
  config.app_host = "http://localhost:3001"
end

Capybara.register_driver :selenium_chrome_headless do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, url: "http://selenium:4444/wd/hub")
end
