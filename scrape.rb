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
downloads = {}
event_data = []
links_to_visit.each do |url|
	page = agent.get(url)
	downloads[:title] = page.parser.xpath('//*[@id="content"]/div[1]/center/h3/a/font').text
	
	host_row = page.parser.xpath('//*[@id="download_table"]')
	
	host_urls = []
	host_row.each do |rls|
		link = rls.css('.td_cols > a')

		link.each do |x|
			host_urls << x.attribute('href').value
		end

	end
	downloads[:links] = host_urls
	event_data.push(downloads)
end

event_data.each do |x|
	puts x
end

