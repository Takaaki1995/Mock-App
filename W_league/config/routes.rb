Rails.application.routes.draw do
  # un aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get '/home', to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
