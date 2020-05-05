Rails.application.routes.draw do
  root to: "questions#index"

  devise_for :users

  concern :votable do
    patch :upvote, on: :member
    patch :downvote, on: :member
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: :votable do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
