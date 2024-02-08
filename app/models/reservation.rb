class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :seat
  belongs_to :bus
  
  
  validates :reservation_date, presence: true
  validate :at_least_one_seat_selected

  # Add other validations as needed
  scope :for_date, ->(date) { where(reservation_date: date) }
  private
  def at_least_one_seat_selected
    errors.add(:base, 'At least one seat must be --------selected') unless seat_id.present?
  end
end
