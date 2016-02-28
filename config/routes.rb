Rails.application.routes.draw do


  get 'deposits/verify#'

  resources :transactions
  resources :deposits
  resources :notifications
  get 'contests/upcoming'
  get 'contests/live'
  get 'contests/completed'
  get 'contests/pay5050'

  devise_for :users
  resources :stream_links, path: :watch
  resources :admin
  resources :notifications
  resources :lineups
  resources :slates
  resources :games
  resources :contests
  resources :teams
  resources :players do
    collection do 
      put 'update_individual'
    end
  end
  root 'welcome#index'
 

  get 'slates/:id/payout' => 'slates#payout'

  get 'players/:id/clearscore' => 'players#clearscore', :as => :clearscore

  get 'slates/:id/scores' => 'slates#scores'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
end
