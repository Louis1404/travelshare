const axios = require('axios')
import "bootstrap";
import { autocomplete } from '../components/autocomplete';

autocomplete();

const clBtn = document.getElementById('user_photo')
if (clBtn) {
  const loader = document.getElementById('photo-loader')
  loader.addEventListener('click', (e) => {
    e.preventDefault()
    clBtn.click()
  })
}

// if (gon.profile) {

  // TRIP FINDER
  // fonction de comparaison
  function compare(a, b) {
  if (a.price < b.price)
    return -1
  if (a.price > b.price)
    return 1
  return 0
  }

  // compare les resultats de l'api
  function resultComparator(object) {
  // console.log("OBJECT", object)
  const prices = {}
  for (var key in object) {
    for (var city in object[key]) {
      if (prices[city]) {
        prices[city] += object[key][city]['price']
      } else {
        prices[city] = object[key][city]['price']
      }
    }
  }
  const results = []
  for (var cityInfo in prices) {
    const data = {
      city: cityInfo,
      price: prices[cityInfo]
    }
    results.push(
      data
    )
  }
  const result = results.sort(compare)[0]
  const destCity = result.city.toLowerCase()
  const img = require(`../images/${destCity}.jpg`)
  const cityCard = document.querySelector('.city-card')
  const bgStyle = `linear-gradient(150deg, rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2)), url("${img}")`
  cityCard.style.backgroundImage = bgStyle
  cityCard.querySelector('h3').innerText = destCity.toUpperCase()
  return result
  }

  // recupere les villes des participants et fait la recherche des prix
  async function getInfos(profiles) {
  const results = {}
  for (const profile of profiles) {
    const { data } = await axios.get(`/getinfos?city=${profile.city}`);
    // console.log(profile.first_name, data['trip'])
    results[`${profile.city}`] = data["trip"][`${profile.city}`]
  }
  return results
  }

  function addTripToDom(profile, data) {
  // for (const profile of profiles) {
    // console.log(`${profile.to_json}`)
    // const traveller = `${profile.to_json}`
    // const way = traveller.way
    const cardHTML = createCard(profile, data)
    const tripDetails = document.querySelector('.trip-details')
    tripDetails.insertAdjacentHTML("beforeend", cardHTML)
  }

  async function getTrips(trip, profiles, destCity) {
    for (const profile of profiles) {
    const { data } = await axios.get(`/getinfos?city=${profile.city}&destination=${destCity}&id=${profile.id}&trip=${trip.id}`);
    const data_exploitable = data.trip[`${profile.city}`][destCity]
    addTripToDom(profile, data_exploitable)
    const map = window.map
    const coords = {
      lat: profile.latitude,
      lng: profile.longitude
    }
    map.setCenter(coords)
    map.addMarkers([coords])
    map.setZoom(10)
  }
  }


  function fontAwesome(data) {
    if (data['transport'].includes("Fly")) {
      return `<i class="fas fa-plane"></i>`
    } else if (data[`transport`].includes("Train")) {
      return `<i class="fas fa-subway"></i>`
    } else {
      return data['transport']
    }
  };

  function usdToEuros(data) {
    return `${Math.round(data['price'] * 0.86018)}`
  }



  // lance le tout
  async function bestMatchFinder() {
  const results = await getInfos(gon.profiles)
  // console.log("API CALL RESPONSE", results)
  const bestMatch = resultComparator(results)
  // console.log("BEST MATCH", bestMatch)
  const trips = getTrips(gon.trip, gon.profiles, bestMatch.city)
  }

  const createCard = (profile, data) => {
    return `
      <div class="trip-detail-content">
        <div class="traveller-name">
          <h5><strong>${profile.first_name} ${profile.last_name}</strong></h5>
        </div>
        <div class="traveller-info">
        <div class="travel-type">
          <p>${fontAwesome(data)}</p>
        </div>
        <div class="travel-time-price"></div>
          <p>${data['time']} m  / <strong>${usdToEuros(data)} €</strong></p>
        </div>
      </div>
    `
  }

bestMatchFinder()
// window.map.
