import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslimpro/blocs/application_bloc.dart';
import 'package:muslimpro/main.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:muslimpro/models/place.dart';
import 'package:muslimpro/models/specific_place.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:muslimpro/screens/adding_mosque.dart';
import 'package:muslimpro/screens/second_page.dart';
import 'package:muslimpro/screens/view_mosque_details.dart';
import 'package:muslimpro/services/notification_service.dart';
import 'package:muslimpro/services/preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:restart_app/restart_app.dart';

import 'login.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  bool _selection = false;
  String? _selectedMosqueName;
  String? _fazrTime;
  String? _zuhrTime;
  String? _asrTime;
  String? _maghribTime;
  String? _ishaTime;
  String? _jamaahTime;
  List<int> _namazDays = [
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday
  ];
  List<int> _zuhrDays = [
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday
  ];
  List<int> _jamaahDay = [DateTime.friday];

  final TextEditingController searchController = TextEditingController();
  bool isExecuted = false;
  List _allResults = [];
  List _results = [];
  List _nearbyMosques = [];
  Future? resultLoaded;

  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  String? _permissionStatus;
  Timer? _timer;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel _userModel = UserModel();
  MosqueModel _mosqueModel = MosqueModel();

  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription? locationSubscription;
  StreamSubscription? boundsSubscription;


  @override
  void initState() {
    super.initState();
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    boundsSubscription = applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    });

    _getPermissionStatus();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      this._userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
    searchController.addListener(_onSearchChanged);



    NotificationService.init(initScheduled: true);
    listenNotifications();

    _getSelectedMosque();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = getData();
  }




  void _setSoundMode() {
    DateTime _currentTime ;
    if(_fazrTime != null && _asrTime != null && _maghribTime!= null && _ishaTime != null && _zuhrTime != null &&_jamaahTime != null) {
        _currentTime = DateTime.now();
        final _currentDay = DateFormat('EEEE').format(_currentTime);
        if (_getSelectedTime(_currentTime, _fazrTime!, 0, 15) ||
            _getSelectedTime(_currentTime, _asrTime!, 0, 15) ||
            _getSelectedTime(_currentTime, _maghribTime!, 0, 15) ||
            _getSelectedTime(_currentTime, _ishaTime!, 0, 15)) {
          _setSilentMode();
          //_setSound(Duration(seconds: 900));
        } else if (_getSelectedTime(_currentTime, _zuhrTime!, 0, 15) &&
            (_currentDay == "Saturday" ||
                _currentDay == "Sunday" ||
                _currentDay == "Monday" ||
                _currentDay == "Tuesday" ||
                _currentDay == "Wednesday" ||
                _currentDay == "Thursday")) {
          //_setSound(Duration(seconds: 900));
          _setSilentMode();
        } else if (_getSelectedTime(_currentTime, _jamaahTime!, 1, 0) &&
            _currentDay == "Friday") {
          //_setSound(Duration(seconds: 3600));
          _setSilentMode();
        } else {
          _setNormalMode();
        }
    }
  }

  bool _getSelectedTime(DateTime now, String string, int hour, int minute){
    final _currentTime = DateTime.now();
    DateTime _date = DateFormat("hh:mm a").parse(string);
    final temp = new DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _date.hour, _date.minute);
    if(now.isAfter(temp.subtract(Duration(seconds: 1))) && now.isBefore(temp.add(Duration(hours: hour,minutes: minute)))){
      return true;
    }
    return false;
  }

  Future<void> _getPermissionStatus() async {
    bool? permissionStatus = false;
    try {
      permissionStatus = await PermissionHandler.permissionsGranted;
      print(permissionStatus);
    } catch (err) {
      print(err);
    }

    setState(() {
      _permissionStatus =
          permissionStatus! ? "Permissions Enabled" : "Permissions not granted";
    });

    if (permissionStatus! == false) {
      _openDoNotDisturbSettings();
    }
  }

  Future<void> _openDoNotDisturbSettings() async {
    await PermissionHandler.openDoNotDisturbSetting();
  }

  void _setSound(Duration duration) {
    int countdown = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown = duration.inSeconds - 1;
        if (countdown == 0) {
          _timer!.cancel();
          _setNormalMode();
        } else {
          _setSilentMode();
        }
      });
    });
  }


  Future<void> _setSilentMode() async {

    try {
       await SoundMode.setSoundMode(RingerModeStatus.silent);

    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> _setNormalMode() async {

    try {
       await SoundMode.setSoundMode(RingerModeStatus.normal);

    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

void _selectNotification() async {
    if(_fazrTime != null && _asrTime != null && _maghribTime!= null && _ishaTime != null && _zuhrTime != null &&_jamaahTime != null){
       await _getNotifications(20,Time(_time(_fazrTime!,5)[0], _time(_fazrTime!,5)[1]), _namazDays, "FAZR Time", "Click Here","15 minutes");
       await _getNotifications(21,Time(_time(_zuhrTime!,5)[0], _time(_zuhrTime!,5)[1]), _zuhrDays, "ZUHR Time", "Click Here", "15 minutes");
       await _getNotifications(22,Time(_time(_asrTime!,5)[0], _time(_asrTime!,5)[1]), _namazDays, "ASR Time", "Click Here", "15 minutes");
        await _getNotifications(23,Time(_time(_maghribTime!,5)[0], _time(_maghribTime!,5)[1]), _namazDays, "MAGHRIB Time", "Click Here", "15 minutes");
        await _getNotifications(24,Time(_time(_ishaTime!,5)[0], _time(_ishaTime!,5)[1]), _namazDays, "ISHA Time", "Click Here", " 15 minutes");
        await _getNotifications(25,Time(_time(_jamaahTime!,5)[0], _time(_jamaahTime!,5)[1]), _jamaahDay, "JUMAAH Time", "Click Here", "1 hour");
    }

    _timer = Timer.periodic(Duration(minutes: 2), (timer) {
      _setSoundMode();
    });
}

  Future<void> _getNotifications(int id, Time time, List<int> days, String title, String body, String payload)async {
       await NotificationService.showNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
        time: time,
        days: days,
      );
  }

  List<int> _time(String string,int duration) {
    DateTime _date = DateFormat("hh:mm a").parse(string);
    //print(_date);
    //_date.subtract(const Duration(minutes: 5));
    String time = DateFormat.Hm().format(_date);
    //print(time);
    int hourPart = int.parse(time.split(":").first);
    int minutePart = int.parse(time.split(":").last);
    if(minutePart < duration){
      int tempMin = duration - minutePart;
     double tempHour = (( hourPart * 60 ) - tempMin) / 60 ;
     hourPart =  tempHour.floor();
     minutePart = ((tempHour - hourPart) * 60).floor();
    }else{
      minutePart = minutePart - duration;
    }
    return [hourPart, minutePart];
  }

  void _getSelectedMosque() async {
    final _mosque = await PreferencesService().getMosque();

    setState(() {
      if(_mosque.selected != null && _mosque.name != null ) {
        _selection = _mosque.selected!;
        _selectedMosqueName = _mosque.name;
        _fazrTime = _mosque.fajr;
        _zuhrTime = _mosque.zuhr;
        _asrTime = _mosque.asr;
        _maghribTime = _mosque.maghrib;
        _ishaTime = _mosque.isha;
        _jamaahTime = _mosque.jamaah;
      }
    });
    _selectNotification();
  }

  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) async{
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => SecondPage(payload: payload)),
    );
  }

  _onSearchChanged(){
    searchResult();
  }

  searchResult() async{
    var showResults = [];
    if(searchController.text != ""){
      for(var mosqueData  in _allResults){
        var name = await MosqueModel.fromMap(mosqueData.data()).name!.toLowerCase();
        if(name.contains(searchController.text.toLowerCase())){
          setState(() {
            showResults.add(mosqueData);
          });
        }
      }
    } else{
      showResults = List.from(_allResults);
    }
    setState(() {
      _results = showResults;
    });
  }

  getData() async{
    //final mosques =  await FirebaseFirestore.instance.collection('mosques').get();
    final mosques = await FirebaseFirestore.instance.collection('mosques').where('uid', isEqualTo: user!.uid).get();
    setState(() {
      _allResults = mosques.docs;
    });
    searchResult();
    return "complete";
  }

  @override
  void dispose() {
    final applicationBloc =
    Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    boundsSubscription!.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _timer!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);


      BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0));

    Widget searchField = TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        autofocus: false,
        controller: searchController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          searchController.text = value!;
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          suffix: Icon(
            Icons.search,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Search by mosque name',
          labelStyle: TextStyle(
              color: Colors.white
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),

        ));

    return Scaffold(
      appBar: AppBar(
        title: Text("JAMA'AH Time"),
        backgroundColor: Colors.green.shade400,
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        borderRadius: radius,
        color: Colors.green.shade400,
        minHeight: 80,
        panel: _getList(applicationBloc, searchField),
        body: (applicationBloc.currentLocation == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  applicationBloc.currentLocation!.latitude,
                                  applicationBloc.currentLocation!.longitude),
                              zoom: 14),
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: Set<Marker>.of(applicationBloc.markers),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildListTile(data) => InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ViewMosqueDetails(mosqueModel: new MosqueModel(
                name: data['name'],
                city: data['city'],
                country: data['country'],
                fajr: data['fajr'],
                zuhr: data['zuhr'],
                asr: data['asr'],
                maghrib: data['maghrib'],
                isha: data['isha'],
                jamaah: data['jamaah'],
                selected: _selection,
              ))));
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 23,
            child: Image.asset('assets/images/mosque.png'),
          ),
          title: Text(
            '${data['name']}',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Checkbox(
            activeColor: Colors.transparent,
            side: BorderSide(
              color: Colors.white
            ),
            onChanged: (bool? value) {
              setState(() {
                _selection = value!;
                final newMosque = MosqueModel(
                  userID: data['uid'],
                  name: data['name'],
                  city: data['city'],
                  country: data['country'],
                  fajr: data['fajr'],
                  zuhr: data['zuhr'],
                  asr: data['asr'],
                  maghrib: data['maghrib'],
                  isha: data['isha'],
                  jamaah: data['jamaah'],
                  selected: _selection,
                  docID: data['docId']
                );

                if (_selection) {
                  PreferencesService().saveMosque(newMosque);
                }

                _getSelectedMosque();

                Fluttertoast.showToast(msg: "${data['name']} selected and will update soon!!");
              });

             // _restart();

            },
            value: (_selectedMosqueName == data['name'])? _selection : false,
          ),
        ),
      );

  Widget _getList(ApplicationBloc applicationBloc, Widget searchField) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Mosques List',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: searchField,
            ),
            Expanded(
              child: ListView.separated(
                      itemBuilder: (context, index) {
                        if(index == 0){
                          return  (_nearbyMosques.isEmpty)? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No nearby mosque available!!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ): buildListTile(_nearbyMosques[index]);
                        }
                        return buildListTile(_results[index- 1]);
                      },
                      itemCount: _results.length + 1,
                      separatorBuilder: (BuildContext context, int index) =>
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 2,
                              color: Colors.white,
                            ),
                          )
                  ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                     // applicationBloc.togglePlaceType();
                      _getNearbyMosque();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text(
                      'Get Nearby Mosque',
                      style: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddingMosque()));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text(
                      'Add new',
                      style: TextStyle(color: Colors.black),
                    )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      logout(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove('email');
    PreferencesService().removeMosque();
    NotificationService.cancelAll();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> _getNearbyMosque() async {
    final applicationBloc = Provider.of<ApplicationBloc>(context,listen: false);
    SpecificPlace _place = await applicationBloc.togglePlaceType();
    String _name = _place.name.toString().toLowerCase();

    final _nearbyNameMosque = await FirebaseFirestore.instance.collection('mosques').where("owner",isEqualTo: "admin")
        .get();
    for(var nearbyMosqueData  in _nearbyNameMosque.docs){
      var nearbyName = await MosqueModel.fromMap(nearbyMosqueData).name!.toLowerCase();
      if(nearbyName.contains(_name)){
        setState(() {
          _nearbyMosques.add(nearbyMosqueData);
        });
      }
    }
  }
}
