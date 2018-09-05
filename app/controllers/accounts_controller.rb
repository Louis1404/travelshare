class AccountsController < ApplicationController
  skip_after_action :verify_authorized

  def dashboard
    @travellers = []
    current_user.profile.travellers.each do |traveller|
      @travellers << traveller
    end
    @trips = []
    @travellers.each do |traveller|
      @trips << Trip.find(traveller.trip_id)
    end
  end
end
