# == Route Map (Updated 2014-09-24 10:42)
#
#                         Prefix Verb   URI Pattern                               Controller#Action
#                         events GET    /events(.:format)                         events#index
#                                POST   /events(.:format)                         events#create
#                      new_event GET    /events/new(.:format)                     events#new
#                     edit_event GET    /events/:id/edit(.:format)                events#edit
#                          event GET    /events/:id(.:format)                     events#show
#                                PATCH  /events/:id(.:format)                     events#update
#                                PUT    /events/:id(.:format)                     events#update
#                                DELETE /events/:id(.:format)                     events#destroy
# autocomplete_firstname_athlets GET    /athlets/autocomplete_firstname(.:format) athlets#autocomplete_firstname
#   autocomplete_surname_athlets GET    /athlets/autocomplete_surname(.:format)   athlets#autocomplete_surname
#      autocomplete_club_athlets GET    /athlets/autocomplete_club(.:format)      athlets#autocomplete_club
#                 import_athlets POST   /athlets/import(.:format)                 athlets#import
#            suggestions_athlets GET    /athlets/suggestions(.:format)            athlets#suggestions
#            destroy_all_athlets DELETE /athlets/destroy_all(.:format)            athlets#destroy_all
#          show_multiple_athlets GET    /athlets/show_multiple(.:format)          athlets#show_multiple
#           new_multiple_athlets GET    /athlets/new_multiple(.:format)           athlets#new_multiple
#          edit_multiple_athlets GET    /athlets/edit_multiple(.:format)          athlets#edit_multiple
#        create_multiple_athlets POST   /athlets/create_multiple(.:format)        athlets#create_multiple
#        update_multiple_athlets PUT    /athlets/update_multiple(.:format)        athlets#update_multiple
#       destroy_multiple_athlets PUT    /athlets/destroy_multiple(.:format)       athlets#destroy_multiple
#                        athlets GET    /athlets(.:format)                        athlets#index
#                                POST   /athlets(.:format)                        athlets#create
#                     new_athlet GET    /athlets/new(.:format)                    athlets#new
#                    edit_athlet GET    /athlets/:id/edit(.:format)               athlets#edit
#                         athlet GET    /athlets/:id(.:format)                    athlets#show
#                                PATCH  /athlets/:id(.:format)                    athlets#update
#                                PUT    /athlets/:id(.:format)                    athlets#update
#                                DELETE /athlets/:id(.:format)                    athlets#destroy
#             destroy_all_relays DELETE /relays/destroy_all(.:format)             relays#destroy_all
#                         relays GET    /relays(.:format)                         relays#index
#                                POST   /relays(.:format)                         relays#create
#                      new_relay GET    /relays/new(.:format)                     relays#new
#                     edit_relay GET    /relays/:id/edit(.:format)                relays#edit
#                          relay GET    /relays/:id(.:format)                     relays#show
#                                PATCH  /relays/:id(.:format)                     relays#update
#                                PUT    /relays/:id(.:format)                     relays#update
#                                DELETE /relays/:id(.:format)                     relays#destroy
#                           root GET    /                                         static_pages#home
#

Rails.application.routes.draw do
  resources :events

  resources :athlets do
    collection do
      get :autocomplete_firstname
      get :autocomplete_surname
      get :autocomplete_club
      post :import
      get :suggestions
      delete :destroy_all

      #get :new_multiple
      get :show_multiple
      get :new_multiple
      get :edit_multiple
      post :create_multiple
      put :update_multiple
      put :destroy_multiple
    end
  end

  resources :relays do
    collection do
      delete :destroy_all
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  get 'datatable_i18n', to: 'datatables#datatable_i18n'
  # https://gist.github.com/ricardodovalle/7244900
  #scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
  #  get 'datatable_i18n', to: 'datatables#datatable_i18n'
  #end
 
  #get '*path', to: redirect("/#{I18n.default_locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  #get '', to: redirect("/#{I18n.default_locale}")
end
