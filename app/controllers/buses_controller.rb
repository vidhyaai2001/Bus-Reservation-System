# app/controllers/buses_controller.rb
 class BusesController < ApplicationController
  before_action :set_bus, only: %i[show]

  # GET /buses
  # Display a list of all buses
  def index
    @buses = Bus.all
  end

  # GET /buses/1
  # Display details of a specific bus
  def show
  end

  # POST /buses/search
  # Search for buses based on source and/or destination
  def search
    route_source = params[:search_source].downcase
    route_destination = params[:search_destination].downcase

    case
    when route_source.present? && route_destination.present?
      @buses = Bus.where("LOWER(route_source) = ? AND LOWER(route_destination) = ?", route_source, route_destination)
    when route_source.present?
      @buses = Bus.where("LOWER(route_source) = ?", route_source)
    when route_destination.present?
      @buses = Bus.where("LOWER(route_destination) = ?", route_destination)
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

  # Set the current bus based on the :id parameter
  def set_bus
    @bus = Bus.find_by(id: params[:id])

    unless @bus
      flash[:alert] = "Bus with ID #{params[:id]} not found."
      flash.keep(:alert)
      redirect_to buses_path and return
    end
  end
end
