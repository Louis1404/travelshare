class WaysController < ApplicationController

  def create
    # origin_city_list = []
    # users_for_trip.each do |user|
    #   origin_city_list << user.city
    # end
    # search_on_API()
    # if @trip.save
    # else
    #   # fail
    #   render :new
    # end
  end

  private

  def search_on_API(origin_city_list)
    # hash_result = {}
    # origin_city_list.each do |city|
    #   city_destination.each do |destination|
    #     url = "http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=#{city}&dName=#{destination}&noRideshare"
    #     research_result = open(url).read
    #     total_result = JSON.parse(research_result)
    #     hash_result[:city][:destination] = total_result[:data]
    #   end
    # end
    # return  hash_result
  end

    # API exemple = http://free.rome2rio.com/api/1.4/xml/Search?key=&oName=Bern&dName=Zurich&noRideshare
    # Rechercher pour chaque ville des travellers la destination la moins cher sur notre liste de destination
    # Récupérer tous les résultats dans un Hash avec des arrays
    # Ajouter les résultats de prix de chaque ville de départ par destinations
    # Prendre la destination qui a le plus petit prix
    # return le résultat pour le create

  def compare_result(hash_result)

  end

end
