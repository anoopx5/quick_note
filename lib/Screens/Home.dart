import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_note/Screens/models/firebase_services.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // final User _user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius:60 ,
              backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!
                  .photoURL!),
            ),
     SizedBox(
              height: 30,
            ),
            Text("${FirebaseAuth.instance.currentUser?.displayName}"),
            Text("${FirebaseAuth.instance.currentUser?.email}"),
            ElevatedButton(
                onPressed: () async {
                  FirebaseServices().signOut();
                  Navigator.pop(context);
                },
                child: Text('Signout')),
      ])

            // Image.network(FirebaseAuth.instance.currentUser.photoURL),


        ),
      );

  }
}
