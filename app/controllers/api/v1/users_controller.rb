#encoding: UTF-8
class Api::V1::UsersController < ApplicationController
  def show
    user = User.find_by(username: params[:id])
    if user.nil?
      head :not_found
    else
      render json: user, status: :ok
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created, location: [:api, user]
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  def assign_devices
    user = User.find_by(username: params[:user_id])
    if user.nil?
      head :not_found
    else
      devices_to_add = Device.where(imei: user_device_imeis_params, status: Device.statuses[:authorized]) - user.devices
      if devices_to_add.empty? || devices_to_add.size<user_device_imeis_params.size
        render json: {errors: I18n.t(:'api.errors.user.device_assignations', :cascade => true)}, status: :bad_request
      else
        user.devices << devices_to_add
        head :no_content
      end
    end
  end

  def remove_device_assignations
    user = User.find_by(username: params[:user_id])
    if user.nil?
      head :not_found
    else
      devices_to_del = Device.where(imei: user_device_imeis_params, status: Device.statuses[:authorized])
      if devices_to_del.empty? || !(devices_to_del - user.devices).empty? || devices_to_del.size<user_device_imeis_params.size
        render json: {errors: I18n.t(:'api.errors.user.delete_device_assignations', :cascade => true)}, status: :bad_request
      else
        user.devices = user.devices - devices_to_del
        head :no_content
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

# Order params should be ?order=name,status:desc
  def user_device_imeis_params
    params[:imeis].gsub(/\s+/, '').split(',')
  end

end
