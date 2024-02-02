class ReservationsController < ApplicationController
  before_action :set_bus
  before_action :require_bus_owner_and_owner_match, only: [:index]
  before_action :authenticate_user!
  def new
    #@bus = Bus.find(params[:bus_id])
    @reservation = Reservation.new
    date = params[:date]
    @bus = Bus.find(params[:bus_id])
    @reservations = @bus.reservations.where(reservation_date: date)
    @all_seats = @bus.seats

    respond_to do |format|
      format.html { render 'new' } # Render the 'new' template (the form)
      format.json { render json: { reservations: @reservations, all_seats: @all_seats } }
    end
  end
  def index
    @reservation = Reservation.new
    @reservations = @bus.reservations.where(reservation_date: params[:date])
  end
  def show
    #@bus = Bus.find(params[:bus_id])
    @reservations = current_user.reservations
    
  end
  def create
  
     # Assuming you have a @bus object and you want to create reservations for it
     @bus = Bus.find(params[:bus_id])
  
     # Assuming you have a current_user method to get the logged-in user
     @user = current_user
  
     # Permitting an array of seat_id values
     seat_ids = params.require(:reservation).permit(seat_id: [])[:seat_id]
  
     # Creating reservations for each seat_id
     seat_ids.each do |seat_id|
       @reservation = Reservation.new(bus: @bus, user: @user,reservation_date: params[:reservation][:reservation_date] , seat_id: seat_id)
       #seat=Seat.find(seat_id)
       #seat.update(status: true)
       if @reservation.save
        # format.html { redirect_to reservation_url(@reservation), notice: "Seat Reserved Succesfully !" }
        # format.json { render :show, status: :created, location: @reservation }
        flash[:notice] = "Seat Reserved Successfully!"
       else
         flash[:alert] = "Error occurred while reserving seats."
         render :new, status: :unprocessable_entity
         return
       end
     end
     redirect_to bus_reservation_path(@bus,@reservation)
     # Redirect or render as needed
   end

 def destroy
    @reservation = @bus.reservations.find(params[:id])
    if @reservation.destroy
      flash[:notice]= 'Reservation was successfully canceled.'
    else
      flash[:alert] = "Error occurred while canceled seats."
      redirect_to bus_reservation_path(@bus,@reservation)
      return
    end
    bus_reservation_path(@bus,@reservation)
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
    params.require(:reservation).permit(:bus_id,:reservation_date,seat_id: [])
  end
  
end