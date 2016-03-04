class Api::V1::WhitelistsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible

  #GET whitelists/:id
  def show
    # searches by hashed id
    whitelist = Whitelist.find_by(id: HASHIDS.decode(params[:id]))
    if whitelist.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless whitelist.viewable_by? current_user
      render json: whitelist, include: request_includes, host: request.host_with_port, status: :ok
    end
  end

  #GET whitelists
  def index
    raise Exceptions::SecurityTransgression unless Whitelist.are_viewable_by? current_user
    whitelists = Whitelist.where(whitelist_filter_params).order(sort_params_for(Whitelist))
    render json: whitelists,include: request_includes, host: request.host_with_port, root: false, status: :ok
  end

  #POST whitelists
  def create
    whitelist = Whitelist.new(whitelist_params)
    raise Exceptions::SecurityTransgression unless whitelist.creatable_by? current_user
    if whitelist.save
      render json: whitelist, status: :created, location: [:api, whitelist]
    else
      render json: {errors: whitelist.errors.full_messages[0]}, status: :unprocessable_entity
    end
  end

  #PATCH whitelists/:id
  def update
    # searches by hashed id
    whitelist = Whitelist.find_by(id: HASHIDS.decode(params[:id]))
    if whitelist.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless whitelist.updatable_by? current_user
      if whitelist.update(whitelist_params)
        render json: whitelist, status: :ok, location: [:api, whitelist]
      else
        render json: {errors: whitelist.errors.full_messages[0]}, status: :unprocessable_entity
      end
    end
  end

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:whitelist.to_s, 6)

  def whitelist_params
    params.require(:whitelist).permit(:title, :description)
  end

  def whitelist_filter_params
    params.permit(:title, :description, :status)
  end
  
end
