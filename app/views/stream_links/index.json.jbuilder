json.array!(@stream_links) do |stream_link|
  json.extract! stream_link, :id, :slate_id, :url
  json.url stream_link_url(stream_link, format: :json)
end
