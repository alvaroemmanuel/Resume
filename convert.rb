require 'kramdown'
require 'pdfkit'
require 'sass'
require 'htmlbeautifier'
require 'fileutils'

FILENAME = 'resume_2.0'

if Gem.win_platform?
  PDFKit.configure do |config|
    config.wkhtmltopdf = 'C:\wkhtmltopdf\bin\wkhtmltopdf.exe'
    config.root_url = 'http://localhost'
    config.verbose = false
  end
end

source = File.read("source/markdown/#{FILENAME}.md")

doc = Kramdown::Document.new(source, auto_ids: false,
  parse_block_html: true, template: 'source/layouts/resume.html').to_html

doc = HtmlBeautifier.beautify(doc)

File.open("build/html/#{FILENAME}.html", 'w') { |file| file.puts doc }

# FileUtils.remove_dir 'build/html/images', true
# FileUtils.cp_r 'source/assets/images/', 'build/html/images'

css = Sass::Engine.for_file(
  'source/assets/stylesheets/resume.css.scss', {}
  ).render

File.open('build/html/stylesheets/resume.css', 'w') { |file| file.puts css }

PDFKit.new(File.new("build/html/#{FILENAME}.html"),
           page_size: 'Letter', margin_top: '2cm',
           margin_right: '0cm', margin_bottom: '2cm',
           margin_left: '0cm', disable_smart_shrinking: false,
           quiet: false, enable_local_file_access: true,
           dpi: 300).to_file("build/pdf/#{FILENAME}.pdf")
