EmoSearch::Application.routes.draw do
  devise_for :users

  match '/about', to: 'static_pages#about'
  root to: 'static_pages#home'
end
