#encoding: UTF-8
class Api::V1::UserGroupsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable

  #GET user_groups/:id
  def show
    # searches by hashed id
    hashids = Hashids.new(Rails.configuration.hashids.salt, 6)
    user_group = UserGroup.find_by(id: hashids.decode(params[:id]))
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
    hashids = Hashids.new(Rails.configuration.hashids.salt, 6)
    user_group = UserGroup.find_by(id: hashids.decode(params[:id]))
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

  private

  def user_group_params
    params.require(:user_group).permit(:name, :description)
  end

  def user_group_filter_params
    params.permit(:name, :description, :status)
  end

end
