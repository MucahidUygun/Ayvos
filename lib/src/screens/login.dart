import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smine/src/screens/home.dart';
import 'package:smine/src/screens/model/usersModel.dart';
import 'package:smine/src/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _email = TextEditingController();
  final _password = TextEditingController();
  UserModel ? _userModel;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  _signIn() async {
    try {
     await _auth.signInWithEmailAndPassword(email: _email.text,password: _password.text);
     await _toTranslate();
     String name = _userModel!.getUserName();
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>HomeScreen(userName: name,)));
    } on FirebaseAuthException catch (e) {
      var message ='';
      switch (e.code) {
        case "invalid-email": 
          message='Geçersiz E-posta';
          break;
        case 'user-disabled': 
          message='Kullanıcı Geçersiz';
          break;
        case 'user-not-found': 
          message='Kullanıcı Bulunamadı';
          break;
        case 'wrong-password': 
          message='Yanlış Şifre';
          break;
        default:
          message='Bilinmeyen hata';
      }
      showDialog(context: context,builder:(context){
        return AlertDialog(
          title: Text("Giriş Başarısız"),
          content: Text(message),
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
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: "Lütfen Mailinizi Giriniz."),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(hintText: "Lütfen Şifrenizi Giriniz."),
              controller: _password,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary,),
                child: Text("Giriş Yap"),
                onPressed:() {
                  _signIn();
                }
              ),  
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text("Kayıt Ol"),
                onPressed:() {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>RegisterScreen()));
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  _toTranslate()async{
    UserModel userModel = await readUser(_auth.currentUser!.uid);
    setState(() {
      _userModel = userModel;
    });
  }
}
Future<UserModel> readUser(String userId) async {
  DocumentSnapshot _readUser = await FirebaseFirestore.instance.collection("Users").doc(userId).get();

  Map<String, dynamic> _readData = _readUser.data()! as Map<String, dynamic>;
  UserModel _readUserobject = UserModel.fromMap(_readData);
  print("Okunan user nesnesi :"+_readUserobject.goString());
  return _readUserobject;
  }