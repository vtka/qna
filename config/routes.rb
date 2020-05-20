Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    confirmations: 'confirmations'
  }

  resources :attachments, only: %i[destroy]

  resources :badges, only: %i[index]

  resources :links, only: %i[destroy]

  concern :votable do
    member do
      post :positive, :negative
      delete :revote
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch :best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index]
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
