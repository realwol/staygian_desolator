json.array!(@roles) do |role|
  json.extract! role, :id, :name, :parent_id
  json.url role_url(role, format: :json)
end
