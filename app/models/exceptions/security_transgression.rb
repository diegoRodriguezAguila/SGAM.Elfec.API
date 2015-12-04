class Exceptions::SecurityTransgression  < Exceptions::ApiException
  def message
    I18n.t(:'api.errors.session.insufficient_privileges', cascade: true)
  end

  def status_code
    :forbidden
  end
end