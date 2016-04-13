class UserSerializer < ModelWithStatusSerializer
  attributes :entity_type, :username, :authentication_token, :first_name,
             :last_name, :email, :position, :company_area, :status
  has_many :roles, :groups, :devices
  include FileUrlHelper, ActiveDirectoryImagesHelper
  self.root = false
  #cache key: 'roles', expires_in: 3.hours

  def attributes
    data = super
    photo_path = File.join(api_user_dir(data[:username]), USER_PHOTO_FILENAME)
    username = (File.exists? photo_path)? data[:username]: 'default'
    photo_url = "#{user_url(options[:host], username)}/#{USER_PHOTO_FILENAME}"
    data.to_a.insert(6, [:photo_url, photo_url]).to_h
  end

  def include_entity_type?
    !options[:include].nil? && options[:include].include?('entity_type')
  end

  def include_authentication_token?
    scope.username==object.username && options[:show_token]
  end
  def include_roles?
    !options[:include].nil? && options[:include].include?('roles')
  end
  def include_groups?
    !options[:include].nil? && options[:include].include?('groups')
  end
  def include_devices?
    !options[:include].nil? && options[:include].include?('devices')
  end
end
