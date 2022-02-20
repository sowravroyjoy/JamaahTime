import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muslimpro/models/mosque_model.dart';
import 'package:muslimpro/screens/admin_add.dart';
import 'package:muslimpro/screens/admin_details.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'login.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();
  bool isExecuted = false;
  List _allResults = [];
  List _results = [];
  Future? resultLoaded;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = getData();
  }

  _onSearchChanged(){
      searchResult();
  }

  searchResult() async{
    var showResults = [];
    if(searchController.text != ""){
      for(var mosqueData  in _allResults){
        var name = await MosqueModel.fromMap(mosqueData.data()).name!.toLowerCase();
        if(name.contains(searchController.text.toLowerCase())){
          setState(() {
            showResults.add(mosqueData);
          });
        }
      }
    } else{
      showResults = List.from(_allResults);
    }
    setState(() {
      _results = showResults;
    });
  }

  getData() async{
    final mosques =  await FirebaseFirestore.instance.collection('mosques').get();
    setState(() {
      _allResults = mosques.docs;
    });
    searchResult();
    return "complete";
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchField = TextFormField(
        cursorColor: Colors.green.shade400,
        autofocus: false,
        controller: searchController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          searchController.text = value!;
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          suffix: Icon(
            Icons.search,
            color: Colors.green.shade400,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            20,
            15,
            20,
            15,
          ),
          labelText: 'Search by mosque name',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text('All listed mosques'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      body:   Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: searchField,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return buildListTile(_results[index]);
                  },
                  itemCount: _results.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                        thickness: 1,
                        color: Colors.black38,
                      ))
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminAdd()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green.shade400,
      ),
    );
  }

  Widget buildListTile(data) => InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdminDetails(
                      mosqueModel: new MosqueModel(
                    userID: data['uid'],
                    name: data['name'],
                    city: data['city'],
                    country: data['country'],
                    fajr: data['fajr'],
                    zuhr: data['zuhr'],
                    asr: data['asr'],
                    maghrib: data['maghrib'],
                    isha: data['isha'],
                    jamaah: data['jamaah'],
                    selected: data['selected'],
                    owner: data['owner'],
                    lat: data['lat'],
                    lng: data['lng'],
                    docID: data['docId'],
                  ))));
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 23,
            child: Image.asset('assets/images/mosque.png'),
          ),
          title: Text(
            '${data['name']}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade400),
          ),
        ),
      );

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove('email');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

