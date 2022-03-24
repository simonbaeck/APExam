import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/styles/styles.dart';

class Admin {
  late int id;
  late String email;
  late String password;

  Admin(int id, String email, String password) {
    this.id = id;
    this.email = email;
    this.password = password;
  }

  @override
  String toString() {
    return '{id: $id, name: $email, password: $password }';
  }
}

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isButtonDisabled = true;

  void onValueChange() {
    setState(() {
      _emController.text;
      _pwController.text;
      if (_emController.text.length > 1 && _pwController.text.length > 1) {
        _isButtonDisabled = false;
      }
    });
  }

  printObj() async {
    Admin temp = Admin(1, _emController.text, _pwController.text);
    print(temp);
    _isButtonDisabled = true;
    _emController.text = "";
    _pwController.text = "";
  }

  @override
  void initState() {
    super.initState();
    _emController.addListener(onValueChange);
    _pwController.addListener(onValueChange);
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "Hallo, admin",
                  style: Styles.headerStyleH1,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: const Text(
                  "Vul hieronder je inloggegevens in om door te gaan.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "email@test.com",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _pwController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "password",
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
                                MaterialStateProperty.all(const Size(250, 65)),
                          ),
                          child: Text("Inloggen".toUpperCase())),
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
