import 'package:flutter/material.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveMosque(MosqueModel model) async {
    final preferences = await SharedPreferences.getInstance();
    bool? _selected = model.selected;

    await preferences.setString('name', model.name.toString());
    await preferences.setString('city', model.city.toString());
    await preferences.setString('country', model.country.toString());
    await preferences.setString('fajr', model.fajr.toString());
    await preferences.setString('zuhr', model.zuhr.toString());
    await preferences.setString('asr', model.asr.toString());
    await preferences.setString('maghrib', model.maghrib.toString());
    await preferences.setString('isha', model.isha.toString());
    await preferences.setString('jamaah', model.jamaah.toString());
    await preferences.setBool('selected', _selected!);

    print("new mosque added");
  }

  Future<MosqueModel> getMosque() async {
    final preferences = await SharedPreferences.getInstance();

    final name = preferences.getString('name');
    final city = preferences.getString('city');
    final country = preferences.getString('country');
    final fajr = preferences.getString('fajr');
    final zuhr = preferences.getString('zuhr');
    final asr = preferences.getString('asr');
    final maghrib = preferences.getString('maghrib');
    final isha = preferences.getString('isha');
    final jamaah = preferences.getString('jamaah');
    final selected = preferences.getBool('selected');

    return MosqueModel(
        name: name,
        city: city,
        country: country,
        fajr: fajr,
        zuhr: zuhr,
        asr: asr,
        maghrib: maghrib,
        isha: isha,
        jamaah: jamaah,
        selected: selected);
  }

  Future<void> removeMosque() async {
    final preferences = await SharedPreferences.getInstance();

     preferences.remove('name');
     preferences.remove('city');
    preferences.remove('country');
   preferences.remove('fajr');
     preferences.remove('zuhr');
     preferences.remove('asr');
  preferences.remove('maghrib');
    preferences.remove('isha');
    preferences.remove('jamaah');
    preferences.remove('selected');

    print("mosque removed");
  }
}
