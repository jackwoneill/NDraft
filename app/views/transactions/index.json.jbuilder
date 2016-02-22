json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :amount, :user_id, :description
  json.url transaction_url(transaction, format: :json)
end
