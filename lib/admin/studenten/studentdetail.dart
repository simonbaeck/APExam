import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_project/admin/studenten/points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../services/loader.dart';
import '../../styles/styles.dart';
import 'answer.class.dart';

class StudentDetail extends StatefulWidget {
  final DocumentSnapshot student;
  const StudentDetail({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  late GeoPoint position;

  Stream<List<Answer>> readAnswers() => FirebaseFirestore.instance
      .collection('antwoorden')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Answer.fromJson(doc.data())).toList());

  late List<Answer> answers = [];

  @override
  void initState() {
    super.initState();
    position = widget.student["studentLocation"];
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
            const SizedBox(height: 20.0),
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
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    "Antwoorden",
                    style: Styles.headerStyleH1,
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: ListView(
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
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    "Punten",
                    style: Styles.headerStyleH1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    checkCorrection("Debug.Log('Hello World') ", "Debug.Log('Hello World') ");
    return Container(
      child: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(26.0, 30.0, 26.0, 30.0),
            shrinkWrap: true,
            controller: ScrollController(),
            itemCount: studentAnswers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  child: ListTile(
                    title: Text(studentAnswers[index].studentId),
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
        padding: const EdgeInsets.fromLTRB(26.0, 30.0, 26.0, 30.0),
        child: Card(
          child: ListTile(title: Text("Geen antwoorden gevonden.")),
        ));
  }
}
