class SendInstallationsJob < ActiveJob::Base
  queue_as :default

  def perform(installation_ids)
    installations = Installation.where(id: installation_ids,
                                       status: status_filter)
    installations.each do |ins|
      data = InstallationSerializer.new(ins)
      installation = {}; data.attributes.each { |k,v| installation[k] = v }
      installation[:type] = INSTALLATION_KEY
      GcmDispatcher.send([ins.device.gcm_token.token], installation)
    end
  end

  private
  def status_filter
    [Installation.statuses[:install_pending],
     Installation.statuses[:uninstall_pending]]
  end

  INSTALLATION_KEY = 'installation'

end
