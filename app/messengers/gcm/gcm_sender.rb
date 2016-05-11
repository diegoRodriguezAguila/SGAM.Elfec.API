module GcmSender extend ActiveSupport::Concern

  def self.send(registration_ids)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name(Rails.configuration.gcm_app)
    n.registration_ids = registration_ids
    n.data = {message: 'hi mom!'}
    n.collapse_key = 'signal_type'
    # Optional notification payload. See the reference below for more keys you can use!
    n.notification = {body: 'great match!',
                      title: 'Portugal vs. Denmark',
                      icon: 'myicon'
    }
    n.save!
  end
end