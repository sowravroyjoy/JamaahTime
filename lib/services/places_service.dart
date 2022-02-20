import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:muslimpro/models/place.dart';
import 'package:muslimpro/models/specific_place.dart';

class PlacesService{

  final key = "AIzaSyDobSSTVft6tC_5pSp8DoaiLJh6s8W5X28";

 /* Future<List<Place>> getAutocomplete(String search) async{
    var url1 = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key');
    //var url1 = Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {'input': '{$search}', 'types': '{(cities)}', 'key': '{$key}'});

    var response  = await http.get(url1);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;

    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

  Future<SpecificPlace> getSpecificPlace(String placeId) async{
    var url2 =Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId');
    //var url2 = Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {'key': '{$key}', 'place_id': '{$placeId}'});

    var response  = await http.get(url2);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String,dynamic>;
    return SpecificPlace.fromJson(jsonResult);
  }*/

  Future<List<SpecificPlace>> getPlaces(double lat, double lng) async{
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?type=mosque&location=$lat,$lng&rankby=distance&key=$key');
    //var url3 = Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?type=mosque&location=25.0666548,-91.40723919999999&rankby=distance&key=AIzaSyDobSSTVft6tC_5pSp8DoaiLJh6s8W5X28');
    //var url3 =  Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', { 'location': '{$lat,$lng}','rankby': '{distance}','type': '{$placeType}', 'keyword': '{mosque}', 'key': '{$key}' });

    var response  = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => SpecificPlace.fromJson(place)).toList();
  }
}