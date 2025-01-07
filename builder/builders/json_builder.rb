require 'json'

class JsonBuilder
  def build(conditions, output: $stdout)
    output.puts(conditions.to_json)
  end
end