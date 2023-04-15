import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotesVieweEdit extends StatefulWidget {
  final DocumentSnapshot DbSnp;
  MyNotesVieweEdit({required this.DbSnp});

  @override
  State<MyNotesVieweEdit> createState() => _MyNotesVieweEditState();
}

class _MyNotesVieweEditState extends State<MyNotesVieweEdit> {
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        widget.DbSnp.reference.update({
          'title': _titleController.text,
          'content': _contentController.text,
          'created': myDate
        }).whenComplete(() => Navigator.pop(context));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note Updated Successfully!')),
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
                  'Edit Note',
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
                                fontFamily: 'Comforta',
                                fontWeight: FontWeight.bold),
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
                                fontFamily: 'Comforta',
                                fontWeight: FontWeight.bold),
                            hintText: 'Enter the Notes'),
                      ),
                    ]),
              ),
            )));
  }
}
