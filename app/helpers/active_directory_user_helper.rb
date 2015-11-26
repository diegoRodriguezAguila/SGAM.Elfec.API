#encode utf-8
require 'net/ldap'

module ActiveDirectoryUserHelper
  ### BEGIN CONFIGURATION ###
  SERVER = 'elffls01.elfec.com'   # Active Directory server name or IP
  PORT = 389                    # Active Directory server port (default 389)
  BASE = 'DC=elfec,DC=com'    # Base to search from
  DOMAIN = 'elfec.com'        # For simplified user@domain format login
  ### END CONFIGURATION ###

  # Valida un usuario con active directory
  # @param [String] username
  # @return [String] password
  def authenticate(username, password)
    return false if username.empty? or password.empty?
    puts "AUTENTICANDO: #{username}@#{DOMAIN} y password #{password}"
    conn = Net::LDAP.new :host => SERVER,
                         :port => PORT,
                         :base => BASE,
                         :auth => { :username => "#{username}@#{DOMAIN}",
                                    :password => password,
                                    :method => :simple }
    if conn.bind
      return true
    else
      return false
    end
      # If we don't rescue this, Net::LDAP is decidedly ungraceful about failing
      # to connect to the server. We'd prefer to say authentication failed.
  rescue Net::LDAP::LdapError => e
    return false
  end
end