import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/addmultiplestudent.dart';
import 'package:flutter_project/admin/studenten/addstudent.dart';
import 'package:flutter_project/admin/studenten/studentdetail.dart';
import 'package:flutter_project/services/loadingscreen.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../services/toaster.dart';

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
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('studenten').orderBy('firstname', descending: false).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data!.docs.isNotEmpty ? Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(26.0, 30.0, 26.0, 30.0),
                          shrinkWrap: true,
                          controller: ScrollController(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StudentDetail(student: ds)),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text("${ds["firstname"]} ${ds['lastname']}"),
                                  subtitle: Text("${ds['snumber']}"),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=${ds['firstname']}+${ds['lastname']}&background=B3161D&color=FFFFFF&font-size=0.4&bold=true"),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: (){
                                            removeStudent(inpId: ds["id"]);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ) : Container(
                      padding: const EdgeInsets.fromLTRB(26.0, 30.0, 26.0, 30.0),
                      child: const Card(
                        child: ListTile(
                          title: Text("Er zijn geen studenten aanwezig"),
                          subtitle: Text("Klik rechtsonder op het + icoontje om studenten toe te voegen."),
                        ),
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
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.delete, color: Colors.white),
              backgroundColor: Styles.APred,
              label: "Verwijder alle studenten",
              onTap: () {
                removeStudents();
              }
          ),
          SpeedDialChild(
            child: const Icon(Icons.group_add, color: Colors.white),
            backgroundColor: Styles.APred,
            label: "Voeg meerdere studenten toe",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMultipleStudent()),
                );
              }
          ),
          SpeedDialChild(
              child: const Icon(Icons.person_add, color: Colors.white),
              backgroundColor: Styles.APred,
              label: "Voeg één student toe",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddStudent()),
                );
              }
          ),
        ],
      ),
    );
  }

  Future removeStudent({required String inpId}) async {
    try {
      final docStudent = FirebaseFirestore.instance.collection('studenten').doc(inpId);
      await docStudent.delete();
    } on FirebaseException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }

  Future removeStudents() async {
    try {
      final collection = FirebaseFirestore.instance.collection('studenten');
      final snapshots = await collection.get();
      final doclength = snapshots.docs.length;

      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      Toaster().showToastMsg("$doclength Studenten verwijderd");
    } on FirebaseException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }
}