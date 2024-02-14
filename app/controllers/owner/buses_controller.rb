# app/controllers/owner/buses_controller.rb
class Owner::BusesController < ApplicationController
  before_action :set_bus, only: %i[show edit update destroy]
  before_action :require_bus_owner, only: [:new, :create]
  before_action :require_bus_owner_and_owner_match, only: [:edit, :update, :destroy]

  # GET /owner/buses
  # Display a list of buses owned by the current user
  def index
    @buses = current_user.buses
  end

  # GET /owner/buses/new
  # Display a form for adding a new bus
  def new
    @bus = current_user.buses.build
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  
  end

  # GET /owner/buses/1/edit
  # Display a form for editing a specific bus
  def edit
  end

  # GET /owner/buses/1
  # Display details of a specific bus
  def show
  end

  # POST /owner/buses
  # Create a new bus
  def create
    @bus = current_user.buses.build(bus_params)

    respond_to do |format|
      if @bus.save
        format.html { redirect_to owner_bus_url(@bus), notice: "Bus was successfully added." }
        format.json { render :show, status: :created, location: @bus }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /owner/buses/1
  # Update a specific bus
  def update
    if @bus.update(bus_params)
      redirect_to owner_bus_url(@bus), notice: "Bus was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /owner/buses/1
  # Remove a specific bus
  def destroy
    @bus.destroy!

    respond_to do |format|
      format.html { redirect_to owner_buses_url, notice: "Bus was successfully removed." }
      format.json { head :no_content }
    end
  end

  # POST /owner/buses/search
  # Search for buses based on source and/or destination
  def search
    route_source = params[:search_source]
    route_destination = params[:search_destination]

    case
    when route_source.present? && route_destination.present?
      @buses = current_user.buses.where("LOWER(route_source) = ? AND LOWER(route_destination) = ?", route_source.downcase, route_destination.downcase)
    when route_source.present?
      @buses = current_user.buses.where("LOWER(route_source) = ?", route_source.downcase)
    when route_destination.present?
      @buses = current_user.buses.where("LOWER(route_destination) = ?", route_destination.downcase)
    else
      flash[:alert] = "Please provide at least source or destination for the search."
      redirect_to owner_buses_path
      return
    end

    if @buses.empty?
      flash[:alert] = "No buses found for the specified route."
      redirect_to owner_buses_path
    else
      render 'owner/buses/index'
    end
  end

  private

  # Set the current bus based on the :id parameter
  def set_bus
    @bus = Bus.find_by(id: params[:id])

    unless @bus
      flash[:alert] = "Bus with ID #{params[:id]} not found."
      flash.keep(:alert)
      redirect_back(fallback_location: root_path)
    end
  end

  # Define the permitted parameters for creating/updating a bus
  def bus_params
    params.require(:bus).permit(:name, :registration_number, :route_source, :route_destination, :total_seats, :departure_time, :arrival_time)
  end

  # Check if the current user is authorized to add a new bus
  def require_bus_owner
    redirect_to owner_buses_path, alert: 'You are not authorized to add a new bus.' unless current_user&.bus_owner?
  end

  # Check if the current user is authorized to edit/remove the current bus
  def require_bus_owner_and_owner_match
    unless current_user&.bus_owner? && current_user == @bus.bus_owner
      redirect_to buses_path, alert: 'You are not authorized to edit/remove this bus!'
    end
  end
end
