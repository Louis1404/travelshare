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
      @time = params[:travellers].each { |d| puts d }.length
      @travellers = []
      create_travellers
    else
      render :new
    end
    @cities = create_list_city(@travellers)
    hash_result = search_on_API(@cities)
    compare_result(hash_result)
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
    # origin_city_list.each do |city|
    #   city_destination.each do |destination|
    #     url = "http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=#{city}&dName=#{destination}&noRideshare"
    #     research_result = open(url).read
    #     total_result = JSON.parse(research_result)
    #     total_result[:routes][0][:segments][0][:indicativePrice][:price]
    #     hash_result[:city][:destination] = total_result[:data]
    #   end
    end
    return :results
  end

    # API exemple = http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=Bern&dName=Zurich&noRideshare
    # Rechercher pour chaque ville des travellers la destination la moins cher sur notre liste de destination
    # Récupérer tous les résultats dans un Hash avec des arrays
    # Ajouter les résultats de prix de chaque ville de départ par destinations
    # Prendre la destination qui a le plus petit prix
    # return le résultat pour le create

  def compare_result(hash_result)
    array_total_price = []
    hash_result.each do |depart|
      depart_array = []
      depart_array << depart
      depart.each do |destination|
        destination_array = []
        destination_array << destination
        destination_array << destination[:routes][0][:segments][0][:indicativePrice][:price]
        array_total_price << destination_array
    end
    array_total_price.sort.first
  end

  def results
    {
      agencies:
        [{
        code:       'SWISSRAILWAYS',
        name:       'Swiss Railways (SBB/CFF/FFS)',
        url:        'http://www.sbb.ch'
        iconPath:   '/logos/trains/ch.png',
        iconSize:   '27,23',
        iconOffset: '0,0'
        ]},
      routes:
        [{
        name:     'Train',
        distance: 95.92,
        duration: 56,
        stops:
          [{
          name: 'Bern',
          pos:  '46.94926,7.43883',
          kind: 'station'
          },{
          name: 'Zürich HB',
          pos:  '47.37819,8.54019',
          kind: 'station'
          }],
        segments:
          [{
          kind:     'train',
          subkind:     'train',
          isMajor:  1,
          distance: 95.92,
          duration: 56,
          sName:    'Bern',
          sPos:     '46.94938,7.43927',
          tName:    'ZÃ¼rich HB',
          tPos:     '47.37819,8.54019',
          path:     '{wp}Gu{kl@wb@uVo|AqiDyoBhUibDeiDc`AsmDaxBqk@wwA...',
          indicativePrice: {
            price: 45,
            currency: 'USD',
            isFreeTransfer: 0,
            nativePrice: 40,
            nativeCurrency: 'CHF'
          },
          itineraries:
            [{
            legs:
              [{
              url: 'http://fahrplan.sbb.ch/bin/query.exe/en...',
              hops:
                [{
                distance:  95.92,
                duration:  56,
                sName:     'Bern',
                sPos:      '46.94938,7.43927',
                tName:     'ZÃ¼rich HB',
                tPos:      '47.37819,8.54019',
                frequency: 400,
                indicativePrice: {
                  price: 45,
                  currency: 'USD',
                  isFreeTransfer: 0,
                  nativePrice: 40,
                  nativeCurrency: 'CHF'
                },
                lines:
                  [{
                  name:      '',
                  vehicle:   'train',
                  agency:    'SWISSRAILWAYS',
                  frequency: 400,
                  duration:  57,
                  }]
                }]
              }]
            }]
          }]
        }]
      }]
    }
  end

end
