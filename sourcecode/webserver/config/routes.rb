Rails.application.routes.draw do
  devise_for :users
  # root 'pages#index'
  root to: redirect('/machines/')

  get "machines/:machine_title/certificate", to: "machines#download_certificate", as: 'machine_certificate'

  get 'machines/:machine_title/down', to: 'machines#down', as: 'machine_down'
  get 'machines/:machine_title/up', to: 'machines#up', as: 'machine_up'
  get 'machines/:machine_title/restart', to: 'machines#restart', as: 'machine_restart'
  get 'machines/:machine_title/status', to: 'machines#status', as: 'machine_status'

  # Wait
  get 'machines/:machine_title/build/wait', to: 'machines#build_wait', as: 'machine_build_wait'
  get 'machines/:machine_title/up/wait', to: 'machines#up_wait', as: 'machine_up_wait'
  get 'machines/:machine_title/down/wait', to: 'machines#down_wait', as: 'machine_down_wait'
  get 'machines/:machine_title/destroy/wait', to: 'machines#destroy_wait', as: 'machine_destroy_wait'
  get 'machines/:machine_title/restart/wait', to: 'machines#restart_wait', as: 'machine_restart_wait'

  resources 'machines', param: :machine_title
end
