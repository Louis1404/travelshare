require 'rest-client'
require 'json'

class RomToRioApiCaller
  def initialize(cities)
    @o_cities = cities
    @city_destinations = ['Londres', 'Rome']
    @key = ENV['ROM2RIO_API_KEY']
  end

  def call
    hash_result = {}
    @o_cities.each do |city|
      @city_destinations.each do |destination|
        if city != destination
          url = "http://free.rome2rio.com/api/1.4/json/Search?key=#{@key}&oName=#{city}&dName=#{destination}&noRideshare&noCar&noFerry"
          research_result = JSON.parse(RestClient.get(url).body)
          price = research_result["routes"][0]["indicativePrices"][0]["price"]
          hash_result[city] = Hash.new(0) unless hash_result[city]
          hash_result[city][destination] += price
        end
      end
    end
    hash_result
  end

end
