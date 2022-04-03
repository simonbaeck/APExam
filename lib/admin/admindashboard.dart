import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/examens.dart';
import 'package:flutter_project/admin/instellingen/instellingen.dart';
import 'package:flutter_project/admin/studenten/studenten.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDasboard extends StatefulWidget {
  const AdminDasboard({Key? key}) : super(key: key);

  @override
  _AdminDashBoardState createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDasboard> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            tooltip: 'Uitloggen',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        allowImplicitScrolling: true,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: const [
          ExamensScreen(),
          StudentenScreen(),
          InstellingenScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Examens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'Studenten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Instellingen',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
