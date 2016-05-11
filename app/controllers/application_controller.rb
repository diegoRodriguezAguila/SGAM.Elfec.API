class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  rescue_from ::Exception, with: :exception_handler, unless: Exceptions::ApiException
  rescue_from Exceptions::ApiException, with: :api_exception_handler

  def api_exception_handler(exception)
    render json: {errors: exception.message}, status: exception.status_code
  end

  # @param [Exception]
  def exception_handler(exception)
    p logger.error exception.backtrace.join("\n")
    render json: {errors: exception.message}, status: :internal_server_error
  end
end
