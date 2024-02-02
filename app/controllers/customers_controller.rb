class CustomersController < ApplicationController

  def index


  end
  def my_resevations
    @reservations=current_user.reservations
  end
end