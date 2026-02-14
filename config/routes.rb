Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # 1. The Home Page (Search)
  root "nutritionists#index"
  
  # 2. The Public Profile (e.g., /nutritionists/1)
  resources :nutritionists, only: [:index, :show]
  resources :appointments, only: [:create]

  # 3. The Nutritionist Dashboard (e.g., /dashboard/1)
  # We pass the ID so we know WHICH nutritionist is logging in
  get "/dashboard/:nutritionist_id", to: "dashboard#index", as: :nutritionist_dashboard
  
  # 4. The API (for React to fetch data)
  namespace :api do
    resources :appointments, only: [:index, :update] do
      # Custom actions for Accept/Reject
      member do
        patch :accept
        patch :reject
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
