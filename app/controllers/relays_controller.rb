class RelaysController < ApplicationController
  before_action :set_relay, only: [:show, :edit, :update, :destroy]

  include ActionView::Helpers::TextHelper

  def index
    # @relays = Relay.all

    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @relays.to_csv }
    #   format.xls { send_data @relays.to_xls(
    #     #:except => [:created_at, :updated_at]
    #     :columns => Relay::allowed_attributes,
    #     :headers => Relay::allowed_attributes
    #   ) }
    # end
  end


  def show
  end


  def new
    event = Event.where(:name => params[:event]).first
    @relay = Relay.new(:relaytmsize => event.team_size, :event => event.name)
  end


  def edit
    pp @relay
  end


  def create
    @relay = Relay.new(relay_params)

    if @relay.save
      redirect_to relay_path(:id => @relay.relaystarter), notice: 'Relay was successfully created.'
    else
      render :new
    end
  end


  def update
    if @relay.update(relay_params)
      redirect_to relay_path(:id => @relay.relaystarter), notice: 'Relay was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @relay.destroy
    redirect_to relays_url, notice: 'Relay was successfully destroyed.'
  end


  def destroy_all
    @athlets = Athlet.where.not(:relaytmsize => 1)
    @athlets.destroy_all
    redirect_to root_url, notice: 'Relays were successfully destroyed.'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relay
      @relay = Relay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relay_params
      params.require(:relay).permit(:club, :event, :relaytm, :relaystarter, :relaytmsize,
        :athlets_attributes => [:starter, :firstname, :surname, :birthday, :sex, :club, :event, :relaytm, :relaystarter, :relaytmsize, :id, :transponderid])
    end
end