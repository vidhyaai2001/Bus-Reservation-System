# app/helpers/reservations_helper.rb

module ReservationsHelper
  def seat_reserved?(seat, reserved_seat_ids)
    reserved_seat_ids.include?(seat.id)
  end
end