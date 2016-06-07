module InstallationsNotifier

  # propagates the installations to the interested devices
  # @param [Array] installations
  def self.propagate_installations(installations)
    SendInstallationsJob.perform_later(installations.map{|ins| ins.id})
  end
end