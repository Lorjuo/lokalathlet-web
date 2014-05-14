json.array!(@athlets) do |athlet|
  json.extract! athlet, :id, :starter, :firstname, :surname, :birthday, :sex, :club, :event, :relaytm, :relaystarter
  json.url athlet_url(athlet, format: :json)
end
