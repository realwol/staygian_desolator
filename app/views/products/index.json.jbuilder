json.array!(@products) do |product|
  json.extract! product, :id, :product_type_id, :title, :sku, :sku_number, :product_number, :user_id, :origin_address, :desc1, :brand, :price, :on_sale, :translate_status, :product_from, :details
  json.url product_url(product, format: :json)
end
