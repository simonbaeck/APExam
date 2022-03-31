import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {

  showToastMsg(message) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.black,
      webPosition: "center",
      webBgColor: "#e0e0e0",
    );
  }

}
