json.array!(@contests) do |contest|
  json.extract! contest, :id, :title, :fee, :start_time, :max_size, :curr_size, :prize_pool
  json.url contest_url(contest, format: :json)
end
