Rails.application.routes.draw do
  root 'home#index'
  get 'search', to: 'home#search'

  devise_for :users
  
  resources :promotions, only: [:index, :show, :new, :create] do
    member do
      post 'generate_coupons'
      post 'approve'
    end
  end

  resources :coupons, only: [] do
    post 'inactivate', on: :member
  end

  namespace 'api', defaults: { format: :json } do
    namespace 'v1' do
      resources :coupons, only: [:show]
    end
  end
end
