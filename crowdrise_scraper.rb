require 'nokogiri'
require 'httparty'
require 'pry'
require 'phantomjs'
require 'watir'


# Get a list of Pages to scrape
categories = [
  'https://www.crowdrise.com/give/causes#/Refugee-Relief',
  'https://www.crowdrise.com/give/causes#/Civil-Rights-&-Social-Action',
  'https://www.crowdrise.com/give/causes#/Environment',
  'https://www.crowdrise.com/give/causes#/Water'
]

options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])

driver = Selenium::WebDriver.for(:chrome, options: options)

categories = ['https://www.crowdrise.com/give/causes#/Refugee-Relief']

funds_address = []

categories.each do |site|
  driver.goto site
  # page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(b.html)
  binding.pry
  list_of_funds = parse_page.css('.spotlight-card a')
  binding.pry
  list_of_funds.each do |link|
    full_url = 'https://www.ioby.org' + link['href']
    funds_address.push(full_url)
  end
end

