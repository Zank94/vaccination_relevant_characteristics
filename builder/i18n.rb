class I18n
  def initialize(translations)
    @translations = build_translation(translations)
  end

  def t(key)
    @translations[key]
  end

  private

  def build_translation(translations, splat = nil)
    flat_translations = splat || {}
    translations.each do |key, value|
      if value.is_a?(String) && key.start_with?('C-')
        flat_translations[key] = value
      elsif value.is_a?(Hash)
        build_translation(value, flat_translations)
      end
    end
    flat_translations
  end
end
