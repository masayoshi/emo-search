EmoSearch::Application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  match '/about', to: 'static_pages#about'
  root to: 'static_pages#home'
end
