import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_note/Screens/Notes/mynotes_home.dart';

import 'firestoreserv.dart';

class MyNoteSearch extends StatefulWidget {
  @override
  _MyNoteSearchState createState() => _MyNoteSearchState();
}

class _MyNoteSearchState extends State<MyNoteSearch> {
  final FirestoreService _firestoreService = FirestoreService();

  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

  void _onSearchQueryChanged(String query) async {
    setState(() {
      _searchQuery = query;
      _searchResults = [];
    });

    if (query.isNotEmpty) {
      List<Map<String, dynamic>> results =
          await _firestoreService.searchItems(query);
      setState(() {
        _searchResults = results;
      });
    }
  }

  void _onItemTapped(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          id: item['id'],
          title: item['title'],
          content: item['content'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 23,
              )),
          backgroundColor: Color(0xffd76633),
          centerTitle: true,
          title: Text('Search your Notes',
              style: TextStyle(
                  fontFamily: 'Comfort'
                      'a',
                  fontSize: 18)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontFamily: 'Comforta'),
                  hintText: 'Enter the title of note',
                ),
                onChanged: _onSearchQueryChanged,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> item = _searchResults[index];
                    return ListTile(
                      title: Text(item['title']),
                      onTap: () => _onItemTapped(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String id;
  final String title;
  final String content;

  DetailPage({required this.id, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffd76633),
        title: Text('My Notes',
            style: TextStyle(fontFamily: 'Comforta', fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Popins'),
              ),
            ),
            Divider(
              indent: 08,
              thickness: 1.5,
              color: Color(0xff524432),
              height: 03,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
