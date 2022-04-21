import 'package:flutter/material.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ExamensScreen extends StatefulWidget {
  const ExamensScreen({Key? key}) : super(key: key);

  @override
  _ExamensScreenState createState() => _ExamensScreenState();
}

class _ExamensScreenState extends State<ExamensScreen> {

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
                  "Examens",
                  style: Styles.headerStyleH1,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Styles.APred[900],
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 10,
        buttonSize: const Size(90.0, 90.0),
        childrenButtonSize: const Size(80.0, 80.0),
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add_task_rounded, color: Colors.white),
            backgroundColor: Styles.APred,
            label: "Mulitple choice vraag",
            labelStyle: const TextStyle(fontSize: 16.0),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_task_rounded, color: Colors.white),
            backgroundColor: Styles.APred,
            label: "Open vraag",
            labelStyle: const TextStyle(fontSize: 16.0),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_task_rounded, color: Colors.white),
            backgroundColor: Styles.APred,
            label: "Correctie vraag",
            labelStyle: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}