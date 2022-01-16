#frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :conversations, only: [:show] do
        resources :messages, only: %i[index create]
      end
    end
  end
end
