import 'package:chat_app/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); //initilization of Firebase app
  // here, Firebase.initilizeApp() is Future method, so you need to add await before.
  //run time error: Unhandled Exception: [core/no-app] 
  //No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
  
  runApp(FlashChat());
}


class FlashChat extends StatelessWidget {
 
 
 
  @override
 
 
  Widget build(BuildContext context) {
 
    return MaterialApp(


      initialRoute: WelcomeScreen.id ,
      routes: {
        WelcomeScreen.id:(context) => WelcomeScreen(),
        LoginScreen.id :(context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id:(context) => ChatScreen(),
          home.id:(context) => home(),
      },
      //home: WelcomeScreen(),

    );
  }
}