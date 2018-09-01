require 'json'
require 'open-uri'

class TripsController < ApplicationController
  after_action :verify_authorized, except: [:create]
  # before_action :skip_policy_scope, only: :add_travellers

  def show
    skip_authorization
    @trip = Trip.find(params[:id])
    @travellers = []
    params[:travellers].each do |traveller_id|
        @travellers << Traveller.find(traveller_id)
      end
    @information_destination = BestMatchCaller.new(@trip, @travellers).call
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
    @trip.destination = @final_destination
    @trip.save
    # redirect_to trip_path(@trip.id)
    redirect_to controller: 'trips', action: 'show', id: @trip.id, travellers: @travellers
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
    array_total_price = {}
    hash_result.each do |depart|
      depart.each do |destination|
        array_total_price["#{destination}"] += destination[:routes][0][:segments][0][:indicativePrice][:price]
      end
    end
    array_for_compare = []
    array_total_price.each do |key, value|
      array_for_compare << value
    end
    best_match = array_for_compare.sort.first
    final_destination = array_total_price.key(best_match)
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
