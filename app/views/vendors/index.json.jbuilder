json.array!(@vendors) do |vendor|
  json.extract! vendor, :id, :name, :brand_id, :purchase_address, :contact, :backup
  json.url vendor_url(vendor, format: :json)
end
