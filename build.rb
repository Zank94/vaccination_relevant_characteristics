require 'optparse'

require_relative 'builder/loader'
require_relative 'builder/i18n'

options = {}

OptionParser.new do |opts|
  opts.on("-s", "--subject=SUBJECT", "Subject to build") do |subject|
    options[:subject] = subject
  end
  opts.on("-f", "--format=FORMAT", "Output format") do |format|
    options[:format] = format
  end
end.parse!

builder = case [options[:subject], options[:format]]
when ['dictionary', 'json']
  require_relative 'builder/builders/json_builder'
  JsonBuilder.new
when ['dictionary', 'html']
  require_relative 'builder/builders/html_builder'
  HtmlBuilder.new
when ['changelog', 'md']
  require_relative 'builder/builders/change_log_builder'
  ChangeLogBuilder.new('md')
when ['changelog', 'html']
  require_relative 'builder/builders/change_log_builder'
  ChangeLogBuilder.new('html')
else
  raise 'Unknown subjet/format'
end

i18n = I18n.new(YAML.load_file('./i18n/en.yml'))

characteristics = Loader.new(i18n).call
builder.build(characteristics)
