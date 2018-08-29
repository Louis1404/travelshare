class TripsController < ApplicationController
  require 'json'
  require 'open-uri'

  def show
    authorize @trip
  end

  def new
    @trip = Trip.new
    @profiles = Profile.all
    authorize @trip
  end

  def create
    @trip = Trip.new
    authorize @trip
    if @trip.save
      (@combi)
    else
      # fail
      render :new
    end
  end

  def edit
    authorize @trip
  end

  def update
    authorize @trip
  end

  private

  def trip_params
    params.require(:trip).permit(:description, :title, :destination)
  end
end
