#encoding: UTF-8
class Api::V1::UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, except: :show_res_file
  include Sortable, Includible
  include ActiveDirectoryUserHelper

  def show
    user = User.find_by(username: params[:id])
    user = get_active_directory_user(params[:id], false) if user.nil?
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
    users = is_ad_filter? ? User.multi_sort(non_registered_ad_users, sort_params_for(User)) :
        User.where(user_filter_params).order(sort_params_for(User))
    users.each { |user| user.update_ad_attributes! }
    render json: users, root: false, include: request_includes, host: request.host_with_port, status: :ok
  end

  def create
    user = get_active_directory_user(user_params, true)
    if user.nil? || user.disabled?
      render json: {errors: I18n.t(:'api.errors.user.invalid_user', cascade: true)}, status: :not_found
    else
      raise Exceptions::SecurityTransgression unless user.creatable_by? current_user
      if user.save
        render json: user, status: :created, host: request.host_with_port,  location: [:api, user]
      else
        render json: {errors: user.errors.full_messages[0]}, status: :unprocessable_entity
      end
    end
  end

  #region File handling

  def show_res_file
    path = File.join(api_user_dir(params[:user_id]), params[:file_name])
    if !File.exists? path
      head :not_found
    else
      send_file path, :disposition => 'inline'
    end
  end

  #endregion

  #region policy rules
  # Gets all the policy rules that should apply to
  # the requested user, directly or indirectly (via a user_group)
  def generate_policy_rules
    user = User.find_by(username: params[:user_id])
    if user.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless user.viewable_by? current_user
      rules = Set[]
      user.entity_rules.each{|ent| rules << ent.rule}
      user.groups.each do |group|
        group.entity_rules.each{|ent| rules << ent.rule}
      end
      render json: rules, root: false, include: request_includes, host: request.host_with_port, status: :ok
    end
  end
  #endregion

  private

  def user_params
    params.require(:username)
  end

  def user_filter_params
    params.permit(:status)
  end

  def is_ad_filter?
    (params.has_key? :status) && params[:status].to_i == User.statuses[:non_registered]
  end

  def user_device_imeis_params
    params[:imeis].gsub(/\s+/, '').split(',')
  end

end
