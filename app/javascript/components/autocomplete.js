function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    var profileCity = document.getElementById('user_city');

    if (profileCity) {
      var autocomplete = new google.maps.places.Autocomplete(profileCity, { types: [ '(cities)' ], region:'EU' });
      google.maps.event.addDomListener(profileCity, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }
  });
}

export { autocomplete };

