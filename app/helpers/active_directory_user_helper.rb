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

  # Obtiene un usuario por username
  # @param [String] username nombre de usuario
  # @return [Net::LDAP::Entry|Nil] el usuario o nil si es que no existe
  def find_by_username(username)
    OP_CONN.search(:filter => "sAMAccountName=#{username}").first
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

end