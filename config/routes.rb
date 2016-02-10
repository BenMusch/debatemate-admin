Rails.application.routes.draw do

  root                 'application#index'
  get    'signup'   => 'users#new'
  get    'login'    => 'sessions#new'
  get    'set_days' => 'users#set_days'
  post   'set_days' => 'users#update_days'
  post   'login'    => 'sessions#create'
  delete 'logout'   => 'sessions#destroy'
  delete 'lessons/:id/remove_user' => 'lessons#remove_user'
  get    'admin/pre_lesson_template' => 'templates#pre_lesson_template'
  get    'admin/post_lesson_template' => 'templates#post_lesson_template'
  
  resources :users
  resources :account_activations,  only: [:edit]
  resources :password_resets,      only: [:edit, :new, :create, :update]
  resources :lessons,              only: [:new, :create, :show, :index, :update] do
    resources :goals,              only: :update
  end
  resources :schools,              only: [:create, :index, :show, :update]
end
