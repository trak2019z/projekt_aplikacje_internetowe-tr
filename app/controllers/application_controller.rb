class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action  :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  before_action :set_cache_buster
 
 def after_sign_out_path_for(resource)
   root_path
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Employee)
      admin_login_path
    else
      clients_login_path
    end
  end

  def  after_sending_reset_password_instructions_path_for(resource_name)
    if resource.is_a?(Employee)
      admin_login_path
    else
      clients_login_path
    end
  end



  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

   protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :address, :phone_number,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :address, :phone_number,
        :email, :password, :password_confirmation, :current_password)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:email, :password)
    end
  end

   def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
