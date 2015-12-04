class Exceptions::InvalidSortException < Exceptions::ApiException
  def message
    I18n.t(:'api.errors.sort.invalid_params', cascade: true)
  end

  def status_code
    :bad_request
  end
end