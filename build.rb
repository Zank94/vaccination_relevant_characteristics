require 'optparse'

require_relative 'builder/loader'
require_relative 'builder/i18n'

options = {}

OptionParser.new do |opts|
  opts.on("-f", "--format=FORMAT", "Output format") do |format|
    options[:format] = format
  end
end.parse!

builder = case options[:format]
when 'json'
  require_relative 'builder/builders/json_builder'
  JsonBuilder.new
when 'html'
  require_relative 'builder/builders/html_builder'
  HtmlBuilder.new
else
  raise 'Unknown format'
end

i18n = I18n.new(YAML.load_file('./i18n/en.yml'))

conditions = Loader.new(i18n).call
builder.build(conditions)