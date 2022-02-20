import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:muslimpro/models/specific_place.dart';
import 'package:muslimpro/screens/admin_screen.dart';
import 'package:muslimpro/screens/homescreen.dart';
import 'package:muslimpro/screens/mapscreen.dart';
import 'package:muslimpro/screens/login.dart';
import 'package:muslimpro/screens/registration.dart';
import 'package:muslimpro/screens/second_page.dart';
import 'package:muslimpro/services/notification_service.dart';
import 'package:muslimpro/services/preferences_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'blocs/application_bloc.dart';


/*void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
 _MyAppState()._getSelectedMosque(taskId);
}*/

const simplePeriodicTask = "simplePeriodicTask";
String? _fazrTime;
String? _zuhrTime;
String? _asrTime;
String? _maghribTime;
String? _ishaTime;
String? _jamaahTime;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simplePeriodicTask:
        print("$simplePeriodicTask was executed");
      _getSelectedMosque();
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        _getSelectedMosque();
        break;
    }

    return Future.value(true);
  });
}

void _getSelectedMosque() async {
  final _mosque = await PreferencesService().getMosque();

    if(_mosque.fajr != null && _mosque.zuhr != null && _mosque.asr != null && _mosque.maghrib != null && _mosque.isha != null && _mosque.jamaah != null ) {
      _fazrTime = _mosque.fajr;
      _zuhrTime = _mosque.zuhr;
      _asrTime = _mosque.asr;
      _maghribTime = _mosque.maghrib;
      _ishaTime = _mosque.isha;
      _jamaahTime = _mosque.jamaah;

  };
  _setSoundMode();
}

Future<void> _setSoundMode() async {
  if(_fazrTime != null && _asrTime != null && _maghribTime!= null && _ishaTime != null && _zuhrTime != null &&_jamaahTime != null) {
    final _currentTime = DateTime.now();
    final _currentDay = DateFormat('EEEE').format(_currentTime);
    if (_getSelectedTime(_currentTime, _fazrTime!, 0, 15) ||
        _getSelectedTime(_currentTime, _asrTime!, 0, 15) ||
        _getSelectedTime(_currentTime, _maghribTime!, 0, 15) ||
        _getSelectedTime(_currentTime, _ishaTime!, 0, 15)) {
      _setSilentMode();
    } else if (_getSelectedTime(_currentTime, _zuhrTime!, 0, 15) &&
        (_currentDay == "Saturday" ||
            _currentDay == "Sunday"||
            _currentDay=="Monday" ||
            _currentDay=="Tuesday" ||
            _currentDay=="Wednesday" ||
            _currentDay=="Thursday")) {
      _setSilentMode();
    } else if (_getSelectedTime(_currentTime, _jamaahTime!, 1, 0) &&
        _currentDay=="Friday") {
      _setSilentMode();
    } else {
      _setNormalMode();
    }
  }
  //BackgroundFetch.finish(taskId);
}


bool _getSelectedTime(DateTime now, String string, int hour, int minute){
  final _currentTime = DateTime.now();
  DateTime _date = DateFormat("hh:mm a").parse(string);
  final temp = new DateTime(_currentTime.year, _currentTime.month,
      _currentTime.day, _date.hour, _date.minute);
  //print(temp);
  if(now.isAfter(temp.subtract(Duration(seconds: 1))) && now.isBefore(temp.add(Duration(hours: hour,minutes: minute)))){
    return true;
  }
  return false;
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

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  final locationName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(locationName));
  SharedPreferences _pref = await SharedPreferences.getInstance();
  var _email = _pref.getString('email');
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  Workmanager().registerPeriodicTask(
    "1",
    simplePeriodicTask,
  );
  runApp(MyApp(email: _email));
  //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatefulWidget {
  final String? email;
  const MyApp({Key? key, required this.email}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String? _fazrTime;
  String? _zuhrTime;
  String? _asrTime;
  String? _maghribTime;
  String? _ishaTime;
  String? _jamaahTime;


  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    try {
      var status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        forceAlarmManager: true,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        //requiredNetworkType: NetworkType.NONE,
      ),_getSelectedMosque, _onBackgroundFetchTimeout);
      print('[BackgroundFetch] configure success: $status');
    } on Exception catch(e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

  void _getSelectedMosque() async {
    final _mosque = await PreferencesService().getMosque();

    setState(() {
      if(_mosque.fajr != null && _mosque.zuhr != null && _mosque.asr != null && _mosque.maghrib != null && _mosque.isha != null && _mosque.jamaah != null ) {
        _fazrTime = _mosque.fajr;
        _zuhrTime = _mosque.zuhr;
        _asrTime = _mosque.asr;
        _maghribTime = _mosque.maghrib;
        _ishaTime = _mosque.isha;
        _jamaahTime = _mosque.jamaah;
      }
    });
    _setSoundMode();
  }

  Future<void> _setSoundMode() async {
    if(_fazrTime != null && _asrTime != null && _maghribTime!= null && _ishaTime != null && _zuhrTime != null &&_jamaahTime != null) {
      final _currentTime = DateTime.now();
      final _currentDay = DateFormat('EEEE').format(_currentTime);
      if (_getSelectedTime(_currentTime, _fazrTime!, 0, 15) ||
          _getSelectedTime(_currentTime, _asrTime!, 0, 15) ||
          _getSelectedTime(_currentTime, _maghribTime!, 0, 15) ||
          _getSelectedTime(_currentTime, _ishaTime!, 0, 15)) {
        _setSilentMode();
      } else if (_getSelectedTime(_currentTime, _zuhrTime!, 0, 15) &&
          (_currentDay == "Saturday" ||
              _currentDay == "Sunday"||
              _currentDay=="Monday" ||
              _currentDay=="Tuesday" ||
              _currentDay=="Wednesday" ||
              _currentDay=="Thursday")) {
        _setSilentMode();
      } else if (_getSelectedTime(_currentTime, _jamaahTime!, 1, 0) &&
          _currentDay=="Friday") {
        _setSilentMode();
      } else {
        _setNormalMode();
      }
    }
    //BackgroundFetch.finish(taskId);
  }

  bool _getSelectedTime(DateTime now, String string, int hour, int minute){
    final _currentTime = DateTime.now();
    DateTime _date = DateFormat("hh:mm a").parse(string);
    final temp = new DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _date.hour, _date.minute);
    //print(temp);
    if(now.isAfter(temp.subtract(Duration(seconds: 1))) && now.isBefore(temp.add(Duration(hours: hour,minutes: minute)))){
      return true;
    }
    return false;
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        title: "JAMA'AH Time",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: widget.email == null? LoginScreen() :MapScreen(),
      ),
    );
  }
}


