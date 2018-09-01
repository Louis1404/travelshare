class ResultComparaisonCaller

  def initialize(hash_result)
    @hash_result = hash_result
    @destination_price = Hash.new(0)
  end

  def call
    @hash_result.each do |d, destination|
      destination.each do |key, value|
        key
        value
        @destination_price[key] += value
      end
    end
    @array_total_price =[]
    @destination_price.each do |key, value|
      @array_total_price << value
    end
    price = @array_total_price.sort.first
    final_destination = @destination_price.key(price)
  end

end
