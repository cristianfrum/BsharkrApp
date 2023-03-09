import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance
        .collection('clientUsers')
        .where(
          'searchKeyFirstName',
          isEqualTo: searchField.substring(0, 1),
        )
        .where('role', isEqualTo: 'trainer')
        .getDocuments();
  }
}
