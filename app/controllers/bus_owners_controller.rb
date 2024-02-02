class BusOwnersController < ApplicationController
    def index
        @buses=current_user.buses
        render 'buses/index'
    end
end