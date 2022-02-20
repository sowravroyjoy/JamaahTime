import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:muslimpro/screens/login.dart';
import 'package:muslimpro/screens/second_page.dart';
import 'package:muslimpro/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel _userModel = UserModel();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
    this._userModel = UserModel.fromMap(value.data());
        setState(() {});
    });



    NotificationService.init(initScheduled: true);
    listenNotifications();


    _demo();


    final _currentDay = DateFormat('EEEE').format(DateTime.now());
    print(_currentDay);


    //print(Time(int.parse(_fazrTime.split(":").first),int.parse(_fazrTime.split(":").last.split(" ").first)).toString());

    NotificationService.showNotification(
      id: 0,
      title: "sarah Abs",
      body: 'This is a demo notification',
      payload: 'sarah.abs',
      time: Time(12,38),
      days: [DateTime.tuesday]
    );

    NotificationService.showNotification(
      id: 1,
        title: "sarah Abs",
        body: 'This is a demo notification',
        payload: 'sarah.abs',
        time: Time(12,39),
        days: [DateTime.tuesday]
    );



  }

  void _demo() {
    DateTime _time;
    DateTime _temp;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _time = DateTime.now();
      print(_time);
      _temp = DateTime(_time.year, _time.month, _time.day, 13, 20);
      print(_temp);
      if((_time.isAfter(_temp)) && (_time.isBefore(_temp.add(Duration(minutes: 1))))){
        _setSilentMode();
      }else {
        _setNormalMode();
      }
    });
}
  Future<void> _setNormalMode() async {

    try {
      await SoundMode.setSoundMode(RingerModeStatus.normal);

    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  Future<void> _setSilentMode() async {

    try {
      await SoundMode.setSoundMode(RingerModeStatus.silent);

    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }


  void listenNotifications() => NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => SecondPage(payload: payload),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Welcome ${_userModel.firstName}"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text(
                    'My Entries',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10,),
                  Divider(thickness: 2,),
                  SizedBox(height: 10,),
                  Container(
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              NotificationService.showNotification(
                                title: "sarah Abs",
                                body: 'This is a demo notification',
                                payload: 'sarah.abs', time: Time(23, 35), days: [DateTime.saturday],
                                //scheduledDate: DateTime.now().add(Duration(seconds: 5)),
                              );
                            },
                            child: Text('Notifications'),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              logout(context);
                            },
                            child: Text('logout')
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove('email');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
