Rails.application.routes.draw do
  #get 'webhook/receive'
  devise_for :users
  root to: 'articles#index'

  resources :articles, except: [:destroy]
  resources :order_items, only: [:create]
  resources :orders, only: [:show] do
    get '/current', to: 'orders#current', on: :collection
    get '/checkout', to: 'orders#checkout'
    resources :checkout, only: [:create]
  end

  post '/webhook', to:'webhook#receive'

  get '/profile', to: 'users#profile'
end
