module ApkLabelHelper

  LABEL_IDENTIFIER = 'application-label-es:'
  # Obtiene el nombre de la aplicación utilizando aapt.exe
  # solo debería usarse si ruby_apk no pudo obtener el label
  # @param [String] apk_path
  def apk_app_name(apk_path)
    begin
    output = `aapt.exe dump badging "#{apk_path}" | findstr #{LABEL_IDENTIFIER}`
    output.sub! LABEL_IDENTIFIER, ''
    output.gsub! "'", ''
    output.sub! "\n", '' if output.include? "\n"
    rescue
      nil
    end
  end
end