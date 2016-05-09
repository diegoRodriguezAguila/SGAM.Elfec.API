class Api::V1::GcmTokensController < ApplicationController
  acts_as_token_authentication_handler_for User

  #POST devices/:device_id/gcm_token
  def create
    # searches by imei or name
    device = Device.find_by_imei_or_name(params[:device_id], params[:device_id])
    return head :not_found if device.nil?
    raise Exceptions::SecurityTransgression unless device.updatable_by? current_user
    return head :not_found if device.nil?
    gcm_token = DeviceGcmToken.new(gcm_token_params)
    gcm_token.device = device
    return render json: {errors: gcm_token.errors.full_messages[0]},
                  status: :unprocessable_entity unless gcm_token.save
    head :created
  end

  #PATCH user_groups/:device_id/gcm_token
  def update
    # searches by imei or name
    device = Device.find_by_imei_or_name(params[:device_id], params[:device_id])
    return head :not_found if device.nil?
    raise Exceptions::SecurityTransgression unless device.updatable_by? current_user
    return head :not_found if device.gcm_token.nil?
    return render json: {errors: device.gcm_token.errors.full_messages[0]},
                  status: :unprocessable_entity unless device.gcm_token.update(gcm_token_params)
    head :no_content
  end

  private

  def gcm_token_params
    params.require(:gcm_token).permit(:token)
  end

end
