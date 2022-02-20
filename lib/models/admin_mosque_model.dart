class AdminMosqueModel{
  String? name;
  String? city;
  String? country;
  String? fajr;
  String? zuhr;
  String? asr;
  String? maghrib;
  String? isha;
  String? jamaah;
  String? lat;
  String? lng;
  String? owner;


 AdminMosqueModel({ this.name, this.city, this.country, this.fajr,
    this.zuhr, this.asr, this.maghrib, this.isha, this.jamaah, this.lat, this.lng, this.owner});

  factory AdminMosqueModel.fromMap(map){
    return AdminMosqueModel(
        name: map['name'],
        city: map['city'],
        country: map['country'],
        fajr: map['fajr'],
        zuhr: map['zuhr'],
        asr: map['asr'],
        maghrib: map['maghrib'],
        isha: map['isha'],
        jamaah: map['jamaah'],
        lat: map['lat'],
      lng: map['lng'],
      owner: map['owner'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'city' : city,
      'country' : country,
      'fajr' : fajr,
      'zuhr' : zuhr,
      'asr' : asr,
      'maghrib' :maghrib,
      'isha' : isha,
      'jamaah' : jamaah,
     'lat' : lat,
      'lng' : lng,
      'owner' : owner,
    };
  }

}