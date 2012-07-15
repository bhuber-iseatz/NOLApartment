apartments = []
markers = []
map = null
apartment_template = null
MIN_PRICE = 0
MAX_PRICE = 3000
MIN_BEDS = 0
MAX_BEDS = 10

$ ->
  setPrices MIN_PRICE, MAX_PRICE
  setBeds MIN_BEDS, MAX_BEDS

  # grab the handlebar template
  apartment_template = Handlebars.compile ($ '#apartment-template').html()

  ($ '#price-slider').slider
    range: true
    min: MIN_PRICE
    max: MAX_PRICE
    step: 50
    values: [+($ '#min-price-input').val(), +($ '#max-price-input').val()]
    slide: (event, ui) ->
      setPrices ui.values[0], ui.values[1]

  ($ '#beds-slider').slider
    range: true
    min: MIN_BEDS
    max: MAX_BEDS
    step: 1
    values: [+($ '#min-beds-input').val(), +($ '#max-beds-input').val()]
    slide: (event, ui) ->
      setBeds ui.values[0], ui.values[1]

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
      html: apartment_template apartment
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

    result = result && a.price >= +min_price if min_price && +min_price > MIN_PRICE
    result = result && a.price <= +max_price if max_price && +max_price < MAX_PRICE
    result = result && a.beds >= +min_beds if min_beds && +min_beds > MIN_BEDS
    result = result && a.beds <= +max_beds if max_beds && +max_beds < MAX_BEDS

    result

  ( a for a in apartments when matchingApartment a )

setPrices = (min_price, max_price) ->
  ($ '#min-price-input').val min_price
  ($ '#max-price-input').val max_price

  max_price += '+' if max_price >= MAX_PRICE
  ($ '#price-range').html '$' + min_price + ' - ' + '$' + max_price

setBeds = (min_beds, max_beds) ->
  ($ '#min-beds-input').val min_beds
  ($ '#max-beds-input').val max_beds

  max_beds += '+' if max_beds >= MAX_BEDS
  ($ '#beds-range').html min_beds + ' - ' + max_beds

