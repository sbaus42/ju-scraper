load './indiegogo_campaigns.rb'
require 'pry'
require 'watir'
require 'nokogiri'
require 'headless'
require 'csv'

campaign_data = []

headless = Headless.new
headless.start

to_parse = Addresses::ALL.length
parsed = 0

caught = false

Addresses::ALL.each do |site|
  browser = Watir::Browser.start site
  sleep 3
  parse_page = Nokogiri::HTML(browser.html)

  if parse_page.css('h1').first.text == "Pardon Our Interruption..."
    puts "They caught us at parse ##{parsed}"
    caught = true
    break
  end

  title = parse_page.css('div.campaignHeaderBasics-title').text.strip rescue ''
  collected = parse_page.css('span.campaignGoalProgress-raisedAmount').text.strip rescue ''
  time_left = parse_page.css('.campaignGoalProgress-detailsTimeLeft').text.strip rescue ''
  participants = parse_page.css('.campaignGoalProgress-raised span')[1].text.strip.scan(/\d+/).first rescue ''
  description = parse_page.css('.campaignOverview-contentText').text.strip rescue ''
  goal = parse_page.css('.campaignGoalProgress-detailsGoal div')

  parsed += 1
  puts "Parsed #{parsed} of #{to_parse}"

  campaign_data.push({
    title: title,
    collected: collected,
    participants: participants,
    time_left: time_left,
    description: description
  })
end

CSV.open('innocentive.csv', 'wb') do |csv|
  csv << campaign_data.first.keys
  campaign_data.each do |data|
    csv << data.values if data.values
  end
end unless caught
