require "application_responder"

require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :prevent_browser_cache

  rescue_from CanCan::AccessDenied do
    redirect_to games_path, alert: 'You are not authorized to access this page'
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  protected

    def prevent_browser_cache
      response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      response.headers['Pragma']        = 'no-cache'
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    end

end
