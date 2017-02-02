class EntityRule < ApplicationRecord
  belongs_to :rule
  belongs_to :entity, polymorphic: true
end
