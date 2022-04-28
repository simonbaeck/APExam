import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_project/admin/admindashboard.dart';
import 'package:flutter_project/admin/adminlogin.dart';
import 'package:flutter_project/homepage.dart';
import 'package:flutter_project/services/loadingscreen.dart';
import 'package:flutter_project/studentlogin.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA0yM2tB_DVxQ1a4cuSe9P1l5izd0qqbvY",
      appId: "1:891983989965:android:aa777fe2b47a571aa8ed84",
      messagingSenderId: "2876530414531507255",
      projectId: "flutterintromobile",
    ),
  ).whenComplete(() => FlutterNativeSplash.remove());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      theme: ThemeData(
        //fontFamily: GoogleFonts.ubuntu().fontFamily,
        // textTheme: Theme.of(context).textTheme.apply(
        //   fontSizeFactor: 1.1,
        //   fontSizeDelta: 2.0,
        // ),
        primarySwatch: Styles.APred,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          if (snapshot.hasData) {
            return const AdminDasboard();
          } else {
            return const Homepage();
          }
        }),
    );
  }
}
