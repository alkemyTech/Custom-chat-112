#frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index create update destroy] do
        post :config, on: :member
      end
      resources :conversations, only: [:show] do
        resources :messages, only: %i[index create]
      end
      resources :messages, only: %i[show update destroy]
    end
  end
end
