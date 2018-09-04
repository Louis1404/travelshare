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

function resultComparator(object) {
  // console.log("resultComparator")
  const prices = {}
  for (var key in object) {
    // console.log(key)
    for (var city in object[key]) {
      // prices[city] = 0
      console.log("TEST", object[key])
      console.log("TEST", object[key][city])
      prices[city] += object[key][city]
    }
  }
  console.log(prices)
}


async function getInfos(profiles) {
  const results = {}
  for (const profile of profiles) {
    const { data } = await axios.get(`/getinfos?city=${profile.city}`);
    results[`${profile.city}`] = data["trip"][`${profile.city}`]
  }
  return results
}


async function chienCheant() {
  const results = await getInfos(gon.profiles)
  resultComparator(results)
}

chienCheant()
