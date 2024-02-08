# app/models/bus.rb
class Bus < ApplicationRecord
   #Associations for Bus
  belongs_to :bus_owner, class_name: 'User'
  has_many :seats, dependent: :destroy
  has_many :reservations
  has_many :reserve_seats, through: :reservations, source: :seat

  #All Validations For Create Bus
  #validates_presence_of :bus_owner
  validate  :bus_owner_must_be_bus_owner

  validates :name, presence: true, length: { maximum: 255 }
  validate :name_does_not_start_with_digit, unless: -> { name.blank? }

  validates :registration_number, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :route_source, presence: true, length: { maximum: 255 }
  validates :route_destination, presence: true, length: { maximum: 255 }

  validates :total_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }, unless: -> { errors[:total_seats].any? }
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
 # validate :arrival_time_after_departure_time
  
  after_save :create_seats, if: :saved_change_to_total_seats?
  before_save :validate_editable_total_seats
  private
  # def arrival_time_after_departure_time
  #   return unless departure_time && arrival_time
  #   errors.add(:arrival_time, 'must be after departure time') if arrival_time <= departure_time
  # end
  def bus_owner_must_be_bus_owner
    errors.add(:bus_owner, 'must be a bus owner') unless bus_owner&.bus_owner?
  end
  def name_does_not_start_with_digit
    if name =~ /\A\d/
      errors.add(:name, "should not start with a digit")
    end
  end
  def validate_editable_total_seats
    return unless total_seats_changed?
  
    if reservations.exists?
      errors.add(:total_seats, "cannot be edited when reservations exist")
      throw(:abort)
    end
  end
  
  def create_seats
    # Only create seats if the bus is newly created or the total_seats attribute is changed
    # and there are no reservations associated with the bus
    if (new_record? || saved_change_to_total_seats?) && reservations.none?
      seats.destroy_all  # Remove existing seats if any
      total_seats.to_i.times do |i|
        seats.create(seat_number: "Seat #{i + 1}")
      end
    end
  end
  
  
end