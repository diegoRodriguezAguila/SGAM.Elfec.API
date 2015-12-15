#encoding: UTF-8
class Api::V1::UserGroupsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable

  #GET user_groups/:id
  def show
    # searches by hashed id
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:id]))
    if user_group.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless user_group.viewable_by? current_user
      render json: user_group, status: :ok
    end
  end

  #GET user_groups
  def index
    raise Exceptions::SecurityTransgression unless UserGroup.are_viewable_by? current_user
    user_groups = UserGroup.where(user_group_filter_params).order(sort_params_for(UserGroup))
    render json: user_groups, root: false, status: :ok
  end

  #POST user_groups
  def create
    user_group = UserGroup.new(user_group_params)
    raise Exceptions::SecurityTransgression unless user_group.creatable_by? current_user
    if user_group.save
      render json: user_group, status: :created, location: [:api, user_group]
    else
      render json: {errors: user_group.errors}, status: :unprocessable_entity
    end
  end

  #PATCH user_groups/:id
  def update
    # searches by hashed id
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:id]))
    if user_group.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless user_group.updatable_by? current_user
      if user_group.update(user_group_params)
        render json: user_group, status: :ok, location: [:api, user_group]
      else
        render json: {errors: user_group.errors}, status: :unprocessable_entity
      end
    end
  end

  #region members
  def show_members
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:user_group_id]))
    if user_group.nil?
      head :not_found
    else
      user_group.members.each { |user| user.update_ad_attributes! }
      render json: user_group.members, host: request.host_with_port, root: false, status: :ok
    end
  end

  def add_members
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:user_group_id]))
    if user_group.nil?
      head :not_found
    else
      users_to_add = User.where(username: user_group_usernames_params,
                                status: User.statuses[:enabled]) - user_group.members
      if users_to_add.empty? || users_to_add.size<user_group_usernames_params.size
        render json: {errors: I18n.t(:'api.errors.user_group.user_memberships', cascade: true)}, status: :bad_request
      else
        user_group.members << users_to_add
        head :no_content
      end
    end
  end

  def remove_members
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:user_group_id]))
    if user_group.nil?
      head :not_found
    else
      users_to_del = User.where(username: user_group_usernames_params)
      if users_to_del.empty? || !(users_to_del - user_group.members).empty? ||
          users_to_del.size<user_group_usernames_params.size
        render json: {errors: I18n.t(:'api.errors.user_group.delete_user_memberships', cascade: true)}, status: :bad_request
      else
        user_group.members = user_group.members - users_to_del
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
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt, 6)

  def user_group_params
    params.require(:user_group).permit(:name, :description)
  end

  def user_group_filter_params
    params.permit(:name, :description, :status)
  end

  def user_group_usernames_params
    params[:usernames].gsub(/\s+/, '').split(',')
  end

end
