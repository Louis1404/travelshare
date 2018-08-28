class TripsController < ApplicationController

  def show
    authorize @trip
  end

  def new
    authorize @trip
  end

  def create
    authorize @trip
  end

  def edit
    authorize @trip
  end

  def update
    authorize @trip
  end

end
