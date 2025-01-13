FROM ruby:3.1

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  yarn \
  build-essential \
  libsqlite3-dev

# 作業ディレクトリを指定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock /app/

# Bundlerのインストール
RUN bundle install

# アプリケーションコードをコピー
COPY . /app
