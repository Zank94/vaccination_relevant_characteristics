require_relative 'builder/loader'
require_relative 'builder/builders/html_builder'

conditions = Loader.new.call
HtmlBuilder.new.build(conditions)