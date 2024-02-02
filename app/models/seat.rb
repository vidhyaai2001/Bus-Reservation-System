class Seat < ApplicationRecord
  belongs_to :bus
  has_many :reservations
  scope :status, -> { where(status: true) }
  def status_for_date(reservation_date)
    reservations_on_date = reservations.where(reservation_date: reservation_date)
    reservations_on_date.present? ? true : false
  end
end
