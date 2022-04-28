import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../styles/styles.dart';

class VraagDetail extends StatefulWidget {
  final DocumentSnapshot vraag;
  const VraagDetail({Key? key, required this.vraag}) : super(key: key);

  @override
  State<VraagDetail> createState() => _VraagDetail();
}

class _VraagDetail extends State<VraagDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vraag["nummer"].toString()),
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
                    center: LatLng(51.230117719874784, 4.416240071306905),
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
                                LatLng(51.230117719874784, 4.416240071306905),
                            color: Styles.APred.withOpacity(0.15),
                            borderStrokeWidth: 2.0,
                            borderColor: Styles.APred.withOpacity(0.35),
                            radius: 50 //radius
                            ),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          height: 55.0,
                          width: 55.0,
                          point: LatLng(51.230117719874784, 4.416240071306905),
                          builder: (context) => Container(
                            child: Icon(
                              Icons.location_on,
                              color: Styles.APred[900],
                              size: 55.0,
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
                    widget.vraag["vraag"].toString() + " ",
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
