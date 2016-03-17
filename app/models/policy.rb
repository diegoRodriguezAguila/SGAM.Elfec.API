class Policy < ActiveRecord::Base
  enum type: {application_control: 'application_control',
              device_restriction:      'device_restriction'}
  validates_presence_of :type, :name, :description
  validates_uniqueness_of :type, :name
  has_many :rules
end
