class Api::V1::DevicesController < ApplicationController
  def show
    device = Device.find_by(imei: params[:id])
    if device.nil?
      head 404
    else
      render json: device, status: :ok
    end
  end

  def index
    render json: Device.all, root: false, status: :ok
  end

end
