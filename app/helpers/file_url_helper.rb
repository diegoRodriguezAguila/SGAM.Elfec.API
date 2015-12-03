module FileUrlHelper
  def applications_dir
    Rails.root+'files/applications/'
  end

  def application_dir(package_name)
    File.join(applications_dir,"#{package_name}/")
  end

  def application_version_dir(package_name, version)
    File.join(application_dir(package_name),"#{version}/")
  end

  def application_version_res_dir(package_name, version)
    File.join(application_version_dir(package_name, version),'resources/')
  end

  def applications_url(host)
    url_for :controller => '/api/v1/applications', :action => 'index', host: host
  end

  def application_url(host, package_name)
    "#{applications_url(host)}/#{package_name}"
  end

  def application_res_url(host, package_name)
    "#{application_url(host, package_name)}/resources"
  end

  def application_version_url(host, package_name, version)
    "#{application_url(host, package_name)}/#{version}"
  end

  def application_version_res_url(host, package_name, version)
    "#{application_version_url(host, package_name, version)}/resources"
  end

  def users_dir
    Rails.root+'files/users/'
  end

  def user_dir(username)
    File.join(users_dir,"#{username}/")
  end

  def users_url(host)
    url_for :controller => '/api/v1/users', :action => 'index', host: host
  end

  def user_url(host, username)
    "#{users_url(host)}/#{username}"
  end


end