Rails.application.routes.draw do
  devise_for :users
  # root 'pages#index'
  root to: redirect('/machines/')

  get "machines/:machine_title/certificate", to: "machines#download_certificate", as: 'machine_certificate'

  get 'machines/:machine_title/down', to: 'machines#down', as: 'machine_down'
  get 'machines/:machine_title/up', to: 'machines#up', as: 'machine_up'
  get 'machines/:machine_title/restart', to: 'machines#restart', as: 'machine_restart'
  get 'machines/:machine_title/status', to: 'machines#status', as: 'machine_status'

  resources 'machines', param: :machine_title
end
