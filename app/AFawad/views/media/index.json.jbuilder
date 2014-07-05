json.array!(@media) do |medium|
  json.extract! medium, :id, :name, :description, :asset_file_name, :asset_content_type, :asset_file_size
  json.url medium_url(medium, format: :json)
end
