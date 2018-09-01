require 'rest-client'
require 'json'

class BestMatchCaller

  def initialize(trip, travellers)
    @destination  = trip.destination
    @travellers = travellers
    @key = ENV['ROM2RIO_API_KEY']
  end

  def call
    hash_result = {}
    @travellers.each do |traveller|
      city = Profile.find(traveller.profile_id).city
      if city != @destination
        url = "http://free.rome2rio.com/api/1.4/json/Search?key=#{@key}&oName=#{city}&dName=#{@destination}&noRideshare&noCar&noFerry"
        research_result = JSON.parse(RestClient.get(url).body)
        hash_result[city] = Hash.new(0)
        hash_result[city]["title"] = research_result["routes"][0]["name"]
        hash_result[city]["price"] = research_result["routes"][0]["indicativePrices"][0]["price"]
        hash_result[city]["distance"] = research_result["routes"][0]["distance"]
        hash_result[city]["time"] = research_result["routes"][0]["totalDuration"]
      end
    end
    hash_result
  end
end
