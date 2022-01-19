#frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index create update destroy]
      resources :chats, only: [:show] do
        resources :messages, only: [:index]
      end
    end
  end
end
