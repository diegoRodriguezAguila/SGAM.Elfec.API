class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  def rescue_action(e)
    case e
      when SecurityTransgression
        render json: {errors: I18n.t(:'api.errors.session.insufficient_privileges', :cascade => true)}, status: :forbidden
    end
  end
end
