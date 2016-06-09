json.array!(@brands) do |brand|
  json.extract! brand, :id, :name, :english_name, :status
  json.url brand_url(brand, format: :json)
end
