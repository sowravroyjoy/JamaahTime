class MosqueModel{
  String? userID;
  String? name;
  String? city;
  String? country;
  String? fajr;
  String? zuhr;
  String? asr;
  String? maghrib;
  String? isha;
  String? jamaah;
  bool? selected;
  String? docID;
  String? lat;
  String? lng;
  String? owner;


  MosqueModel({this.userID, this.name, this.city, this.country, this.fajr,
      this.zuhr, this.asr, this.maghrib, this.isha, this.jamaah, this.selected, this.docID, this.lat, this.lng, this.owner});

  factory MosqueModel.fromMap(map){
    return MosqueModel(
      userID: map['uid'],
      name: map['name'],
      city: map['city'],
      country: map['country'],
      fajr: map['fajr'],
      zuhr: map['zuhr'],
      asr: map['asr'],
      maghrib: map['maghrib'],
      isha: map['isha'],
      jamaah: map['jamaah'],
      selected: map['selected'],
        docID: map['docId'],
      lat: map['lat'],
      lng: map['lng'],
      owner: map['owner'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid' : userID,
      'name' : name,
      'city' : city,
      'country' : country,
      'fajr' : fajr,
      'zuhr' : zuhr,
      'asr' : asr,
      'maghrib' :maghrib,
      'isha' : isha,
      'jamaah' : jamaah,
      'selected' : selected,
      'docId' : docID,
      'lat' : lat,
      'lng' : lng,
      'owner' : owner,
    };
  }

}