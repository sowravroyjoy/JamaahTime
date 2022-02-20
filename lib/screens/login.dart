import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:muslimpro/screens/homescreen.dart';
import 'package:muslimpro/screens/mapscreen.dart';
import 'package:muslimpro/screens/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  UserModel _userModel = UserModel();
  bool? _process;
  int? _count;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
  }
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please enter your email!!");
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please enter a valid email!!");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffix: Icon(
            Icons.mail,
            color: Colors.green.shade400,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(color: Colors.green.shade400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
        ));

    final passwordField = TextFormField(
        cursorColor: Colors.green.shade400,
        obscureText: true,
        autofocus: false,
        controller: passwordController,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid password(min. 6 characters)!!");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffix: Icon(
            Icons.lock,
            color: Colors.green.shade400,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.green.shade400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
        ));

    final loginButton = Material(
      elevation: (_process!)? 0 : 5,
      color: (_process!)? Colors.green.shade600 :Colors.green.shade400,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          20,
          15,
          20,
          15,
        ),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        onPressed: () {
            setState(() {
              _process = true;
              _count = (_count! - 1);
            });
            (_count! < 0) ? Fluttertoast.showToast(msg: "Wait Please!!") :
            signIn(emailController.text, passwordController.text);
        },
        child:  (_process!)? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Processing',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            SizedBox(width: 20,),
            Center(child: SizedBox(height:15, width: 15,child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))),
          ],
        )
      : Text(
      'Login',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
      )
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Image.asset(
                      'assets/images/logo_two.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: emailField,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: passwordField,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: loginButton,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.green.shade400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
        {
          _checkAdmin(email)
        });
      }
    }
    catch (err) {
      setState(() {
        _process = false;
        _count = 1;
      });
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  Future<void> _checkAdmin(String email) async {
    Future.delayed(const Duration(seconds: 1), () async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _userModel = UserModel.fromMap(value.data());
      });
    });
    if (_userModel.role == "user") {
      if(!_auth.currentUser!.emailVerified){
        await _auth.currentUser!.sendEmailVerification();
        setState(() {
          _process = false;
          _count = 1;
        });
        Fluttertoast.showToast(msg: "Verification email sent!!");
      }else{
        _pref.setString('email', email);
        setState(() {
          _process = false;
          _count = 1;
        });
        Fluttertoast.showToast(msg: "Login Successful!!");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MapScreen()));
      }
    }
    else if (_userModel.role == "admin") {
      setState(() {
        _process = false;
        _count = 1;
      });
      Fluttertoast.showToast(msg: "Welcome Back Admin!!");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AdminScreen()));
    }
  });
  }
}

