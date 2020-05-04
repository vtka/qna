Rails.application.routes.draw do

  devise_for :users

  resources :attachments, only: %i[destroy]

  resources :badges, only: %i[index]

  resources :links, only: %i[destroy]

  concern :votable do
    member do
      post :positive, :negative
      delete :revote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch :best, on: :member
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
