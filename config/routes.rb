Rails.application.routes.draw do
  resources :articles
  root to: 'pages#home'
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'pages/about', to: 'pages#about'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :categories, except: [:destroy]
end
