Rails.application.routes.draw do
  resources :roles do
    collection do
      get 'auth_list_index'
      post 'create_auth'
      post 'update_auth_role_relation'
      post 'update_auth_status'
    end
  end
  resources :departments
  resources :vendors do
    member do
      post 'update_vendor_info'
    end
  end

  resources :merchants do
    member do
      get 'get_merchant_skus'
      post 'stop_merchant'
      post 'add_merchant_product'
      post 'update_shipment_cost'
      delete 'remove_merchant_binding_sku'
    end

    collection do
      get 'account_list'
      get 'export_account'
      get 'export_all_account'
      post 'create_account'
      post 'set_account_updated'
      delete 'remove_account'
    end
  end
  resources :brands do
    member do
      post 'update_brand_english_name'
      post 'forbidden_brand'
      post 'update_brand_shop_status'
      post 'recover_brand'
    end

    collection do
      get 'forbidden_brand_list'
    end
  end

  get 'merchant/index'
  post 'merchant/create'
  delete 'merchant/remove'

  resources :cash_rates, only:[:index, :create]

  resources :variables, only: [:index] do
    collection do
      get 'translate_variables'
      get 'variable_translate_list'
      get 'variable_search'
      post 'update_translate_variable'
      post 'save_translate_variable'
      delete 'remove_variable'
      delete 'remove_translate_variable'
    end
  end
  resources :shops do
    member do
      get 'shield'
      get 'recover'
      post 'add_back_up'
      delete 'stop_and_delete'
    end
    collection do
      post 'search'
    end
  end

  resources :products do
    collection do
      get 'get_product_links_from_search_link'
      get 'patch_translate_binding'
      get 'stand_by_products'
      get 'removed_products'
      get 'unchecked_products'
      get 'grasp_product_from_link'
      get 'product_detail_forbidden'
      get 'product_grasp_filter'
      get 'wait_designer'
      get 'get_tmall_links'
      get 'get_tmall_link_from_link'
      get 'un_updated_page'
      get 'export_page'
      get 'export_products'
      get 'shield_products'
      get 'edited_products'
      get 'presaled_products'
      get 'off_sale_products'
      get 'temp_off_sale_products'
      get 'check_shop_id'
      get 'search'
      get 'update_price'
      get 'change_product_type'
      get 'change_product_type'
      post 'save_search_link'
      post 'save_tmall_link'
      post 'patch_translate'
      post 'search_shop'
      post 'create_product_forbidden_word'
      post 'create_product_grasp_filter'
      post 'custome_upload_image'
      post 'update_product_type'
      post 'save_tmall_links'
      post 'temp_off_sale_all'
      post 'off_sale_all'
      post 'shield_all'
      post 'on_sale_all'
      post 'update_attributes_div'
      delete 'remove_key_word'
    end

    member do
      get 'regrasp_product'
      get 'translate_preview'
      get 'shield_product'
      get 'edited_product'
      get 'presale_product'
      get 'offsale_product'
      get 'onsale_product'
      get 'temp_offsale_product'
      post 'update_separate_product'
    end
  end

  resources :product_types do
    member do
      get 'next_product_types_list'
      get 'update_price_setting'
      post 'update_product_type_translation'
      post 'update_final_type'
      post 'update_shipment_method'
      post 'update_product_type_attribute'
      post 'update_description'
      post 'update_type_setting'
      post 'update_type_introduction'
      post 'update_key_words'
      delete 'remove_product_type_attribute'
    end

    collection do
      get 'search_des_translation'
      get 'description_translation_history_page'
      get 'update_price_setting'
      post 'save_desc_translation'
      post 'get_children_product_types'
      post 'update_shipment_method'
      post 'update_product_type_attribute'
      post 'update_description'
      post 'update_type_setting'
      post 'update_type_introduction'
      delete 'remove_product_type_attribute'
      delete 'remove_shipment_relation'
      delete 'remove_desc_translation'
    end
  end

  devise_for :users
  resources :users do
    collection do
      get 'user_statistic'
      post 'create_new_user'
      post 'set_selected_user'
      post 'create_user_from_depart'
      post 'update_responser'
    end

    member do
      post 'change_user_password'
      post 'admin_reset_user_pwd'
      post 'reset_user_pwd'
      get 'show_little_brothers'
      get 'user_setting'
    end
  end
  resources :shipments do 
    collection do
      post 'save_shipment_value'
      post 'delete_shipment_method_value'
    end
  end

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
