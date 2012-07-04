$(document).ready(function() {
  var mapOptions = {
    center: new google.maps.LatLng(29.9728, -90.0590),
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"),
      mapOptions);
});
