class Api::V1::ApplicationsController < ApplicationController
  acts_as_token_authentication_handler_for User
  def show
    # searches by package
    application = Application.find_by(package: params[:id])
    if application.nil?
      head :not_found
    else
      render json: application, status: :ok
    end
  end
end
