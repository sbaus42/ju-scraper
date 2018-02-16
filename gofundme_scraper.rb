require 'nokogiri'
require 'httparty'
require 'pry'

# Get a list of Pages to scrape
categories = [
  'https://es.gofundme.com/classroom-fundraising',
  'https://es.gofundme.com/raise-funds/parks',
  'https://es.gofundme.com/raise-funds/recreation-centers',
  'https://es.gofundme.com/success'
]
# Wrap this in a loop for each category

funds_address = []

categories.each do |site|
  page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(page)

  list_of_funds = parse_page.css('.tile-img-contain a')

  list_of_funds.each do |link|
    funds_address.push(link['href'])
  end
end

funds_address.uniq!

# After the pages are there, put everything in a hash and convert to JSON
# funds_address = ['https://es.gofundme.com/39i3m68']

campaign_data = []

funds_address.each do |site|
  page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(page)

  title = parse_page.css('h1.campaign-title').text rescue ''
  description = parse_page.css('#story p').text rescue ''

  collected = parse_page.css('h2.goal strong').first.text rescue ''
  goal = parse_page.css('h2.goal span')
          .first.text
          .scan(/\$.+\s/)
          .first.strip rescue ''

  r_match = parse_page.css('.campaign-status').first.text rescue ''
  backers, time_lapse = r_match.scan(/\d+/)
  time_lapse += r_match.scan(/\b\w+$/).first

  campaign_data.push({
    title: title,
    description: description,
    collected: collected,
    goal: goal,
    backers: backers,
    time_lapse: time_lapse
  })
end
