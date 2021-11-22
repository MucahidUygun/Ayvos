import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smine/src/screens/login.dart';
import 'package:smine/src/screens/model/usersModel.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  HomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Ana Sayfa")),
        actions: [
          IconButton(
          icon: const Icon(Icons.logout),
            onPressed: (){
            _auth.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>LoginScreen()));
            },
          ),
        ], 
      ),
      body: Center(
        child: Text("HoşGeldin " +widget.userName),
      ),
    );
  }
    
}

