class Api::V1::DevicesController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable

  def show
    # searches by imei or name
    device = Device.find_by_imei_or_name(params[:id], params[:id])
    return head :not_found if device.nil?
    raise Exceptions::SecurityTransgression unless device.viewable_by? current_user
    render json: device, status: :ok
  end

  def index
    raise Exceptions::SecurityTransgression unless Device.are_viewable_by? current_user
    devices = Device.where(device_filter_params).order(sort_params_for(Device))
    render json: devices, root: false, status: :ok
  end

  #POST devices
  def create
    device = Device.new(device_params)
    raise Exceptions::SecurityTransgression unless device.creatable_by? current_user
    return render json: {errors: device.errors.full_messages[0]},
                  status: :unprocessable_entity unless device.save
    render json: device, status: :created, location: [:api, device]
  end

  #PATCH devices/:id
  def update
    device = Device.find_by_imei_or_name(params[:id], params[:id])
    return head :not_found if device.nil?
    update_params = update_device_params
    raise Exceptions::SecurityTransgression if !device.updatable_by?(current_user) ||
        update_params[:status]==Device.statuses[:auth_pending]
    return render json: {errors: device.errors.full_messages[0]},
           status: :unprocessable_entity unless device.update(update_params)
    render json: device, status: :ok, location: [:api, device]
  end

  private

  def device_params
    params.require(:device).permit(:name, :imei, :serial, :wifi_mac_address, :bluetooth_mac_address, :platform,
                                   :os_version, :baseband_version, :brand, :model, :phone_number, :screen_size,
                                   :screen_resolution, :camera, :sd_memory_card, :gmail_account, :comments, :status)
  end

  def update_device_params
    params.require(:device).permit(:name, :os_version, :phone_number, :screen_size,
                                   :screen_resolution, :camera,
                                   :sd_memory_card, :gmail_account, :comments, :status)
  end

  def device_filter_params
    params.permit(:platform, :os_version, :brand, :model, :gmail_account, :status)
  end

end
