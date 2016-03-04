module Includible
  extend ActiveSupport::Concern

  # Obtiene los includes del request
  def request_includes
    return [] if params[:include].nil?
    include_params = params[:include].gsub(/\s+/, '').split(',')
    include_params.each do |incl|
      include_parts = incl.split('.')
      include_parts.each do |part|
        include_params << part unless include_params.include? part
      end
    end
    include_params
  end
end