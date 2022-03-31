import 'dart:developer';
import 'dart:html' as Html;
import 'dart:js_util';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/admin/admindashboard.dart';
import 'package:flutter_project/adminlogin.dart';
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
  );

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
        fontFamily: GoogleFonts.ubuntu().fontFamily,
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

enum AuthState { notSignedIn, signedIn }

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AdminDasboard();
            } else {
              return Scaffold(
                body: PageView(
                  allowImplicitScrolling: true,
                  controller: pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _selectedIndex = page;
                    });
                  },
                  children: const [
                    StudentLoginScreen(),
                    AdminLoginScreen(),
                  ]),
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Student',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Admin',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              );
            }
          }),
    );
  }
}
