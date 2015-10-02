class AthletsController < ApplicationController
  before_action :set_athlet, only: [:show, :edit, :update, :destroy]

  include ActionView::Helpers::TextHelper

  # Autocompletion
  def autocomplete_firstname
    render :json => Athlet.where('firstname LIKE ?', "%#{params[:term]}%").limit(15).order(:firstname).pluck(:firstname).uniq
  end

  def autocomplete_surname
    render :json => Athlet.where('surname LIKE ?', "%#{params[:term]}%").limit(15).order(:surname).pluck(:surname).uniq
  end

  def autocomplete_club
    render :json => Athlet.where('club LIKE ?', "%#{params[:term]}%").limit(15).order(:club).pluck(:club).uniq
  end


  # Actions
  def import
    Athlet.import(params[:file])
    redirect_to(root_url, notice: "Athlets imported")
  end


  def index
    if params[:event]
      p params[:event]
      @athlets = Athlet.order(:event).order(:starter).where(:event => params[:event])
    else
      if params[:transponderid]
        p params[:transponderid]
        @athlets = Athlet.order(:event).order(:starter).where(:transponderid => params[:transponderid]).all
        #@athlets = Athlet.joins(:event).where(events: {active: true}).order(:event).order(:starter).where(:transponderid => params[:transponderid]).all
      else
        @athlets = Athlet.order(:event).order(:starter).all
      end
    end

    #@athlets = Athlet.where(:relaytmsize => 1).all
    #@relays = Athlet.where.not(:relaytmsize => 1).group(:relaystarter)

    respond_to do |format|
      format.html
      format.csv { send_data @athlets.to_csv }
      #format.xls { send_data @athlets.to_xls }

      # gem 'to_xls-rails'
      format.xls {
        #response.headers["Content-Disposition"] = 'attachement; filename='+Time.now.strftime("%Y%m%dT%H%M%S")+'.txt'
        send_data @athlets.to_xls(
                      #:except => [:created_at, :updated_at]
                      :only => Athlet::allowed_attributes.map { |x| x.to_sym },
                      :header => true,
                      :header_columns => Athlet::allowed_attributes,
                      #:prepend => [["Col 0, Row 0", "Col 1, Row 0"], ["Col 0, Row 1"]]
                  ), :filename => Time.now.strftime("%Y%m%dT%H%M%S")+'.xls' }

      format.json { render json: @athlets }
      #format.json { render json: @athlets.to_json(:except => :event) }
      format.xml { render xml: @athlets }
    end
  end


  def show
    respond_to do |format|
      format.html
      format.json { render json: @athlet }
      format.xml { render xml: @athlet }
    end
  end

  def suggestions
    #@athlets = Athlet.select("athlets.*, GROUP_CONCAT(athlets.event SEPARATOR ', ') AS events")
    # sqlite variante
    @athlets = Athlet.select("athlets.*, GROUP_CONCAT(athlets.event, ', ') AS events")
    @athlets = @athlets.group("firstname, surname, sex, birthday").limit(5)
    @athlets = @athlets.where("firstname LIKE (?)", "%#{params[:firstname]}%") if params[:firstname].present?
    @athlets = @athlets.where("surname LIKE (?)", "%#{params[:surname]}%") if params[:surname].present?
    # TODO: year and sex
  end


  def show_multiple
    @athlets = Athlet.where(:relaystarter => params[:relaystarter])
  end


  def new
    @athlet = Athlet.new(:event => params[:event])
    @athlet.relaytmsize = 1
    session[:event] = params[:event]
  end


  def new_multiple
    @athlets = [];
    3.times { @athlets << Athlet.new({:relaytmsize => 3}) }
    render :form_multiple
  end


  def edit
    session[:event] = params[:event]
  end


  def edit_multiple
    @athlets = Athlet.where(:relaystarter => params[:relaystarter])
    render :form_multiple
  end


  def create
    @athlet = Athlet.new(athlet_params)
    @athlet.relaytmsize = 1
    if @athlet.transponderid.blank?
      @athlet.transponderid = @athlet.starter;
    end
    if @athlet.save
      #https://github.com/rails-api/rails-api/blob/master/lib/rails-api/templates/rails/scaffold_controller/controller.rb
      respond_to do |format|
        format.html { redirect_to @athlet, notice: 'Athlet was successfully created.' }
        format.json { render json: @athlet, status: :created, location: @athlet }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @athlet.errors, status: :unprocessable_entity }
      end
    end

  end


  def create_multiple
    athlets_attributes = params[:athlets] # make a temporary copy
    @athlets = []
    athlets_attributes.each do |value|
      value[:starter] = params[:athlet][:starter]
      value[:relaystarter] = params[:athlet][:relaystarter]
      value[:event] = params[:athlet][:event]
      value[:club] = params[:athlet][:club]

      @athlets << Athlet.new(check_permission(value))
    end

    begin
      Athlet.transaction do
        success = @athlets.map(&:save!)
      end
    rescue ActiveRecord::RecordInvalid => invalid
      render :form_multiple
      return
    end
    redirect_to athlets_url, notice: 'Relay was successfully updated.'
    #http://ramblingabout.wordpress.com/2009/05/23/saving-different-active-record-classes-in-a-single-transaction/
    #http://stackoverflow.com/questions/2567133/work-with-rescue-in-rails
    #http://stackoverflow.com/questions/6326451/rails-3-transactions-rolling-back-everything
    #http://stackoverflow.com/questions/2246036/rails-transaction-doesnt-rollback-on-validation-error
    #http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
  end


  def update

    if params[:athlet][:transponderid].blank?
      params[:athlet][:transponderid] = params[:athlet][:starter]
    end
    if @athlet.update(athlet_params)
      #https://github.com/rails-api/rails-api/blob/master/lib/rails-api/templates/rails/scaffold_controller/controller.rb
      respond_to do |format|
        format.html { redirect_to @athlet, notice: 'Athlet was successfully updated.' }
        #format.json { head :no_content }
        format.json { render json: @athlet, status: :created, location: @athlet }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @athlet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_multiple
    athlets_attributes = params[:athlets] # make a temporary copy
    athlets_attributes.each do |key, value|
      #athlets_attributes.each do |value|
      value[:starter] = params[:athlet][:starter]
      value[:event] = params[:athlet][:event]
      value[:club] = params[:athlet][:club]
    end
    @athlets = Athlet.update(athlets_attributes.keys, athlets_attributes.values)
    @athlets.reject! { |p| p.errors.empty? }
    if @athlets.empty?
      redirect_to athlets_url, notice: 'Relay was successfully updated.'
    else
      render :form_multiple
    end
  end


  def destroy
    @athlet.destroy

    #https://github.com/rails-api/rails-api/blob/master/lib/rails-api/templates/rails/scaffold_controller/controller.rb
    respond_to do |format|
      format.html { redirect_to athlets_url, notice: 'Athlet was successfully destroyed.' }
      #format.json { head :no_content }
      format.json { head :no_content, status: :success }
    end
  end


  def destroy_multiple
    @athlets = Athlet.where(:relaystarter => params[:relaystarter])
    @athlets.destroy_all
    redirect_to athlets_url, notice: 'Relay was successfully destroyed.'
  end


  def destroy_all
    @athlets = Athlet.where(:relaytmsize => 1)
    @athlets.destroy_all
    redirect_to root_url, notice: 'Athlets were successfully destroyed.'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_athlet
    @athlet = Athlet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def athlet_params
    params.require(:athlet).permit(:starter, :firstname, :surname, :birthday, :sex, :club, :event, :relaytm, :relaystarter, :relaytmsize, :transponderid, :starttime)
  end

  def check_permission(attributes)
    attributes.permit(:starter, :firstname, :surname, :birthday, :sex, :club, :event, :relaytm, :relaystarter, :relaytmsize, :transponderid, :starttime)
  end
end
