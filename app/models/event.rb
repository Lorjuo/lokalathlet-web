# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  team_size  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
  validates :team_size, :presence => :true
end
