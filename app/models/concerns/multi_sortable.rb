module MultiSortable
  extend ActiveSupport::Concern
  DIRECTION_MULTIPLIER = { asc: 1, desc: -1 }

# Note: nil will be sorted towards the bottom (regardless if :asc or :desc)
  def multi_sort(items, order)
    items.sort do |this, that|
      order.reduce(0) do |diff, order|
        next diff if diff != 0 # this and that have differed at an earlier order entry
        key, direction = order
        # deal with nil cases
        next  0 if this[key].nil? && that[key].nil?
        next  1 if this[key].nil?
        next -1 if that[key].nil?
        # do the actual comparison
        comparison = this[key] <=> that[key]
        next comparison * DIRECTION_MULTIPLIER[direction]
      end
    end
  end
end