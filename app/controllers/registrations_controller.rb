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
