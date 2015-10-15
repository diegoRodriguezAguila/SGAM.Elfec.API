class Api::V1::ApplicationsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable

  def show
    # searches by package
    application = Application.find_by(package: params[:id])
    if application.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless application.viewable_by? current_user
      render json: application, status: :ok
    end
  end

  def index
    raise Exceptions::SecurityTransgression unless Application.are_viewable_by? current_user
    apps = Application.where(app_filter_params).order(sort_params)
    render json: apps, root: false, status: :ok
  end

  #app filter params ?status=1
  def app_filter_params
    params.permit(:status)
  end

end
