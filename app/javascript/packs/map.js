import GMaps from 'gmaps/gmaps.js';
import "bootstrap";
const styles = [
    {
        "featureType": "administrative",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#444444"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f2f2f2"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": 45
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit.line",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": "100"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#046e99"
            },
            {
                "visibility": "on"
            }
        ]
    }
];
const userIcon = require('../images/user_icon.png')
const destIcon = require('../images/dest_city.png')

const mapElement = document.getElementById('map');
if (mapElement) { // don't try to build a map if there's no div#map to inject in
  const map = new GMaps({ el: '#map', lat: 50, lng: 3});
  // const markers = JSON.parse(mapElement.dataset.markers);

  if ( gon.markers ) {
    map.addMarkers(gon.markers);
    const geocoder = new google.maps.Geocoder()
    geocoder.geocode( { 'address': gon.destmarker}, function(results) {
      const coords = {
        lat: results[0].geometry.location.lat(),
        lng: results[0].geometry.location.lng(),
        icon: destIcon
      }

      map.addMarkers([coords])
      map.setCenter(coords)

      gon.markers.forEach(function(marker) {
        const lineOptions = {
          path: [
            [marker.lat, marker.lng],
            [coords.lat, coords.lng]
          ],
          strokeColor: '#e54d32',
          strokeWeight: 4,
        }
        map.drawPolyline(lineOptions)
      });
    })
    map.setZoom(4);
  }

  map.addStyle({
    styles: styles,
    mapTypeId: 'map_style'
  });
  map.setStyle('map_style');
  map.setZoom(4);
  window.map = map
}



