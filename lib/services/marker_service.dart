import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslimpro/models/specific_place.dart';

class MarkerService{

  LatLngBounds? bounds(Set<Marker> markers){
    if(markers == null || markers.isEmpty) return null;
    return createBounds(markers.map((m) => m.position).toList());
  }

  LatLngBounds? createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element);
    final southwestLog = positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element);
    final northeastLog = positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);

    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLog),
        northeast: LatLng(northeastLat, northeastLog)
    );
  }

  Marker createMarkerFromPlace(SpecificPlace place, bool center){
    var markerId = place.name;
    if(center) markerId = 'center';

    return Marker(
      markerId: MarkerId(markerId),
      draggable: false,
      //visible: (center) ? false : true,
      infoWindow: InfoWindow(
        title: place.name,
      ),
      position: LatLng(
        place.geometry.location.lat,
        place.geometry.location.lng
      )
    );
  }


}