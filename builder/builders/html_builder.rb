require 'json'
require 'yaml'
require 'siphash'

class HtmlBuilder
  HEADER = <<~HTML
  <html><head><link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"></head>
  HTML

  def build(conditions, output: $stdout)
    $stderr.puts "Building HTML"
    version = `git describe`
    $stderr.puts "Version #{version.inspect}"
    info = JSON.parse(`git --no-pager log -1 --pretty=format:'{"commit": "%H", "tag": "%D", "author": "%an", "date": "%ad", "message": "%s"}' $(git describe --tags --abbrev=0)`, symbolize_names: true)
    output << HEADER
    output << '<body><div class="container"><h1>Conditions dictionary</h1>'
    output << <<~HTML
    <table>
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
        <td><a href="https://github.com/Syadem/vaccination_profile/commit/#{info[:commit]}">github</a></td>
      </tr>
    </table>
    HTML
    detail(conditions, output)
    output << "</div></body></html>"
  end

  private

  def detail(conditions, output)
    conditions.each do |condition|
      checksum = SipHash.digest('Weblate Sip Hash', "C-#{condition['id']}").to_s(16)
      output << <<~HTML
        <details id="C-#{condition['id']}">
          <summary>C-#{condition['id']} - #{condition['label']}</summary>
            <pre><code>#{condition.to_yaml}</code></pre>
            <a href="https://hosted.weblate.org/translate/syadem-translations/vcds_conditions/en/?checksum=#{checksum}">Weblate translations</a>
        </details>
      HTML
    end
  end
end
