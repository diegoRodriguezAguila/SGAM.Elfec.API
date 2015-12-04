module Exceptions
  class ApiException < StandardError
    def message
      super.message
    end

    def status_code
      :internal_server_error
    end
  end
end