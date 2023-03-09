import 'package:cloud_firestore/cloud_firestore.dart';

class SearchServiceA {
  searchByA(String cautare) {
    return Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'client')
        .getDocuments();
  }
}
