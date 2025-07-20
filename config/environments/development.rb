require "active_support/core_ext/integer/time"

Rails.application.configure do
  # ここで指定された設定は config/application.rb の設定より優先されます。

  # コード変更を即時に反映させるため、サーバーの再起動を不要にします。
  config.enable_reloading = true

  # 起動時にコードをイーガーロードしないようにします。
  config.eager_load = false

  # 完全なエラーレポートを表示します。
  config.consider_all_requests_local = true

  # サーバータイミングを有効にします。
  config.server_timing = true

  # アクションコントローラのキャッシュを有効/無効にします。デフォルトではアクションコントローラのキャッシュは無効です。
  # rails dev:cache を実行してアクションコントローラのキャッシュを切り替えます。
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end

  # キャッシュを避けるために :null_store に変更します。
  config.cache_store = :memory_store

  # アップロードされたファイルをローカルファイルシステムに保存します（オプションは config/storage.yml を参照）。
  config.active_storage.service = :local

  #
  config.action_mailer.raise_delivery_errors = true

  # テンプレートの変更を即時に反映させます。
  config.action_mailer.perform_caching = false

  # メールテンプレートで生成されるリンクに localhost を使用します。
  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Rails ロガーに非推奨警告を表示します。
  config.active_support.deprecation = :log

  # 保留中のマイグレーションがある場合、ページ読み込み時にエラーを発生させます。
  config.active_record.migration_error = :page_load

  # データベースクエリをトリガーしたコードをログで強調表示します。
  config.active_record.verbose_query_logs = true

  # SQL クエリのログにランタイム情報タグを追加します。
  config.active_record.query_log_tags_enabled = true

  # バックグラウンドジョブをキューに入れたコードをログで強調表示します。
  config.active_job.verbose_enqueue_logs = true

  # 翻訳が見つからない場合にエラーを発生させます。
  # config.i18n.raise_on_missing_translations = true

  # レンダリングされたビューにファイル名を注釈します。
  config.action_view.annotate_rendered_view_with_filenames = true

  # すべてのオリジンからのアクションケーブルアクセスを許可する場合はコメントを外します。
  # config.action_cable.disable_request_forgery_protection = true

  # before_action の only/except オプションで存在しないアクションを参照している場合にエラーを発生させます。
  config.action_controller.raise_on_missing_callback_actions = true

  # `bin/rails generate` で生成されたファイルに対して RuboCop による自動修正を適用します。
  # config.generators.apply_rubocop_autocorrect_after_generate!

  config.assets.debug = true
  config.assets.check_precompiled_asset = false
end
