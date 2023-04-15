import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MyNotesViewer extends StatefulWidget {
  DocumentSnapshot DbSnp;

  MyNotesViewer({required this.DbSnp});

  @override
  State<MyNotesViewer> createState() => _MyNotesViewerState();
}

class _MyNotesViewerState extends State<MyNotesViewer> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  final myDate = DateTime.now();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.DbSnp['title']);

    _contentController = TextEditingController(text: widget.DbSnp['content']);

    super.initState();
  }

  CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('My Notes');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                backgroundColor: Color(0xffd76633),
                title: Text(
                  'My Notes',
                  style: TextStyle(fontFamily: 'Comforta', fontSize: 18),
                )),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      enabled: false,
                      enableInteractiveSelection: false,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter the Note Title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Popins',
                              fontWeight: FontWeight.bold,
                              color: Color(0xffd00000)),
                          hintStyle: TextStyle(
                              fontFamily: 'Comforta',
                              fontWeight: FontWeight.bold),
                          hintText: 'Note Title'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      DateFormat.yMMMd().add_jm().format(myDate),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Comforta'),
                    ),
                    TextFormField(
                      enabled: false,
                      enableInteractiveSelection: false,
                      controller: _contentController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Notes';
                        }

                        return null;
                      },
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontFamily: 'Popins',
                              fontWeight: FontWeight.bold,
                              color: Color(0xffd00000)),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: 'Comforta',
                              fontWeight: FontWeight.bold),
                          hintText: 'Enter the Notes'),
                    ),
                  ],
                ),
              ),
            )));
  }
}
