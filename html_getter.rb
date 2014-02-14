# Get the HTML

require 'mechanize'
require 'nokogiri'

# Variables
agent = Mechanize.new
links_to_visit = []

# Open the saved page for testing
f = File.open("page.html")
page = Nokogiri::HTML(f)
f.close

# Grab link rows
link_rows = page.css("table.posts_table tr")

# Extract the links to each episode
link_rows.each do |row|
	row_link = row.css("a")[1]['href']
	links_to_visit << "http://tv-release.net/#{row_link}/"
end

# Visit each of the links
links_to_visit.each do |link|
	page = agent.get(link)
	puts page.search("h3 a").text

end
