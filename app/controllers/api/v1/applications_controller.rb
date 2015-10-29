class Api::V1::ApplicationsController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:show_version_file, :show_file]
  include Sortable, FileUrlHelper, ApkIconsHelper, ApkLabelHelper, ApplicationHelper

  def show
    # searches by package
    application = Application.find_by(package: params[:id])
    if application.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless application.viewable_by? current_user
      if !params.has_key?(:d)
        render json: application, host: request.host_with_port, status: :ok
      else
        params[:application_id] = params[:id]
        params[:version] = application.latest_version
        download_version_apk
      end
    end
  end

  def index
    raise Exceptions::SecurityTransgression unless Application.are_viewable_by? current_user
    apps = Application.where(app_filter_params).order(sort_params)
    render json: apps, root: false, host: request.host_with_port, status: :ok
  end


  def create
    params.require(:file)
    apk = Android::Apk.new(params[:file].path)
    manifest = apk.manifest
    app_name = manifest.label
    app_name = apk_app_name(params[:file].path) if app_name.nil?
    package_name = manifest.package_name
    version_name = manifest.version_name
    new_app = Application.find_by(package: package_name) # existe ya
    new_app = Application.new(package: package_name, status: Application.statuses[:enabled]) if new_app.nil?
    new_app.name = app_name # igual actualizamos el nombre de la app
    app_version = AppVersion.new(version: version_name, version_code: manifest.version_code, status: AppVersion.statuses[:enabled])
    if new_app.save
      app_version.application = new_app
      if app_version.valid?
        save_apk(application_version_dir(package_name, version_name), params[:file])
        save_icon(application_version_res_dir(package_name, version_name), apk)
        app_version.save
        new_app.app_versions << app_version
        render json: new_app, host: request.host_with_port, status: :created, location: [:api, new_app]
      else
        render json: {errors: app_version.errors.full_messages[0]}, status: :unprocessable_entity
      end
    else
      render json: {errors: new_app.errors.full_messages[0]}, status: :unprocessable_entity
    end
  end

  def show_version_file
    if is_file_apk(params[:file_name])
      head :not_found
    else
      send_file "#{application_version_dir(params[:application_id], params[:version])}/#{params[:file_name]}", :disposition => 'inline'
    end
  end

  def download_version_apk
    package = params[:application_id]
    version = params[:version]
    application = Application.find_by(package: package)
    if application.nil? || application.app_versions.where(version: version).size==0
      head :not_found
    else
      send_file "#{application_version_dir(package, version)}/app.apk",
                filename: apk_public_file_name(package, version)
    end
  end

  def show_file
    application = Application.find_by(package: params[:application_id])
    if application.nil?
      head :not_found
    else
      params[:version] = application.latest_version
      show_version_file
    end
  end

  private

  # @param [String] file_name
  def is_file_apk(file_name)
    /.apk\z/ =~ file_name
  end

  def apk_public_file_name(package, version)
    "#{package} v.#{version}.apk"
  end

  # app filter params ?status=1
  def app_filter_params
    params.permit(:status)
  end

end
