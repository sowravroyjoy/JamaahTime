import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:muslimpro/screens/login.dart';
import 'package:muslimpro/screens/homescreen.dart';

import 'mapscreen.dart';

class AddingMosque extends StatefulWidget {
  const AddingMosque({Key? key}) : super(key: key);

  @override
  _AddingMosqueState createState() => _AddingMosqueState();
}

class _AddingMosqueState extends State<AddingMosque> {
  bool? _process;
  int? _count;
   TimeOfDay? _fajr;
   TimeOfDay? _zuhr;
  TimeOfDay? _asr;
  TimeOfDay? _maghrib;
  TimeOfDay? _isha;
  TimeOfDay? _jamaah;

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final nameEditingController = new TextEditingController();
  final cityEditingController = new TextEditingController();
  final countryEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
  }
  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("Name cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Name',
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
    final cityField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: cityEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("City cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          cityEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'City',
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

    final countryField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: countryEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("Country cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          countryEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Country',
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

    final pickFAJR = Container(
      child: Row(
        children: [
          SizedBox(width: 50,),
          Text(
            'FAJR   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade400,
            ),
          ),
      SizedBox(width: 50,),
      Material(
        elevation: 5,
        color: Colors.green.shade400,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          minWidth: MediaQuery.of(context).size.width/2,
          onPressed: (){
            showTimePicker(
              context: context,
              initialTime: _fajr ?? TimeOfDay.now(),
            ).then((value) {
              setState(() {
                _fajr = value!;
              });
            });
          },
          child: Text(
            (_fajr ==null) ? 'Pick Time' : _fajr!.format(context).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      )
        ],
      ),
    );

    final pickZUHR = Container(
      child: Row(
        children: [
          SizedBox(width: 50,),
          Text(
            'ZUHR   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade400,
            ),
          ),
          SizedBox(width: 48,),
          Material(
            elevation: 5,
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width/2,
              onPressed: (){
                showTimePicker(
                  context: context,
                  initialTime: _zuhr ?? TimeOfDay.now(),
                ).then((value) {
                  setState(() {
                    _zuhr = value!;
                  });
                });
              },
              child: Text(
                  (_zuhr ==null) ? 'Pick Time' : _zuhr!.format(context).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );

    final pickASR = Container(
      child: Row(
        children: [
          SizedBox(width: 50,),
          Text(
            'ASR   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade400,
            ),
          ),
          SizedBox(width: 58,),
          Material(
            elevation: 5,
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width/2,
              onPressed: (){
                showTimePicker(
                  context: context,
                  initialTime: _asr ?? TimeOfDay.now(),
                ).then((value) {
                  setState(() {
                    _asr = value!;
                  });
                });
              },
              child: Text(
                  (_asr ==null) ? 'Pick Time' : _asr!.format(context).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );

    final pickMAGHRIB = Container(
      child: Row(
        children: [
          SizedBox(width: 50,),
          Text(
            'MAGHRIB   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade400,
            ),
          ),
          SizedBox(width: 22,),
          Material(
            elevation: 5,
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width/2,
              onPressed: (){
                showTimePicker(
                  context: context,
                  initialTime: _maghrib ?? TimeOfDay.now(),
                ).then((value) {
                  setState(() {
                    _maghrib = value!;
                  });
                });
              },
              child: Text(
                (_maghrib ==null) ? 'Pick Time' : _maghrib!.format(context).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );


    final pickISHA = Container(
      child: Row(
        children: [
          SizedBox(width: 50,),
          Text(
            'ISHA   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade400,
            ),
          ),
          SizedBox(width: 53,),
          Material(
            elevation: 5,
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width/2,
              onPressed: (){
                showTimePicker(
                  context: context,
                  initialTime: _isha ?? TimeOfDay.now(),
                ).then((value) {
                  setState(() {
                    _isha = value!;
                  });
                });
              },
              child: Text(
                (_isha ==null) ? 'Pick Time' : _isha!.format(context).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );


    final pickJAMAAH = Container(
      child: Row(
        children: [
          SizedBox(width: 50,),
          Text(
            'JUMAAH   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade400,
            ),
          ),
          SizedBox(width: 25,),
          Material(
            elevation: 5,
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width/2,
              onPressed: (){
                showTimePicker(
                  context: context,
                  initialTime: _jamaah ?? TimeOfDay.now(),
                ).then((value) {
                  setState(() {
                    _jamaah = value!;
                  });
                });
              },
              child: Text(
                (_jamaah ==null) ? 'Pick Time' : _jamaah!.format(context).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );

    final addButton = Material(
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
          (_count! < 0) ? Fluttertoast.showToast(msg: "Wait Please!!") : postDetailsToFirestore();
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
            : Text(
          'Add Mosque',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        elevation: 0,
        title: Text('Add New Mosque'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      //backgroundColor: Colors.green,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget> [
                    SizedBox(
                      height: 20,
                    ),
                    nameField,
                    SizedBox(
                      height: 10,
                    ),
                    cityField,
                    SizedBox(
                      height: 10,
                    ),
                    countryField,
                    SizedBox(height: 20,),
                    pickFAJR,
                    SizedBox(height: 20,),
                    pickZUHR,
                    SizedBox(height: 20,),
                    pickASR,
                    SizedBox(height: 20,),
                    pickMAGHRIB,
                    SizedBox(height: 20,),
                    pickISHA,
                    SizedBox(height: 20,),
                    pickJAMAAH,
                    SizedBox(height: 20,),
                    addButton,
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),);
  }

  postDetailsToFirestore() async{
    final ref = FirebaseFirestore.instance.collection("mosques").doc();
    User? user = _auth.currentUser;

    try{
      if(user!.uid != null && nameEditingController.text != null && cityEditingController.text != null && countryEditingController.text != null && _fajr!.format(context).toString() != null && _zuhr!.format(context).toString() != null && _asr!.format(context).toString() != null && _maghrib!.format(context).toString() != null && _isha!.format(context).toString() != null && _jamaah!.format(context).toString() != null){
        MosqueModel model = MosqueModel();
        model.userID = user.uid;
        model.name = nameEditingController.text;
        model.city = cityEditingController.text;
        model.country = countryEditingController.text;
        model.fajr = _fajr!.format(context).toString();
        model.zuhr = _zuhr!.format(context).toString();
        model.asr = _asr!.format(context).toString();
        model.maghrib = _maghrib!.format(context).toString();
        model.isha = _isha!.format(context).toString();
        model.jamaah = _jamaah!.format(context).toString();
        model.docID = ref.id;
        model.owner = "user";
        model.selected = false;
        model.lng = null;
        model.lat = null;


        await ref.set(model.toMap());

        setState(() {
          _process = false;
        });
        Fluttertoast.showToast(msg: "Mosque added successfully!!");

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MapScreen()), (route) => false);
      } else{
        setState(() {
          _process = false;
        });
        Fluttertoast.showToast(msg: "Please enter all the details!!");
      }
    } catch (err) {
      setState(() {
        _process = false;
      });
      Fluttertoast.showToast(msg: "Please enter all the details!!");
    }


  }



}
