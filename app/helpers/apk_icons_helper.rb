#encode utf-8
module ApkIconsHelper

  # Obtiene los iconos de la aplicación
  # si no se puede encontrar se obtiene el xhpdi por defecto
  # @param [Android::Apk] apk
  def icons_of_apk(apk)
    begin
      icons = apk.icon
    rescue
      name  = 'res/mipmap-xhdpi-v4/ic_launcher.png'
      icons = {name=>apk.file(name)}
    end
    icons
  end

  # Obtiene el icono que se guardara de la aplicación
  # mayormente es el xhdpi, con nombre ic_launcher
  # @param [Android::Apk] apk
  def app_icon(apk)
    icons = icons_of_apk(apk)
    icons.each do |name, data|
      if /xhdpi/ =~ name
        return {name: 'icon.png', data: data}
      end
    end
    # Si no tiene xhdpi se envía el
    name = icons.keys[icons.size-1]
    {name: name, data: icons[name]}
  end
end