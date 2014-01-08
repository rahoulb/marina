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
    resources :mailouts
    resources :subscription_plans
    resources :members
    resources :field_definitions
    resources :pin_payment_notifications, only: [:create]
  end
end
