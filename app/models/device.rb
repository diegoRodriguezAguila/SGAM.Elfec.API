class Device < ActiveRecord::Base
  enum status: [:unauthorized, :authorized, :auth_pending]
  validates_presence_of :imei, :serial, :wifi_mac_address, :bluetooth_mac_address, :platform,
                        :os_version, :baseband_version, :brand, :model, :gmail_account, :status
  validates_uniqueness_of :name, :imei, :wifi_mac_address, :bluetooth_mac_address
  validates_numericality_of :imei, :phone_number, :screen_size, :camera, :sd_memory_card, allow_nil: true
  validates_inclusion_of :platform, in: ['Android']
  validates :wifi_mac_address, :bluetooth_mac_address, mac_address: true, allow_nil: true
  validates :imei, imei: true, allow_nil: true
  validates :gmail_account, email: true, allow_nil: true
  validates_format_of :screen_resolution, with: /\A\d+[x]\d+\z/i, allow_nil: true

  has_and_belongs_to_many :users, join_table: 'user_devices'
  has_one :gcm_token, class_name: 'DeviceGcmToken', dependent: :destroy

  has_many :device_sessions

  has_many :installed_apps, class_name: 'Installation', dependent: :destroy

  before_save :format_for_save
  # Verifica si el dispositivo es creable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def creatable_by? (user)
    user.has_permission? Permission.register_device
  end

  # Verifica si el dispositivo es updateable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def updatable_by? (user)
    user.has_permission? Permission.update_device
  end

  # Verifica si este dispositivo espec�fico esn visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    user.has_permission? Permission.view_single_device
  end

  # Verifica si el recurso de los dispositivos son visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    return user.has_permission? Permission.view_devices
  end

  # Dev sugar for query imei and name
  # @param [String] imei
  # @param [String] name
  # @return [Device]
  def self.find_by_imei_or_name(imei, name)
    where('imei= ? OR name= ?', imei, name).first
  end

  # Dev sugar for query imei and name
  # @param [String] device_id imei or name
  # @return [Device]
  def self.find_by_identifier(device_id)
    where('imei= ? OR name= ?', device_id, device_id).first
  end

  # filters devices by rules that apply to them
  # @param [Array] rules
  scope :filter_by_rules, ->(rules) {
    devices_table = Device.arel_table
    like_filters = Rule.like_queries_for rules
    where(devices_table[:imei].matches_any(like_filters[:like])
              .and(devices_table[:imei]
                       .does_not_match_any(like_filters[:not_like])))
  }

  private
  # Formatea los campos a lo estandarizado para el correcto guardado en la base de datos
  def format_for_save
    model.upcase! unless model.nil?
    brand.capitalize! unless brand.nil?
    screen_resolution.downcase! unless screen_resolution.nil?
    self.screen_size = screen_size.round(2) unless screen_size.nil?
    self.camera = camera.round(2) unless camera.nil?
    self.sd_memory_card = sd_memory_card.round(2) unless sd_memory_card.nil?
  end
end
