import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/addmultiplechoise.dart';
import 'package:flutter_project/admin/examens/addopenvraag.dart';
import 'package:flutter_project/admin/examens/addcodecorrectie.dart';
import 'package:flutter_project/admin/examens/vraagdetail.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addmultiplechoise.dart';
import 'addopenvraag.dart';
import 'addcodecorrectie.dart';

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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vragen')
                    .orderBy('nummer', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data!.docs.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VraagDetail(
                                              vraag: ds,
                                            )),
                                  );
                                },
                              );
                            },
                          ))
                        : Container(
                            width: double.infinity,
                            child: Text(
                              "Examens",
                              style: Styles.headerStyleH1,
                            ),
                          );
                  }
                },
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddMultplechoice()),
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.add_task_rounded, color: Colors.white),
              backgroundColor: Styles.APred,
              label: "Open vraag",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddOpenvraag()),
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.add_task_rounded, color: Colors.white),
              backgroundColor: Styles.APred,
              label: "Correctie vraag",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Addcodecorrectie()),
                );
              }),
        ],
      ),
    );
  }
}
