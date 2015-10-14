module Sortable
  extend ActiveSupport::Concern
# Order params should be ?sort=name,status:desc
  def sort_params
    if params[:sort].nil?
      return nil
    end
    sort_params_a = params[:sort].gsub(/\s+/, '').split(',')
    sort_params = {}
    sort_params_a.each do |h|
      key_val = h.split(':')
      sort_params[key_val[0].to_sym] = (key_val.size>1 ? key_val[1] : 'asc').to_sym
    end
    sort_params
  end
end