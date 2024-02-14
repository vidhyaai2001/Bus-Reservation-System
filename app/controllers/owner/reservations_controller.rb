# app/controllers/owner/reservations_controller.rb
class Owner::ReservationsController < ApplicationController
  before_action :set_bus

  # GET /owner/buses/:bus_id/reservations
  # Display reservations for a specific bus on a given date
  def index
    date = params[:date]
    
    # Fetch all seats for the current bus
    @seats = @bus.seats
    
    # Fetch reserved seat IDs for the given date
   # @reserved_seat_ids = @bus.reservations.for_date(date).pluck(:seat_id).to_set
    if date.present?
    # Fetch reserved seat IDs for the given date
    @seats = @bus.seats
    @reserved_seat_ids = @bus.reservations.for_date(date).pluck(:seat_id).to_set
  else
    # Fetch all reservations for the bus (when date is nil)
   # @reserved_seat_ids = @bus.reservations.pluck(:seat_id).to_set
   @reservations = @bus.reservations
  end
  respond_to do |format|
    format.html
    format.turbo_stream
  end
  end
  
  private

  # Set the current bus based on the :bus_id parameter
  def set_bus
    @bus = Bus.find(params[:bus_id])
  end
end
