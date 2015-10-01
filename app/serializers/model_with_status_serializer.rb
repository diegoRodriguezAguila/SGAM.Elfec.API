class ModelWithStatusSerializer < ActiveModel::Serializer
  def attributes
    data = super
    data[:status] = object.class.statuses[object.status]
    data
  end
end