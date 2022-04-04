import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles/styles.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            '../assets/splash.png',
            height: 150.0,
          ),
          const SizedBox(height: 20.0),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Styles.APred),
          ),
        ],
      )
    );
  }
}
