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

function addTripToDom(profile, trip, destCity) {
  console.log(trip[`${destCity}`])
  document.body.innerHTML += `<h1>${profile.first_name} va à ${destCity}</h1>`
}

async function getTrips(profiles, destCity) {
  for (const profile of profiles) {
    const { data } = await axios.get(`/getinfos?city=${profile.city}&destination=${destCity}`);
    // console.log(profile.first_name, data)
    addTripToDom(profile, data.trip[`${profile.city}`], destCity)
  }
}
// lance le tout
async function bestMatchFinder() {
  const results = await getInfos(gon.profiles)
  // console.log("API CALL RESPONSE", results)
  const bestMatch = resultComparator(results)
  // console.log("BEST MATCH", bestMatch)
  const trips = getTrips(gon.profiles, bestMatch.city)
}

bestMatchFinder()
