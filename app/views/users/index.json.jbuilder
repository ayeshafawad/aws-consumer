json.array!(@users) do |user|
  json.extract! user, :id, :email, :password, :aws_key_id, :aws_sa_key, :aws_region
  json.url user_url(user, format: :json)
end
