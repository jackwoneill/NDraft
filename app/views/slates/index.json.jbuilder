json.array!(@slates) do |slate|
  json.extract! slate, :id, :start_time, :name
  json.url slate_url(slate, format: :json)
end
