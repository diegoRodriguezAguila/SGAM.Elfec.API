class SendInstallationsJob < ActiveJob::Base
  queue_as :default

  def perform(installation_ids)
    installations = Installation.where(id: installation_ids,
                                       status: status_filter)
    tokens = installations.collect(&:device)
                 .flatten.to_set.map{|d| d.gcm_token.token}
    installation = installations.first
    GcmDispatcher.send(tokens, {type: 'installation', status: installation.status,
                                package: installation.package, version: installation.version})
    p tokens.map{|t| t.hash}
  end

  private
  def status_filter
    [Installation.statuses[:install_pending],
     Installation.statuses[:uninstall_pending]]
  end

end
