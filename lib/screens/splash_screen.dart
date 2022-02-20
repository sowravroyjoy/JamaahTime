import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_screen.dart';
import 'mapscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserModel _userModel = UserModel();
  String? role;
  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _userModel = UserModel.fromMap(value.data());
      });
    });
    setState(() {
      role == _userModel.role;
    });
    if (role == "user") {
      Timer(Duration(milliseconds: 500), (){
        Fluttertoast.showToast(msg: "Login Successful!!");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MapScreen()));
      });

    }
    else if (role == "admin") {
      Timer(Duration(milliseconds: 500), (){
        Fluttertoast.showToast(msg: "Welcome Back Admin!!");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminScreen()));
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(
        semanticsLabel: "Processing",
      )
      ),
    );
  }
}
