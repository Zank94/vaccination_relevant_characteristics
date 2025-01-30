require 'yaml'
class Loader
  def initialize(i18n)
    @i18n = i18n
  end

  def call
    Dir.glob('characteristics/**/*.yml').map do |file|
      characteristic = YAML.load_file(file)
      {
        **characteristic,
        'label_en' => @i18n.t("C-#{characteristic['id']}"),
      }
    end
  end
end
