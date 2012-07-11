apartments = []
markers = []
map = null
$ ->
  mapOptions = {
    center: ( new google.maps.LatLng 29.9728, -90.05902 ),
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  map = new google.maps.Map ( $ '#map_canvas' )[0], mapOptions

  $.getJSON '/apartments', (data) ->
    apartments = ( new Apartment a for a in data )
    mapApartments(apartments)

  ($ 'button#filter').click ->
    min_price = ($ '#min-price-input').val()
    max_price = ($ '#max-price-input').val()
    min_beds = ($ '#min-beds-input').val()
    max_beds = ($ '#max-beds-input').val()
    mapApartments ( findApartments min_price, max_price, min_beds, max_beds )

mapApartments = (apartments) ->
  clearMarkers()
  for apartment in apartments
    marker = new google.maps.Marker {
      position: new google.maps.LatLng apartment.latitude, apartment.longitude
      html: '<a href="' + apartment.url + '" target="_blank">' + apartment.title + '</a>' + ' beds: ' + apartment.beds + 'price: ' + apartment.price
    }

    markers.push marker

    infoWindow = new google.maps.InfoWindow()

    marker.setMap map

    google.maps.event.addListener marker, 'click', ->
      infoWindow.setContent @html
      infoWindow.open map, this

clearMarkers = ->
  for marker in markers
    marker.setMap null
  markers = []

findApartments = (min_price, max_price, min_beds, max_beds) ->
  matchingApartment = (a) ->
    result = true

    result = result && a.price >= min_price if min_price
    result = result && a.price <= max_price if max_price
    result = result && a.beds >= min_beds if min_beds
    result = result && a.beds <= max_beds if max_beds

    result

  ( a for a in apartments when matchingApartment a )
