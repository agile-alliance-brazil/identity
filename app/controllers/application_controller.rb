# Base controller with common actions/methods
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def authenticate!
    if doorkeeper_token
      sign_in(User.find(doorkeeper_token.resource_owner_id))
    else
      authenticate_user!
    end
  end

  protected

  UPDATEABLE = %i(username email first_name last_name password
                  password_confirmation remember_me).freeze

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(*UPDATEABLE)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:login, :username, :email, :password, :remember_me)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(*UPDATEABLE)
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] ||
      session['omniauth.origin'] ||
      user_path(resource) ||
      root_path
  end
end
