import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:muslimpro/services/preferences_service.dart';

class ViewMosqueDetails extends StatefulWidget {
  final MosqueModel mosqueModel;

  const ViewMosqueDetails({Key? key, required this.mosqueModel}) : super(key: key);

  @override
  _ViewMosqueDetailsState createState() => _ViewMosqueDetailsState();
}

class _ViewMosqueDetailsState extends State<ViewMosqueDetails> {

  @override
  Widget build(BuildContext context) {
    Widget _deleteButton = Material(
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
          _deleteData();
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
                    child: _deleteButton,
                  ),
                  SizedBox(height: 60,),
                ],
              )
            ),
          ),
    );
  }

  void _deleteData() async{
    if(widget.mosqueModel.selected == true){
      await PreferencesService().removeMosque();
    }
    await FirebaseFirestore.instance.collection('mosques').doc(widget.mosqueModel.docID).delete();
    Fluttertoast.showToast(msg: "Mosque deleted!!");
    Navigator.pop(context);
  }

}
