import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_note/Screens/Home.dart';
import 'package:quick_note/Screens/Notes/mynotes_home.dart';

import 'package:quick_note/Screens/models/firebase_services.dart';

class Tab1 extends StatefulWidget {
  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GmailLogin(),
    );
  }
}

class GmailLogin extends StatefulWidget {
  @override
  _GmailLoginState createState() => _GmailLoginState();
}

class _GmailLoginState extends State<GmailLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  void _autoLogin() async {
    final user = await _auth.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => MyNoteHome(user),
      ));
    }
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => MyNoteHome(user!),
      ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xffEDE6E2),
            appBar: AppBar(
              backgroundColor: Color(0xffEDE6E2),
              elevation: 0,
            ),
            body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                  SizedBox(height: 80.0),
                  Center(
                    child: Container(
                      child: Image.asset(
                        'assets/Logo1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Neon',
                          fontSize: 25,
                          color: Color(0xff524432),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      'Welcome Back, Please Login with Google !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Neon', color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: signInWithGoogle,
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Color(0xffF0F0F0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: const Offset(
                                        -1.0,
                                        10.0,
                                      ),
                                      blurRadius: 8.0,
                                      spreadRadius: -9.0,
                                    ),
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(30)),
                              child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                                  Container(
                                      height: 40,
                                      width: 200,
                                      child: Stack(children: <Widget>[
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.asset(
                                                'assets/gmail.png')),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 55, top: 10),
                                          child: Text(
                                            'Login with Google',
                                            style: TextStyle(
                                                fontFamily: 'Neon',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ])),
                                ]),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ]))));
  }
}
