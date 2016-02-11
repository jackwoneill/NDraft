json.array!(@games) do |game|
  json.extract! game, :id, :team_1, :team_2, :start_time
  json.url game_url(game, format: :json)
end
