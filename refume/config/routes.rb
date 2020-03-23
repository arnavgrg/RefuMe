Rails.application.routes.draw do
  resources :posts
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  #resources :matches
  root   'static_pages#home'
  get    '/home',          to: 'static_pages#home'
  get    '/help',          to: 'static_pages#help'
  get    '/about',         to: 'static_pages#about'
  get    '/info',          to: 'static_pages#info'
  get    '/contact',       to: 'static_pages#contact'
  get    '/signup',        to: 'users#new'
  get    '/select',        to: 'users#select'
  post   '/select',        to: 'users#role_select'
  get    '/mentor_mentee', to: 'users#mentor_mentee'
  get    '/login',         to: 'sessions#new'
  post   '/login',         to: 'sessions#create'
  delete '/logout',        to: 'sessions#destroy'
  get    '/microposts',     to: 'microposts#index'
  post   '/microposts',     to: 'microposts#create'
  post   '/matches/new',   to: 'matches#create'
  get    '/matches/:id',   to: 'matches#show'
  resources :users
  resources :matches
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
