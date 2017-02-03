class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  before_action :authenticate_request, :check_header
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: {error: 'Not Authorized'}, status: 401 unless @current_user
  end

  def check_header
    return unless %w(POST PUT PATCH).include? request.method
    head 406 if request.content_type != 'application/json'
  end

  def render_error(errors, status)
    render json: {errors: parse_errors(errors), status: status}, status: status
  end
  #rescue_from ::Exception, with: :exception_handler, unless: Exceptions::ApiException
  rescue_from Exceptions::ApiException, with: :api_exception_handler

  def api_exception_handler(exception)
    render json: {errors: exception.message}, status: exception.status_code
  end

  # @param [Exception]
  def exception_handler(exception)
    #p logger.error exception.backtrace.join("\n")
    render json: {errors: exception.message}, status: :internal_server_error
  end

  def parse_errors(errors)
    return errors if errors.is_a? Array
    err_arr = []
    errors.each_key { |key|err_arr+=errors[key]}
    err_arr
  end
end
