EmoSearch::Application.routes.draw do
  match '/about', to: 'static_pages#about'
  root to: 'static_pages#home'
end
