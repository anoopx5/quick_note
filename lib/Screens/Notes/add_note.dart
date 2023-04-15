import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quick_note/Screens/drawerHome.dart';
import 'package:intl/intl.dart';

class AddMyNotes extends StatefulWidget {
  @override
  _AddMyNotesState createState() => _AddMyNotesState();
}

class _AddMyNotesState extends State<AddMyNotes> {
  var title;
  var content;
  final CollectionReference mynotes =
      FirebaseFirestore.instance.collection('My Notes');
  final myDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('My Notes');

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _usersRef.add({
          'title': _titleController.text,
          'content': _contentController.text,
          'created': myDate
        }).whenComplete(() => Navigator.popAndPushNamed(context, '/'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note Saved Successfully!')),
        );
        _titleController.clear();
        _contentController.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/');
                },
                child: Icon(Icons.arrow_back)),
            backgroundColor: Color(0xffd76633),
            title: Text(
              'Add New Note',
              style: TextStyle(fontFamily: 'Comforta', fontSize: 18),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: _submitForm,
          child: Icon(Icons.save),
          backgroundColor: Color(0xffd76633),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
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
                          fontFamily: 'Comforta', fontWeight: FontWeight.bold),
                      hintText: 'Note Title'),
                ),
                SizedBox(height: 16),
                TextFormField(
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
                          fontFamily: 'Comforta', fontWeight: FontWeight.bold),
                      hintText: 'Enter the Notes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
