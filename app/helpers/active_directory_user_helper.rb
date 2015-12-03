#encoding: UTF-8
require 'net/ldap'

module ActiveDirectoryUserHelper
  ### BEGIN CONFIGURATION ###
  SERVER = 'elffls01.elfec.com'   # Active Directory server name or IP
  PORT = 389                    # Active Directory server port (default 389)
  BASE = 'DC=elfec,DC=com'    # Base to search from
  DOMAIN = 'elfec.com'        # For simplified user@domain format login
  ### END CONFIGURATION ###

  # Conexión para operaciones de LDAP a nombre de la aplicacion
  OP_CONN = Net::LDAP.new(:host => SERVER, :port => PORT, :base => BASE,
                          :auth => {username: "drodriguez@#{DOMAIN}",
                                    password: 'Rasta$#"!',
                                    method: :simple})


  # Valida un usuario con active directory
  # @param [String] username
  # @param [String] password
  # @return [Boolean]
  def authenticate(username, password)
    conn = Net::LDAP.new(:host => SERVER, :port => PORT, :base => BASE,
                  :auth => {username: "#{username}@#{DOMAIN}", password: password, method: :simple})
    return false if username.empty? or password.empty?
    if conn.bind
      return conn.bind
    else
      return false
    end
      # If we don't rescue this, Net::LDAP is decidedly ungraceful about failing
      # to connect to the server. We'd prefer to say authentication failed.
  rescue Net::LDAP::LdapError => e
    return false
  end

  # Obtiene los atributos de un usuario por username
  # @param [String] username nombre de usuario
  # @return [Hash|Nil] atributos de ad el usuario o nil si es que no existe
  def get_active_directory_user(username)
    found_entry = OP_CONN.search(filter: "sAMAccountName=#{username}").first
    return get_user_attributes(found_entry) unless found_entry.nil?
    return nil
  rescue Net::LDAP::LdapError => e
    return nil
  end

  # Obtiene todos los usuarios de AD
  # @return [Array] lista de usuarios
  def all_users
    filter = Net::LDAP::Filter.construct(
        '(&(objectCategory=organizationalPerson)(objectClass=User)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))')
    OP_CONN.search(filter: filter)
  rescue Net::LDAP::LdapError => e
    return []
  end

  private

  # Obtiene los atributos de usuario a partir de un entry de ad
  # @param [Net::LDAP::Entry] entry
  # @return [Hash] user attributes
  def get_user_attributes(entry)
    email = (entry.attribute_names.include? :mail) ? entry.mail[0].to_s.force_encoding('utf-8'):nil
    position = (entry.attribute_names.include? :description) ? entry.description[0].to_s.force_encoding('utf-8'):nil
    company_area = (entry.attribute_names.include? :physicaldeliveryofficename) ?
        entry.physicaldeliveryofficename[0].to_s.force_encoding('utf-8'):nil
    account_control = entry.userAccountControl[0]
    status = (account_control.to_s.to_i & 0x0002).zero?.to_i
    { username: entry.samaccountname[0].to_s.force_encoding('utf-8'),
               first_name: entry.givenname[0].to_s.force_encoding('utf-8'),
               last_name: entry.sn[0].to_s.force_encoding('utf-8'),
               email: email, position: position, company_area: company_area,
               last_ad_sync_at: Time.now, status: status}
  end

end