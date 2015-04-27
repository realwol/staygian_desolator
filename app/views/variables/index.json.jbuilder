json.array!(@variables) do |variable|
  json.extract! variable, :id, :color, :size, :price, :product_id, :deleted_at, :image_url1, :stock
  json.url variable_url(variable, format: :json)
end
