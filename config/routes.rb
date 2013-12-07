Marina::Application.routes.draw do
  root 'dashboard#show'
  namespace :admin do
    resources :mailouts, only: [:index]
    resources :subscription_plans, only: [:index]
  end

  namespace :api do
    resources :mailouts
    resources :subscription_plans
  end
end
