import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String userName;
  late String bio;
  
  bool showSpinner =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                  //Do something with the user input.
                },
                
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  userName=value;
                  //Do something with the user input.
                },
                
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your name')
              ),
               SizedBox(
                height: 8.0,
              ),
               TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  bio=value;
                  //Do something with the user input.
                },
                
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Bio')
              ),
               SizedBox(
                height: 8.0,
              ),
              TextField(
                
                textAlign: TextAlign.center,
                obscureText: true,
      
                onChanged: (value) {
                  password=value;
                  //Do something with the user input.
                },
                
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Password')
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async 
                    {setState(() {
                          showSpinner=true;
                        });
                      try{
                     final new_user= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        if(new_user!= _auth.createUserWithEmailAndPassword(email: email, password: password)){
                          Navigator.pushNamed(context, ChatScreen.id);
                        } 

                        await FirebaseFirestore.instance.collection("AppUsers").doc(new_user.user!.uid.toString()).set(
                          {
                            "userName":userName,
                            "bio":bio,
                            "email":email,

                          }
                        );
                        setState(() {
                          showSpinner=false;
                        });                 }
                      catch(e){
                        print(e);
                      }
                      //Implement registration functionality.
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}