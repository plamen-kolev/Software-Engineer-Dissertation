Rails.application.routes.draw do
  devise_for :users
  # root 'pages#index'
  root to: redirect('/machines/')
  resources 'machines'
end
