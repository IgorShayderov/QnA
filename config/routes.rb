# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  resources :attachments, only: %i[destroy]
  resources :rewards, only: %i[index]

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :unvote
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable] do
      member do
        patch :best
      end
    end
  end
end
