class Customer
  include Cequel::Record

  key :id, :timeuuid, auto: true
  column :firstname, :text, :index => true
  column :surname, :text, :index => true
  column :birthday, :timestamp
  column :sex, :text
  column :email, :text
  column :club, :text
  column :extra_start_time, :timestamp
  column :note, :text
  column :transponder_id, :text
end