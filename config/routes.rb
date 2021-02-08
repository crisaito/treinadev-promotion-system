Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  
  resources :promotions, only: [:index, :show, :new, :create] do
    post 'generate_coupons', on: :member
  end

  resources :coupons, only: [] do
    post 'inactivate', on: :member
  end
end
