class Api::V1::DevicesController < ApplicationController
  acts_as_token_authentication_handler_for User

  def show
    # searches by imei or name
    device = Device.find_by_imei_or_name(params[:id], params[:id])
    if device.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless device.viewable_by? current_user
      render json: device, status: :ok
    end
  end

  def index
    raise Exceptions::SecurityTransgression unless Device.are_viewable_by? current_user
    devices = Device.where(device_filter_params).order(device_order_params)
    render json: devices, root: false, status: :ok
  end

  def create
    device = Device.new(device_params)
    raise Exceptions::SecurityTransgression unless device.creatable_by? current_user
    device.format_for_save!
    if device.save
      render json: device, status: :created, location: [:api, device]
    else
      render json: {errors: device.errors}, status: :unprocessable_entity
    end
  end

  def update
    device = Device.find_by(imei: params[:id])
    if device.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless device.updatable_by? current_user
      device.attributes = device_params
      device.format_for_save!
      if device.save
        render json: device, status: :ok, location: [:api, device]
      else
        render json: {errors: device.errors}, status: :unprocessable_entity
      end
    end
  end

  private

  def device_params
    params.require(:device).permit(:name, :imei, :serial, :wifi_mac_address, :bluetooth_mac_address, :platform,
                                   :os_version, :baseband_version, :brand, :model, :phone_number, :screen_size,
                                   :screen_resolution, :camera, :sd_memory_card, :gmail_account, :comments, :status)
  end

  def device_filter_params
    params.permit(:platform, :os_version, :brand, :model, :gmail_account, :status)
  end

  # Order params should be ?order=name,status:desc
  def device_order_params
    if params[:order].nil?
      return nil
    end
    order_params_a = params[:order].gsub(/\s+/, '').split(',')
    order_params = {}
    order_params_a.each do |h|
      key_val = h.split(':')
      order_params[key_val[0].to_sym] = (key_val.size>1 ? key_val[1] : 'asc').to_sym
    end
    order_params
  end

end
