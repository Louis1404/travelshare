require 'json'
require 'open-uri'

class TripsController < ApplicationController
  after_action :verify_authorized, except: [:create, :find_traveller_trip]
  # before_action :skip_policy_scope, only: :add_travellers

  def show
    skip_authorization
    @trip = Trip.find(params[:id])
    @travellers = []
    @profiles =[]
    params[:travellers].each do |traveller_id|
        @travellers << Traveller.find(traveller_id)
      end
    @travellers.each do |traveller|
      @profiles << Profile.find(traveller.profile_id)
    end
    @markers = @profiles.map do |profile|
      @geocod = Geocoder.search(profile.city)
      {
        lat: @geocod[0].data["geometry"]["location"]["lat"],
        lng: @geocod[0].data["geometry"]["location"]["lng"]#,
        # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
      }
    end

    @information_destination = BestMatchCaller.new(@trip, @travellers).call
    @ways = create_ways(@information_destination)
  end

  def new
    if params[:trip]
      @trip = Trip.find(params[:trip])
      @profiles = Profile.where.not(id: @trip.travellers.pluck("profile_id"))
      # Est ce que le @profiles ne sélectionne que les profiles qui ne sont pas dans le trip?
      @travellers = @trip.travellers
    else
      @trip = Trip.new
      @profiles = Profile.all
    end
    authorize @trip
    @trip.save
    # @trip = Trip.new # ou .find par id
    # @profiles = Trip.find(2).travellers.pluck("profile_id")
    # @profiles = Profile.all # Profile.where.not(id: t) si j'ai une id
    # si j'ai une ID
    # @travellers = aux travellers associés au trip
    # authorize @trip
    # ajout d'un input hidden dans la view si j'ai une id avec la valeur de l'id
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
    @trip = Trip.find(params[:trip_id])
    authorize @trip
    if @trip.save
      @travellers = []
      params[:travellers].each do |traveller_id|
        @travellers << Traveller.find(traveller_id)
      end
    else
      render :new
    end

    @cities = create_list_city(@travellers)
    @hash_result = RomToRioApiCaller.new(@cities).call
    @final_destination = ResultComparaisonCaller.new(@hash_result).call
    @trip.destination = @final_destination
    @trip.save
    redirect_to controller: 'trips', action: 'show', id: @trip.id, travellers: @travellers
  end

  def edit
    authorize @trip
  end

  def update
    authorize @trip
  end

  def find_traveller_trip
    render json: {
      trip: RomToRioApiCaller.new([params[:city]]).call
    }
  end

  def destination_comparaison
    render json: {
      destination: ResultComparaisonCaller.new([params[:trip]]).call
    }
  end

  def get_info_for_destination
    render json: {
      details: ResultComparaisonCaller.new([params[:destination]]).call
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
