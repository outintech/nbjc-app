Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions }, path_names: { sign_in: :login }
    resource :user, only: [:show, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'space/search', to: 'spaces#create_yelp_search'
      resources :spaces, only: [:create, :index, :show, :update, :destroy] do
        resources :reviews
        resources :address
        resources :photos
        resources :space_indicators
        resources :space_languages
      end
      resources :indicators
    end
  end
end
