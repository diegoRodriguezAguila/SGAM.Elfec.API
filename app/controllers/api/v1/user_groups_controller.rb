#encoding: UTF-8
class Api::V1::UserGroupsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible

  #GET user_groups/:id
  def show
    # searches by hashed id
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:id]))
    return head :not_found if user_group.nil?
    raise Exceptions::SecurityTransgression unless user_group
                                                       .viewable_by? current_user
    render json: user_group, include: request_includes,
           host: request.host_with_port, status: :ok
  end

  #GET user_groups
  def index
    raise Exceptions::SecurityTransgression unless UserGroup.are_viewable_by? current_user
    user_groups = UserGroup.where(user_group_filter_params).order(sort_params_for(UserGroup))
    render json: user_groups, include: request_includes,
           host: request.host_with_port, root: false, status: :ok
  end

  #POST user_groups
  def create
    user_group = UserGroup.new(user_group_params)
    raise Exceptions::SecurityTransgression unless user_group.creatable_by? current_user
    users_to_add = User.where(username: user_group_usernames_params,
                              status: UserGroup.statuses[:enabled])
    p users_to_add
    user_group.members << users_to_add
    return render json: {errors: user_group.errors.full_messages[0]},
                  status: :unprocessable_entity unless user_group.save
    render json: user_group, status: :created, location: [:api, user_group]
  end

  #PATCH user_groups/:id
  def update
    # searches by hashed id
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:id]))
    return head :not_found if user_group.nil?
    update_params = update_user_group_params
    raise Exceptions::SecurityTransgression if !user_group.updatable_by?(current_user)||
        update_params[:status]==UserGroup.statuses[:sealed]#users can't set a group to sealed
    return render json: {errors: user_group.errors.full_messages[0]},
                  status: :unprocessable_entity unless user_group
                                                           .update(update_params)
    render json: user_group, status: :ok, location: [:api, user_group]
  end

  #region members
  def show_members
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:user_group_id]))
    return head :not_found if user_group.nil?
    user_group.members.each { |user| user.update_ad_attributes! }
    render json: user_group.members, host: request.host_with_port, root: false, status: :ok
  end

  def add_members
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:user_group_id]))
    return head :not_found if user_group.nil?
    raise Exceptions::SecurityTransgression unless user_group.updatable_by? current_user
    users_to_add = User.where(username: user_group_usernames_params,
                              status: UserGroup.statuses[:enabled]) - user_group.members
    return render json: {errors: I18n.t(:'api.errors.user_group.user_memberships')},
                  status: :bad_request unless users_to_add_valid?(users_to_add)
    user_group.members << users_to_add
    head :no_content
  end

  def remove_members
    user_group = UserGroup.find_by(id: HASHIDS.decode(params[:user_group_id]))
    return head :not_found if user_group.nil?
    raise Exceptions::SecurityTransgression unless user_group.updatable_by? current_user
    users_to_del = User.where(username: user_group_usernames_params)
    return render json: {errors: I18n.t(:'api.errors.user_group.delete_user_memberships')},
                  status: :bad_request unless users_to_del_valid?(user_group, users_to_del)
    user_group.members = user_group.members - users_to_del
    head :no_content
  end

  #endregion

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:user_group.to_s, Rails.configuration.ids_length)

  def user_group_params
    params.require(:user_group).permit(:name, :description)
  end

  def update_user_group_params
    params.require(:user_group).permit(:name, :description, :status)
  end

  def user_group_filter_params
    params.permit(:name, :description, :status)
  end

  def user_group_usernames_params
    params[:usernames].gsub(/\s+/, '').split(',')
  end

  def users_to_add_valid?(users_to_add)
    users_to_add.empty? ||
        users_to_add.size<user_group_usernames_params.size
  end

  def users_to_del_valid?(user_group, users_to_del)
    users_to_del.empty? ||
        !(users_to_del - user_group.members).empty? ||
        users_to_del.size<user_group_usernames_params.size
  end

end
