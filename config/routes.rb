EmoSearch::Application.routes.draw do
  resources :videos, only: [:index, :show, :create, :update]

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  get 'tags/:tags', to: 'videos#index', as: :tag

  match '/about', to: 'static_pages#about'
  root to: 'static_pages#home'
end
#== Route Map
# Generated on 09 Oct 2012 06:38
#
#                          POST   /videos(.:format)                      videos#create
#                    video GET    /videos/:id(.:format)                  videos#show
#         new_user_session GET    /users/sign_in(.:format)               devise/sessions#new
#             user_session POST   /users/sign_in(.:format)               devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)              devise/sessions#destroy
#  user_omniauth_authorize        /users/auth/:provider(.:format)        omniauth_callbacks#passthru {:provider=>/twitter|facebook/}
#   user_omniauth_callback        /users/auth/:action/callback(.:format) omniauth_callbacks#(?-mix:twitter|facebook)
#            user_password POST   /users/password(.:format)              devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)          devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)         devise/passwords#edit
#                          PUT    /users/password(.:format)              devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)                devise/registrations#cancel
#        user_registration POST   /users(.:format)                       devise/registrations#create
#    new_user_registration GET    /users/sign_up(.:format)               devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)                  devise/registrations#edit
#                          PUT    /users(.:format)                       devise/registrations#update
#                          DELETE /users(.:format)                       devise/registrations#destroy
#        user_confirmation POST   /users/confirmation(.:format)          devise/confirmations#create
#    new_user_confirmation GET    /users/confirmation/new(.:format)      devise/confirmations#new
#                          GET    /users/confirmation(.:format)          devise/confirmations#show
#                      tag GET    /tags/:tag(.:format)                   videos#index
#                    about        /about(.:format)                       static_pages#about
#                     root        /                                      static_pages#home
