Rails.application.routes.draw do
  devise_for :users  # ここがあるか確認
  root "home#index"
  resources :boards, only: [:index, :show]
end
