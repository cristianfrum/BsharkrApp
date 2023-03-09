import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerProfileVisits {
  int visits;
  String id;
  List<GraphDate> dateList = [];
  List<GraphViews> viewsList = [];
  TrainerProfileVisits(DocumentSnapshot document) {
    this.visits = document['visits'] ?? 0;
    this.id = document['id'] ?? null;
    for (int i = 0; i < (document.data["graphDate"] as Map).length; ++i) {
      String key = (document.data["graphDate"] as Map).keys.toList()[i];
      Timestamp value = (document.data["graphDate"] as Map)[key];
      dateList.add(GraphDate(key, value));
    }
    for (int i = 0; i < (document.data["graphViews"] as Map).length; ++i) {
      String key = (document.data["graphViews"] as Map).keys.toList()[i];
      int value = (document.data["graphViews"] as Map)[key];
      viewsList.add(GraphViews(key, value));
    }
  }
}

class GraphDate {
  String number;
  Timestamp time;

  GraphDate(String number, Timestamp time) {
    this.number = number;
    this.time = time;
  }
}

class GraphViews {
  String number;
  int views;

  GraphViews(String number, int views) {
    this.number = number;
    this.views = views;
  }
}
