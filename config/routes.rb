# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  resources :questions do
    member do
      delete :delete_file
    end

    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
        delete :delete_file
      end
    end
  end
end
