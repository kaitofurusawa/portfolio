Rails.application.routes.draw do
  get "static_pages/terms"
  get "static_pages/privacy"
  get "password_resets/new"
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  # トップページ
  root "boards#index"

  # ユーザー登録関連（sorcery用）
  resources :users, only: [ :new, :create, :show, :edit, :update ]

  # ログイン・ログアウト関連（sorcery用）
  resources :sessions, only: [ :new, :create, :destroy ]
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # 掲示板（boards）のルーティング
  resources :boards do
    resources :comments, only: [ :create, :update, :destroy, :edit ]
    resource :bookmark, only: [:create, :destroy], module: :boards
  end

  # パスワードリセット関連（sorcery用）
  resources :password_resets, only: [:new, :create, :edit, :update]

  # 利用規約とプライバシーポリシー
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
