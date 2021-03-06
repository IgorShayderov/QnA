# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'searches/index'
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'oauth_confirmations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

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
    resources :subscriptions, shallow: true, only: %i[create destroy]

    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable] do
      member do
        patch :best
      end
    end
  end

  resources :searches, only: :index

  mount ActionCable.server => '/cable'
end
