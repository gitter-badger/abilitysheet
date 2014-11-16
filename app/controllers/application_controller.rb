class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # strong parametersを設定し、usernameを許可
    devise_parameter_sanitizer.for(:sign_up) << [:username, :iidxid, :djname, :grade, :pref]
    devise_parameter_sanitizer.for(:account_update) << [:djname, :grade, :pref]
  end
end
