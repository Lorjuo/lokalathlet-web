class Event < ActiveRecord::Base
  validates :team_size, :presence => :true
end
