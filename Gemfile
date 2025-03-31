source "https://rubygems.org"

ruby '3.2.2'

# Rails 本体
gem "rails", "~> 8.0.2"

# Propshaft を削除（またはコメントアウト）
# gem 'propshaft'

# Sprockets を追加
gem "sprockets-rails", "~> 3.5"
gem "sprockets", "~> 4.2"

# PostgreSQL
gem "pg", "~> 1.5"

gem "puma", "~> 6.6"

gem 'devise'

gem 'kaminari'

gem 'faker'

gem "sassc-rails"

gem 'database_cleaner-active_record'

# gem 'annotate'

gem 'sorcery'

gem 'active_storage_validations'

# JavaScript & Hotwire
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# JSON API
gem "jbuilder"

# ActiveRecord キャッシュ、ジョブ、Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# dotenv（環境変数管理）
gem "dotenv-rails", groups: [:development, :test]

# 高速起動
gem "bootsnap", require: false

# ActiveStorageのドライバ
gem 'aws-sdk-s3', require: false

group :development, :test do
  # デバッグツール
  # gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # 静的解析（セキュリティチェック）
  gem "brakeman", require: false

  # コードスタイル管理
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Rails console で pry を使えるようにする
  gem "pry-rails"

  # エラーページでコンソールを使う
  gem "web-console"

  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'database_cleaner-active_record'
end
