import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/studenten/addstudent.dart';
import 'package:flutter_project/styles/styles.dart';

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
        padding: const EdgeInsets.fromLTRB(20.0, 26.0, 20.0, 26.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('studenten').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return Card(
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
                                    icon: const Icon(Icons.edit),
                                    onPressed: (){},
                                ),
                                const SizedBox(width: 5.0),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: (){
                                      removeStudent(inpId: ds["id"]);
                                    },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudent()),
          );
        },
        backgroundColor: Styles.APred,
        child: const Icon(Icons.person_add_alt_rounded),
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
}
