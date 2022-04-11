import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/services/toaster.dart';
import 'package:flutter_project/styles/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isButtonDisabled = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onValueChange() {
    setState(() {
      emailController.text;
      passwordController.text;
      if (emailController.text.length > 3 &&
          passwordController.text.length > 3) {
        isButtonDisabled = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(onValueChange);
    passwordController.addListener(onValueChange);
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
                      controller: emailController,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "email@test.com",
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
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
                          onPressed: isButtonDisabled ? null : () => signIn(),
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

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim().toString(),
        password: passwordController.text.trim().toString(),
      );
    } on FirebaseAuthException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }
}
