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
  // console.log("RESULT", result.city)
  // console.log(object[result.city])
  return result
  }

  // recupere les villes des participants
  async function getInfos(profiles) {
  const results = {}
  for (const profile of profiles) {
    const { data } = await axios.get(`/getinfos?city=${profile.city}`);
    // console.log(profile.first_name, data['trip'])
    results[`${profile.city}`] = data["trip"][`${profile.city}`]
  }
  // console.log("R", results)
  return results
  }

  function addTripToDom(profile, ways) {
  // const cardHTML = createCard(profile, trip)
  const tripDetails = document.querySelector('.trip-details')
  // tripDetails.innerHTML += cardHTML
  }

  async function getTrips(profiles, destCity) {
    const ways = []
  for (const profile of profiles) {
    const { data } = await axios.get(`/getinfos?city=${profile.city}&destination=${destCity}`);
    // console.log(profile.first_name, data)
    const { way } = await axios.get(`/getinfos?city=${profile.id}&destination=${destCity}&trip_info=${data.trip[profile.city]}`);
    ways.push(way.trip)
  }
  console.log("WAYS", ways)
  addTripToDom(profile, ways, destCity)
  }

  // lance le tout
  async function bestMatchFinder() {
  const results = await getInfos(gon.profiles)
  // console.log("API CALL RESPONSE", results)
  const bestMatch = resultComparator(results)
  // console.log("BEST MATCH", bestMatch)
  const trips = getTrips(gon.profiles, bestMatch.city)
  }

  // const createCard = (profile, trip) => {
  //   return `
  //       <div class="trip-detail-content">
  //         <div class="traveller-name">
  //           <p><strong><%= profile.first_name %> <%= profile.last_name %></strong></p>
  //         </div>
  //         <div class="way-to-go">
  //           <p><%= way.content %></p>
  //         </div>
  //         <div class="way-time">
  //           <p>Trip time: <%= way.travel_time %> minutes</p>
  //         </div>
  //         <div class="way-detail-price">
  //           <p><strong><%= way.price %> $</strong></p>
  //         </div>
  //       </div>
  //   `
  // }

// }
bestMatchFinder()
