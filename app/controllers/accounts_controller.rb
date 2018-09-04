class AccountsController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    array_trips_id = []
    current_user.profile.travellers.each do |traveller|
    array_trips_id << traveller.trip_id
    end
    @trips = []
    array_trips_id.each do |id|
      @trips << Trip.find(id)
    end
    @trips
  end
end
