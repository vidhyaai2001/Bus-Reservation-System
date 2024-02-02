class BusesController < ApplicationController
  before_action :set_bus, only: %i[ show edit update destroy ]
  before_action :require_bus_owner, only: [:new,:create]
  before_action :require_bus_owner_and_owner_match, only: [:edit, :update, :destroy]


  # GET /buses or /buses.json
  def index
    @buses = Bus.all
  end

  # GET /buses/1 or /buses/1.json
  def show
  end

  # GET /buses/new
  def new
    @bus = current_user.buses.build
    
  end

  # GET /buses/1/edit
  def edit
  end

  # POST /buses or /buses.json
  def create
    @bus =current_user.buses.build(bus_params)

    respond_to do |format|
      if @bus.save
        format.html { redirect_to bus_url(@bus), notice: "Bus was successfully created." }
        format.json { render :show, status: :created, location: @bus }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buses/1 or /buses/1.json
  def update
    respond_to do |format|
      if @bus.update(bus_params)
        format.html { redirect_to bus_url(@bus), notice: "Bus was successfully updated." }
        format.json { render :show, status: :ok, location: @bus }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buses/1 or /buses/1.json
  def destroy
    @bus.destroy!

    respond_to do |format|
      format.html { redirect_to buses_url, notice: "Bus was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    # Retrieve the search parameters from the query string
    route_source= params[:search_source]
    route_destination = params[:search_destination]

    # Implement your search logic based on the provided parameters
    # For example:
    @buses = Bus.where( route_source:  route_source, route_destination: route_destination)
 
    # Add any additional logic or filtering as needed

    # Render the same view as your index action (assuming you want to display the results on the same page)
    render 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bus
      @bus = Bus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bus_params
      params.require(:bus).permit(:name, :registration_number, :route_source, :route_destination, :total_seats, :departure_time, :arrival_time)
    end
    def require_bus_owner
      redirect_to buses_path, alert: 'You are not authorized for add new bus.' unless current_user&.bus_owner?
    end

    def require_bus_owner_and_owner_match
      unless current_user&.bus_owner? && current_user == @bus.bus_owner
        redirect_to buses_path, alert: 'You are not authorized to edit/destroy this bus.'
      end
    end
end