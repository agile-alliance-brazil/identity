Rails.application.routes.draw do
  use_doorkeeper

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for  :users,
              controllers: {
                omniauth_callbacks: 'users/omniauth_callbacks'
              },
              path_names: {
                sign_in: 'login',
                sign_out: 'logout',
                sign_up: 'signup'
              }

  resources :users, only: [:index, :show]

  root 'users#show'
end
