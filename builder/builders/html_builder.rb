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
    output << "<table>
      <tr>
        <td><b>Version</b></td>
        <td>#{version}</td>
      </tr>
      <tr>
        <td><b>Id</td>
        <td>#{info[:commit]}</b></td>
      </tr>
      <tr>
        <td><b>Author</b></td>
        <td>#{info[:author]}</td>
      </tr>
      <tr>
        <td><b>Date</b></td>
        <td>#{info[:date]}</td>
      </tr>
      <tr>
        <td><b>Message</b></td>
        <td>#{info[:message]}</td>
      </tr>
      <tr>
        <td><b>Diff</b></td>
        <td><a href=\"https://github.com/Syadem/vaccination_profile/commit/#{info[:commit]}\">github</a></td>
      </tr>
    </table>"
    conditions.each do |condition|
      output << "<details id='C-#{condition['id']}'>
  <summary>C-#{condition['id']} - #{condition['label']}</summary>
      <pre><code>#{condition.to_yaml}</code></pre>
</details>"
    end
    output << "</div></body></html>"
  end
end
