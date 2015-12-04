#encoding: UTF-8
require 'net/ldap'
module ActiveDirectoryImagesHelper
  include FileUrlHelper
  USER_PHOTO_FILENAME = 'photo.png'
  # Obtiene la imagen de un entry de usuario de active directory
  # si es que la tiene, caso contrario retorna nil
  # @param [Net::LDAP::Entry|Nil]
  def get_user_entry_image(entry)
    [:thumbnailphoto, :jpegphoto, :photo].each do |photo_key|
      if entry.attribute_names.include?(photo_key)
        return entry[photo_key][0]
      end
    end
    nil
  end

  # Guarda la imagen del usuario en el path correspondiente
  def save_user_image(username, image)
    return if image.nil?
    path = File.join((api_user_dir username), USER_PHOTO_FILENAME)
    FileUtils::mkdir_p File.dirname(path)
    File.open(path, 'wb') { |f| f.write image }
  end

end