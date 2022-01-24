# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index show update destroy]
      post 'auth/register', to: 'users#create'
      post 'auth/login', to: 'auth#create'
      get 'auth/me', to: 'auth#show'
      resources :conversations, only: [:show] do
        resources :messages, only: %i[index create]
      end
      resources :messages, only: %i[update]
    end
  end
end
