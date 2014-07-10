json.array!(@iams) do |iam|
  json.extract! iam, :id, :name
  json.url iam_url(iam, format: :json)
end
