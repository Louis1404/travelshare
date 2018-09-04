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
    # @trip = Trip.find(params[:trip_id])
    # authorize @trip
    # if @trip.save
    #   @travellers = []
    #   params[:travellers].each do |traveller_id|
    #     @travellers << Traveller.find(traveller_id)
    #   end
    # else
    #   render :new
    # end

    # @cities = create_list_city(@travellers)
    # @hash_result = RomToRioApiCaller.new(@cities).call
    # @final_destination = ResultComparaisonCaller.new(@hash_result).call
    # @trip.destination = @final_destination
    # @trip.save
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
    # if params[:destination] && params[:trip_info]
    #   data = {
    #     profile: params[:city],
    #     infos: params[:trip_info],
    #     destination: params[:destination]
    #   }
    #   # puts data[:infos]
    #   service = CreateWayCaller.new(data)
    if params[:destination] && params[:city]
      response = RomToRioApiCaller.new(params[:city], [params[:destination]]).call
      profile_id = params[:id]
      response[params[:city]]
      CreateWayCaller.new({
        profile: profile_id,
        infos: response[params[:city]][params[:destination]],
        destination: params[:destination]
      }).call
    elsif params[:destination]
      trip = Trip.find()
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

  # def create_travellers
  #   @time.times do |i|
  #     traveller = Traveller.new()
  #     array_de_travelers = params[:travellers].each { |d| puts d }.to_a
  #     traveller.profile_id = array_de_travelers[i][1]
  #     if traveller.profile_id == current_user.id
  #       traveller.organizer = true
  #     end
  #     traveller.trip_id = @trip.id
  #     traveller.save
  #     @travellers << traveller
  #   end
  #   @travellers
  # end

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
    # API exemple = http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=Bern&dName=Zurich&noRideshare
    # Rechercher pour chaque ville des travellers la destination la moins cher sur notre liste de destination
    # Récupérer tous les résultats dans un Hash avec des arrays
    # Ajouter les résultats de prix de chaque ville de départ par destinations
    # Prendre la destination qui a le plus petit prix
    # return le résultat pour le create

  def compare_result(hash_result)
    puts params
    # ResultComparaisonCaller.new(@hash_result).call
  end

  # def results
  #   {
  #     agencies:
  #       [{
  #       code:       'SWISSRAILWAYS',
  #       name:       'Swiss Railways (SBB/CFF/FFS)',
  #       url:        'http://www.sbb.ch'
  #       iconPath:   '/logos/trains/ch.png',
  #       iconSize:   '27,23',
  #       iconOffset: '0,0'
  #       ]},
  #     routes:
  #       [{
  #       name:     'Train',
  #       distance: 95.92,
  #       duration: 56,
  #       stops:
  #         [{
  #         name: 'Bern',
  #         pos:  '46.94926,7.43883',
  #         kind: 'station'
  #         },{
  #         name: 'Zürich HB',
  #         pos:  '47.37819,8.54019',
  #         kind: 'station'
  #         }],
  #       segments:
  #         [{
  #         kind:     'train',
  #         subkind:     'train',
  #         isMajor:  1,
  #         distance: 95.92,
  #         duration: 56,
  #         sName:    'Bern',
  #         sPos:     '46.94938,7.43927',
  #         tName:    'ZÃ¼rich HB',
  #         tPos:     '47.37819,8.54019',
  #         path:     '{wp}Gu{kl@wb@uVo|AqiDyoBhUibDeiDc`AsmDaxBqk@wwA...',
  #         indicativePrice: {
  #           price: 45,
  #           currency: 'USD',
  #           isFreeTransfer: 0,
  #           nativePrice: 40,
  #           nativeCurrency: 'CHF'
  #         },
  #         itineraries:
  #           [{
  #           legs:
  #             [{
  #             url: 'http://fahrplan.sbb.ch/bin/query.exe/en...',
  #             hops:
  #               [{
  #               distance:  95.92,
  #               duration:  56,
  #               sName:     'Bern',
  #               sPos:      '46.94938,7.43927',
  #               tName:     'ZÃ¼rich HB',
  #               tPos:      '47.37819,8.54019',
  #               frequency: 400,
  #               indicativePrice: {
  #                 price: 45,
  #                 currency: 'USD',
  #                 isFreeTransfer: 0,
  #                 nativePrice: 40,
  #                 nativeCurrency: 'CHF'
  #               },
  #               lines:
  #                 [{
  #                 name:      '',
  #                 vehicle:   'train',
  #                 agency:    'SWISSRAILWAYS',
  #                 frequency: 400,
  #                 duration:  57,
  #                 }]
  #               }]
  #             }]
  #           }]
  #         }]
  #       }]
  #     }]
  #   }
  # end
end
