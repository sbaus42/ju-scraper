load './innocentive_campaigns.rb'
require 'pry'
require 'httparty'
require 'nokogiri'

Addresses::ALL.each do |site|
  page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(page)

  binding.pry

  title = parse_page.css('div#challenge-name p').text
  reward = parse_page.css('.challenge-info strong span').text
  goal = parse_page.css('.needed .big').first.text

  # TODO: Donors
  campaign_data.push({
    title: title,
    reward: reward,
    goal: goal
  })
end
