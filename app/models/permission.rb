class Permission < ActiveRecord::Base
  enum name: {admin_app_access: 'admin_app_access',
              register_device: 'register_device'}
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
