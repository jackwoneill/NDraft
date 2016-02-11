json.array!(@lineups) do |lineup|
  json.extract! lineup, :id, :top, :mid, :adc, :support, :jungler, :flex_1, :flex_2, :flex_3, :user_id, :contest_id
  json.url lineup_url(lineup, format: :json)
end
