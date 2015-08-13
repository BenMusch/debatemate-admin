Rails.application.routes.draw do
  get 'signup' => 'users#new'
  root 'application#under_construction'
  resources :users
end
