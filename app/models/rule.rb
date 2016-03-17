class Rule < ActiveRecord::Base
  enum type: {permit: 'permit',
              deny:   'deny'}
  validates_presence_of :policy, :type, :name, :value
  validates_uniqueness_of :name, scope: :policy
  belongs_to :policy
end
