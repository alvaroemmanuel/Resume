require 'kramdown'
require 'pdfkit'

source = File.read('resume.md')

doc = Kramdown::Document.new(source, :auto_ids => false, :parse_block_html => true, :template => 'template.html').to_html

File.open('resume.html','w') {|file| file.puts doc}

%x(htmlbeautifier resume.html)

PDFKit.new(File.new('resume.html'), :page_size => 'Letter', :margin_top => '0mm', :margin_right => '0mm', :margin_bottom => '0mm', :margin_left => '0mm').to_file('resume.pdf')
