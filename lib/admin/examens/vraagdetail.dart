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
        title: Text(widget.vraag["vraag"].toString()),
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
