import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:muslimpro/models/admin_mosque_model.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:muslimpro/models/user_model.dart';
import 'package:muslimpro/screens/admin_screen.dart';
import 'package:muslimpro/screens/login.dart';
import 'package:muslimpro/screens/homescreen.dart';
import 'admin_details.dart';
import 'mapscreen.dart';

class AdminUpdateScreen extends StatefulWidget {
  final MosqueModel model;
  const AdminUpdateScreen({Key? key, required this.model}) : super(key: key);

  @override
  _AdminUpdateScreenState createState() => _AdminUpdateScreenState();
}

class _AdminUpdateScreenState extends State<AdminUpdateScreen> {
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
  final latEditingController = new TextEditingController();
  final lngEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    nameEditingController.text = widget.model.name.toString();
    cityEditingController.text = widget.model.city.toString();
    countryEditingController.text = widget.model.country.toString();
    latEditingController.text = widget.model.lat.toString();
    lngEditingController.text = widget.model.lng.toString();

    _fajr = _timeOfDay(widget.model.fajr.toString());
    _zuhr = _timeOfDay(widget.model.zuhr.toString());
    _asr = _timeOfDay(widget.model.asr.toString());
    _maghrib = _timeOfDay(widget.model.maghrib.toString());
    _isha = _timeOfDay(widget.model.isha.toString());
    _jamaah = _timeOfDay(widget.model.jamaah.toString());
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        //initialValue: widget.model.name,
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
        //initialValue: widget.model.city,
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
       // initialValue: widget.model.country,
        validator: (value){
          if(value!.isEmpty){
            return ("Country cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          countryEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
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

    final latField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: latEditingController,
        keyboardType: TextInputType.number,
        //initialValue: widget.model.lat,
        validator: (value){
          if(value!.isEmpty){
            return ("Latitude cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          latEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Latitude',
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
    final lngField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: lngEditingController,
        keyboardType: TextInputType.number,
       // initialValue: widget.model.lng,
        validator: (value){
          if(value!.isEmpty){
            return ("Longitude cannot be empty!!");
          }
          return null;
        },
        onSaved: (value) {
          lngEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Longitude',
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
                  initialTime: _fajr ?? TimeOfDay.now() ,
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
                  initialTime: _isha ??TimeOfDay.now(),
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
                  initialTime: _jamaah ??TimeOfDay.now(),
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

    final updateButton = Material(
      elevation: 5,
      color: Colors.red,
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
          _update();
        },
        child: Text(
          'Update',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 5,
      color: Colors.blue,
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
          _back();
        },
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            fontSize: 20
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
            _back();
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
                    SizedBox(
                      height: 10,
                    ),
                    latField,
                    SizedBox(
                      height: 10,
                    ),
                    lngField,
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
                    updateButton,
                    SizedBox(height: 20,),
                    cancelButton,
                    SizedBox(height: 60,),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),);
  }

  void _update() async{

    try{
      if( nameEditingController.text != null && cityEditingController.text != null && countryEditingController.text != null && latEditingController.text != null && lngEditingController.text != null && _fajr!.format(context).toString() != null && _zuhr!.format(context).toString() != null && _asr!.format(context).toString() != null && _maghrib!.format(context).toString() != null && _isha!.format(context).toString() != null && _jamaah!.format(context).toString() != null){
        MosqueModel mosqueModel = MosqueModel();
        mosqueModel.userID = null;
        mosqueModel.name = nameEditingController.text;
        mosqueModel.city = cityEditingController.text;
        mosqueModel.country = countryEditingController.text;
        mosqueModel.lat = latEditingController.text;
        mosqueModel.lng = lngEditingController.text;
        mosqueModel.fajr = _fajr!.format(context).toString();
        mosqueModel.zuhr = _zuhr!.format(context).toString();
        mosqueModel.asr = _asr!.format(context).toString();
        mosqueModel.maghrib = _maghrib!.format(context).toString();
        mosqueModel.isha = _isha!.format(context).toString();
        mosqueModel.jamaah = _jamaah!.format(context).toString();
        mosqueModel.docID = widget.model.docID.toString();
        mosqueModel.owner = "admin";
        mosqueModel.selected = false;

        await FirebaseFirestore.instance.collection("mosques").doc(widget.model.docID).update(mosqueModel.toMap());
        Fluttertoast.showToast(msg: "Mosque updated successfully!!");

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminDetails(mosqueModel: new MosqueModel(
              userID: mosqueModel.userID,
              name: mosqueModel.name,
              city: mosqueModel.city,
              country: mosqueModel.country,
              fajr: mosqueModel.fajr,
              zuhr: mosqueModel.zuhr,
              asr: mosqueModel.asr,
              maghrib: mosqueModel.maghrib,
              isha: mosqueModel.isha,
              jamaah: mosqueModel.jamaah,
              selected: mosqueModel.selected,
              owner: mosqueModel.owner,
              lat: mosqueModel.lat,
              lng: mosqueModel.lng,
              docID: mosqueModel.docID,
            ))));
      } else{
        Fluttertoast.showToast(msg: "Please enter all the details!!");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Something is wrong!!");
    }
  }

  void _back() async{
    await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AdminDetails(mosqueModel: new MosqueModel(
          userID: widget.model.userID,
          name: widget.model.name,
          city: widget.model.city,
          country: widget.model.country,
          fajr: widget.model.fajr,
          zuhr: widget.model.zuhr,
          asr: widget.model.asr,
          maghrib: widget.model.maghrib,
          isha: widget.model.isha,
          jamaah: widget.model.jamaah,
          selected: widget.model.selected,
          owner: widget.model.owner,
          lat: widget.model.lat,
          lng: widget.model.lng,
          docID: widget.model.docID,
        ))));
  }


  TimeOfDay _timeOfDay(String string){
    DateTime _date = DateFormat("h:mm a").parse(string);
     return TimeOfDay.fromDateTime(_date);
  }

}
