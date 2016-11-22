#encode utf-8
module ApkIconsHelper
  APP_ICON_FILENAME = 'icon.png'

  # Obtiene el icono que se guardara de la aplicación
  # mayormente es el xhdpi, con nombre ic_launcher
  # @param [ApkInfo] apk_info
  def app_icon(apk_info)
    icon = apk_info.icons.last
    icon = apk_info.icons[2] if apk_info.icons.length>2
    icon[:name] = APP_ICON_FILENAME
    icon
  end
end