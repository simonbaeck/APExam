import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/styles/styles.dart';

class Student {
  late int id;
  late String name;

  Student(int id, String name) {
    this.id = id;
    this.name = name;
  }

  @override
  String toString() {
    return '{ id: $id, name: $name }';
  }
}

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final TextEditingController _snController = TextEditingController();
  bool _isButtonDisabled = true;

  void onValueChange() {
    setState(() {
      _snController.text;
      if (_snController.text.length == 6) {
        _isButtonDisabled = false;
      }
    });
  }

  printObj() async {
    Student temp = Student(1, "s" + _snController.text);
    print(temp);
    _snController.text = "";
    _isButtonDisabled = true;
  }

  @override
  void initState() {
    super.initState();
    _snController.addListener(onValueChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(30.0, 45.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "Hallo, student",
                  style: Styles.headerStyleH1,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: const Text(
                  "Vul hieronder je studentennummer in om te starten.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _snController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefix: const Text("s"),
                        hintText: "748596",
                        helperText:
                            "s-nummer kan je vinden op je studentenkaart.",
                        counterText:
                            "${6 - _snController.text.length} character left",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          onPressed:
                              _isButtonDisabled ? null : () => printObj(),
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(const Size(double.infinity, 65)),
                          ),
                          child: Text("Naar examen".toUpperCase())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
