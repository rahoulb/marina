Marina::Application.routes.draw do
  root 'dashboard#show'
  namespace :admin do
    resources :mailouts
  end

  namespace :api do
    resources :mailouts
    resources :subscription_plans
  end
end
