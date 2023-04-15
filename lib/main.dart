import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/Notes/mynotesview.dart';
import 'Screens/Notes/search_note.dart';

import 'Screens/Notes/mynotes_home.dart';
import 'Screens/gmailLogin.dart';
import 'Screens/Notes/add_note.dart';

import 'Screens/Notes/mynoteview_edit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get user => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => MyNoteHome(user!),
        '/home2': (context) => MyNoteHome(user),
        '/addNote': (context) => AddMyNotes(),
        '/login': (context) => Tab1(),
        '/search': (context) => MyNoteSearch(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.red),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffEDE6E2),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Image.asset(
                    "assets/Logo1.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffd76633)))
            ]),
      ),
    );
  }
}
