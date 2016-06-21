# == Schema Information
#
# Table name: athlets
#
#  id           :integer          not null, primary key
#  starter      :integer
#  firstname    :string(255)
#  surname      :string(255)
#  birthday     :date
#  sex          :string(255)
#  club         :string(255)
#  event        :string(255)
#  relaytm      :integer
#  relaystarter :integer
#  created_at   :datetime
#  updated_at   :datetime
#  relaytmsize  :integer
#  transponderid :string(255)
#


class RelayMember < ActiveRecord::Base

  self.table_name = "athlets"

  def self.allowed_attributes
    ['id', 'starter', 'firstname', 'surname', 'birthday', 'sex', 'relaytm', 'relaystarter', 'relaytmsize', 'transponderid', 'starttime']
  end

  # Validation
  validates :firstname, :presence => true, length: { minimum: 3 }
  validates :surname, :presence => true, length: { minimum: 3 }
  #validates :birthday, :presence => true, :inclusion => 1900..2100
  validates :birthday, :presence => true
  validates :sex, :presence => true
  validates :transponderid, :presence => false

  # Getter / Setter
  # http://stackoverflow.com/questions/2033069/convert-data-when-putting-them-into-a-database-using-active-record
  # http://openbook.galileocomputing.de/ruby_on_rails/ruby_on_rails_10_004.htm
  def birthday
    #self[:birthday] ? self[:birthday].year : nil
    self[:birthday] ? self[:birthday] : nil
  end

  def birthday=(value)
    # old : self[:birthday] = Date.new(value.to_i,1,1)
    datestr = String.try_convert(value)
    if !datestr.blank? && datestr.size == 4
      self[:birthday] = Date.new(datestr.to_i,1,1)
    else
      self[:birthday] = Date.strptime(value, '%Y-%m-%d')
    end

  end

  # Virtual Attributes
  
  def name
    "#{self.firstname} #{self.surname}"
  end

  def relay
    Relay.find(relaystarter)
  end
end
