json.array!(@withdrawals) do |withdrawal|
  json.extract! withdrawal, :id, :user_id, :amount, :completed
  json.url withdrawal_url(withdrawal, format: :json)
end
