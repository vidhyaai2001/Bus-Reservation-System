# app/models/bus.rb
class Bus < ApplicationRecord
   #Associations for Bus
  belongs_to :bus_owner, class_name: 'User'
  has_many :seats, dependent: :destroy
  has_many :reservations, dependent: :destroy

  #All Validations For Create Bus
  validates_presence_of :bus_owner
  validate  :bus_owner_must_be_bus_owner
  validates :name, presence: true, length: { maximum: 255 }
  validates :registration_number, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :route_source, presence: true, length: { maximum: 255 }
  validates :route_destination, presence: true, length: { maximum: 255 }
  validates :total_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
  validate :arrival_time_after_departure_time

  private

  def arrival_time_after_departure_time
    return unless departure_time && arrival_time

    errors.add(:arrival_time, 'must be after departure time') if arrival_time <= departure_time
  end


 # after_create :create_seats
 after_save :create_seats
  private

  def bus_owner_must_be_bus_owner
    errors.add(:bus_owner, 'must be a bus owner') unless bus_owner&.bus_owner?
  end



  # def create_seats
  #   total_seats.to_i.times do |i|
  #     seats.create(seat_number: "Seat #{i + 1}", status: false)
  #   end
  # end
  def create_seats
    # Only create seats if the bus is newly created or the total_seats attribute is changed
    if new_record? || saved_change_to_total_seats?
      seats.destroy_all  # Remove existing seats if any
      total_seats.to_i.times do |i|
        seats.create(seat_number: "Seat #{i + 1}")
      end
    end
  end
end