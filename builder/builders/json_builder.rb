require 'json'

class JsonBuilder
  def build(characteristics, output: $stdout)
    output.puts(characteristics.to_json)
  end
end
