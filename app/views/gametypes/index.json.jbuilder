json.array!(@gametypes) do |gametype|
  json.extract! gametype, :id, :name, :abbr
  json.url gametype_url(gametype, format: :json)
end
