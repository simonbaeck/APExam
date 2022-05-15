import 'package:flutter/material.dart';
import 'package:flutter_project/styles/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  // Text styles
  static TextStyle headerStyleH1 = GoogleFonts.ubuntu(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
  );

  static TextStyle headerStyleH2 = GoogleFonts.ubuntu(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  );

  static TextStyle textColorBlack = const TextStyle(
    color: Colors.black,
    // fontFamily: GoogleFonts.ubuntu().fontFamily,
    fontSize: 18,
  );

  // Colors
  static const MaterialColor APdarkred = MaterialColor(
    0x9997000c, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color.fromARGB(25, 151, 0, 12), //10%
      100: Color.fromARGB(50, 151, 0, 12), //20%
      200: Color.fromARGB(75, 151, 0, 12), //30%
      300: Color.fromARGB(100, 151, 0, 12), //40%
      400: Color.fromARGB(125, 151, 0, 12), //50%
      500: Color.fromARGB(150, 151, 0, 12), //60%
      600: Color.fromARGB(175, 151, 0, 12), //70%
      700: Color.fromARGB(200, 151, 0, 12), //80%
      800: Color.fromARGB(225, 151, 0, 12), //90%
      900: Color.fromARGB(250, 151, 0, 12), //100%
    },
  );

  static const MaterialColor APred = MaterialColor(
    0xccc40009, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color.fromARGB(25, 196, 0, 9), //10%
      100: Color.fromARGB(50, 196, 0, 9), //20%
      200: Color.fromARGB(75, 196, 0, 9), //30%
      300: Color.fromARGB(100, 196, 0, 9), //40%
      400: Color.fromARGB(125, 196, 0, 9), //50%
      500: Color.fromARGB(150, 196, 0, 9), //60%
      600: Color.fromARGB(175, 196, 0, 9), //70%
      700: Color.fromARGB(200, 196, 0, 9), //80%
      800: Color.fromARGB(225, 196, 0, 9), //90%
      900: Color.fromARGB(250, 196, 0, 9), //100%
    },
  );
}
