import 'package:flutter/material.dart';
import 'package:flutter_project/admin/examens/multiplechoice/addmultiplechoise.dart';
import 'package:flutter_project/admin/examens/openvraag/addopenvraag.dart';
import 'package:flutter_project/admin/examens/codecorrectie/addcodecorrectie.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/loader.dart';
import 'multiplechoice/addmultiplechoise.dart';
import 'openvraag/addopenvraag.dart';
import 'codecorrectie/addcodecorrectie.dart';
import '../../services/toaster.dart';
import '../../services/capitalize.dart';

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
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              /*Open vraag*/
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('vragen').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (!snapshot.hasData) {
                    return const LoaderWidget(loaderText: "Laden...");
                  } else {
                    return snapshot.data!.docs.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  26.0, 30.0, 26.0, 30.0),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    snapshot.data!.docs[index];
                                return GestureDetector(
                                  child: Card(
                                    child: ListTile(
                                      subtitle: Text("${ds["type"].toString().capitalizeString()} vraag"),
                                      title: Text(ds["vraag"]),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              //removeStudent(inpId: ds["id"]);
                                              removeVraag(inpId: ds["id"]);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.fromLTRB(
                                26.0, 30.0, 26.0, 30.0),
                            child: const Card(
                              child: ListTile(
                                title: Text("Er zijn nog geen vragen"),
                                subtitle: Text(
                                    "Klik rechtsonder op het + icoontje om vragen toe te voegen."),
                              ),
                            ),
                          );
                  }
                },
              ),
            ],
            /*Code correctie*/
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

  Future removeVraag({required String inpId}) async {
    try {
      final docVraag =
          FirebaseFirestore.instance.collection('vragen').doc(inpId);
      await docVraag.delete();
    } on FirebaseException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }

  Future removeCode({required String inpId}) async {
    try {
      final docVraag =
          FirebaseFirestore.instance.collection('codecorrectie').doc(inpId);
      await docVraag.delete();
    } on FirebaseException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }
}
