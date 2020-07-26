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

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable] do
      member do
        patch :best
      end
    end
  end

  mount ActionCable.server => '/cable'
end
