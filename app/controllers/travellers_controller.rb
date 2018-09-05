class TravellersController < ApplicationController

#   def new
#     @traveller = Traveller.new
#     authorize @traveller
#   end

  def create
    @trip = Trip.new

    @traveller = Traveller.new(traveller_params)
  end


  private


#   def traveller_params
#     params.require(:traveller).permit(:user_id)
#   end

end
