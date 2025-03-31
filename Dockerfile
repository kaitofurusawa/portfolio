FROM ruby:3.2.2

# アプリケーションディレクトリの設定
WORKDIR /app

# 依存関係のインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs wget gnupg2 unzip

# Chromiumのインストール
RUN apt-get update -qq && apt-get install -y chromium

# ChromeDriverのインストール
RUN wget -N https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver

# ChromeDriverパスの設定
ENV PATH /usr/local/bin:$PATH

# Gemfileのコピーとインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションファイルのコピー
COPY . .

# サーバーコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]