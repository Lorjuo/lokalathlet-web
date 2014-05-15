class AthletsController < ApplicationController
  before_action :set_athlet, only: [:show, :edit, :update, :destroy]

  include ActionView::Helpers::TextHelper

  # Autocompletion
  def autocomplete_firstname
    render :json => Athlet.where('firstname LIKE ?', "%#{params[:term]}%").order(:firstname).pluck(:firstname).uniq
  end

  def autocomplete_surname
    render :json => Athlet.where('surname LIKE ?', "%#{params[:term]}%").order(:surname).pluck(:surname).uniq
  end

  def autocomplete_club
    render :json => Athlet.where('club LIKE ?', "%#{params[:term]}%").order(:club).pluck(:club).uniq
  end


  # Actions
  def import
    Athlet.import(params[:file])
    redirect_to(athlets_url, notice: "Athlets imported")
  end


  def index
    @athlets = Athlet.where(:relaytmsize => 1).all
    @relays = Athlet.where.not(:relaytmsize => 1).group(:relaystarter)

    respond_to do |format|
      format.html
      format.csv { send_data @relays.to_csv }
      format.xls { send_data @relays.to_xls(
        #:except => [:created_at, :updated_at]
        :columns => Athlet::allowed_attributes,
        :headers => Athlet::allowed_attributes
      ) }
    end
  end


  def show
  end


  def show_multiple
    @athlets = Athlet.where(:relaystarter => params[:relaystarter])
  end


  def new
    @athlet = Athlet.new
    @athlet.relaytmsize = 1
  end


  def edit
  end


  def edit_multiple
    @athlets = Athlet.where(:relaystarter => params[:relaystarter])
  end


  def create
    @athlet = Athlet.new(athlet_params)

    if @athlet.save
      redirect_to @athlet, notice: 'Athlet was successfully created.'
    else
      render :new
    end
  end


  def update
    if @athlet.update(athlet_params)
      redirect_to @athlet, notice: 'Athlet was successfully updated.'
    else
      render :edit
    end
  end

  def update_multiple
    athlets_attributes = params[:athlets] # make a temporary copy
    athlets_attributes.each do |key, value|
      value[:starter] = params[:athlet][:starter]
      value[:event] = params[:athlet][:event]
      value[:club] = params[:athlet][:club]
    end
    @athlets = Athlet.update(athlets_attributes.keys, athlets_attributes.values)
    @athlets.reject! { |p| p.errors.empty? }
    if @athlets.empty?
      redirect_to athlets_url
    else
      render "edit_multiple"
    end
  end


  def destroy
    @athlet.destroy
    redirect_to athlets_url, notice: 'Athlet was successfully destroyed.'
  end


  def destroy_multiple
    @athlets = Athlet.where(:relaystarter => params[:relaystarter])
    @athlets.destroy_all
    redirect_to athlets_url, notice: 'Relay was successfully destroyed.'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_athlet
      @athlet = Athlet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def athlet_params
      params.require(:athlet).permit(:starter, :firstname, :surname, :birthday, :sex, :club, :event, :relaytm, :relaystarter, :relaytmsize)
    end
end
