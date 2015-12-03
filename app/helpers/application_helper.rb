module ApplicationHelper
  APK_FILENAME = 'app.apk'

  def save_apk(app_dir, apk_file)
    path = File.join(app_dir, APK_FILENAME)
    FileUtils::mkdir_p File.dirname(path)
    File.open(path, 'wb') { |f| f.write apk_file.read }
  end

  # @param [Android::Apk] apk
  def save_icon(app_res_dir, apk)
    icon = app_icon(apk)
    path = File.join(app_res_dir, icon[:name])
    FileUtils::mkdir_p File.dirname(path)
    File.open(path, 'wb') { |f| f.write icon[:data] }
  end
end
