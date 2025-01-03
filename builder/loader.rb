require 'yaml'
class Loader
  def call
    Dir.glob('conditions/**/*.yml').map do |file|
      YAML.load_file(file)
    end
  end
end