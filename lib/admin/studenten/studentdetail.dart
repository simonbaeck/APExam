import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_project/admin/studenten/points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../services/loader.dart';
import '../../services/toaster.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';

class StudentDetail extends StatefulWidget {
  final DocumentSnapshot student;
  const StudentDetail({Key? key, required this.student}) : super(key: key);


  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  final changeScoreController = TextEditingController();

  late GeoPoint position;
  final changeScoreController = TextEditingController();
  bool hasChangedScore = false;

  Stream<List<Answer>> readAnswers() => FirebaseFirestore.instance
      .collection('antwoorden')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Answer.fromJson(doc.data())).toList());

  late List<Answer> answers = [];
  late bool _toggled = false;
  bool toggleIsLoading = true;
  bool pointsLoading = true;
  late int studentScore = 0;

  @override
  void initState() {
    super.initState();
    position = widget.student["studentLocation"];
    getExtraTime(studentId: widget.student["id"]);
    getScore(studentId: widget.student["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student["sNumber"].toString()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    widget.student["firstName"].toString() +
                        " " +
                        widget.student["lastName"].toString(),
                    style: Styles.headerStyleH1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 250.0,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: Styles.APred.shade900,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(11.0)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(position.latitude, position.longitude),
                    minZoom: 17.0,
                    maxZoom: 17.0,
                    allowPanning: false,
                  ),
                  layers: [
                    TileLayerOptions(
                        minZoom: 17,
                        maxZoom: 17,
                        backgroundColor: Colors.white,
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c']),
                    CircleLayerOptions(
                      circles: [
                        CircleMarker(
                            //radius marker
                            point:
                                LatLng(position.latitude, position.longitude),
                            color: Styles.APred.withOpacity(0.15),
                            borderStrokeWidth: 2.0,
                            borderColor: Styles.APred.withOpacity(0.35),
                            radius: 75 //radius
                            ),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          height: 25.0,
                          width: 25.0,
                          point: LatLng(position.latitude, position.longitude),
                          builder: (context) => Container(
                            child: Icon(
                              Icons.gps_fixed,
                              color: Styles.APred[900],
                              size: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: const Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                color: Styles.APred,
                child: ListTile(
                    title: Text(
                  "Deze student heeft het examen 0 keer verlaten",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                )),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              height: 1.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    "Antwoorden",
                    style: Styles.headerStyleH2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                StreamBuilder<List<Answer>>(
                    stream: readAnswers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        answers = snapshot.data!;
                        return answersList(answers, widget.student.id);
                      } else {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              height: 1.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    "Punten",
                    style: Styles.headerStyleH2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            pointsLoading == false ? Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Behaalde punten: " + studentScore.toString(),
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    child: TextFormField(
                      controller: changeScoreController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Vul punten in",
                      ),
                    )
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      final score = changeScoreController.text;
                      changeScore(inpScore: int.parse(score));
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 65)),
                    ),
                    child: Text("Wijzig punten".toUpperCase())
                  ),
                ],
              ),
            ) : Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
              alignment: Alignment.topLeft,
              width: double.infinity,
            ),
            const SizedBox(height: 30.0),
            Container(

              width: double.infinity,
              height: 1.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
              children: [
              Text(
                "Heeft een: "+ widget.student["score"].toString() + " behaald",
                ),
               ],
               ),
            ),
            const SizedBox(height: 20.0),
           Container(
             //width: 10,
             child:
             TextField(
               controller: changeScoreController,

             )
           ),
            const SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: () {
                  final score = changeScoreController.text;
                  //var local = int.parse(score);
                  changeScore(inpScore: int.parse(score));
                },
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                child: Text("Wijzig punten".toUpperCase())
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    "Instellingen",
                    style: Styles.headerStyleH2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            SwitchListTile(
              title: const Text("Extra tijd"),
              controlAffinity: ListTileControlAffinity.leading,
              value: _toggled,
              onChanged: (bool value) {
                setState(() => {_toggled = value});
              },
            ),
          ],
        ),
      ),
    );
  }
  Future changeScore({required int inpScore}) async{
    final docStudent = FirebaseFirestore.instance.collection("studenten").doc(widget.student.id);
    await docStudent.update({"score": inpScore}).catchError((e) => print(e));
    Toaster().showToastMsg("Score gewijzigd");
    Navigator.of(context).pop();
  }
}


    await docSnapshot.then((data) {
      setState(() {
        _toggled = data['extraTime'];
        toggleIsLoading = false;
      });
    });
  }

  Future getScore({ required String? studentId }) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("studenten");
    DocumentReference documentReference = collectionReference.doc(studentId);
    Future<DocumentSnapshot> docSnapshot = documentReference.get();
    setState(() {
      pointsLoading = true;
    });

    await docSnapshot.then((data) {
      setState(() {
        studentScore = data["score"];
        changeScoreController.text = studentScore.toString();
        pointsLoading = false;
      });
    });
  }

  Future changeScore({required int inpScore}) async{
    final docStudent = FirebaseFirestore.instance.collection("studenten").doc(widget.student.id);
    await docStudent.update({"score": inpScore})
        .then((value) => getScore(studentId: widget.student["id"]))
        .catchError((e) => print(e));
    Toaster().showToastMsg("Score gewijzigd");
  }
}

Widget answersList(List<Answer> answers, String currentStudent) {
  List<Answer> studentAnswers = [];

  for (var answer in answers) {
    if (currentStudent == answer.studentId) {
      studentAnswers.add(answer);
    }
  }
  if (studentAnswers.isNotEmpty) {
    return Container(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            controller: ScrollController(),
            itemCount: studentAnswers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  child: ListTile(
                    title: Text(studentAnswers[index].vraag),
                    subtitle: Text(studentAnswers[index].antwoord),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  } else {
    return Container(
        child: const Card(
          child: ListTile(title: Text("Geen antwoorden gevonden.")),
        ));
  }
}
