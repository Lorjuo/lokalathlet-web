json.array! @athlets do |athlet|
  json.id athlet.id
  json.starter athlet.starter
  json.firstname athlet.firstname
  json.surname athlet.surname
  json.birthday athlet.birthday
  json.sex athlet.sex
  json.club athlet.club
  json.event athlet.event.name
  json.relaytm athlet.relaytm
  json.relaystarter athlet.relaystarter
  json.relaytmsize athlet.relaytmsize
  json.transponderid athlet.transponderid
  json.starttime athlet.starttime
end