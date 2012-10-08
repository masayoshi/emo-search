EmoSearch::Application.routes.draw do
  resources :videos, only: [:index, :show, :create]

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  get 'tags/:tag', to: 'videos#index', as: :tag

  match '/about', to: 'static_pages#about'
  root to: 'static_pages#home'
end
