Rails.application.routes.draw do
  resources :cash_rates, only:[:index, :create]

  resources :variables
  resources :shops do
    member do
      get 'shield'
      get 'recover'
    end
  end

  resources :products do
    collection do
      get 'get_tmall_links'
      post 'save_tmall_links'
      get 'un_updated_page'
      get 'export_page'
      get 'export_products'
      get 'shield_products'
      get 'presaled_products'
      get 'off_sale_products'
      get 'temp_off_sale_products'
      get 'check_shop_id'
      get 'search'
      get 'update_price'
    end

    member do
      get 'shield_product'
      get 'presale_product'
      get 'offsale_product'
      get 'onsale_product'
      get 'temp_offsale_product'
    end
  end

  resources :product_types

  devise_for :users
  resources :users

  root 'products#index'
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
