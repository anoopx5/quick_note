import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('My Notes');

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    List<Map<String, dynamic>> items = [];

    final QuerySnapshot snapshot = await _collectionReference
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    snapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> item = document.data() as Map<String, dynamic>;
      item['id'] = document.id;
      items.add(item);
    });

    return items;
  }
}
