require 'time'
require 'redcarpet'
class ChangeLogBuilder
  def initialize(format)
    @format = format
  end
  def build(_conditions, output: $stdout)
    case @format
    when 'md'
      md(output)
    when 'html'
      markdown_string = ""
      md(markdown_string)
      renderer = Redcarpet::Render::HTML.new
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      html = markdown.render(markdown_string)
      
      output << <<~HTML
      <html><head><link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"></head><body><div class="container">
      #{html}
      </div>
      </body>
      HTML
    end
  end

  def md(output)
    all_tags = execute_command("git tag --sort=-creatordate").split("\n")
    output << "# Changelog\n\n"

    all_tags.each_with_index do |tag, index|
      tag_date = execute_command("git log -1 --format='%aI' #{tag}")
      tag_author = execute_command("git log -1 --format='%an' #{tag}")

      if index + 1 < all_tags.size
        previous_tag = all_tags[index + 1]
        commits = execute_command("git log #{previous_tag}..#{tag} --pretty=format:'%h - %s (%an)'").split("\n")
      else
        commits = execute_command("git log #{tag} --pretty=format:'%h - %s (%an)'").split("\n")
      end

      modified_files = execute_command("git diff --name-only #{tag} #{previous_tag || ''}").split("\n")

      output << "## Version #{tag}\n"
      output << "**Date :** #{Time.parse(tag_date).strftime('%Y-%m-%d')}\n\n"
      output << "**Author :** #{tag_author}\n\n"

      output << "### Changes\n"
      unless commits.empty?
        commits.each do |c|
          output << "- #{c}\n"
        end
        output << "\n\n"
      end

      if !modified_files.empty?
        output << "### Files\n"
        modified_files.each do |file|
          output << "- #{file}\n"
        end
      end
      output << "\n"
    end
  end
  
  private

  def execute_command(cmd)
    `#{cmd}`.strip
  end  
end



