require 'zip/zip'

class ApkParser
  class NotApkFileError < StandardError;
  end
  USER_PERMISSION = 'uses-permission:'
  APP_LABEL = 'application-label:'
  APP_ICON = 'application-icon-'
  SUPPORTS_SCREENS = 'supports-screens: '

  attr_reader :apk_file_path

  def initialize(apk_file_path)
    raise NotFoundError, "'#{apk_file_path}'" unless File.exist? apk_file_path
    @apk_file_path = apk_file_path
  end

  # 
  # Parses an apk file and returns its major information
  # @return [ApkInfo] major info of the apk
  def parse
    output = `aapt.exe dump badging "#{@apk_file_path}"`
    apk_out = output.split("\n")
    apk_info = ApkInfo.new
    set_package_data(apk_info, apk_out[0])
    set_sdk_data(apk_info, apk_out[1], apk_out[2])
    set_permissions_and_label(apk_info, apk_out)
    set_icons(apk_info, apk_out)
    apk_info
  end

  # private methods
  private

  # Assigns the package data
  # @param [ApkInfo] apk_info
  # @param [String] package_data
  def set_package_data(apk_info, package_data)
    parts = package_data.split
    apk_info.package_name = parts[1].split("'")[1] if parts.length > 1
    apk_info.version_code = parts[2].split("'")[1].to_i if parts.length > 2
    apk_info.version_name = parts[3].split("'")[1] if parts.length > 3
  end

  # Assigns the sdk data
  # @param [ApkInfo] apk_info
  # @param [String] target_sdk_version
  def set_sdk_data(apk_info, sdk_version, target_sdk_version)
    apk_info.min_sdk_version = sdk_version.split("'")[1].to_i
    apk_info.target_sdk_version = target_sdk_version.split("'")[1].to_i
  end

  # Assigns the permissions and label data
  # @param [ApkInfo] apk_info
  # @param [Array] apk_out
  def set_permissions_and_label(apk_info, apk_out)
    (3...apk_out.length).each { |i|
      sp = apk_out[i].split("'")
      apk_info.permissions << sp[1] if sp[0] == USER_PERMISSION
      apk_info.label = sp[1] if sp[0] == APP_LABEL
      set_screen_support(apk_info, sp) if sp[0] == SUPPORTS_SCREENS
    }
  end

  def set_screen_support(apk_info, supports_screens)
    screen_support = ScreenSupport.new
    (1...supports_screens.length).step(2) do |i|
      screen_support.small = true if (i == 1 && supports_screens[i] == 'small')
      screen_support.normal = true if (i == 3 && supports_screens[i] == 'normal')
      screen_support.large = true if (i == 5 && supports_screens[i] == 'large')
      screen_support.x_large = true if (i == 7 && supports_screens[i] == 'xlarge')
    end
    apk_info.screen_support = screen_support
  end

  def set_icons(apk_info, apk_out)
    icon_names = Set[]
    (3...apk_out.length).each { |i|
      if apk_out[i].start_with?(APP_ICON)
        sp = apk_out[i].split("'")
        icon_names << sp[1]
      end
    }
    begin
      @zip = Zip::ZipFile.open(@apk_file_path)
    rescue Zip::ZipError => e
      raise NotApkFileError, e.message
    end
    icon_names.each do |icon|
      apk_info.icons << {name: icon, data: file(icon)}
    end
  end

  # find and return binary data with name
  # @param [String] name file name in apk(fullpath)
  # @return [String] binary data
  # @raise [NotFoundError] when 'name' doesn't exist in the apk
  def file(name) # get data by entry name(path)
    @zip.read(entry(name))
  end

  # find and return zip entry with name
  # @param [String] name file name in apk(fullpath)
  # @return [Zip::ZipEntry] zip entry object
  # @raise [NotFoundError] when 'name' doesn't exist in the apk
  def entry(name)
    entry = @zip.find_entry(name)
    raise NotFoundError, "'#{name}'" if entry.nil?
    entry
  end

end