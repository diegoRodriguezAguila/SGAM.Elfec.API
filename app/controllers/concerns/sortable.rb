module Sortable
  extend ActiveSupport::Concern

  # Order params should be ?sort=name,-status
  # minus (-) in param is descending order
  def sort_params_for(model_class)
    return {} if params[:sort].nil?
    model_methods = model_class.attribute_names
    sort_params_a = params[:sort].gsub(/\s+/, '').split(',')
    sort_params = {}
    sort_params_a.each do |h|
      param_name= h.tr('-','')
      raise Exceptions::InvalidSortException unless model_methods.include? param_name
      sort_params[param_name.to_sym] = (h[0]=='-' )? :desc : :asc
    end
    sort_params
  end
end