require 'yaml'
class Loader
  def initialize(i18n)
    @i18n = i18n
  end

  def call
    Dir.glob('conditions/**/*.yml').map do |file|
      condition = YAML.load_file(file)
      {
        **condition,
        'label_en' => @i18n.t("C-#{condition['id']}"),
      }
    end
  end
end