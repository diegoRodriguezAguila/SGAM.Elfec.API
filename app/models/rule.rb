class Rule < ActiveRecord::Base
  enum type: {permit: 'permit',
              deny:   'deny'}
  validates_presence_of :policy, :type, :name, :value
  validates_uniqueness_of :name, scope: :policy
  belongs_to :policy
  has_many :applies_to_entities, foreign_key: 'rule_id', class_name: 'EntityRule'
  has_many :users, through: :applies_to_entities, source: :entity, source_type: 'User'
  has_many :user_groups, through: :applies_to_entities, source: :entity, source_type: 'UserGroup'
  self.inheritance_column = 'parent_type'
end
