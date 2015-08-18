Rails.application.routes.draw do
  root               'application#index'
  get    'signup' => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :account_activations,  only: [:edit]
  resources :password_resets,      only: [:edit, :new, :create, :update]
  resources :lessons,              only: [:show, :index] do
    resources :pre_lesson_surveys, shallow: true,
                                   except:  :destroy
  end
end
