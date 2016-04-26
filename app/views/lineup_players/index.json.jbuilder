json.array!(@lineup_players) do |lineup_player|
  json.extract! lineup_player, :id, :lineup_id, :player_id
  json.url lineup_player_url(lineup_player, format: :json)
end
