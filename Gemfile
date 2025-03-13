source "https://rubygems.org"

ruby '3.2.2'

# Rails 本体
gem "rails", "~> 8.0.2"

# アセットパイプライン
gem "propshaft"

# PostgreSQL
gem "pg", "~> 1.5"

# Web サーバー（Puma 6 以上）
gem "puma", ">= 6.0"

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

group :development, :test do
  # デバッグツール
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

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
end

group :test do
  # システムテスト
  gem "capybara"
  gem "selenium-webdriver"
end
