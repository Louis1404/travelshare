class CreateWayCaller

  def initialize(data)
    @profile = Profile.find(data[:profile])
    @traveller = @profile.travellers.last
    @trip_info = data[:infos]
    @destination = data[:destination]
  end

  def call
    way = Way.new
    way.departure_city = @profile.city
    way.arrival_city = @destination
    way.price = @trip_info["price"]
    way.content = @trip_info['transport']
    way.travel_time = @trip_info['time']
    way.distance = @trip_info['distance:']
    way.traveller_id = @traveller.id
    way.save
    return way
  end
end
