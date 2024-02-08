class BusOwnersController < ApplicationController
   
    def index
        @buses=current_user.buses
    end
end