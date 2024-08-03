Rails.application.routes.draw do
  get 'auth/github/callback', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :retirement, only: %i[create], controller: 'retirement'
  resource :repository, only: %i[update]
  namespace :users, path: '/:user_login' do
    resources :issues,  only: %i[index]
    resources :wikis, only: %i[index]
    resources :contributions, only: %i[index]
    get 'loading', to: 'loading#show'
  end
end
