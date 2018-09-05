require 'json'
require 'open-uri'

class TripsController < ApplicationController
  after_action :verify_authorized, except: [:create, :find_traveller_trip]
  # before_action :skip_policy_scope, only: :add_travellers

  def show
    skip_authorization
    @trip = Trip.find(params[:id])
    # @travellers = []
    @profiles = []
    params[:travellers].each do |traveller_id|
      @profiles << Traveller.find(traveller_id).profile
    end

    # @travellers.each do |traveller|
    #   @profiles << Profile.find(traveller.profile_id)
    # end
    # @markers = @profiles.map do |profile|
    #   @geocod = Geocoder.search(profile.city)
    #   {
    #     lat: @geocod[0].data["geometry"]["location"]["lat"],
    #     lng: @geocod[0].data["geometry"]["location"]["lng"]#,
    #     # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
    #   }
    # end

    # @information_destination = BestMatchCaller.new(@trip, @travellers).call
    # @ways = create_ways(@information_destination)
    gon.trip = @trip
    gon.profiles = @profiles
  end

  def new
    if params[:search].present?
      if params[:trip]
        @trip = Trip.find(params[:trip])
        sql_query = "first_name ILIKE :search OR last_name ILIKE :search OR city ILIKE :search"
        @profiles = []
        @profiles = Profile.where(sql_query, search: "%#{params[:search]}%")
                           .where.not(latitude: nil, id: @trip.travellers.pluck("profile_id"))
        @travellers = @trip.travellers
      else
        sql_query = "first_name ILIKE :search OR last_name ILIKE :search OR city ILIKE :search"
        @profiles = []
        @profiles = Profile.where(sql_query, search: "%#{params[:search]}%")
        @trip = Trip.new
      end
    elsif params[:trip]
      @trip = Trip.find(params[:trip])
      @profiles = Profile.where.not(latitude: nil, id: @trip.travellers.pluck("profile_id"))
      @travellers = @trip.travellers
    else
      @trip = Trip.new
      @trip.save
      @travellers = []
      traveller = Traveller.create(
      profile: current_user.profile,
      trip: @trip
      )
      @travellers << traveller
      @profiles = Profile.where.not(latitude: nil, id: traveller.profile_id)
    end
    authorize @trip
    @trip.save
  end

  def add_travellers
    skip_authorization
    if params[:trip]
      @trip = Trip.find(params[:trip])
    else
      @trip = Trip.new
    end
    Traveller.create(
      profile: Profile.find(params[:profile]),
      trip: @trip
    )
    redirect_to controller: 'trips', action: 'new', trip: "#{@trip.id}"
  end

  def delete_travellers
    skip_authorization
    @trip = Trip.find(params[:trip])
    traveller = Traveller.find(params[:traveller])
    traveller.destroy
    redirect_to controller: 'trips', action: 'new', trip: "#{@trip.id}"
  end

  def create
    redirect_to controller: 'trips', action: 'show', id: @trip.id, travellers: @travellers
  end

  def edit
    authorize @trip
  end

  def update
    authorize @trip
  end

  def find_traveller_trip
    service = nil
    if params[:destination] && params[:city]
      response = RomToRioApiCaller.new(params[:city], [params[:destination]]).call
      profile_id = params[:id]
      response[params[:city]]
      params[:destination]
      CreateWayCaller.new({
        profile: profile_id,
        infos: response[params[:city]][params[:destination]],
        destination: params[:destination]
      }).call
      @trip = Trip.find(params[:trip])
      @trip.destination = params[:destination]
      @trip.save
    else
      response = RomToRioApiCaller.new(params[:city]).call
    end
    render json: {
      trip: response
    }
  end

  private

  def trip_params
    params.require(:trip).permit(:description, :title, :destination )
  end

  def create_ways(hash_result)
    @information_destination = hash_result
    @ways = []
    @travellers.each do |traveller|
      profile = Profile.find(traveller.profile_id)
      @information_destination.each do |key, value|
        if profile.city == key
          way = Way.new
          way.departure_city = profile.city
          way.arrival_city = @trip.destination
          way.traveller_id = traveller.id
          way.price = value["price"]
          way.content = value["title"]
          way.travel_time = value["time"]
          way.duration = value["distance"]
          way.save
          @ways << way
        end
      end
    end
    @ways
  end

  def create_list_city(travellers)
    @cities = []
    @travellers.each do |traveller|
      id = traveller.profile_id
      profile = Profile.find(id)
      @cities << profile.city.split(",")[0]
    end
    @cities
  end

end
