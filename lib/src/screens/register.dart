import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smine/src/screens/Login.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email="1",_password="1",sicilNo="1",name="1",surname="1",phoneNum="1";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt ol"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>LoginScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: "Lütfen Mailinizi Giriniz."),
              onChanged: (value){
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(hintText: "Lütfen Şifrenizi Giriniz."),
              onChanged: (value){
                setState(() {
                  _password = value.trim();
                });
              },
            ),
          ), 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Lütfen İsminizi Giriniz."),
              onChanged: (value){
                setState(() {
                  name = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Lütfen Soyisminizi Giriniz."),
              onChanged: (value){
                setState(() {
                  surname = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Lütfen Sicin Numaranızı Giriniz."),
              onChanged: (value){
                setState(() {
                  sicilNo = value.trim();
                });
              },
            ),
          ), 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Lütfen Cep Telefon Numaranızı Giriniz."),
              onChanged: (value){
                setState(() {
                  phoneNum = value.trim();
                });
              },
            ),
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text("Kayıt Ol"),
            onPressed:() async{
              register();
            }
          ),
        ],
      ),
    );
  }

  Future<void> userCreate(String name,String sicilNo,String surname,String phoneNum,UserCredential user) async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    await users.doc(user.user!.uid).set({
      'SicilNo' : sicilNo,
      'Name': name,
      'surname' : surname,
      'phoneNum' : phoneNum
    });
  }
  register()async{
        try {
            UserCredential user = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
            var uuid = const Uuid();
            sicilNo = uuid.v1();
            debugPrint(sicilNo.toString());
            userCreate(name,sicilNo,surname,phoneNum,user);
            backDialog("Kayıt Başarılı");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>const LoginScreen()));
          }on FirebaseAuthException catch (e) {
            var massege="";
            switch (e.code) {
              case "weak-password":
                massege ="Şifre uzunluğu yetersiz";
                break;
              case "email-already-in-use" :
                massege = "Bu e-mail kullanılmaktadır.";
              break ;
              default:
            }
            backDialog(massege);
       }
  }
    backDialog (String massage){
            showDialog(context: context,builder:(context){
              return AlertDialog(
                title: Text(massage),
                content: Text(massage),
                actions: [
                  TextButton(
                    child: Text("Tamam"),
                    onPressed: (){
                      Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
          );
  } 
}