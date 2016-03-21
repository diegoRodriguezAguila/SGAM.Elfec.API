class Permission < ActiveRecord::Base
  enum name: {admin_app_access:       'admin_app_access',
              register_user:          'register_user',
              view_users:             'view_users',
              view_single_user:       'view_single_user',
              register_device:        'register_device',
              view_devices:           'view_devices',
              view_single_device:     'view_single_device',
              update_device:          'update_device',
              register_application:   'register_application',
              view_applications:      'view_applications',
              view_single_application:'view_single_application',
              download_application:   'download_application',
              register_user_group:    'register_user_group',
              view_user_groups:       'view_user_groups',
              view_single_user_group: 'view_single_user_group',
              update_user_group:      'update_user_group'}

  enum status: [:disabled, :enabled]
  has_and_belongs_to_many :roles, join_table: :role_permissions
  validates :name, presence: true, uniqueness: true
  validates :status, presence: true

  class << self
    Permission.names.keys.each do |key|
      self.send(:define_method, key, -> { self.where(name: Permission.names[key], status: Permission.statuses[:enabled]).take})
    end
  end

end
