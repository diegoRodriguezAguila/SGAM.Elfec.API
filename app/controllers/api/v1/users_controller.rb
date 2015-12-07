#encoding: UTF-8
class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, except: :show_res_file
  include Sortable, Includible
  include ActiveDirectoryUserHelper

  def show
    user = User.find_by(username: params[:id])
    if user.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless user.viewable_by? current_user
      # si tiene que sincronizar con AD lo hace
      user.update_ad_attributes!
      render json: user, include: request_includes, host: request.host_with_port, status: :ok
    end
  end

  def index
    raise Exceptions::SecurityTransgression unless User.are_viewable_by? current_user
    users = is_ad_filter? ? User.multi_sort(all_active_directory_users, sort_params_for(User)) :
        User.where(user_filter_params).order(sort_params_for(User))
    users.each { |user| user.update_ad_attributes! }
    render json: users, root: false, include: request_includes, host: request.host_with_port, status: :ok
  end

  def create
    user = User.new(user_params)
    raise Exceptions::SecurityTransgression unless user.creatable_by? current_user
    if user.save
      render json: user, status: :created, location: [:api, user]
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  #region devices
  def show_devices
    user = User.find_by(username: params[:user_id])
    if user.nil?
      head :not_found
    else
      render json: user.devices, root: false, status: :ok
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

  def show_res_file
    path = File.join(api_user_dir(params[:user_id]), params[:file_name])
    if !File.exists? path
      head :not_found
    else
      send_file path, :disposition => 'inline'
    end
  end

  #endregion

  private

  def user_params
    params.require(:user).permit(:username)
  end

  def user_filter_params
    params.permit(:status)
  end

  def is_ad_filter?
    (params.has_key? :status) && params[:status].to_i == User.statuses[:non_registered]
  end

  # Order params should be ?order=name,status:desc
  def user_device_imeis_params
    params[:imeis].gsub(/\s+/, '').split(',')
  end

end
