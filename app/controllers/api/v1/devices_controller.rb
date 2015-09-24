class Api::V1::DevicesController < ApplicationController
  def show
    device = Device.find_by(imei: params[:id])
    if device.nil?
      head :not_found
    else
      render json: device, status: :ok
    end
  end

  def index
    render json: Device.all, root: false, status: :ok
  end

  def create
    device = Device.new(device_params)
    if device.save
      render json: device, status: :created, location: [:api, device]
    else
      render json: { errors: device.errors }, status: :unprocessable_entity
    end
  end

  def update
    device = Device.find_by(imei: params[:id])
    if device.update(device_params)
      render json: device, status: :ok, location: [:api, device]
    else
      render json: { errors: device.errors }, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.require(:device).permit(:name, :imei, :serial, :mac_address, :platform,
                                   :os_version, :brand, :model, :phone_number, :screen_size,
                                   :screen_resolution, :camera, :sd_memory_card, :status)
  end

end
