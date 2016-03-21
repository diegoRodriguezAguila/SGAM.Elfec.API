class EntityRule < ActiveRecord::Base
  belongs_to :rule
  belongs_to :entity, polymorphic: true
end
