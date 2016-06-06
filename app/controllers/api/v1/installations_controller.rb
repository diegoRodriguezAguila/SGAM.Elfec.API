class Api::V1::InstallationsController < ApplicationController
  acts_as_token_authentication_handler_for User

  #POST installations
  def create
    new_params = installation_params
    app = Application.find_by_package(new_params[:application_id])
    device = Device.find_by_imei_or_name(new_params[:device_id])
    return head :not_found if (app.nil? || device.nil?)
    version = app.app_versions.where(version: new_params[:version]).first
    return head :not_found if version.nil?
    installation = Installation.new(application: app, app_version: version, device: device,
                                    status: Installation.statuses[:install_pending])
    return render json: {errors: installation.errors.full_messages[0]},
                  status: :unprocessable_entity unless installation.save
    render json: installation, status: :created, location: [:api, installation]
  end

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:installation.to_s,
                        Rails.configuration.ids_length)

  def installation_params
    params.require(:installation).permit(:application_id, :version, :device_id)
  end
end
