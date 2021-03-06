class AccountsController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    profile_travellers = []
    current_user.profile.travellers.each do |traveller|
      profile_travellers << traveller
    end
    @trips = []
    profile_travellers.each do |traveller|
      @trips << Trip.find(traveller.trip_id)
    end
  end
end
