import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslimpro/models/geometry.dart';
import 'package:muslimpro/models/location.dart';
import 'package:muslimpro/models/place.dart';
import 'package:muslimpro/models/specific_place.dart';
import 'package:muslimpro/services/geolocator_service.dart';
import 'package:muslimpro/services/marker_service.dart';
import 'package:muslimpro/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  Position? currentLocation;
//  List<Place>? searchResults;
  //StreamController<SpecificPlace> selectedLocation = StreamController<SpecificPlace>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>.broadcast();
  SpecificPlace? selectLocationStatic;
  List<Marker> markers = <Marker>[];

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectLocationStatic = SpecificPlace(
        geometry: Geometry(
            location: Location(
                lat: currentLocation!.latitude,
                lng: currentLocation!.longitude)),
        name: 'me',
    );


    notifyListeners();
  }

  /*searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    //var sLocation = await placesService.getSpecificPlace(placeId);
    var sLocation = await placesService.getSpecificPlace(placeId);
    selectedLocation.add(sLocation);
    selectLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }*/


 Future<SpecificPlace> togglePlaceType() async {

      var places = await placesService.getPlaces(selectLocationStatic!.geometry.location.lat, selectLocationStatic!.geometry.location.lng);

      markers = [];

      if(places.isNotEmpty){
        var newMarker = markerService.createMarkerFromPlace(places[0],false);
        markers.add(newMarker);
      }

      var locationMarker = markerService.createMarkerFromPlace(selectLocationStatic!, true);
      markers.add(locationMarker);

      var _bounds = markerService.bounds(Set<Marker>.of(markers));

      bounds.add(_bounds!);

    notifyListeners();

    return places[0];
  }

  @override
  void dispose() {
    //selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
