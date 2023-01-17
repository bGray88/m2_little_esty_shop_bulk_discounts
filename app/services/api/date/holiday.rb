require 'httparty'
require 'json'

class Holiday
  def initialize
  end

  def response
    HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end

  def parsed
    JSON.parse(response.body, symbolize_names: true)
  end

  def next_three
    parsed.first(3)
  end
end
