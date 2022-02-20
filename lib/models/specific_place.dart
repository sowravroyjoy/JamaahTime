import 'package:muslimpro/models/geometry.dart';

class SpecificPlace{
  final Geometry geometry;
  final String name;


  SpecificPlace({required this.geometry, required this.name,});

  factory SpecificPlace.fromJson(Map<String,dynamic> parsedJson){
    return SpecificPlace(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['name'],

    );
  }
}