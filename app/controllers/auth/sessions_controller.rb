class Auth::SessionsController < Devise::SessionsController

  skip_before_action :verify_authenticity_token, only: :create

  after_action :clear_flash

  protected

    def after_sign_in_path_for(resource)
      root_path
      # stored_location_for(resource) || root_path
    end

    def clear_flash
      unless flash.empty?
        flash.delete(:alert)
        flash.delete(:notice)
      end
    end

end
