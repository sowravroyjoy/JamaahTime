import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:muslimpro/screens/login.dart';
import 'package:muslimpro/screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mapscreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  bool? _process;
  int? _count;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
  }

  @override
  Widget build(BuildContext context) {

    final firstNameField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          RegExp regex = new RegExp(r'^.{3,}$');
          if(value!.isEmpty){
            return ("First Name cannot be empty!!");
          }
          if(!regex.hasMatch(value)){
            return ("Please enter valid name(min. 3 characters)!!");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffix: Icon(
            Icons.badge,
            color: Colors.green.shade400,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'First Name',
          labelStyle: TextStyle(
              color: Colors.green.shade400
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
        ));
    final secondNameField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("Second Name cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffix: Icon(
            Icons.badge,
            color: Colors.green.shade400,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Second Name',
          labelStyle: TextStyle(
              color: Colors.green.shade400
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
        ));

    final emailField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value){
          if(value!.isEmpty){
            return ("Please enter your email!!");
          }
          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
            return ("Please enter a valid email!!");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
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
          labelStyle: TextStyle(
              color: Colors.green.shade400
          ),
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
        controller: passwordEditingController,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if(value!.isEmpty){
            return ("Password is required");
          }
          if(!regex.hasMatch(value)){
            return ("Please enter valid password(min. 6 characters)!!");
          }
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
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
          labelStyle: TextStyle(
              color: Colors.green.shade400
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
        ));

    final confirmPasswordField = TextFormField(
        cursorColor: Colors.green.shade400,
        obscureText: true,
        autofocus: false,
        controller: confirmPasswordEditingController,
        validator: (value){
         if(confirmPasswordEditingController.text != passwordEditingController.text){
           return ("Password don't match");
         }
         return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
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
          labelText: 'Confirm Password',
          labelStyle: TextStyle(
              color: Colors.green.shade400
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
        ));

    final registerButton = Material(
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
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0) ? Fluttertoast.showToast(msg: "Wait Please!!") :
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child:(_process!)? Row(
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
            :  Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
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
                  children:<Widget> [
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/logo_two.png', fit: BoxFit.fill, ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: firstNameField,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: secondNameField,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: emailField,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: passwordField,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: confirmPasswordField,
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: registerButton,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                              color: Colors.grey
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.green.shade400

                            ),
                          ),

                        )

                      ],
                    ),
                    SizedBox(height: 80,),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  void signUp(String email, String password)async{
    try {
      if (_formKey.currentState!.validate()) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password)
            .then((value) =>
        {
          postDetailsToFirestore()
        });
      }
    }catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      print(err.toString());
    }
    }


  postDetailsToFirestore() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.userID = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    userModel.role = "user";

    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
      if(!user.emailVerified){
        await user.sendEmailVerification();
        setState(() {
          _process = false;
        });
        Fluttertoast.showToast(msg: "Verification email sent!!");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }else{
        setState(() {
          _process = false;
        });
        Fluttertoast.showToast(msg: "Verified account created successfully!!");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MapScreen()));
      }

  }
}
