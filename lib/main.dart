// ignore_for_file: prefer_const_constructors


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice/pages/dashboard.dart';
import 'package:practice/pages/inventory.dart';
import 'package:practice/pages/login.dart';
import 'package:practice/pages/pos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: 'AIzaSyDk53XeltOAR4UPlehl_CfgwIf54NvS-mg',
    appId: '1:446815211035:web:0b470b145c7f3a6a9d72be',
    messagingSenderId: '446815211035',
    projectId: 'webportal-73955',
    storageBucket: 'webportal-73955.appspot.com',
    authDomain: "webportal-73955.firebaseapp.com",
  )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: POS(),
    );
  }
}