Rails.application.routes.draw do
  root to: 'home#index'
  get 'auth/github/callback', to: 'user_sessions#create'
end
