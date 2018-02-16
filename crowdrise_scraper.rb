require 'nokogiri'
require 'httparty'
require 'pry'
require 'headless'
require 'watir'

# Get a list of Pages to scrape
categories = [
  'https://www.crowdrise.com/give/causes#/Refugee-Relief',
  'https://www.crowdrise.com/give/causes#/Civil-Rights-&-Social-Action',
  'https://www.crowdrise.com/give/causes#/Environment',
  'https://www.crowdrise.com/give/causes#/Water'
]

headless = Headless.new
headless.start

# categories = ['https://www.crowdrise.com/give/causes#/Refugee-Relief']

funds_address = []

categories.each do |site|
  browser = Watir::Browser.start site
  # page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(browser.html)

  list_of_funds = parse_page.css('.spotlight-card a')

  list_of_funds.each do |link|
    full_url = 'https://www.crowdrise.com/o/en/campaign' + link['href']
    funds_address.push(full_url.gsub('/fundraiser', ''))
  end
end
funds_address.uniq!
# Now get the info required

campaign_data = []

funds_address.each do |site|
  page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(page)

  title = parse_page.css('h1.campaign-title').text rescue ''
  collected =  parse_page.css('h2.raised').first.text rescue ''
  goal =  parse_page.css('h3.goal').first.text.scan(/\$.+\s/).first.strip rescue ''

  campaign_data.push({
    title: title,
    collected: collected,
    goal: goal
  })
end

