json.array!(@players) do |player|
  json.extract! player, :id, :id, :name, :team, :salary
  json.url player_url(player, format: :json)
end
