Marina::Application.routes.draw do
  root 'dashboard#show'

  namespace :public do
    resources :subscription_plans, only: [] do
      resources :registrations
    end
  end

  namespace :admin do
    resources :mailouts, only: [:index]
    resources :subscription_plans, only: [:index]
    resources :site_assets, only: [:index]
  end

  namespace :api do
    resources :sessions, only: [:new, :create]
    resource :profile
    resources :mailouts
    resources :subscription_plans
    resources :members
    resources :field_definitions
    resources :pin_payment_notifications, only: [:create]
    namespace :members_directory do
      resources :latest_members, only: [:show]
      resource :members_search, only: [:show], controller: 'members_search'
    end
  end
end
