import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../styles/styles.dart';

class StudentDetail extends StatefulWidget {
  final DocumentSnapshot student;
  const StudentDetail({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  late GeoPoint position;

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
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
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']
                    ),
                    CircleLayerOptions(
                      circles: [
                        CircleMarker( //radius marker
                            point: LatLng(position.latitude, position.longitude),
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
                          height: 35.0,
                          width: 35.0,
                          point: LatLng(position.latitude, position.longitude),
                          builder: (context) => Container(
                            child: Icon(
                              Icons.location_on,
                              color: Styles.APred[900],
                              size: 35.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Text(
                    widget.student["firstName"].toString() + " " + widget.student["lastName"].toString(),
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
