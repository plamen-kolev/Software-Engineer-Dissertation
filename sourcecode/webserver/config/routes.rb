Rails.application.routes.draw do
  devise_for :users
  # root 'pages#index'
  root to: redirect('/machines/')

  get "machines/:machine_title/certificate", to: "machines#download_certificate", as: 'machine_certificate'

  resources 'machines', param: :title do
    get 'down', to: 'machines#down'
    get 'up', to: 'machines#up'
    get 'restart', to: 'machines#restart'
    get 'status', to: 'machines#status'
  end
  
end
