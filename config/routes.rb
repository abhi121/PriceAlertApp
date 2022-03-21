require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'
  post "/sign_in", to: "users#sign_in"
  post "/sign_up", to: "users#create"

  resources :users, except: :create
  resources :alerts
  resources :coins, only: :index

end
