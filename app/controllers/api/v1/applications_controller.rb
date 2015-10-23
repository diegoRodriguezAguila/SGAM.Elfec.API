class Api::V1::ApplicationsController < ApplicationController
  acts_as_token_authentication_handler_for User
  include Sortable
  include FileHelper
  include ApkIconsHelper
  include ApkLabelHelper

  def show
    # searches by package
    application = Application.find_by(package: params[:id])
    if application.nil?
      head :not_found
    else
      raise Exceptions::SecurityTransgression unless application.viewable_by? current_user
      render json: application, status: :ok
    end
  end

  def index
    raise Exceptions::SecurityTransgression unless Application.are_viewable_by? current_user
    apps = Application.where(app_filter_params).order(sort_params)
    render json: apps, root: false, status: :ok
  end


  def create
    apk = Android::Apk.new(params[:apk_file].path)
    manifest = apk.manifest
    app_name = manifest.label
    app_name = apk_app_name(params[:apk_file].path) if app_name.nil?
    package_name = manifest.package_name
    version_name = manifest.version_name
    new_app = Application.find_by(package: package_name) # existe ya
    new_app = Application.new(package: package_name, status: Application.statuses[:enabled]) if new_app.nil?
    new_app.name = app_name # igual actualizamos el nombre de la app
    app_version = AppVersion.new(version: version_name, url: I18n.t(:'api.errors.application.undefined_url', :cascade => true),
                                 version_code: manifest.version_code, status: AppVersion.statuses[:enabled])
    if new_app.save
      app_version.application = new_app
      if app_version.valid?
        app_dir = application_version_dir(package_name, version_name)
        app_dir_url = application_version_url(package_name, version_name)
        app_version.icon_url = save_icon(app_dir, app_dir_url, apk)
        app_version.url = save_apk(app_dir, app_dir_url, params[:apk_file])
        app_version.save
        new_app.app_versions << app_version
        render json: new_app, status: :created, location: [:api, new_app]
      else
        render json: {errors: app_version.errors}, status: :unprocessable_entity
      end
    else
      render json: {errors: new_app.errors}, status: :unprocessable_entity
    end
  end

  private

  def save_apk(app_dir, app_dir_url, apk_file)
    path = File.join(app_dir, 'app.apk')
    FileUtils::mkdir_p File.dirname(path)
    File.open(path, 'wb') { |f| f.write apk_file.read }
    "#{app_dir_url}?d"
  end

  def save_icon(app_dir, app_dir_url, apk)
    icon = app_icon(apk)
    path = File.join(app_dir, icon[:name])
    FileUtils::mkdir_p File.dirname(path)
    File.open(path, 'wb') { |f| f.write icon[:data] }
    "#{app_dir_url}/#{icon[:name]}"
  end


  # app filter params ?status=1
  def app_filter_params
    params.permit(:status)
  end

end
