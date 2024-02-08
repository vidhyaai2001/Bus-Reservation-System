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
        format.html { redirect_to bus_url(@bus), notice: "Bus was successfully added." }
        format.json { render :show, status: :created, location: @bus }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buses/1 or /buses/1.json
  def update
      if @bus.update(bus_params)
        redirect_to bus_url(@bus), notice: "Bus was successfully updated."
      else
        render :edit, status: :unprocessable_entity 
      end
  end

  # DELETE /buses/1 or /buses/1.json
  def destroy
    @bus.destroy!

    respond_to do |format|
      format.html { redirect_to buses_url, notice: "Bus was successfully removed." }
      format.json { head :no_content }
    end
  end

  def search
    route_source = params[:search_source]
    route_destination = params[:search_destination]
    case
    when route_source.present? && route_destination.present?
      @buses = Bus.where("LOWER(route_source) = ? AND LOWER(route_destination) = ?", route_source.downcase, route_destination.downcase)
    when route_source.present?
      @buses = Bus.where("LOWER(route_source) = ?", route_source.downcase)
    when route_destination.present?
      @buses = Bus.where("LOWER(route_destination) = ?", route_destination.downcase)
    else
      flash[:alert] = "Please provide at least source or destination for the search."
      redirect_to buses_path
      return
    end
    if @buses.empty?
      flash[:alert] = "No buses found for the specified route."
      redirect_to buses_path
    else
      render 'index'
    end
  end
  
  

  private
    def set_bus
      @bus = Bus.find_by(id: params[:id])
      unless @bus
        flash[:alert] = "Bus with ID #{params[:id]} not found."
        flash.keep(:alert)
        redirect_to buses_path and return
      end
    end
    def bus_params
      params.require(:bus).permit(:name, :registration_number, :route_source, :route_destination, :total_seats, :departure_time, :arrival_time)
    end
    def require_bus_owner
      redirect_to buses_path, alert: 'You are not authorized for add new bus.' unless current_user&.bus_owner?
    end

    def require_bus_owner_and_owner_match
      unless current_user&.bus_owner? && current_user == @bus.bus_owner
        redirect_to buses_path, alert: 'You are not authorized to edit/remove this bus!'
      end
    end
end