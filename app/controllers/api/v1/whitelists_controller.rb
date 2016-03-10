class Api::V1::WhitelistsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable, Includible

  #GET whitelists/:id
  def show
    # searches by hashed id
    whitelist = Whitelist.find_by(id: HASHIDS.decode(params[:id]))
    return head :not_found if whitelist.nil?
    raise Exceptions::SecurityTransgression unless whitelist.viewable_by? current_user
    render json: whitelist, include: request_includes, host: request.host_with_port, status: :ok
  end

  #GET whitelists
  def index
    raise Exceptions::SecurityTransgression unless Whitelist.are_viewable_by? current_user
    whitelists = Whitelist.where(whitelist_filter_params).order(sort_params_for(Whitelist))
    render json: whitelists, include: request_includes, host: request.host_with_port, root: false, status: :ok
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
    return head :not_found if whitelist.nil?
    raise Exceptions::SecurityTransgression unless whitelist.updatable_by? current_user
    if whitelist.update(whitelist_params)
      render json: whitelist, status: :ok, location: [:api, whitelist]
    else
      render json: {errors: whitelist.errors.full_messages[0]}, status: :unprocessable_entity
    end
  end

  #region permitted_apps
  def show_permitted_apps
    whitelist = Whitelist.find_by(id: HASHIDS.decode(params[:whitelist_id]))
    if whitelist.nil?
      head :not_found
    else
      render json: whitelist.permitted_apps, host: request.host_with_port, root: false, status: :ok
    end
  end

  def add_permitted_apps
    whitelist = Whitelist.find_by(id: HASHIDS.decode(params[:whitelist_id]))
    return head :not_found if whitelist.nil?
    raise Exceptions::SecurityTransgression unless whitelist.updatable_by? current_user
    apps_to_permit = []
    whitelist_app_packages_params.each do |package|
      app = WhitelistApp.find_or_create_by(package: package, whitelist_id: whitelist.id)
      unless app.errors.empty?
        return render json: {errors: app.errors.full_messages[0]}, status: :unprocessable_entity
      end
      apps_to_permit << app
    end
    apps_to_permit = apps_to_permit - whitelist.permitted_apps
    whitelist.permitted_apps << apps_to_permit
    head :no_content
  end

  def remove_permitted_apps
    whitelist = Whitelist.find_by(id: HASHIDS.decode(params[:whitelist_id]))
    return head :not_found if whitelist.nil?
    raise Exceptions::SecurityTransgression unless whitelist.updatable_by? current_user
    whitelist.permitted_apps.where(package: whitelist_app_packages_params).destroy_all
    head :no_content
  end


  #endregion

  private
  HASHIDS = Hashids.new(Rails.configuration.hashids.salt+:whitelist.to_s, Rails.configuration.ids_length)

  def whitelist_params
    params.require(:whitelist).permit(:title, :description)
  end

  def whitelist_filter_params
    params.permit(:title, :description, :status)
  end

  def whitelist_app_packages_params
    params[:app_packages].gsub(/\s+/, '').split(',')
  end

end
