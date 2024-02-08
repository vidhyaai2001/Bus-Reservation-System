class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :buses, foreign_key: :bus_owner_id, dependent: :destroy
  has_many :reservations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
      
         validates :user_name, presence: true, length: { maximum: 255 }
         validates :phone, presence: true,numericality: { only_integer: true }, length: { is: 10 }
        
         validates :user_type, presence: true, inclusion: { in: ['customer', 'bus_owner'] }
         validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

         enum user_type: { customer: 'customer', bus_owner: 'bus_owner' }

        #  def has_user_type?(desired_type)
        #   self.user_type == desired_type
        # end
end