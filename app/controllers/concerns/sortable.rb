module Sortable
  extend ActiveSupport::Concern

  # Order params should be ?sort=name,-status
  # minus (-) in param is descending order
  def sort_params
    if params[:sort].nil?
      return nil
    end
    sort_params_a = params[:sort].gsub(/\s+/, '').split(',')
    sort_params = {}
    sort_params_a.each do |h|
      sort_params[h.tr('-','').to_sym] = (h[0]=='-' )? :desc : :asc
    end
    sort_params
  end
end