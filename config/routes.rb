Rails.application.routes.draw do
  root to: 'home#index'
  get '/pages/*id', to: 'pages#show', as: :page, format: false
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resource :repository, only: %i[update]
  # resources :users, only: [] do
  #   resources :issues,  only: %i[index]
  #   resources :wikis, only: %i[index]
  #   resources :contributions, only: %i[index]
  # end
  namespace :current_user do
    resources :issues,  only: %i[index]
    resources :wikis, only: %i[index]
    resources :contributions, only: %i[index]
  end
  get 'loading', to: 'loading#show'
end
