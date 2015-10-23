module ApkLabelHelper

  # Obtiene el nombre de la aplicación utilizando aapt.exe
  # solo debería usarse si ruby_apk no pudo obtener el label
  # @param [String] apk_path
  def apk_app_name(apk_path)
    begin
    label_identifier = 'application-label-es:';
    output = `aapt.exe dump badging "#{apk_path}" | findstr #{label_identifier}`
    output.sub! label_identifier, ''
    output.gsub! "'", ''
    output.sub! "\n", '' if output.include? "\n"
    rescue
      nil
    end
  end
end