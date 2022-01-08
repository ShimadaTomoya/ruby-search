require 'nokogiri'
require 'rexml/document'

xml = File.open('./sample/test.xml','r')
doc =  REXML::Document.new(xml)

File.open('./sample/wikisource.txt', 'w') do |f|
	doc.get_elements('//mediawiki/page').each do |page|
		p title = page.elements['title'].text.gsub(/\s+|\[.*\]|\{.*\}|\n|Category:/, '')
		p page.elements['revision'].elements['text'].text.gsub(/\s+|\[.*\]|\{.*\}|\n|Category:/, '')
  	#f.write(elem.text.gsub(/\s+|\[|\]|\{|\}|\n|Category:/, '') + "\n")
	end
end