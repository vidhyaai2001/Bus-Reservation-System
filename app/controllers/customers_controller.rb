class CustomersController < ApplicationController

  def my_reservations
    @reservations=current_user.reservations
  end
end