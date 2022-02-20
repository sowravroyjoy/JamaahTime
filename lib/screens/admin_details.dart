import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslimpro/models/admin_mosque_model.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:muslimpro/screens/admin_update_screen.dart';

class AdminDetails extends StatefulWidget {
  final MosqueModel mosqueModel;

  const AdminDetails({Key? key, required this.mosqueModel}) : super(key: key);

  @override
  _AdminDetailsState createState() => _AdminDetailsState();
}

class _AdminDetailsState extends State<AdminDetails> {


  @override
  Widget build(BuildContext context) {

    final updateButton = Material(
      elevation: 5,
      color: Colors.green.shade400,
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
          (widget.mosqueModel.owner == 'admin')? _updateData() : Fluttertoast.showToast(msg: "Not Allowed!!");
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
          Navigator.pop(context);
        },
        child: Text(
          'Back',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),
    );

    final deleteButton = Material(
      elevation: 5,
      color: Colors.redAccent,
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
          (widget.mosqueModel.owner == 'admin')? _deleteData() : Fluttertoast.showToast(msg: "Not Allowed!!");
        },
        child: Text(
          'Delete',
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
      body: SingleChildScrollView(
        child:  Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/logo_two.png', fit: BoxFit.fill, ),
              ),
              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Publisher :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.mosqueModel.owner.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                                fontSize: 20
                            ),
                          ),
                        ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Mosque Name :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.name.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'City Name :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.city.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Country Name :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.country.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Latitude :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.lat.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Longitude :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.lng.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'FAZR Time :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.fajr.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'ZUHR Time :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.zuhr.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'ASR Time :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.asr.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'MAGHRIB Time :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.maghrib.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'ISHA Time :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.isha.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "JUMAAH Time :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                          fontSize: 20
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.mosqueModel.jamaah.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: updateButton,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: deleteButton,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cancelButton,
              ),

              SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }
  void _deleteData() async{
    await FirebaseFirestore.instance.collection('mosques').doc(widget.mosqueModel.docID).delete();
    Fluttertoast.showToast(msg: "Mosque deleted!!");
    Navigator.pop(context);
  }

  void _updateData() async{
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AdminUpdateScreen(model: new MosqueModel(
          userID: widget.mosqueModel.userID,
          name: widget.mosqueModel.name,
          city: widget.mosqueModel.city,
          country: widget.mosqueModel.country,
          fajr: widget.mosqueModel.fajr,
          zuhr: widget.mosqueModel.zuhr,
          asr: widget.mosqueModel.asr,
          maghrib: widget.mosqueModel.maghrib,
          isha: widget.mosqueModel.isha,
          jamaah: widget.mosqueModel.jamaah,
          selected: widget.mosqueModel.selected,
          owner: widget.mosqueModel.owner,
          lat: widget.mosqueModel.lat,
          lng: widget.mosqueModel.lng,
          docID: widget.mosqueModel.docID,
        ))));
  }
}
