import 'package:flutter/material.dart';
import 'package:flutter_project/styles/styles.dart';

class StudentenScreen extends StatefulWidget {
  const StudentenScreen({Key? key}) : super(key: key);

  @override
  _StudentenScreenState createState() => _StudentenScreenState();
}

class _StudentenScreenState extends State<StudentenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "Studenten",
                  style: Styles.headerStyleH1,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Test");
        },
        backgroundColor: Styles.APred,
        child: const Icon(Icons.person_add_alt_rounded),
      ),
    );
  }
}
