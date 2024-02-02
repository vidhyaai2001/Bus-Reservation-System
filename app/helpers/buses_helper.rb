module BusesHelper

  def available_seates(bus)
    available =bus.total_seats-bus.reservations.count
  end
end
