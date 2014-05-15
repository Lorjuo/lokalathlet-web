class AthletsController < ApplicationController
  before_action :set_athlet, only: [:show, :edit, :update, :destroy]

  include ActionView::Helpers::TextHelper

  def autocomplete_firstname
    render :json => Athlet.where('firstname LIKE ?', "%#{params[:term]}%").order(:firstname).pluck(:firstname).uniq
  end

  def autocomplete_surname
    render :json => Athlet.where('surname LIKE ?', "%#{params[:term]}%").order(:surname).pluck(:surname).uniq
  end

  def autocomplete_club
    render :json => Athlet.where('club LIKE ?', "%#{params[:term]}%").order(:club).pluck(:club).uniq
  end

  def import
    Athlet.import(params[:file])
    redirect_to(athlets_url, notice: "Athlets imported")
  end

  # GET /athlets
  # GET /athlets.json
  def index
    @athlets = Athlet.all

    respond_to do |format|
      format.html
      format.csv { send_data @athlets.to_csv }
      format.xls { send_data @athlets.to_xls(:except => [:created_at, :updated_at]) }
    end
  end

  # GET /athlets/1
  # GET /athlets/1.json
  def show
  end

  # GET /athlets/new
  def new
    @athlet = Athlet.new
  end

  # GET /athlets/1/edit
  def edit
  end

  # POST /athlets
  # POST /athlets.json
  def create
    @athlet = Athlet.new(athlet_params)

    respond_to do |format|
      if @athlet.save
        format.html { redirect_to @athlet, notice: 'Athlet was successfully created.' }
        format.json { render :show, status: :created, location: @athlet }
      else
        format.html { render :new }
        format.json { render json: @athlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /athlets/1
  # PATCH/PUT /athlets/1.json
  def update
    respond_to do |format|
      if @athlet.update(athlet_params)
        format.html { redirect_to @athlet, notice: 'Athlet was successfully updated.' }
        format.json { render :show, status: :ok, location: @athlet }
      else
        format.html { render :edit }
        format.json { render json: @athlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /athlets/1
  # DELETE /athlets/1.json
  def destroy
    @athlet.destroy
    respond_to do |format|
      format.html { redirect_to athlets_url, notice: 'Athlet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_athlet
      @athlet = Athlet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def athlet_params
      params.require(:athlet).permit(:starter, :firstname, :surname, :birthday, :sex, :club, :event, :relaytm, :relaystarter)
    end
end
