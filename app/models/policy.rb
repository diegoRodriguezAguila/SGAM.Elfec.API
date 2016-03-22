class Policy < ActiveRecord::Base
  enum type: {application_control: 'application_control',
              device_restriction:      'device_restriction'}
  enum status: [:disabled, :enabled]
  validates_presence_of :type, :name, :description
  validates_uniqueness_of :type, :name
  has_many :rules
  self.inheritance_column = 'parent_type'

  # Verifica si esta directiva de usuarios específica es visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    user.has_permission? Permission.view_policies
  end

  # Verifica si el recurso de las directivas de usuarios son visibles por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    user.has_permission? Permission.view_single_policy
  end

end
