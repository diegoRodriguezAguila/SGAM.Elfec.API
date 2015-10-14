class Api::V1::ApplicationsController < ApplicationController
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
