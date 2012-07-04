$(document).ready(function() {
  var mapOptions = {
    center: new google.maps.LatLng(29.9728, -90.0590),
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"),
      mapOptions);

  $.getJSON("/apartments", function(data) {
    for( var i = 0; i < data.length; i++) {
      var apartment = data[i];

      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(apartment.latitude, apartment.longitude),
        title: apartment.title
      });

      marker.setMap(map);
    }
  });
});
