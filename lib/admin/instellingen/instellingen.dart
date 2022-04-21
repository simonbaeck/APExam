import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/main.dart';
import 'package:flutter_project/services/toaster.dart';
import 'package:flutter_project/styles/styles.dart';

class InstellingenScreen extends StatefulWidget {
  const InstellingenScreen({Key? key}) : super(key: key);

  @override
  _InstellingenScreenState createState() => _InstellingenScreenState();
}

class _InstellingenScreenState extends State<InstellingenScreen> {
  final passwordController = TextEditingController();
  bool isButtonDisabled = true;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void onValueChange() {
    setState(() {
      passwordController.text;
      if (passwordController.text.length >= 6) {
        isButtonDisabled = false;
      } else {
        isButtonDisabled = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(onValueChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "Instellingen",
                  style: Styles.headerStyleH1,
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    style: Styles.textColorBlack,
                    children: <TextSpan>[
                      const TextSpan(text: "Ingelogd als "),
                      TextSpan(
                          text: FirebaseAuth.instance.currentUser!.email!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1,
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                child: Text(
                  "Vul hieronder je nieuwe wachtwoord in",
                  style: Styles.textColorBlack,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Nieuw wachtwoord",
                      ),
                    ),
                    const SizedBox(height: 7.5),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: Text(
                        "Wachtwoord moet langer zijn dan of 6 karakter bevatten.",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          onPressed: isButtonDisabled ? null : () => changePassword(),
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 65)),
                          ),
                          child: Text("Opslaan".toUpperCase())),
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

  Future changePassword() async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(passwordController.text.trim().toString()).whenComplete(
        () async => {
          Toaster().showToastMsg("Wachtwoord opgeslagen"),
          await FirebaseAuth.instance.signOut().whenComplete(
            () => Toaster().showToastMsg("Gelieve opnieuw in te loggen")
          ),
        }
      );
    } on FirebaseAuthException catch (e) {
      Toaster().showToastMsg(e.message);
    }
  }
}
