class Relay < ActiveRecord::Base
  has_no_table
  has_many :athlets, :primary_key => :relaystarter, :foreign_key => :relaystarter, :class_name => RelayMember
  accepts_nested_attributes_for :athlets

  #attr_accessor :id
  attr_accessor :new_record

  column :club, :string
  column :event, :string
  column :relaystarter, :integer
  column :relaytmsize, :integer
  column :relaystarttime, :string


  validates :club, :presence => true, length: { minimum: 3 }
  validates :event, :presence => true
  validates :relaystarter, :presence => true

  after_initialize :set_defaults
  after_initialize :build_athlets

  #attr_accessible :club, :event, :relaystarter, :relaytm, :athlets_attributes
  #def id
  #  @id ||= 1
  #end
  
  def self.allowed_attributes
    ['club', 'event', 'relaystarter', 'relaytmsize']
  end

  def self.find(id)
    athlets = Athlet.where(:relaystarter => id)

    if athlets
      puts athlets.first.attributes
      relay = Relay.new(athlets.first.attributes.slice(*Relay.allowed_attributes).merge({:new_record => false}))
      pp relay
    else
      nil
    end
  end


  def self.all
    athlets = Athlet.where.not(:relaytmsize => 1).group(:relaystarter).all
    athlets.map{ |athlet| Relay.new(athlet.attributes.slice(*Relay.allowed_attributes).merge({:new_record => false})) }
  end

  def self.event(name)
    athlets = Athlet.where(:event => name).group(:relaystarter).all
    athlets.map{ |athlet| Relay.new(athlet.attributes.slice(*Relay.allowed_attributes).merge({:new_record => false})) }
  end

  def to_param
    self.relaystarter
  end

  def set_defaults
    #self.relaytmsize ||= self.event.team_size
    self.relaytmsize ||= 4
  end

  def build_athlets
    (relaytmsize - athlets.size).times do
      self.athlets.build
    end if self.new_record?
  end

  def save
    if valid?
      # Maybe capture this in a transaction
      index = 1
      self.athlets.map do |athlet|
        athlet.assign_attributes(self.attributes.slice(*Relay.allowed_attributes))
        athlet.starter = (athlet.relaystarter * 10) + index
        athlet.relaytm = index
        if athlet.transponderid.blank?
          athlet.transponderid = athlet.starter;
        end
        if athlet.starttime.blank?
          if !self.relaystarttime.blank?
              athlet.starttime = self.relaystarttime
          end
        end
        athlet.save
        index = index + 1
      end
    end
  end

  def destroy
    self.athlets.map(&:destroy)
  end

  # def update(params)
  #   params
  #   debugger
  # end
end