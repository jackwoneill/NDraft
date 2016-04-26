json.array!(@positions) do |position|
  json.extract! position, :id, :game_id, :name, :abbr, :pos_num, :num_allowed
  json.url position_url(position, format: :json)
end
