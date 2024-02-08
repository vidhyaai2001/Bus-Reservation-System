# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :phone, :user_type])
  end

  protected

  # def after_sign_up_path_for(resource)
  #   if resource.has_user_type?('bus_owner')
  #      root_path 
  #   elsif resource.has_user_type?('customer')
  #    root_path
  #   else
  #     super
  #   end
  # end
end
#   rails generate model Bus name:string registration_number:string route_source:string 
#   route_destination:string total_seats:integer bus_owner:references

#   rails generate scaffold Bus name:string registration_number:string route_source:string
#    route_destination:string
#    total_seats:integer bus_owner:references departure_time:datetime arrival_time:datetime