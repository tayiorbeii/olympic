require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'uri'

agent = Mechanize.new

page = agent.get('http://tv-release.net')

# Grab the search form and type the query in
search_form = page.form('find')
search_form.s = 'Winter Olympics 2014'

#submit the query
page = agent.submit(search_form, search_form.buttons.first)

#grabs table rows
release_row = page.parser.xpath("//table[@class='posts_table']//tr")

#pulls release link out of each row, builds array
links_to_visit = []
release_row.each do |rls|
	link = rls.css('td > a')[1].attribute('href').content
	links_to_visit << "http://tv-release.net/#{link}/"
end

#visit each of the links

events = []
links_to_visit.each do |url|
	page = agent.get(url)
	# events[:titles] = page.parser.xpath('//*[@id="content"]/div[1]/center/h3/a/font/text()').text



end


puts events[:titles]