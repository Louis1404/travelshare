require 'json'
require 'open-uri'

class TripsController < ApplicationController
  after_action :verify_authorized, except: [:create]
  def show
    authorize @trip
  end

  def new
    @trip = Trip.new # ou .find par id
    # @profiles = Trip.find(2).travellers.pluck("profile_id")
    @profiles = Profile.all # Profile.where.not(id: t) si j'ai une id
    # si j'ai une ID
    # @travellers = aux travellers associés au trip
    authorize @trip
    # ajout d'un input hidden dans la view si j'ai une id avec la valeur de l'id
  end

  def create
    # @trip = Trip.new #ou .find par id
    # authorize @trip
    # if @trip.save
    #   @time = params[:travellers].each { |d| puts d }.length
    #   @travellers = []
    #   create_travellers
    # else
    #   render :new
    # end
    # @cities = create_list_city(@travellers)
    # hash_result = search_on_API(@cities)
    # compare_result(hash_result)
    redirect_to controller: 'trips', action: 'new', id: 3
  end

  def edit
    authorize @trip
  end

  def update
    authorize @trip
  end

  private

  def trip_params
    params.require(:trip).permit(:description, :title, :destination )
  end

   private

  def create_travellers
    @time.times do |i|
      traveller = Traveller.new()
      array_de_travelers = params[:travellers].each { |d| puts d }.to_a
      traveller.profile_id = array_de_travelers[i][1]
      if traveller.profile_id == current_user.id
        traveller.organizer = true
      end
      traveller.trip_id = @trip.id
      traveller.save
      @travellers << traveller
    end
    @travellers
  end

  def create_list_city(travellers)
    @cities = []
    @travellers.each do |traveller|
      id = traveller.profile_id
      profile = Profile.find(id)
      @cities << profile.city
    end
    @cities
  end

  def search_on_API(origin_city_list)
    city_destination = ["Paris", "Lyon", "Berlin", "Sarajevo", "Madrid"]
    hash_result = {}
    origin_city_list.each do |city|
      city_destination.each do |destination|
        url = "http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=#{city}&dName=#{destination}&noRideshare"
        research_result = open(url).read
        total_result = JSON.parse(research_result)
        total_result[:routes][0][:segments][0][:indicativePrice][:price]
        hash_result[:city][:destination] = total_result[:data]
      end
    end
    return hash_result
  end

    # API exemple = http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=Bern&dName=Zurich&noRideshare
    # Rechercher pour chaque ville des travellers la destination la moins cher sur notre liste de destination
    # Récupérer tous les résultats dans un Hash avec des arrays
    # Ajouter les résultats de prix de chaque ville de départ par destinations
    # Prendre la destination qui a le plus petit prix
    # return le résultat pour le create

  def compare_result(hash_result)
    hash_result
  end

end
