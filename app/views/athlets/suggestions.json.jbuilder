# json.athlets @athlets do |athlet|
#   json.id athlet.id
#   json.firstname athlet.firstname
#   json.surname athlet.surname
#   json.sex athlet.sex
#   json.birthday athlet.birthday
# end
json.set! :athlets do
  @athlets.each do |athlet|
    json.set! athlet.id do
      json.(athlet, :id, :firstname, :surname, :sex, :events, :birthday, :club)
    end
  end
end