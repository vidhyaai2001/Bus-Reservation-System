module ApplicationHelper
  # Assuming this method is defined in a helper or directly in the view
def reservation_exists?(seat_id)
  @reservations.present? && @reservations.pluck(:seat_id).include?(seat_id)
end
def seat_reserved?(seat_id)
  @reservations.pluck(:seat_id).include?(seat_id)
end

end
