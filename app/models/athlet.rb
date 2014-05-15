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
#

class Athlet < ActiveRecord::Base

  require 'csv'

  # Validation
  validates :starter, :presence => true, :inclusion => 0..2000 # TODO: restrict this
  validates :firstname, :presence => true, length: { minimum: 3 }
  validates :surname, :presence => true, length: { minimum: 3 }
  # validates :name, uniqueness: { scope: :year, message: "should happen once per year" }
  validates :birthday, :presence => true, :inclusion => 1900..2100
  validates :sex, :presence => true
  validates :club, :allow_blank => :true, length: { minimum: 3 }
  validates :event, :presence => true

  # Getter / Setter
  # http://stackoverflow.com/questions/2033069/convert-data-when-putting-them-into-a-database-using-active-record
  # http://openbook.galileocomputing.de/ruby_on_rails/ruby_on_rails_10_004.htm
  def birthday
    self[:birthday] ? self[:birthday].year : 2000
  end

  def birthday=(value)
    self[:birthday] = Date.new(value.to_i,1,1)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |athlet|
        csv << athlet.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    allowed_attributes = ['id', 'starter', 'firstname', 'surname', 'birthday', 'sex', 'club', 'event', 'relaytm', 'relaystarter']

    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      athlet = find_by_id(row["id"]) || new
      athlet.attributes = row.to_hash.slice(*allowed_attributes)
      athlet.save! if athlet.valid?
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
