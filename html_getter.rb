# Get the HTML
require 'mechanize'
require 'nokogiri'
require 'builder'
require_relative 'episode'

# Variables
agent = Mechanize.new
links_to_visit = []
playlist = []

# Open the saved page for testing
# f = File.open("page.html")
# page = Nokogiri::HTML(f)
# f.close

# Open tv-release.net
page = agent.get('http://tv-release.net')

# Grab the search form and type the query in
search_form = page.form('find')
search_form.s = 'Winter Olympics 2014'

#submit the query
page = agent.submit(search_form, search_form.buttons.first)

# Grab link rows
# link_rows = page.css("table.posts_table tr") #Nokogiri
link_rows = page.search("table.posts_table tr")


# Extract the links to each episode
link_rows.each do |row|
	row_link = row.css("a")[1]['href']
	links_to_visit << "http://tv-release.net/#{row_link}/"
end

# uri = URI.new
# Visit each of the links
links_to_visit.each do |link|
	page = agent.get(link)

	title = page.search("h3 a").text
	link_rows = page.search("td.td_cols")

	# Process the episode links
	episode_links = []
	link_rows.each do |row|
		row_link = row.css("a")[0]['href']
		# Check for supported hosts
		if ((URI.parse(row_link).host == ("rapidgator.net") || 
			URI.parse(row_link).host == ("ul.to") || 
			URI.parse(row_link).host == ("hugefiles.net") || 
			URI.parse(row_link).host == ("bayfiles.net") || 
			URI.parse(row_link).host == ("bitshare.com")))
			episode_links << "#{row_link}"
		end

	end

	# Create episode object
	episode = Episode.new(title, episode_links)
	playlist << episode
end

# Print to make sure it's working
# playlist.each do |x|
# 	puts x.title, x.links
# end


# Build XML File
file = File.new("playlist.xml", "wb")
builder = Builder::XmlMarkup.new(:target => file, :indent => 1)

builder.poster("Winter Olympics 2014")
builder.fanart
builder.info do
	builder.message
	builder.thumbnail
end
playlist.each do |list|

	builder.item do
		builder.title(list.title)
		builder.link do
			list.links.each do |x|
				builder.sublink(x)
			end	
		end
	end
end



