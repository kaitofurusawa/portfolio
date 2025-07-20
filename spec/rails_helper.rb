require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # system spec（Capybara + Selenium）用
  config.use_transactional_fixtures = false

  # DatabaseCleanerの設定
  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    # js: true だけ :truncation、他は:transaction
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # FactoryBotシンタックスの利用
  config.include FactoryBot::Syntax::Methods

  # ログイン用マクロ
  config.include LoginMacros, type: :system

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.filter_rails_from_backtrace!
end
