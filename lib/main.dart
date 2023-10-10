import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';

void main() async {

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: FirebaseOptions(
  apiKey: "AIzaSyDyKFvFMXPfITLCdsMDNXjv_IRea_ArMG4",
 
appId: "1:109178811801:web:d31703503fff6550128f08",
  projectId: "epigo-8f971",
  messagingSenderId: "109178811801",
  )

);
FirebaseFirestore.instance.settings =
  const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //close dialog
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
 
      theme: ThemeData(
        primaryColor: Color(0xFFFF7043),
        backgroundColor: Color(0xFFFF7043),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFFFF7043),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home:  LoginScreen(),
          routes: {
        HomeScreen.id:(context)=> const  HomeScreen(),
      
      
      


      },
     
    );
  }
}