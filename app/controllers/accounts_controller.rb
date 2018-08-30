class AccountsController < ApplicationController
  skip_after_action :verify_authorized
  def dashboard
    array_trips_id = current_user.profile.travellers.each { |traveller| traveller.trip_id}
    array_trips_id.each { |id| @trips << Trip.find(id)}
    @trips

  end
end
