# Get the HTML

require 'mechanize'
require 'nokogiri'
require_relative 'episode'

# Variables
agent = Mechanize.new
links_to_visit = []
playlist = []

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

	title = page.search("h3 a").text
	link_rows = page.search("td.td_cols")

	episode_links = []
	link_rows.each do |row|
		row_link = row.css("a")[0]['href']
		episode_links << "#{row_link}"
	end


	episode = Episode.new(title, episode_links)
	playlist << episode
end

puts playlist[0].title
puts playlist[0].links

