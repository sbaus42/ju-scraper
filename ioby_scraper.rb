require 'nokogiri'
require 'httparty'
require 'pry'

# Get a list of Pages to scrape
categories = [
  'https://www.ioby.org/projects/browse/closed?f[0]=sm_field_project_status%3A3',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A26',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A27',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A28',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A29',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A2',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A31',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A32',
  'https://www.ioby.org/projects/browse?f[0]=sm_field_project_status%3A1&f[1]=im_field_project_impact_areas%3A33'
]

funds_address = []

categories.each do |site|
  page = HTTParty.get(site)
  parse_page = Nokogiri::HTML(page)

  list_of_funds = parse_page.css('article a')

  list_of_funds.each do |link|
    full_url = 'https://www.ioby.org' + link['href']
    funds_address.push(full_url)
  end
end

funds_address.uniq!
campaign_data = []

# funds_address = ['https://www.ioby.org/project/heritage-compost-project']
funds_address.each do |site|
  page = HTTParty.get(site) rescue next
  parse_page = Nokogiri::HTML(page)

  title = parse_page.css('h1#pagetitle').text rescue ''
  description = parse_page.css('.full p')[1].text rescue ''

  collected = parse_page.css('.raised .big').first.text rescue ''
  goal = parse_page.css('#total_funding_needed span').first.text rescue ''

  donors = parse_page.css('.donor-list li').length.to_s rescue ''

  campaign_data.push({
    title: title,
    description: description,
    collected: collected,
    goal: goal,
    donors: donors,
    query_date: Date.today.to_s
  })
end

CSV.open('ioby.csv', 'wb') do |csv|
  csv << campaign_data.first.keys
  campaign_data.each do |data|
    csv << data.values if data.values
  end
end
