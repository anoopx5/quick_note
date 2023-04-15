import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:quick_note/Screens/Notes/mynotesview.dart';
import 'package:quick_note/Screens/Notes/search_note.dart';

import '../gmailLogin.dart';
import 'add_note.dart';
import 'search_note.dart';
import 'mynoteview_edit.dart';

class MyNoteHome extends StatefulWidget {
  final User user;

  MyNoteHome(this.user);

  @override
  State<MyNoteHome> createState() => _MyNoteHomeState();
}

class _MyNoteHomeState extends State<MyNoteHome> {
  TextEditingController titleControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();
  final mytext = Text(
    'Welcome',
    style: TextStyle(fontFamily: 'Comforta'),
  );

  var _name = FirebaseAuth.instance.currentUser?.displayName;

  final CollectionReference mynotes =
      FirebaseFirestore.instance.collection('My Notes');

  void deleteNote(docId) {
    mynotes.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              actions: [
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut().whenComplete(() =>
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false));
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(top: 09, right: 18),
                      child: Image.asset(
                        'assets/logout.png',
                        height: 20,
                        width: 20,
                        color: Color(0xffede6e2),
                      )),
                )
              ],
              backgroundColor: Color(0xffd76633),
              centerTitle: true,
              title: Text(
                'Quick Note',
                style: TextStyle(fontFamily: 'Right', fontSize: 30),
              )),
          body: Column(children: <Widget>[
            SizedBox(
              height: 05,
            ),
            SingleChildScrollView(
              child: Row(children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL!),
                      backgroundColor: Color(0xffd76633),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Welcome,',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Color(0xff524432)),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' $_name',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Popins',
                              color: Color(0xffd76633)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyNoteSearch()));
                  },
                  child: Expanded(
                    child: CircleAvatar(
                      backgroundColor: Color(0xffd76633),
                      maxRadius: 15,
                      child: Icon(
                        Icons.manage_search,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 08, right: 00),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xffede6e2),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(45))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 25, top: 05),
                            child: Container(
                              child: Text(
                                'Your Recent Notes..',
                                style: TextStyle(
                                    fontFamily: 'Comforta',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              backgroundColor: Color(0xffd76633),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddMyNotes()));
                              },
                              label: Text(
                                'Add Note',
                                style: TextStyle(fontFamily: 'Comforta'),
                              ),
                              icon: Icon((Icons.add_circle_outlined)),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: mynotes.orderBy('created').snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return GridView.builder(
                                        shrinkWrap: false,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        itemCount: snapshot.hasData
                                            ? snapshot.data!.docs.length
                                            : 0,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot DbSnp =
                                              snapshot.data!.docs[index];

                                          DateTime myDate = (DbSnp.data()
                                                      as Map<String, dynamic>)[
                                                  'created']
                                              .toDate();
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyNotesViewer(
                                                                DbSnp: DbSnp,
                                                              )));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(03),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${DbSnp['title']}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Popins',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff524432),
                                                            fontSize: 13),
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                        thickness: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 02,
                                                                bottom: 05),
                                                        child: Container(
                                                          child: Text(
                                                            DateFormat.yMMMd()
                                                                .add_jm()
                                                                .format(myDate),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Comforta'),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 08,
                                                      ),
                                                      Text(
                                                        "${DbSnp['content']}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Inter'),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Expanded(
                                                        child: ListTile(
                                                          leading:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MyNotesVieweEdit(
                                                                              DbSnp: DbSnp)));
                                                            },
                                                            child: Icon(
                                                              Icons.edit_note,
                                                              color: Colors
                                                                  .green[900],
                                                            ),
                                                          ),
                                                          trailing:
                                                              GestureDetector(
                                                            onTap: () {
                                                              deleteNote(
                                                                  DbSnp.id);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .delete_sweep,
                                                              color: Colors
                                                                  .red[800],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                  return Text('There is no Notes');
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
