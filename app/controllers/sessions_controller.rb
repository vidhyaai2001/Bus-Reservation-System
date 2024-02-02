# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  protected

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      root_path
    else
      super
    end
  end
end
