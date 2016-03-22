class Rule < ActiveRecord::Base
  enum action: {permit: 'permit',
              deny:   'deny'}
  validates_presence_of :policy, :action, :name, :value
  validates_uniqueness_of :name, scope: :policy
  belongs_to :policy
  has_many :applies_to_entities, foreign_key: 'rule_id', class_name: 'EntityRule', dependent: :destroy
  has_many :users, through: :applies_to_entities, source: :entity, source_type: 'User'
  has_many :user_groups, through: :applies_to_entities, source: :entity, source_type: 'UserGroup'
end
