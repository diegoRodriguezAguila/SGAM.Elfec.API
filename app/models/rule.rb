class Rule < ActiveRecord::Base
  enum action: {permit: 'permit',
              deny:   'deny'}
  enum status: [:disabled, :enabled]
  validates_presence_of :policy, :action, :name, :value
  validates_uniqueness_of :name, scope: :policy
  belongs_to :policy
  has_many :applies_to_entities, foreign_key: 'rule_id', class_name: 'EntityRule', dependent: :destroy
  has_many :users, through: :applies_to_entities, source: :entity, source_type: 'User'
  has_many :user_groups, through: :applies_to_entities, source: :entity, source_type: 'UserGroup'

  def entities
    entity_list = []
    users.each{|u| entity_list<<u}
    user_groups.each{|ug| entity_list<<ug}
    entity_list
  end
end
