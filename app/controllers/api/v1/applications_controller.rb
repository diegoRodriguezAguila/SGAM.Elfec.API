class Api::V1::ApplicationsController < ApplicationController
  acts_as_token_authentication_handler_for User, except: [:show_version_res_file, :show_res_file]
  include Sortable, FileUrlHelper, ApkIconsHelper, ApkLabelHelper, ApplicationHelper

  def show
    # searches by package
    application = Application.find_by(package: params[:id])
    return head :not_found if application.nil?
    raise Exceptions::SecurityTransgression unless application.viewable_by? current_user
    return render json: application, host: request.host_with_port,
                  status: :ok unless params.has_key?(:d)
    params[:application_id] = params[:id]
    params[:version] = application.latest_version
    download_version_apk
  end

  def index
    raise Exceptions::SecurityTransgression unless Application.are_viewable_by? current_user
    apps = Application.where(app_filter_params).order(sort_params_for(Application))
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
    version_code = manifest.version_code
    new_app = Application.find_or_create_instance(name: app_name,
                                            package: package_name,
                                                  status: Application.statuses[:enabled])
    if version_code >= self.application.latest_version_code
      # si la version de la app nueva es mayor a la ultima
      # actualizamos el nombre
      self.application.name = app_name
    end
    app_version = AppVersion.new(version: version_name, version_code: version_code,
                                 status: AppVersion.statuses[:enabled])
    raise Exceptions::SecurityTransgression unless new_app.creatable_by? current_user
    return render json: {errors: new_app.errors.full_messages[0]},
                  status: :unprocessable_entity unless new_app.save
    save_apk(application_version_dir(package_name, version_name), params[:file])
    save_icon(application_version_res_dir(package_name, version_name), apk)
    app_version.application = new_app
    return render json: {errors: app_version.errors.full_messages[0]},
                  status: :unprocessable_entity unless app_version.save
    #new_app.app_versions << app_version
    render json: new_app, host: request.host_with_port, status: :created,
           location: [:api, new_app]
  end

  def show_version_res_file
    path = File.join(application_version_res_dir(params[:application_id], params[:version]), params[:file_name])
    return head :not_found unless File.exists? path
    send_file path, :disposition => 'inline'
  end

  def download_version_apk
    return head :not_acceptable unless params.has_key?(:d)
    package = params[:application_id]
    version = params[:version]
    application = Application.find_by(package: package)
    return head :not_found if application.nil? ||
        application.app_versions.where(version: version).size==0
    raise Exceptions::SecurityTransgression unless application.downloadable_by? current_user
    send_file "#{application_version_dir(package, version)}/#{APK_FILENAME}",
              filename: apk_public_file_name(package, version)
  end

  def show_res_file
    application = Application.find_by(package: params[:application_id])
    return head :not_found if application.nil?
    params[:version] = application.latest_version
    show_version_res_file
  end

  #region AppVersion

  # PATCH/PUT /applications/:application_id/:version/status
  def edit_status
    # searches by hashed id
    app = Application.find_by(package: params[:application_id])
    return head :not_found if app.nil?
    app_version = app.app_versions.find_by(version: params[:version])
    return head :not_found if app_version.nil?
    raise Exceptions::SecurityTransgression unless app.updatable_by? current_user
    return render json: {errors: user_group.errors.full_messages[0]},
                  status: :unprocessable_entity unless app_version
                                                           .update(app_version_status_params)
    render json: app, status: :ok, location: [:api, app], host: request.host_with_port
  end

  #endregion

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

  def app_version_status_params
    params.require(:status)
    params.permit(:status)
  end

end
