json.array!(@departments) do |department|
  json.extract! department, :id, :name, :parent_id, :backup
  json.url department_url(department, format: :json)
end
