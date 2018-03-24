# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper

  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  resources :users, only: %i[index show] do
    collection do
      get :me
    end
  end

  root 'users#me'
end
