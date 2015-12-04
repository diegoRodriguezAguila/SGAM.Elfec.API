class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  rescue_from ::Exception, with: :exception_handler, unless: Exceptions::SecurityTransgression
  rescue_from Exceptions::SecurityTransgression, with: :security_transgression_handler


  def security_transgression_handler
    render json: {errors: I18n.t(:'api.errors.session.insufficient_privileges', :cascade => true)}, status: :forbidden
  end

  # @param [Exception]
  def exception_handler(exception)
    render json: {errors: exception.message}, status: :internal_server_error
  end
end
