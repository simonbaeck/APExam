import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/styles.dart';

class Toaster {
  showToastMsg(message) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.black,
      backgroundColor: Colors.grey.shade300.withOpacity(0.9),
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "#e0e0e0",
    );
  }
}
