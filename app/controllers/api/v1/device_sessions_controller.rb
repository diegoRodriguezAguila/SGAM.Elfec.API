class Api::V1::DeviceSessionsController < ApplicationController
  acts_as_token_authentication_handler_for User

  #POST device_sessions
  def create
    user = current_user
    device = Device.find_by_imei_or_name(params[:device_id], params[:device_id])
    raise Exceptions::UnpermittedDeviceException.new(user.username) unless
        user.can_use_device? device
    # if an already opened session exists for the same device, just retrieve it
    device_session = DeviceSession.find_or_create_by(user: user,
                                         device: device, status: DeviceSession.statuses[:opened])
    return render json: {errors: device_session.errors.full_messages[0]},
                  status: :unprocessable_entity unless device_session.save
    render json: device_session, status: :ok
  end

  #DELETE device_sessions/:id
  def destroy
    device_session = DeviceSession.find_by(id: HASHIDS.decode(params[:id]))
    return head :not_found if (device_session.nil? || device_session.closed?)
    raise Exceptions::SecurityTransgression unless device_session.closable_by? current_user
    device_session.closed!
    return render json: {errors: device_session.errors.full_messages[0]},
                  status: :unprocessable_entity unless device_session.save
    head :no_content
  end

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+
                            :device_session.to_s, Rails.configuration.ids_length)
end
