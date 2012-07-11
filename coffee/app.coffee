$ ->
  mapOptions = {
    center: ( new google.maps.LatLng 29.9728, -90.05902 ),
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  map = new google.maps.Map ( $ '#map_canvas' )[0], mapOptions
  console.log ( $ '#map_canvas' )
  $.getJSON '/apartments', (data) ->
    for a in data
      apartment = new Apartment a

      marker = new google.maps.Marker {
        position: new google.maps.LatLng apartment.latitude, apartment.longitude
        html: '<a href="' + apartment.url + '" target="_blank">' + apartment.title + '</a>' + ' beds: ' + apartment.beds + 'price: ' + apartment.price
      }

      infoWindow = new google.maps.InfoWindow()

      marker.setMap map

      google.maps.event.addListener marker, 'click', ->
        infoWindow.setContent @html
        infoWindow.open map, this
