require 'json'
require 'yaml'
class HtmlBuilder
  HEAD ='<head><link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"></head>'
  def build(conditions, output: $stdout)
    output << "<html>"
    output << HEAD
    output << '<body><div class="container">'
    conditions.each do |condition|
      
      output << "<details id='C-#{condition['id']}'>
  <summary>C-#{condition['id']} - #{condition['label']}</summary>
      <pre><code>#{condition.to_yaml}</code></pre>
</details>"
    end
    output << "</div></body></html>"
  end
end


