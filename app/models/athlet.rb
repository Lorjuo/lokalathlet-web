class Athlet < ActiveRecord::Base

  # Validation
  validates :firstname, :presence => true, length: { minimum: 3 }
  validates :surname, :presence => true, length: { minimum: 3 }
  # validates :name, uniqueness: { scope: :year, message: "should happen once per year" }
  validates :birthday, :presence => true, :inclusion => 1900..2100

  # Getter / Setter
  # http://stackoverflow.com/questions/2033069/convert-data-when-putting-them-into-a-database-using-active-record
  # http://openbook.galileocomputing.de/ruby_on_rails/ruby_on_rails_10_004.htm
  def birthday
    self[:birthday] ? self[:birthday].year : 2000
  end

  def birthday=(value)
    self[:birthday] = Date.new(value.to_i,1,1)
  end
end
