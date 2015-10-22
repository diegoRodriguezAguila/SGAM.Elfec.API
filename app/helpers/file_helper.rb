module FileHelper
  def applications_dir
    Rails.public_path+'api/applications/'
  end

  def application_dir(package_name)
    File.join(applications_dir,"#{package_name}/")
  end

  def application_version_dir(package_name, version)
    File.join(application_dir(package_name),"#{version}/")
  end

  def applications_url
    '/api/applications'
  end

  def application_url(package_name)
    "#{applications_url}/#{package_name}"
  end

  def application_version_url(package_name, version)
    "#{application_url(package_name)}/#{version}"
  end
end