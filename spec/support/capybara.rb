Selenium::WebDriver::Service.driver_path = nil if defined?(Selenium::WebDriver::Service)

require "capybara/rspec"
require "selenium/webdriver"

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--headless')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://selenium:4444/wd/hub",
    capabilities: options
  )
end

Capybara.default_driver    = :rack_test
Capybara.javascript_driver = :remote_chrome

Capybara.server_host = '0.0.0.0'
Capybara.server_port = 3001
Capybara.app_host    = "http://web:3001"