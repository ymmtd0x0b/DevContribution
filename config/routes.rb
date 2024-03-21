Rails.application.routes.draw do
  namespace :lazy do
    get 'registrations/new'
  end
  root to: 'home#index'
  get '/pages/*id', to: 'pages#show', as: :page, format: false
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resources :registrations, only: %i[new create destroy]
  resources :repositories, only: %i[update] do
    scope module: :repositories do
      resources :assigned_issues, only: %i[index]
      resources :reviewed_issues, only: %i[index]
      resources :issues,  only: %i[index]
      resources :wikis, only: %i[index]
      resources :all, only: %i[index]
    end
  end
end
