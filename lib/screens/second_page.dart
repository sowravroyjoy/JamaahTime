import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslimpro/main.dart';
import 'package:muslimpro/screens/login.dart';
import 'package:muslimpro/screens/mapscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondPage extends StatefulWidget {
  final String? payload;

  const SecondPage({Key? key, required this.payload}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  Timer? _timer;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async{
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(_countdown == 0){
        _timer!.cancel();
       Navigator.pop(context);
      }else{
        setState(() {
          _countdown = _countdown - 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
                children: [
                  SizedBox(height: 70,),
                  Text(
                      (widget.payload != null)? "Your phone will be silent soon for ${widget.payload}" : "Something wrong !!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  SizedBox(height: 10,),
                   Text(
                       "You will be redirected to the home screen in ${_countdown} seconds..." ,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }
}
