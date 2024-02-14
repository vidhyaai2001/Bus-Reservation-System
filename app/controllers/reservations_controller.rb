class ReservationsController < ApplicationController
  before_action :set_bus, only: [:new,:create,:destroy]
  #before_action :require_bus_owner_and_owner_match, only: [:index]
  before_action :authenticate_user!
  def new
    date = params[:date]
    @reservation = Reservation.new
    @seats = @bus.seats
    @reserved_seat_ids = @bus.reservations.for_date(date).pluck(:seat_id).to_set
  end
  def index
     @reservations = current_user.reservations
  end
  def create  
    seat_ids = params[:reservation][:seat_id]
    date = params[:reservation][:reservation_date]
  
    if date.present? && seat_ids.present?
      reservations = seat_ids.map { |seat_id| Reservation.new(reservation_params.merge(seat_id: seat_id)) }
  
      Reservation.transaction do
        if reservations.all?(&:valid?) && !conflict_exists?(reservations)
          reservations.each(&:save)
          flash[:notice] = "Seats Reserved Successfully!"
          redirect_to reservations_path()
        else
          flash[:alert] = "Once a seat is booked, you cannot rebook it for the same date."
          redirect_to new_bus_reservation_path(@bus, date: date)
        end
      end
    else
      flash[:alert] = "Please select a date and at least one seat."
      redirect_to new_bus_reservation_path(@bus, date: date)
    end
  end
  def destroy
    @reservation = @bus.reservations.find(params[:id])
    if @reservation.destroy
      flash[:notice]= 'Reservation was successfully canceled.'
    else
      flash[:alert] = "Error occurred while canceled seats."
    end
    redirect_back(fallback_location:bus_reservation_path(@bus,@reservation))
  end
  private
  def require_bus_owner_and_owner_match
    unless current_user&.bus_owner? && current_user == @bus.bus_owner
      redirect_to buses_path, alert: 'You are not authorized to see reservations!'
    end
  end
  def set_bus
    @bus = Bus.find(params[:bus_id])
  end
  def reservation_params
    params.require(:reservation).permit(:bus_id,:user_id,:reservation_date,seat_id: [])
  end
  
  def conflict_exists?(reservations)
    existing_reservations = Reservation.where(
      reservation_date: reservations.first.reservation_date,
      seat_id: reservations.map(&:seat_id)
    )
     existing_reservations.present?
  end

end