var map,
    label = 1,
    markers = [],
    voronoi = [];
    
var draw_marker = function(latLng) {
  
  var marker = new google.maps.Marker({
    draggable: true,
    position: latLng,
    map: map,
    label: label.toString()
  });
  
  markers.push(marker);
  
  marker.addListener('dblclick', function(e) {
    var marker_id = marker.getLabel();
    marker.setMap(null);
    
    markers.splice(parseInt(marker_id), 1);
    
    Shiny.onInputChange('remove_point', {
      label: marker_id
    });
  });
  
  marker.addListener('dragend', function(e) {
    var marker_id = marker.getLabel();
    
    Shiny.onInputChange('update_point', {
      label : marker_id,
      lat   : e.latLng.lat(),
      lng   : e.latLng.lng()
    });
  });
}    

$(document).ready( function() {
  
  Shiny.addCustomMessageHandler('draw_voronoi', function(message) {
    
    var points = message.points;
    
    voronoi.map( function(shape) {
      shape.setMap(null);
    })
    
    voronoi = new Array(points.x1.length);
    
    for (i = 0; i < points.x1.length; i++) {
      
      var latLng_1 = new google.maps.LatLng(points.y1[i], points.x1[i]);
      var latLng_2 = new google.maps.LatLng(points.y2[i], points.x2[i]);
    
      voronoi[i] = new google.maps.Polyline({
        map: map,
        path: [latLng_1, latLng_2],
        geodesic: message.geodesic
      });
      
    }
    
  });
  
  Shiny.addCustomMessageHandler('clear_all', function(message) {
    
    markers.map( function(marker) { 
      marker.setMap(null);
    });
    
    markers = [];
    
    voronoi.map( function(shape) {
      shape.setMap(null);
    })
    
    voronoi = [];
  });
  
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 38, lng: -90},
    zoom: 6
  });
  
  map.addListener('click', function(e) {
    draw_marker(e.latLng);
    
    Shiny.onInputChange('add_point', {
      lat: e.latLng.lat(),
      lng: e.latLng.lng(),
      label: label
    });
    
    label++;
  });
});
