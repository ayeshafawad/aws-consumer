json.array!(@policies) do |policy|
  json.extract! policy, :id, :name
  json.url policy_url(policy, format: :json)
end
