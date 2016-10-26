class Auth::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, only: :create

  protected

    def after_sign_up_path_for(resource)
      stored_location_for(resource) || root_path
    end

    # def after_update_path_for(resource)
    #   edit_user_registration_path
    # end

end