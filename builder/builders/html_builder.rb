require 'json'
require 'yaml'
class HtmlBuilder
  HEAD ='<head><link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"></head>'
  def build(conditions, output: $stdout)
    version = `git describe`
    info = JSON.parse(`git --no-pager log -1 --pretty=format:'{"commit": "%H", "tag": "%D", "author": "%an", "date": "%ad", "message": "%s"}' $(git describe --tags --abbrev=0)`, symbolize_names: true)
    output << "<html>"
    output << HEAD
    output << '<body><div class="container"><h1>Conditions dictionary</h1>'
    output << "<details><summary>Version: #{version}</summary>
      Commit: #{info[:commit]}<br>
    </details>"
    conditions.each do |condition|
      output << "<details id='C-#{condition['id']}'>
  <summary>C-#{condition['id']} - #{condition['label']}</summary>
      <pre><code>#{condition.to_yaml}</code></pre>
</details>"
    end
    output << "</div></body></html>"
  end
end
