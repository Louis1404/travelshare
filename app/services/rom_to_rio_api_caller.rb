require 'rest-client'
require 'json'

DCITIES = ['Londres', 'Vienne']

class RomToRioApiCaller
  def initialize(city, dcities = DCITIES)
    @o_city = city
    @city_destinations = dcities
    @key = ENV['ROM2RIO_API_KEY']
  end

  def call
    hash_result = {}
    @city_destinations.each do |destination|
      if @o_city != destination
        p destination
        url = "http://free.rome2rio.com/api/1.4/json/Search?key=#{@key}&oName=#{@o_city}&dName=#{destination}&noRideshare&noCar&noFerry"
        research_result = JSON.parse(RestClient.get(url).body)
        p price = research_result["routes"][0]["indicativePrices"]
        p research_result["routes"][0]["indicativePrices"][0]["price"]
        hash_result[@o_city] = {} unless hash_result[@o_city]
        data = {
          transport: research_result["routes"][0]["name"],
          price: research_result["routes"][0]["indicativePrices"][0]["price"],
          distance: research_result["routes"][0]["distance"],
          time: research_result["routes"][0]["totalDuration"]
        }
        hash_result[@o_city][destination] = data
      end
    end
    hash_result
  end

end
