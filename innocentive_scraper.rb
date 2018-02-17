load './innocentive_campaigns.rb'
require 'pry'
require 'httparty'
require 'nokogiri'

campaign_data = []

Addresses::ALL.each do |site|
  page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(page)

  title = parse_page.css('div#challenge-name p').text rescue ''
  description = parse_page.css('.text-container div p').first.text rescue ''
  reward = parse_page.css('.challenge-info strong span').text rescue ''
  participants = parse_page.css('.challenge-info div span')[2].text rescue ''
  start_date = parse_page.css('.challenge-info div span')[3].text rescue ''
  end_date = parse_page.css('.challenge-info div strong')[1].text rescue ''

  campaign_data.push({
    title: title,
    description: description,
    reward: reward,
    participants: participants,
    start_date: start_date,
    end_date: end_date
  })
end

CSV.open('innocentive.csv', 'wb') do |csv|
  csv << campaign_data.first.keys
  campaign_data.each do |data|
    csv << data.values if data.values
  end
end

