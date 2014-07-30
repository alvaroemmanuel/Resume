require 'kramdown'
require 'pdfkit'
require 'sass'
require 'fileutils'

if Gem.win_platform?
	PDFKit.configure do |config|
	  config.wkhtmltopdf = 'C:\wkhtmltopdf\bin\wkhtmltopdf.exe'
	  config.root_url = "http://localhost"
	  config.verbose = false
	end
end

source = File.read('source/markdown/resume.md')

doc = Kramdown::Document.new(source, :auto_ids => false, :parse_block_html => true, :template => 'source/layouts/resume.html').to_html

File.open('build/html/resume.html','w') {|file| file.puts doc}

%x(htmlbeautifier build/html/resume.html)

FileUtils.remove_dir 'build/html/images', force=true
FileUtils.cp_r 'source/assets/images/', 'build/html/images'

css = Sass::Engine.for_file('source/assets/stylesheets/resume.css.scss', {}).render
File.open('build/html/stylesheets/resume.css','w') {|file| file.puts css}

PDFKit.new(File.new('build/html/resume.html'), :page_size => 'Letter', :margin_top => '1in', :margin_right => '1in', :margin_bottom => '1in', :margin_left => '1in').to_file('build/pdf/resume.pdf')
