Rails.application.routes.draw do
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
  end

  # パスワードリセット関連（sorcery用）
  resources :password_resets, only: [:new, :create, :edit, :update]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
