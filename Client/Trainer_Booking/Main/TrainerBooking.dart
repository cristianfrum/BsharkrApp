import 'dart:io';
import 'package:Bsharkr/Client/Trainer_Booking/Main/searchByName.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:app_review/app_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:Bsharkr/Client/Trainer_Booking/Voting_Page/Voting.dart';
import 'package:Bsharkr/models/TrainerProfileVisists.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/chatscreen.dart';
import '../../Congrats.dart';
import '../../ReviewTextError.dart';
import 'GeoLocation.dart/Geo.dart';

class TrainerBookingPage extends StatefulWidget {
  TrainerBookingPage({this.imClient});
  final ClientUser imClient;
  @override
  _TrainerBookingPageState createState() => new _TrainerBookingPageState();
}

class _TrainerBookingPageState extends State<TrainerBookingPage>
    with SingleTickerProviderStateMixin {
  _TrainerBookingPageState parent;
  bool semafor = true;
  var queryResultSet = [];
  var tempSearchStore = [];
  bool flag1 = false,
      flag2 = false,
      flag3 = false,
      flag4 = false,
      flag5 = false,
      flag6 = false,
      flag7 = false;

  getPermission() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    if (permissions.containsValue(PermissionStatus.denied)) {
      setState(() {
        permissionGranted = 'never ask';
      });
    }
    if (permissions.containsValue(PermissionStatus.granted)) {
      var location = new Location();
      var auxx, auxy;
      await location.getLocation().then((onValue) {
        auxx = onValue.latitude;
        auxy = onValue.longitude;
      });
      setState(() {
        x = auxx;
        y = auxy;

        permissionGranted = 'true';
      });
    }
  }

  Map<PermissionGroup, PermissionStatus> permissions;
  ServiceStatus serviceStatus;
  String permissionGranted;
  double x;
  double y;

  _getLocation() async {
    var location = new Location();
    try {
      await location.getLocation().then((onValue) {
        setState(() {
          x = onValue.latitude;
          y = onValue.longitude;

          permissionGranted = 'true';
        });
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        setState(() {
          permissionGranted = 'false';
        });
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        setState(() {
          permissionGranted = 'never ask';
        });
      }
    }
  }

  bool pressed1 = false;
  bool pressed2 = false;
  bool pressed3 = false;
  bool pressed4 = false;
  bool pressed5 = false;
  bool pressed6 = false;
  bool pressed7 = false;

  List<TrainerUser> firstButton = [];
  List<TrainerUser> secondButton = [];
  List<TrainerUser> thirdButton = [];
  List<TrainerUser> fourthButton = [];
  List<TrainerUser> fifthButton = [];
  List<TrainerUser> sixthButton = [];
  List<TrainerUser> seventhButton = [];
  bool loading = false;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  bool notLoading = false;
  bool extractedAlreadyAnySpecialization = false;
  bool extractedAlreadyWorkout = false;
  bool extractedAlreadyAerobics = false;
  bool extractedAlreadyZumba = false;
  bool extractedAlreadyTrx = false;
  bool extractedAlreadyKangooJumps = false;
  bool extractedAlreadyPilates = false;

  var db = Firestore.instance;
  _getTrainersAnySpecialization() async {
    setState(() {
      loading = true;
    });
    if (extractedAlreadyAnySpecialization == false) {
      GeoPoint sw, ne;

      GeoPoint center = GeoPoint(x, y);
      sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
          boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
      ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
          boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
      QuerySnapshot query = await Firestore.instance
          .collection('clientUsers')
          .where('role', isEqualTo: 'trainer')
          .where('location.geopoint', isGreaterThan: sw)
          .where('location.geopoint', isLessThan: ne)
          .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
          .limit(200)
          .getDocuments();

      for (int i = 0; i < query.documents.length - 1; i++) {
        for (int j = i + 1; j < query.documents.length; j++) {
          if (TrainerUser(query.documents[i]).rating <
              TrainerUser(query.documents[j]).rating) {
            var aux = query.documents[i];
            query.documents[i] = query.documents[j];
            query.documents[j] = aux;
          }
        }
      }
      query.documents.forEach((element) async {
          tempSearchStore.add(TrainerUser(element));
          firstButton.add(TrainerUser(element));
      });
      for (int i = 0;
          i < (query.documents.length < 5 ? query.documents.length : 5);
          i++) {
        if (updatedProfileViewsAny[i] == 0 && controller.index == 0) {
          updateVisits(tempSearchStore[i].id);
          updatedProfileViewsAny[i] = 1;
        }
      }
      setState(() {
        flag1 = true;
        pressed1 = true;
        loading = false;
      });
    }
  }

  _getTrainersWorkout() async {
    setState(() {
      loading = true;
    });
    GeoPoint sw, ne;

    GeoPoint center = GeoPoint(x, y);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'trainer')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .where('specialization.workout', isEqualTo: true)
        .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
        .limit(100)
        .getDocuments();
    for (int i = 0; i < query.documents.length - 1; i++) {
      for (int j = i + 1; j < query.documents.length; j++) {
        if (TrainerUser(query.documents[i]).rating <
            TrainerUser(query.documents[j]).rating) {
          var aux = query.documents[i];
          query.documents[i] = query.documents[j];
          query.documents[j] = aux;
        }
      }
    }
    query.documents.forEach((element) {
      tempSearchStore.add(TrainerUser(element));
      secondButton.add(TrainerUser(element));
    });
    for (int i = 0;
        i < (query.documents.length < 5 ? query.documents.length : 5);
        i++) {
      if (updatedProfileViewsWorkout[i] == 0 && controller.index == 0) {
        updateVisits(tempSearchStore[i].id);
        updatedProfileViewsWorkout[i] = 1;
      }
    }
    setState(() {
      flag2 = true;
      pressed2 = true;
      loading = false;
    });
  }

  _getTrainersAerobics() async {
    setState(() {
      loading = true;
    });
    GeoPoint sw, ne;

    GeoPoint center = GeoPoint(x, y);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'trainer')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .where('specialization.aerobic', isEqualTo: true)
        .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
        .limit(100)
        .getDocuments();
    for (int i = 0; i < query.documents.length - 1; i++) {
      for (int j = i + 1; j < query.documents.length; j++) {
        if (TrainerUser(query.documents[i]).rating <
            TrainerUser(query.documents[j]).rating) {
          var aux = query.documents[i];
          query.documents[i] = query.documents[j];
          query.documents[j] = aux;
        }
      }
    }
    query.documents.forEach((element) {
      tempSearchStore.add(TrainerUser(element));
      thirdButton.add(TrainerUser(element));
    });
    for (int i = 0;
        i < (query.documents.length < 5 ? query.documents.length : 5);
        i++) {
      if (updatedProfileViewsAerobics[i] == 0 && controller.index == 0) {
        updateVisits(tempSearchStore[i].id);
        updatedProfileViewsAerobics[i] = 1;
      }
    }
    setState(() {
      flag3 = true;
      pressed3 = true;
      loading = false;
    });
  }

  _getTrainerZumba() async {
    setState(() {
      loading = true;
    });
    GeoPoint sw, ne;

    GeoPoint center = GeoPoint(x, y);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'trainer')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .where('specialization.zumba', isEqualTo: true)
        .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
        .limit(100)
        .getDocuments();
    for (int i = 0; i < query.documents.length - 1; i++) {
      for (int j = i + 1; j < query.documents.length; j++) {
        if (TrainerUser(query.documents[i]).rating <
            TrainerUser(query.documents[j]).rating) {
          var aux = query.documents[i];
          query.documents[i] = query.documents[j];
          query.documents[j] = aux;
        }
      }
    }
    query.documents.forEach((element) {
      tempSearchStore.add(TrainerUser(element));
      fourthButton.add(TrainerUser(element));
    });
    for (int i = 0;
        i < (query.documents.length < 5 ? query.documents.length : 5);
        i++) {
      if (updatedProfileViewsZumba[i] == 0 && controller.index == 0) {
        updateVisits(tempSearchStore[i].id);
        updatedProfileViewsZumba[i] = 1;
      }
    }
    setState(() {
      flag4 = true;
      pressed4 = true;
      loading = false;
    });
  }

  _getTrainerTrx() async {
    setState(() {
      loading = true;
    });
    GeoPoint sw, ne;

    GeoPoint center = GeoPoint(x, y);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'trainer')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .where('specialization.trx', isEqualTo: true)
        .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
        .limit(100)
        .getDocuments();
    for (int i = 0; i < query.documents.length - 1; i++) {
      for (int j = i + 1; j < query.documents.length; j++) {
        if (TrainerUser(query.documents[i]).rating <
            TrainerUser(query.documents[j]).rating) {
          var aux = query.documents[i];
          query.documents[i] = query.documents[j];
          query.documents[j] = aux;
        }
      }
    }
    query.documents.forEach((element) {
      tempSearchStore.add(TrainerUser(element));
      fifthButton.add(TrainerUser(element));
    });
    for (int i = 0;
        i < (query.documents.length < 5 ? query.documents.length : 5);
        i++) {
      if (updatedProfileViewsTrx[i] == 0 && controller.index == 0) {
        updateVisits(tempSearchStore[i].id);
        updatedProfileViewsTrx[i] = 1;
      }
    }
    setState(() {
      flag5 = true;
      pressed5 = true;
      loading = false;
    });
  }

  _getTrainerKangooJumps() async {
    setState(() {
      loading = true;
    });
    GeoPoint sw, ne;

    GeoPoint center = GeoPoint(x, y);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'trainer')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .where('specialization.kangooJumps', isEqualTo: true)
        .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
        .limit(100)
        .getDocuments();
    for (int i = 0; i < query.documents.length - 1; i++) {
      for (int j = i + 1; j < query.documents.length; j++) {
        if (TrainerUser(query.documents[i]).rating <
            TrainerUser(query.documents[j]).rating) {
          var aux = query.documents[i];
          query.documents[i] = query.documents[j];
          query.documents[j] = aux;
        }
      }
    }

    query.documents.forEach((element) {
      tempSearchStore.add(TrainerUser(element));
      sixthButton.add(TrainerUser(element));
    });
    for (int i = 0;
        i < (query.documents.length < 5 ? query.documents.length : 5);
        i++) {
      if (updatedProfileViewsKangooJumps[i] == 0 && controller.index == 0) {
        updateVisits(tempSearchStore[i].id);
        updatedProfileViewsKangooJumps[i] = 1;
      }
    }
    setState(() {
      flag6 = true;
      pressed6 = true;
      loading = false;
    });
  }

  _getTrainerPilates() async {
    setState(() {
      loading = true;
    });
    GeoPoint sw, ne;

    GeoPoint center = GeoPoint(x, y);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'trainer')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .where('specialization.pilates', isEqualTo: true)
        .where('approved', isEqualTo: true)
          .where('pendingDeletion', isEqualTo: false)
        .limit(100)
        .getDocuments();
    for (int i = 0; i < query.documents.length - 1; i++) {
      for (int j = i + 1; j < query.documents.length; j++) {
        if (TrainerUser(query.documents[i]).rating <
            TrainerUser(query.documents[j]).rating) {
          var aux = query.documents[i];
          query.documents[i] = query.documents[j];
          query.documents[j] = aux;
        }
      }
    }

    query.documents.forEach((element) {
      tempSearchStore.add(TrainerUser(element));
      seventhButton.add(TrainerUser(element));
    });
    for (int i = 0;
        i < (query.documents.length < 5 ? query.documents.length : 5);
        i++) {
      if (updatedProfileViewsPilates[i] == 0 && controller.index == 0) {
        updateVisits(tempSearchStore[i].id);
        updatedProfileViewsPilates[i] = 1;
      }
    }
    setState(() {
      flag7 = true;
      pressed7 = true;
      loading = false;
    });
  }

  updateVisits(String trainerId) async {
    QuerySnapshot query = await Firestore.instance
        .collection('profileVisits')
        .where('id', isEqualTo: trainerId)
        .getDocuments();
    if (query.documents.length != 0) {
      await Firestore.instance
          .collection('profileVisits')
          .document(trainerId)
          .updateData(
        {
          'visits': TrainerProfileVisits(query.documents[0]).visits + 1,
          'graphViews.30': TrainerProfileVisits(query.documents[0])
                  .viewsList
                  .where((element) => element.number == '30')
                  .toList()[0]
                  .views +
              1,
          'id': trainerId
        },
      );
    }
  }

  updateClassesVisits(String trainerId) async {
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('id', isEqualTo: trainerId)
        .getDocuments();
    if (query.documents.length != 0) {
      await Firestore.instance
          .collection('profileVisits')
          .document(trainerId)
          .updateData(
        {
          'visits': TrainerProfileVisits(query.documents[0]).visits + 1,
          'graphViews.30': TrainerProfileVisits(query.documents[0])
                  .viewsList
                  .where((element) => element.number == '30')
                  .toList()[0]
                  .views +
              1,
          'id': trainerId
        },
      );
    }
  }

  double finalScrollAnySpecialization = 0;
  double finalScrollZumba = 0;
  double finalScrollWorkout = 0;
  double finalScrollAerobics = 0;
  double finalScrollTrx = 0;
  double finalScrollKangooJumps = 0;
  double finalScrollPilates = 0;
  int pagePilates = 1;
  int pageAny = 1;
  int pageWorkout = 1;
  int pageAerobics = 1;
  int pageZumba = 1;
  int pageTrx = 1;
  int pageKangooJumps = 1;
  double currentScrollAny = 0;
  double currentScrollWorkout = 0;
  double currentScrollAerobics = 0;
  double currentScrollZumba = 0;
  double currentScrollPilates = 0;
  double currentScrollKangooJumps = 0;
  double currentScrollTrx = 0;
  bool enableAnyScroll = false;
  bool enableWorkoutScroll = false;
  bool enableAerobicsScroll = false;
  bool enableZumbaScroll = false;
  bool enablePilatesScroll = false;
  bool enableKangooJumpsScroll = false;
  bool enableTrxScroll = false;
  int counterAny = -1;
  int counterWorkout = -1;
  int counterZumba = -1;
  int counterPilates = -1;
  int counterKangooJumps = -1;
  int counterTrx = -1;
  int counterAerobics = -1;
  List<int> updatedProfileViewsAny = new List.filled(100, 0, growable: true);
  List<int> updatedProfileViewsWorkout =
      new List.filled(100, 0, growable: true);
  List<int> updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
  List<int> updatedProfileViewsPilates =
      new List.filled(100, 0, growable: true);
  List<int> updatedProfileViewsKangooJumps =
      new List.filled(100, 0, growable: true);
  List<int> updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
  List<int> updatedProfileViewsAerobics =
      new List.filled(100, 0, growable: true);
  bool flagPlaceholder = false;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
    if (Platform.isAndroid) {
      _getLocation();
    }
    if (Platform.isIOS) {
      getPermission();
    }
    queryResultSet = [];
    tempSearchStore = [];
    _scrollController.addListener(() {
      if (controller.index == 0) {
        if (enableAnyScroll == true) {
          currentScrollAny = _scrollController.position.pixels;

          while ((currentScrollAny * prefs.getDouble('height') -
                  150 * prefs.getDouble('height')) >
              (counterAny * 93 * prefs.getDouble('height'))) {
            counterAny++;
          }
          if (counterAny != -1) {
            if (updatedProfileViewsAny[5 + counterAny] == 0) {
              updateVisits(tempSearchStore[5 + counterAny].id);
              updatedProfileViewsAny[5 + counterAny] = 1;
            }
          }
        }

        if (enableWorkoutScroll == true) {
          currentScrollWorkout = _scrollController.position.pixels;

          while (currentScrollWorkout * prefs.getDouble('height') -
                  150 * prefs.getDouble('height') >
              counterWorkout * 93 * prefs.getDouble('height')) {
            counterWorkout++;
          }
          if (counterWorkout != -1) {
            if (updatedProfileViewsWorkout[5 + counterWorkout] == 0) {
              updateVisits(tempSearchStore[5 + counterWorkout].id);
              updatedProfileViewsWorkout[5 + counterWorkout] = 1;
            }
          }
        }

        if (enableAerobicsScroll == true) {
          currentScrollAerobics = _scrollController.position.pixels;

          while (currentScrollAerobics * prefs.getDouble('height') -
                  150 * prefs.getDouble('height') >
              counterAerobics * 93 * prefs.getDouble('height')) {
            counterAerobics++;
          }
          if (counterAerobics != -1) {
            if (updatedProfileViewsAerobics[5 + counterAerobics] == 0) {
              updateVisits(tempSearchStore[5 + counterAerobics].id);
              updatedProfileViewsAerobics[5 + counterAerobics] = 1;
            }
          }
        }

        if (enableZumbaScroll == true) {
          currentScrollZumba = _scrollController.position.pixels;

          while (currentScrollZumba * prefs.getDouble('height') -
                  150 * prefs.getDouble('height') >
              counterZumba * 93 * prefs.getDouble('height')) {
            counterZumba++;
          }
          if (counterZumba != -1) {
            if (updatedProfileViewsZumba[5 + counterZumba] == 0) {
              updateVisits(tempSearchStore[5 + counterZumba].id);
              updatedProfileViewsZumba[5 + counterZumba] = 1;
            }
          }
        }

        if (enableTrxScroll == true) {
          currentScrollTrx = _scrollController.position.pixels;

          while (currentScrollTrx * prefs.getDouble('height') -
                  150 * prefs.getDouble('height') >
              counterTrx * 93 * prefs.getDouble('height')) {
            counterTrx++;
          }
          if (counterTrx != -1) {
            if (updatedProfileViewsTrx[5 + counterTrx] == 0) {
              updateVisits(tempSearchStore[5 + counterTrx].id);
              updatedProfileViewsTrx[5 + counterTrx] = 1;
            }
          }
        }

        if (enableKangooJumpsScroll == true) {
          currentScrollKangooJumps = _scrollController.position.pixels;

          while (currentScrollKangooJumps * prefs.getDouble('height') -
                  150 * prefs.getDouble('height') >
              counterKangooJumps * 93 * prefs.getDouble('height')) {
            counterKangooJumps++;
          }
          if (counterKangooJumps != -1) {
            if (updatedProfileViewsKangooJumps[5 + counterKangooJumps] == 0) {
              updateVisits(tempSearchStore[5 + counterKangooJumps].id);
              updatedProfileViewsKangooJumps[5 + counterKangooJumps] = 1;
            }
          }
        }

        if (enablePilatesScroll == true) {
          currentScrollPilates = _scrollController.position.pixels;

          while (currentScrollPilates * prefs.getDouble('height') -
                  150 * prefs.getDouble('height') >
              counterPilates * 93 * prefs.getDouble('height')) {
            counterPilates++;
          }
          if (counterPilates != -1) {
            if (updatedProfileViewsPilates[5 + counterPilates] == 0) {
              updateVisits(tempSearchStore[5 + counterPilates].id);
              updatedProfileViewsPilates[5 + counterPilates] = 1;
            }
          }
        }
      }
    });
  }

  bool flagPh1 = false,
      flagPh2 = false,
      flagPh3 = false,
      flagPh4 = false,
      flagPh5 = false,
      flagPh6 = false,
      flagPh7 = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TabController controller;
  @override
  Widget build(BuildContext context) {
    flagPlaceholder = false;
    flagPh1 = false;
    flagPh2 = false;
    flagPh3 = false;
    flagPh4 = false;
    flagPh5 = false;
    flagPh6 = false;
    flagPh7 = false;
    return permissionGranted == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(prefix0.mainColor),
              ),
            ),
            color: prefix0.backgroundColor,
          )
        : permissionGranted == 'never ask'
            ? Scaffold(
                backgroundColor: prefix0.backgroundColor,
                appBar: AppBar(
                  backgroundColor: prefix0.backgroundColor,
                  elevation: 0.0,
                  title: Center(
                    child: Text(
                      "Search",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22 * prefs.getDouble('height'),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                body: Container(
                  color: prefix0.backgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: SvgPicture.asset(
                          'assets/bookingPlaceholderf1.svg',
                          width: 200.0 * prefs.getDouble('width'),
                          height: 150.0 * prefs.getDouble('height'),
                        ),
                      ),
                      SizedBox(
                        height: 30 * prefs.getDouble('height'),
                      ),
                      Text(
                        "Locatia nu este accesibila",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20 * prefs.getDouble('height'),
                            letterSpacing: -0.75),
                      ),
                      SizedBox(height: 20 * prefs.getDouble('height')),
                      Center(
                        child: Container(
                          width: 250 * prefs.getDouble('width'),
                          child: Text(
                            "Pentru ca lista antrenorilor sa fie relevanta, avem nevoie de permisiune pentru a accesa locatia.",
                            style: TextStyle(
                                fontSize: 15.0 * prefs.getDouble('height'),
                                color: Color.fromARGB(150, 255, 255, 255),
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48 * prefs.getDouble('height'),
                      ),
                      InkWell(
                        onTap: () async {
                          await PermissionHandler().openAppSettings();
                          setState(() {});
                        },
                        child: Container(
                          height: 60 * prefs.getDouble('height'),
                          width: 210 * prefs.getDouble('width'),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: prefix0.mainColor),
                          child: Center(
                            child: Text(
                              "Setarile aplicatiei",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0 * prefs.getDouble('height'),
                                  color: Colors.white,
                                  letterSpacing: -0.408),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : permissionGranted == 'true'
                ? Scaffold(
                    backgroundColor: prefix0.backgroundColor,
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(90.0),
                      child: AppBar(
                        backgroundColor: prefix0.backgroundColor,
                        elevation: 0.0,
                        title: Text(
                          "Search",
                          style: TextStyle(
                              fontSize: 24 * prefs.getDouble('height'),
                              letterSpacing: -0.8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        bottom: TabBar(
                            indicatorColor: prefix0.mainColor,
                            controller: controller,
                            tabs: <Widget>[
                              Tab(
                                text: "Personal trainers",
                              ),
                              Tab(
                                text: "Group classes",
                              )
                            ]),
                        centerTitle: true,
                        actions: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SearchByName(
                                          x: x,
                                          y: y,
                                          imClient: widget.imClient),
                                ),
                              );
                            },
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right: 16 * prefs.getDouble('width')),
                                child: Icon(
                                  Icons.search,
                                  size: 28 * prefs.getDouble('height'),
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                    body: Builder(
                        builder: (context) => IgnorePointer(
                              ignoring: loading,
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  TabBarView(
                                    controller: controller,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        },
                                        child: Container(
                                          color: prefix0.backgroundColor,
                                          child: ListView(
                                            controller: _scrollController,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 64 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    child: Stack(
                                                      overflow:
                                                          Overflow.visible,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 16 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              top: 16 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                          child: SizedBox(
                                                            width: 410 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            height: 42 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 150 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag1 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () {
                                                                                tempSearchStore = [];
                                                                                if (pressed1 == false) {
                                                                                  flag1 = true;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = true;
                                                                                  enableWorkoutScroll = false;
                                                                                  enableAerobicsScroll = false;
                                                                                  enableKangooJumpsScroll = false;
                                                                                  enablePilatesScroll = false;
                                                                                  enableTrxScroll = false;
                                                                                  enableZumbaScroll = false;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  _getTrainersAnySpecialization();
                                                                                } else {
                                                                                  setState(() {
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    enableAnyScroll = true;
                                                                                    enableWorkoutScroll = false;
                                                                                    enableAerobicsScroll = false;
                                                                                    enableKangooJumpsScroll = false;
                                                                                    enablePilatesScroll = false;
                                                                                    enableTrxScroll = false;
                                                                                    enableZumbaScroll = false;
                                                                                    flag1 = true;
                                                                                    flag2 = false;
                                                                                    flag3 = false;
                                                                                    flag4 = false;
                                                                                    flag5 = false;
                                                                                    flag6 = false;
                                                                                    flag7 = false;
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    firstButton.forEach((element) {
                                                                                      tempSearchStore.add(element);
                                                                                    });
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    _scrollController.animateTo(
                                                                                      0.0,
                                                                                      curve: Curves.easeOut,
                                                                                      duration: const Duration(milliseconds: 300),
                                                                                    );
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Any specialization",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 87 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag2 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () async {
                                                                                tempSearchStore = [];
                                                                                if (pressed2 == false) {
                                                                                  _getTrainersWorkout();
                                                                                  flag1 = false;
                                                                                  flag2 = true;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = false;
                                                                                  enableWorkoutScroll = true;
                                                                                  enableAerobicsScroll = false;
                                                                                  enableKangooJumpsScroll = false;
                                                                                  enablePilatesScroll = false;
                                                                                  enableTrxScroll = false;
                                                                                  enableZumbaScroll = false;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                } else {
                                                                                  setState(() {
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    enableAnyScroll = false;
                                                                                    enableWorkoutScroll = true;
                                                                                    enableAerobicsScroll = false;
                                                                                    enableKangooJumpsScroll = false;
                                                                                    enablePilatesScroll = false;
                                                                                    enableTrxScroll = false;
                                                                                    enableZumbaScroll = false;
                                                                                    flag1 = false;
                                                                                    flag2 = true;
                                                                                    flag3 = false;
                                                                                    flag4 = false;
                                                                                    flag5 = false;
                                                                                    flag6 = false;
                                                                                    flag7 = false;
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    secondButton.forEach((element) {
                                                                                      tempSearchStore.add(element);
                                                                                    });
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Workout",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 90 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag3 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () {
                                                                                tempSearchStore = [];
                                                                                if (pressed3 == false) {
                                                                                  _getTrainersAerobics();
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = true;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = false;
                                                                                  enableWorkoutScroll = false;
                                                                                  enableAerobicsScroll = true;
                                                                                  enableKangooJumpsScroll = false;
                                                                                  enablePilatesScroll = false;
                                                                                  enableTrxScroll = false;
                                                                                  enableZumbaScroll = false;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                } else {
                                                                                  setState(() {
                                                                                    flag1 = false;
                                                                                    flag2 = false;
                                                                                    flag3 = true;
                                                                                    flag4 = false;
                                                                                    flag5 = false;
                                                                                    flag6 = false;
                                                                                    flag7 = false;
                                                                                    tempSearchStore = thirdButton;
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    enableAnyScroll = false;
                                                                                    enableWorkoutScroll = false;
                                                                                    enableAerobicsScroll = true;
                                                                                    enableKangooJumpsScroll = false;
                                                                                    enablePilatesScroll = false;
                                                                                    enableTrxScroll = false;
                                                                                    enableZumbaScroll = false;
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Aerobics",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 77 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag4 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () {
                                                                                tempSearchStore = [];
                                                                                if (pressed4 == false) {
                                                                                  _getTrainerZumba();
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = true;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = false;
                                                                                  enableWorkoutScroll = false;
                                                                                  enableAerobicsScroll = false;
                                                                                  enableKangooJumpsScroll = false;
                                                                                  enablePilatesScroll = false;
                                                                                  enableTrxScroll = false;
                                                                                  enableZumbaScroll = true;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                } else {
                                                                                  setState(() {
                                                                                    flag1 = false;
                                                                                    flag2 = false;
                                                                                    flag3 = false;
                                                                                    flag4 = true;
                                                                                    flag5 = false;
                                                                                    flag6 = false;
                                                                                    flag7 = false;
                                                                                    tempSearchStore = fourthButton;
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    enableAnyScroll = false;
                                                                                    enableWorkoutScroll = false;
                                                                                    enableAerobicsScroll = false;
                                                                                    enableKangooJumpsScroll = false;
                                                                                    enablePilatesScroll = false;
                                                                                    enableTrxScroll = false;
                                                                                    enableZumbaScroll = true;
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Zumba",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 75 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag5 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () {
                                                                                tempSearchStore = [];
                                                                                if (pressed5 == false) {
                                                                                  _getTrainerTrx();
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = true;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = false;
                                                                                  enableWorkoutScroll = false;
                                                                                  enableAerobicsScroll = false;
                                                                                  enableKangooJumpsScroll = false;
                                                                                  enablePilatesScroll = false;
                                                                                  enableTrxScroll = true;
                                                                                  enableZumbaScroll = false;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                } else {
                                                                                  setState(() {
                                                                                    flag1 = false;
                                                                                    flag2 = false;
                                                                                    flag3 = false;
                                                                                    flag4 = false;
                                                                                    flag5 = true;
                                                                                    flag6 = false;
                                                                                    flag7 = false;
                                                                                    tempSearchStore = fifthButton;
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    enableAnyScroll = false;
                                                                                    enableWorkoutScroll = false;
                                                                                    enableAerobicsScroll = false;
                                                                                    enableKangooJumpsScroll = false;
                                                                                    enablePilatesScroll = false;
                                                                                    enableTrxScroll = true;
                                                                                    enableZumbaScroll = false;
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "TRX",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 130 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag6 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () {
                                                                                tempSearchStore = [];
                                                                                if (pressed6 == false) {
                                                                                  _getTrainerKangooJumps();
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = true;
                                                                                  flag7 = false;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = false;
                                                                                  enableWorkoutScroll = false;
                                                                                  enableAerobicsScroll = false;
                                                                                  enableKangooJumpsScroll = true;
                                                                                  enablePilatesScroll = false;
                                                                                  enableTrxScroll = false;
                                                                                  enableZumbaScroll = false;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                } else {
                                                                                  setState(() {
                                                                                    flag1 = false;
                                                                                    flag2 = false;
                                                                                    flag3 = false;
                                                                                    flag4 = false;
                                                                                    flag5 = false;
                                                                                    flag6 = true;
                                                                                    flag7 = false;
                                                                                    tempSearchStore = sixthButton;
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    enableAnyScroll = false;
                                                                                    enableWorkoutScroll = false;
                                                                                    enableAerobicsScroll = false;
                                                                                    enableKangooJumpsScroll = true;
                                                                                    enablePilatesScroll = false;
                                                                                    enableTrxScroll = false;
                                                                                    enableZumbaScroll = false;
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Kangoo Jumps",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          right: 8 *
                                                                              prefs.getDouble(
                                                                                  'width')),
                                                                      child:
                                                                          Container(
                                                                        width: 80 *
                                                                            prefs.getDouble('width'),
                                                                        height: 42 *
                                                                            prefs.getDouble('height'),
                                                                        child:
                                                                            Material(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                          color: flag7 == false
                                                                              ? prefix0.secondaryColor
                                                                              : prefix0.mainColor,
                                                                          child: MaterialButton(
                                                                              onPressed: () {
                                                                                tempSearchStore = [];
                                                                                if (pressed7 == false) {
                                                                                  _getTrainerPilates();
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = true;
                                                                                  updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                  updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                  currentScrollAny = 0;
                                                                                  currentScrollWorkout = 0;
                                                                                  currentScrollZumba = 0;
                                                                                  currentScrollPilates = 0;
                                                                                  currentScrollKangooJumps = 0;
                                                                                  currentScrollTrx = 0;
                                                                                  currentScrollAerobics = 0;
                                                                                  enableAnyScroll = false;
                                                                                  enableWorkoutScroll = false;
                                                                                  enableAerobicsScroll = false;
                                                                                  enableKangooJumpsScroll = false;
                                                                                  enablePilatesScroll = true;
                                                                                  enableTrxScroll = false;
                                                                                  enableZumbaScroll = false;
                                                                                  counterAny = -1;
                                                                                  counterWorkout = -1;
                                                                                  counterPilates = -1;
                                                                                  counterZumba = -1;
                                                                                  counterKangooJumps = -1;
                                                                                  counterTrx = -1;
                                                                                  counterAerobics = -1;
                                                                                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                } else {
                                                                                  setState(() {
                                                                                    flag1 = false;
                                                                                    flag2 = false;
                                                                                    flag3 = false;
                                                                                    flag4 = false;
                                                                                    flag5 = false;
                                                                                    flag6 = false;
                                                                                    flag7 = true;
                                                                                    tempSearchStore = seventhButton;
                                                                                    for (int i = 0; i < ((tempSearchStore.length < 5) ? tempSearchStore.length : 5); i++) {
                                                                                      updateVisits(tempSearchStore[i].id);
                                                                                    }
                                                                                    updatedProfileViewsAny = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsWorkout = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsZumba = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsPilates = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsKangooJumps = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsTrx = new List.filled(100, 0, growable: true);
                                                                                    updatedProfileViewsAerobics = new List.filled(100, 0, growable: true);
                                                                                    currentScrollAny = 0;
                                                                                    currentScrollWorkout = 0;
                                                                                    currentScrollZumba = 0;
                                                                                    currentScrollPilates = 0;
                                                                                    currentScrollKangooJumps = 0;
                                                                                    currentScrollTrx = 0;
                                                                                    currentScrollAerobics = 0;
                                                                                    enableAnyScroll = false;
                                                                                    enableWorkoutScroll = false;
                                                                                    enableAerobicsScroll = false;
                                                                                    enableKangooJumpsScroll = false;
                                                                                    enablePilatesScroll = true;
                                                                                    enableTrxScroll = false;
                                                                                    enableZumbaScroll = false;
                                                                                    counterAny = -1;
                                                                                    counterWorkout = -1;
                                                                                    counterPilates = -1;
                                                                                    counterZumba = -1;
                                                                                    counterKangooJumps = -1;
                                                                                    counterTrx = -1;
                                                                                    counterAerobics = -1;
                                                                                    _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Pilates",
                                                                                    style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        ),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8 *
                                                            prefs.getDouble(
                                                                'height')),
                                                    child: Column(
                                                      children: tempSearchStore
                                                                  .length !=
                                                              0
                                                          ? tempSearchStore.map(
                                                              (element) {
                                                                return buildItem(
                                                                    element);
                                                              },
                                                            ).toList()
                                                          : (flag1 == true ||
                                                                  flag2 ==
                                                                      true ||
                                                                  flag3 ==
                                                                      true ||
                                                                  flag4 ==
                                                                      true ||
                                                                  flag5 ==
                                                                      true ||
                                                                  flag6 ==
                                                                      true ||
                                                                  flag7 == true)
                                                              ? loading == false
                                                                  ? [
                                                                      Container(
                                                                        height: 500 *
                                                                            prefs.getDouble('height'),
                                                                        color:
                                                                            backgroundColor,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              SvgPicture.asset(
                                                                                'assets/noTrainerBookingf1.svg',
                                                                                width: 350.0 * prefs.getDouble('width'),
                                                                                height: 200.0 * prefs.getDouble('height'),
                                                                              ),
                                                                              SizedBox(height: 16 * prefs.getDouble('height')),
                                                                              Text("No trainers", style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.75, fontSize: 20 * prefs.getDouble('height'), color: Colors.white)),
                                                                              SizedBox(height: 8 * prefs.getDouble('height')),
                                                                              Container(
                                                                                margin: EdgeInsets.symmetric(horizontal: 32 * prefs.getDouble('width')),
                                                                                width: 375 * prefs.getDouble('width'),
                                                                                child: Text(
                                                                                  "No trainers in your local area that match your search.",
                                                                                  style: TextStyle(letterSpacing: 0.75, fontSize: 13 * prefs.getDouble('height'), color: Color.fromARGB(200, 255, 255, 255), fontFamily: 'Roboto'),
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 3,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ]
                                                                  : [
                                                                      Container()
                                                                    ]
                                                              : (flag1 == false &&
                                                                      flag2 ==
                                                                          false &&
                                                                      flag3 ==
                                                                          false &&
                                                                      flag4 ==
                                                                          false &&
                                                                      flag5 ==
                                                                          false &&
                                                                      flag6 ==
                                                                          false &&
                                                                      flag7 ==
                                                                          false)
                                                                  ? [
                                                                      Container(
                                                                        height: 500 *
                                                                            prefs.getDouble('height'),
                                                                        color:
                                                                            backgroundColor,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              SvgPicture.asset(
                                                                                'assets/mainBookingf1.svg',
                                                                                width: 350.0 * prefs.getDouble('width'),
                                                                                height: 150.0 * prefs.getDouble('height'),
                                                                              ),
                                                                              SizedBox(height: 16 * prefs.getDouble('height')),
                                                                              Padding(padding: EdgeInsets.symmetric(horizontal: 52 * prefs.getDouble('width')), child: Text("You are one tap away to find your ideal trainer", style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.75, fontSize: 20 * prefs.getDouble('height'), color: Colors.white), textAlign: TextAlign.center)),
                                                                              SizedBox(height: 32 * prefs.getDouble('height')),
                                                                              Container(
                                                                                margin: EdgeInsets.symmetric(horizontal: 32 * prefs.getDouble('width')),
                                                                                width: 375 * prefs.getDouble('width'),
                                                                                child: Text(
                                                                                  "Choose which specialization you want your trainer to master. Please note that you can have multiple trainers at the same time.",
                                                                                  style: TextStyle(letterSpacing: 0.75, fontSize: 13 * prefs.getDouble('height'), color: Color.fromARGB(200, 255, 255, 255), fontFamily: 'Roboto'),
                                                                                  textAlign: TextAlign.center,
                                                                                  maxLines: 3,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ]
                                                                  : [
                                                                      Container()
                                                                    ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        },
                                        child: Container(
                                          color: prefix0.backgroundColor,
                                          child: ListView(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Stack(
                                                    overflow: Overflow.visible,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 16 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            top: 16 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        child: SizedBox(
                                                          width: 410 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          height: 42 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag1 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () {
                                                                              tempSearchStore = [];
                                                                              if (pressed1 == false) {
                                                                                _getTrainersAnySpecialization();
                                                                                flag1 = true;
                                                                                flag2 = false;
                                                                                flag3 = false;
                                                                                flag4 = false;
                                                                                flag5 = false;
                                                                                flag6 = false;
                                                                                flag7 = false;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = true;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  tempSearchStore = firstButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Any specialization",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 87 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag2 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () async {
                                                                              tempSearchStore = [];
                                                                              if (pressed2 == false) {
                                                                                _getTrainersWorkout();
                                                                                flag1 = false;
                                                                                flag2 = true;
                                                                                flag3 = false;
                                                                                flag4 = false;
                                                                                flag5 = false;
                                                                                flag6 = false;
                                                                                flag7 = false;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  flag2 = true;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  tempSearchStore = secondButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Workout",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 90 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag3 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () {
                                                                              tempSearchStore = [];
                                                                              if (pressed3 == false) {
                                                                                _getTrainersAerobics();
                                                                                flag1 = false;
                                                                                flag2 = false;
                                                                                flag3 = true;
                                                                                flag4 = false;
                                                                                flag5 = false;
                                                                                flag6 = false;
                                                                                flag7 = false;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = true;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  tempSearchStore = thirdButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Aerobics",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 77 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag4 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () {
                                                                              tempSearchStore = [];
                                                                              if (pressed4 == false) {
                                                                                _getTrainerZumba();
                                                                                flag1 = false;
                                                                                flag2 = false;
                                                                                flag3 = false;
                                                                                flag4 = true;
                                                                                flag5 = false;
                                                                                flag6 = false;
                                                                                flag7 = false;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = true;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  tempSearchStore = fourthButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Zumba",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 75 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag5 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () {
                                                                              tempSearchStore = [];
                                                                              if (pressed5 == false) {
                                                                                _getTrainerTrx();
                                                                                flag1 = false;
                                                                                flag2 = false;
                                                                                flag3 = false;
                                                                                flag4 = false;
                                                                                flag5 = true;
                                                                                flag6 = false;
                                                                                flag7 = false;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = true;
                                                                                  flag6 = false;
                                                                                  flag7 = false;
                                                                                  tempSearchStore = fifthButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "TRX",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 130 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag6 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () {
                                                                              tempSearchStore = [];
                                                                              if (pressed6 == false) {
                                                                                _getTrainerKangooJumps();
                                                                                flag1 = false;
                                                                                flag2 = false;
                                                                                flag3 = false;
                                                                                flag4 = false;
                                                                                flag5 = false;
                                                                                flag6 = true;
                                                                                flag7 = false;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = true;
                                                                                  flag7 = false;
                                                                                  tempSearchStore = sixthButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Kangoo Jumps",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8 *
                                                                            prefs.getDouble(
                                                                                'width')),
                                                                    child:
                                                                        Container(
                                                                      width: 80 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      height: 42 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      child:
                                                                          Material(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: flag7 ==
                                                                                false
                                                                            ? prefix0.secondaryColor
                                                                            : prefix0.mainColor,
                                                                        child: MaterialButton(
                                                                            onPressed: () {
                                                                              tempSearchStore = [];
                                                                              if (pressed7 == false) {
                                                                                _getTrainerPilates();
                                                                                flag1 = false;
                                                                                flag2 = false;
                                                                                flag3 = false;
                                                                                flag4 = false;
                                                                                flag5 = false;
                                                                                flag6 = false;
                                                                                flag7 = true;
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  flag2 = false;
                                                                                  flag3 = false;
                                                                                  flag4 = false;
                                                                                  flag5 = false;
                                                                                  flag6 = false;
                                                                                  flag7 = true;
                                                                                  tempSearchStore = seventhButton;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Pilates",
                                                                                  style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 13 * prefs.getDouble('height')),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8 *
                                                            prefs.getDouble(
                                                                'height')),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Column(
                                                          children:
                                                              tempSearchStore
                                                                  .map(
                                                            (element) {
                                                              int counter = 0;
                                                              List<DateTime>
                                                                  dateList = [];
                                                              List<int>
                                                                  indexess = [];

                                                              if (flag1 ==
                                                                  true) {
                                                                counter = element
                                                                    .counterClasses;
                                                                int auxi = 0;
                                                                element.classes
                                                                    .forEach(
                                                                        (actualClass) {
                                                                  if ((actualClass
                                                                              .public ==
                                                                          true ||
                                                                      element.clients
                                                                              .where((element1) => element1.clientId == prefs.getString('id'))
                                                                              .toList()
                                                                              .length !=
                                                                          0)) {
                                                                    flagPh1 =
                                                                        true;
                                                                    indexess.add(
                                                                        auxi);
                                                                    dateList.add(
                                                                        actualClass
                                                                            .dateAndTimeDateTime);
                                                                  }
                                                                  auxi++;
                                                                });
                                                                for (int i = 0;
                                                                    i <
                                                                        dateList.length -
                                                                            1;
                                                                    i++) {
                                                                  for (int j =
                                                                          i + 1;
                                                                      j <
                                                                          dateList
                                                                              .length;
                                                                      j++) {
                                                                    if (dateList[
                                                                            i]
                                                                        .isAfter(
                                                                            dateList[j])) {
                                                                      DateTime
                                                                          auxiliar1 =
                                                                          dateList[
                                                                              i];
                                                                      dateList[
                                                                              i] =
                                                                          dateList[
                                                                              j];
                                                                      dateList[
                                                                              j] =
                                                                          auxiliar1;

                                                                      int auxiliar2 =
                                                                          indexess[
                                                                              i];
                                                                      indexess[
                                                                              i] =
                                                                          indexess[
                                                                              j];
                                                                      indexess[
                                                                              j] =
                                                                          auxiliar2;
                                                                    }
                                                                  }
                                                                }
                                                              } else {
                                                                if (flag2 ==
                                                                    true) {
                                                                  counter = element
                                                                      .workoutCounter;
                                                                  int auxi = 0;
                                                                  element
                                                                      .classes
                                                                      .forEach(
                                                                          (actualClass) {
                                                                    if (actualClass.type ==
                                                                            "Workout" &&
                                                                        (actualClass.public ==
                                                                                true ||
                                                                            element.clients.where((element1) => element1.clientId == prefs.getString('id')).toList().length !=
                                                                                0)) {
                                                                      flagPh2 =
                                                                          true;
                                                                      indexess.add(
                                                                          auxi);
                                                                      dateList.add(
                                                                          actualClass
                                                                              .dateAndTimeDateTime);
                                                                    }
                                                                    auxi++;
                                                                  });
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          dateList.length -
                                                                              1;
                                                                      i++) {
                                                                    for (int j =
                                                                            i + 1;
                                                                        j < dateList.length;
                                                                        j++) {
                                                                      if (dateList[
                                                                              i]
                                                                          .isAfter(
                                                                              dateList[j])) {
                                                                        DateTime
                                                                            auxiliar1 =
                                                                            dateList[i];
                                                                        dateList[i] =
                                                                            dateList[j];
                                                                        dateList[j] =
                                                                            auxiliar1;

                                                                        int auxiliar2 =
                                                                            indexess[i];
                                                                        indexess[i] =
                                                                            indexess[j];
                                                                        indexess[j] =
                                                                            auxiliar2;
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  if (flag3 ==
                                                                      true) {
                                                                    counter =
                                                                        element
                                                                            .aerobicCounter;
                                                                    int auxi =
                                                                        0;
                                                                    element
                                                                        .classes
                                                                        .forEach(
                                                                            (actualClass) {
                                                                      if (actualClass.type ==
                                                                              "Aerobic" &&
                                                                          (actualClass.public == true ||
                                                                              element.clients.where((element1) => element1.clientId == prefs.getString('id')).toList().length != 0)) {
                                                                        flagPh3 =
                                                                            true;
                                                                        indexess
                                                                            .add(auxi);
                                                                        dateList
                                                                            .add(actualClass.dateAndTimeDateTime);
                                                                      }
                                                                      auxi++;
                                                                    });
                                                                    for (int i =
                                                                            0;
                                                                        i <
                                                                            dateList.length -
                                                                                1;
                                                                        i++) {
                                                                      for (int j =
                                                                              i + 1;
                                                                          j < dateList.length;
                                                                          j++) {
                                                                        if (dateList[i]
                                                                            .isAfter(dateList[j])) {
                                                                          DateTime
                                                                              auxiliar1 =
                                                                              dateList[i];
                                                                          dateList[i] =
                                                                              dateList[j];
                                                                          dateList[j] =
                                                                              auxiliar1;

                                                                          int auxiliar2 =
                                                                              indexess[i];
                                                                          indexess[i] =
                                                                              indexess[j];
                                                                          indexess[j] =
                                                                              auxiliar2;
                                                                        }
                                                                      }
                                                                    }
                                                                  } else {
                                                                    if (flag4 ==
                                                                        true) {
                                                                      counter =
                                                                          element
                                                                              .zumbaCounter;
                                                                      int auxi =
                                                                          0;
                                                                      element
                                                                          .classes
                                                                          .forEach(
                                                                              (actualClass) {
                                                                        if (actualClass.type ==
                                                                                "Zumba" &&
                                                                            (actualClass.public == true ||
                                                                                element.clients.where((element1) => element1.clientId == prefs.getString('id')).toList().length != 0)) {
                                                                          flagPh4 =
                                                                              true;
                                                                          indexess
                                                                              .add(auxi);
                                                                          dateList
                                                                              .add(actualClass.dateAndTimeDateTime);
                                                                        }
                                                                        auxi++;
                                                                      });
                                                                      for (int i =
                                                                              0;
                                                                          i < dateList.length - 1;
                                                                          i++) {
                                                                        for (int j =
                                                                                i + 1;
                                                                            j < dateList.length;
                                                                            j++) {
                                                                          if (dateList[i]
                                                                              .isAfter(dateList[j])) {
                                                                            DateTime
                                                                                auxiliar1 =
                                                                                dateList[i];
                                                                            dateList[i] =
                                                                                dateList[j];
                                                                            dateList[j] =
                                                                                auxiliar1;

                                                                            int auxiliar2 =
                                                                                indexess[i];
                                                                            indexess[i] =
                                                                                indexess[j];
                                                                            indexess[j] =
                                                                                auxiliar2;
                                                                          }
                                                                        }
                                                                      }
                                                                    } else {
                                                                      if (flag5 ==
                                                                          true) {
                                                                        counter =
                                                                            element.trxCounter;
                                                                        int auxi =
                                                                            0;
                                                                        element
                                                                            .classes
                                                                            .forEach((actualClass) {
                                                                          if (actualClass.type == "Trx" &&
                                                                              (actualClass.public == true || element.clients.where((element1) => element1.clientId == prefs.getString('id')).toList().length != 0)) {
                                                                            flagPh5 =
                                                                                true;
                                                                            indexess.add(auxi);
                                                                            dateList.add(actualClass.dateAndTimeDateTime);
                                                                          }
                                                                          auxi++;
                                                                        });
                                                                        for (int i =
                                                                                0;
                                                                            i < dateList.length - 1;
                                                                            i++) {
                                                                          for (int j = i + 1;
                                                                              j < dateList.length;
                                                                              j++) {
                                                                            if (dateList[i].isAfter(dateList[j])) {
                                                                              DateTime auxiliar1 = dateList[i];
                                                                              dateList[i] = dateList[j];
                                                                              dateList[j] = auxiliar1;

                                                                              int auxiliar2 = indexess[i];
                                                                              indexess[i] = indexess[j];
                                                                              indexess[j] = auxiliar2;
                                                                            }
                                                                          }
                                                                        }
                                                                      } else {
                                                                        if (flag6 ==
                                                                            true) {
                                                                          counter =
                                                                              element.kangooJumpsCounter;
                                                                          int auxi =
                                                                              0;
                                                                          element
                                                                              .classes
                                                                              .forEach((actualClass) {
                                                                            if (actualClass.type == "Kangoo Jumps" &&
                                                                                (actualClass.public == true || element.clients.where((element1) => element1.clientId == prefs.getString('id')).toList().length != 0)) {
                                                                              flagPh6 = true;
                                                                              indexess.add(auxi);
                                                                              dateList.add(actualClass.dateAndTimeDateTime);
                                                                            }
                                                                            auxi++;
                                                                          });
                                                                          for (int i = 0;
                                                                              i < dateList.length - 1;
                                                                              i++) {
                                                                            for (int j = i + 1;
                                                                                j < dateList.length;
                                                                                j++) {
                                                                              if (dateList[i].isAfter(dateList[j])) {
                                                                                DateTime auxiliar1 = dateList[i];
                                                                                dateList[i] = dateList[j];
                                                                                dateList[j] = auxiliar1;

                                                                                int auxiliar2 = indexess[i];
                                                                                indexess[i] = indexess[j];
                                                                                indexess[j] = auxiliar2;
                                                                              }
                                                                            }
                                                                          }
                                                                        } else {
                                                                          if (flag7 ==
                                                                              true) {
                                                                            counter =
                                                                                element.pilatesCounter;
                                                                            int auxi =
                                                                                0;
                                                                            element.classes.forEach((actualClass) {
                                                                              if (actualClass.type == "Pilates" && (actualClass.public == true || element.clients.where((element1) => element1.clientId == prefs.getString('id')).toList().length != 0)) {
                                                                                flagPh7 = true;
                                                                                indexess.add(auxi);
                                                                                dateList.add(actualClass.dateAndTimeDateTime);
                                                                              }
                                                                              auxi++;
                                                                            });

                                                                            for (int i = 0;
                                                                                i < dateList.length - 1;
                                                                                i++) {
                                                                              for (int j = i + 1; j < dateList.length; j++) {
                                                                                if (dateList[i].isAfter(dateList[j])) {
                                                                                  DateTime auxiliar1 = dateList[i];
                                                                                  dateList[i] = dateList[j];
                                                                                  dateList[j] = auxiliar1;

                                                                                  int auxiliar2 = indexess[i];
                                                                                  indexess[i] = indexess[j];
                                                                                  indexess[j] = auxiliar2;
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              return indexess
                                                                          .length !=
                                                                      0
                                                                  ? ListView
                                                                      .builder(
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          indexess
                                                                              .length,
                                                                      itemBuilder: (_, int index) => item(
                                                                          element,
                                                                          indexess[
                                                                              index]),
                                                                    )
                                                                  : Container();
                                                            },
                                                          ).toList(),
                                                        ),
                                                        (loading == false &&
                                                                ((flag1 ==
                                                                            true &&
                                                                        flagPh1 ==
                                                                            false) ||
                                                                    (flag2 ==
                                                                            true &&
                                                                        flagPh2 ==
                                                                            false) ||
                                                                    (flag3 ==
                                                                            true &&
                                                                        flagPh3 ==
                                                                            false) ||
                                                                    (flag4 ==
                                                                            true &&
                                                                        flagPh4 ==
                                                                            false) ||
                                                                    (flag5 ==
                                                                            true &&
                                                                        flagPh5 ==
                                                                            false) ||
                                                                    (flag6 ==
                                                                            true &&
                                                                        flagPh6 ==
                                                                            false) ||
                                                                    (flag7 ==
                                                                            true &&
                                                                        flagPh7 ==
                                                                            false)))
                                                            ? Container(
                                                                height: 500 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                child: Center(
                                                                    child:
                                                                        Container(
                                                                  color:
                                                                      backgroundColor,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      SvgPicture
                                                                          .asset(
                                                                        'assets/noTrainerBookingf1.svg',
                                                                        width: 250.0 *
                                                                            prefs.getDouble('width'),
                                                                        height: 150.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              32 * prefs.getDouble('height')),
                                                                      Text(
                                                                          "No available classes",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontWeight: FontWeight.w600,
                                                                              letterSpacing: 0.75,
                                                                              fontSize: 20 * prefs.getDouble('height'),
                                                                              color: Colors.white)),
                                                                      SizedBox(
                                                                          height:
                                                                              8 * prefs.getDouble('height')),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                32 * prefs.getDouble('width')),
                                                                        width: 375 *
                                                                            prefs.getDouble('width'),
                                                                        child:
                                                                            Text(
                                                                          "No available classes match your search.",
                                                                          style: TextStyle(
                                                                              letterSpacing: 0.75,
                                                                              fontSize: 13 * prefs.getDouble('height'),
                                                                              color: Color.fromARGB(200, 255, 255, 255),
                                                                              fontFamily: 'Roboto'),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              3,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  loading == true
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0 *
                                                      prefs
                                                          .getDouble('height')),
                                              color: prefix0.secondaryColor,
                                            ),
                                            height:
                                                80 * prefs.getDouble('height'),
                                            width:
                                                80 * prefs.getDouble('width'),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(mainColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )))
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: prefix0.backgroundColor,
                      elevation: 0.0,
                      title: Center(
                        child: Text(
                          "Search",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22 * prefs.getDouble('height'),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    body: Container(
                      color: prefix0.backgroundColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: SvgPicture.asset(
                              'assets/bookingPlaceholderf1.svg',
                              width: 200.0 * prefs.getDouble('width'),
                              height: 150.0 * prefs.getDouble('height'),
                            ),
                          ),
                          SizedBox(
                            height: 30 * prefs.getDouble('height'),
                          ),
                          Text(
                            "Locatia nu este accesibila",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 20 * prefs.getDouble('height'),
                                letterSpacing: -0.75),
                          ),
                          SizedBox(height: 20 * prefs.getDouble('height')),
                          Center(
                            child: Container(
                              width: 250 * prefs.getDouble('width'),
                              child: Text(
                                "Pentru ca lista antrenorilor sa fie relevanta, avem nevoie de permisiune pentru a accesa locatia.",
                                style: TextStyle(
                                    fontSize: 15.0 * prefs.getDouble('height'),
                                    color: Color.fromARGB(150, 255, 255, 255),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 48 * prefs.getDouble('height'),
                          ),
                          InkWell(
                            onTap: () async {
                              if (Platform.isAndroid) {
                                var auxx, auxy;

                                try {
                                  var location = new Location();

                                  await location.getLocation().then((onValue) {
                                    auxx = onValue.latitude;
                                    auxy = onValue.longitude;
                                  });

                                  setState(() {
                                    x = auxx;
                                    y = auxy;
                                    permissionGranted = 'true';
                                  });
                                } catch (e) {
                                  if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
                                    setState(() {
                                      permissionGranted = 'never ask';
                                    });
                                  }
                                  if (e.code == 'PERMISSION_DENIED') {
                                    setState(() {
                                      permissionGranted = 'false';
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              height: 60 * prefs.getDouble('height'),
                              width: 210 * prefs.getDouble('width'),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: prefix0.mainColor),
                              child: Center(
                                child: Text(
                                  "Acceseaza locatia",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          17.0 * prefs.getDouble('height'),
                                      color: Colors.white,
                                      letterSpacing: -0.408),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
  }

  List<String> daysOfTheWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  List<String> monthsOfTheYear = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "Octomber",
    "November",
    "December"
  ];
  Widget item(TrainerUser trainer, int index) {
    bool trainFlag = false;
    widget.imClient.trainers.forEach((trainer1) {
      if (trainer1.trainerAccepted == true &&
          trainer1.trainerId == trainer.id) {
        trainFlag = true;
      }
    });
    if (trainer.classes[index] != null &&
        (trainer.classes[index].public == true || trainFlag == true)) {
      String hour = trainer.classes[index].dateAndTimeDateTime.hour < 10
          ? ("0" + trainer.classes[index].dateAndTimeDateTime.hour.toString())
          : trainer.classes[index].dateAndTimeDateTime.hour.toString();
      String minute = trainer.classes[index].dateAndTimeDateTime.minute < 10
          ? ("0" + trainer.classes[index].dateAndTimeDateTime.minute.toString())
          : trainer.classes[index].dateAndTimeDateTime.minute.toString();
      String duration;
      if (trainer.classes[index].duration.toDate().hour < 1) {
        if (trainer.classes[index].duration.toDate().minute >= 0 &&
            trainer.classes[index].duration.toDate().minute < 10) {
          duration = "0${trainer.classes[index].duration.toDate().minute}m";
        }
        if (trainer.classes[index].duration.toDate().minute > 9 &&
            trainer.classes[index].duration.toDate().minute < 60) {
          duration = "${trainer.classes[index].duration.toDate().minute}m";
        }
      } else {
        if (trainer.classes[index].duration.toDate().hour > 0 &&
            trainer.classes[index].duration.toDate().hour < 10) {
          duration = "0${trainer.classes[index].duration.toDate().hour}h";
        }
        if (trainer.classes[index].duration.toDate().hour > 9 &&
            trainer.classes[index].duration.toDate().hour < 60) {
          duration = "${trainer.classes[index].duration.toDate().hour}h";
        }

        if (trainer.classes[index].duration.toDate().minute >= 0 &&
            trainer.classes[index].duration.toDate().minute < 10) {
          duration = duration +
              " " +
              "0${trainer.classes[index].duration.toDate().minute}m";
        }
        if (trainer.classes[index].duration.toDate().minute > 9 &&
            trainer.classes[index].duration.toDate().minute < 60) {
          duration = duration +
              " " +
              "${trainer.classes[index].duration.toDate().minute}m";
        }
      }
      bool enrolledFlag = false;
      widget.imClient.classes.forEach((actualClass) {
        if (actualClass.duration == trainer.classes[index].duration &&
            actualClass.dateAndTimeDateTime ==
                trainer.classes[index].dateAndTimeDateTime &&
            actualClass.dateAndTime == trainer.classes[index].dateAndTime &&
            actualClass.trainerId == trainer.id) {
          enrolledFlag = true;
        }
      });
      bool unavailable = false;
      if (trainer.classes[index].occupiedSpots.length >=
              trainer.classes[index].spots &&
          enrolledFlag == false) {
        unavailable = true;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 343 * prefs.getDouble('width'),
            height: 306 * prefs.getDouble('height'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: secondaryColor,
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16 * prefs.getDouble('width'),
                    vertical: 16 * prefs.getDouble('height')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 56 * prefs.getDouble('height'),
                          width: 216 * prefs.getDouble('width'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "${trainer.classes[index].dateAndTimeDateTime.year}" +
                                      "-" +
                                      "${monthsOfTheYear[trainer.classes[index].dateAndTimeDateTime.month - 1]}" +
                                      "-" +
                                      "${trainer.classes[index].dateAndTimeDateTime.day}" +
                                      "-" +
                                      "${daysOfTheWeek[trainer.classes[index].dateAndTimeDateTime.weekday - 1]}" +
                                      " " +
                                      hour +
                                      ":" +
                                      minute,
                                  style: TextStyle(
                                      letterSpacing: 0.066,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                      color: mainColor)),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 15 * prefs.getDouble('height'),
                                      fontFamily: 'Roboto',
                                      letterSpacing: -0.24),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: trainer.classes[index].classLevel +
                                          " " +
                                          trainer.classes[index].type +
                                          " Class with " +
                                          trainer.firstName +
                                          " " +
                                          trainer.lastName,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              17 * prefs.getDouble('height'),
                                          letterSpacing: -0.408,
                                          color: Colors.white),
                                    ),
                                    TextSpan(
                                        text: trainer.classes[index].public ==
                                                true
                                            ? " - PUBLIC"
                                            : " - PRIVATE",
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize:
                                                12 * prefs.getDouble('height'),
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25 * prefs.getDouble('height'),
                          width: 94 * prefs.getDouble('width'),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(duration,
                                    style: TextStyle(
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        letterSpacing: -0.24,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(200, 255, 255, 255),
                                        fontFamily: 'Roboto')),
                                SizedBox(width: 8.0 * prefs.getDouble('width')),
                                Icon(Icons.alarm,
                                    color: mainColor,
                                    size: 24 * prefs.getDouble('height'))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[],
                    ),
                    InkWell(
                      onTap: () {
                        if (trainer.classes[index].gymWebsite != null) {
                          launch(trainer.classes[index].gymWebsite);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 24 * prefs.getDouble('height'),
                            color: mainColor,
                          ),
                          SizedBox(width: 8 * prefs.getDouble('width')),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 15 * prefs.getDouble('height'),
                                      fontFamily: 'Roboto',
                                      letterSpacing: -0.24),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "At ",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                      ),
                                    ),
                                    TextSpan(
                                      text: trainer.classes[index].locationName,
                                      style: TextStyle(color: mainColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                trainer.classes[index].locationStreet +
                                    ", " +
                                    trainer.classes[index].locationDistrict,
                                style: TextStyle(
                                    fontSize: 15 * prefs.getDouble('height'),
                                    fontFamily: 'Roboto',
                                    letterSpacing: -0.24,
                                    color: Color.fromARGB(150, 255, 255, 255)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          size: 24 * prefs.getDouble('height'),
                          color: mainColor,
                        ),
                        SizedBox(width: 8 * prefs.getDouble('width')),
                        Text(
                          trainer.classes[index].occupiedSpots.length
                                  .toString() +
                              "/" +
                              trainer.classes[index].spots.toString() +
                              " occupied spots in this class",
                          style: TextStyle(
                              fontSize: 15 * prefs.getDouble('height'),
                              fontFamily: 'Roboto',
                              letterSpacing: -0.24,
                              color: Color.fromARGB(150, 255, 255, 255)),
                        )
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 24 * prefs.getDouble('height'),
                          color: mainColor,
                        ),
                        SizedBox(width: 8 * prefs.getDouble('width')),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        trainer.classes[index].individualPrice,
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 22 * prefs.getDouble('height'),
                                    ),
                                  ),
                                  TextSpan(
                                    text: " individual price",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        letterSpacing: -0.24),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "or " +
                                  trainer.classes[index].memberPrice +
                                  " member price",
                              style: TextStyle(
                                  fontSize: 15 * prefs.getDouble('height'),
                                  fontFamily: 'Roboto',
                                  letterSpacing: -0.24,
                                  color: Color.fromARGB(150, 255, 255, 255)),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 24.0 * prefs.getDouble('height')),
                      child: Container(
                        width: 310.0 * prefs.getDouble('width'),
                        height: 42.0 * prefs.getDouble('height'),
                        child: Material(
                          color: unavailable == true
                              ? Color(0xff57575E)
                              : enrolledFlag == false
                                  ? mainColor
                                  : Color(0xff57575E),
                          borderRadius: BorderRadius.circular(90.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (enrolledFlag == false) {
                                setState(() {
                                  loading = true;
                                });
                                if (unavailable == false) {
                                  QuerySnapshot query = await Firestore.instance
                                      .collection('clientUsers')
                                      .where('id', isEqualTo: trainer.id)
                                      .getDocuments();

                                  TrainerUser updatedTrainer =
                                      TrainerUser(query.documents[0]);
                                  bool flagUpdated = false;
                                  int temporaryIndex = 0;
                                  updatedTrainer.classes
                                      .forEach((actualClass) async {
                                    if (actualClass.dateAndTime ==
                                            trainer
                                                .classes[index].dateAndTime &&
                                        actualClass.dateAndTimeDateTime ==
                                            trainer.classes[index]
                                                .dateAndTimeDateTime &&
                                        actualClass.duration ==
                                            trainer.classes[index].duration &&
                                        actualClass.firstName ==
                                            trainer.classes[index].firstName &&
                                        trainer.classes[index].lastName ==
                                            actualClass.lastName) {
                                      flagUpdated = true;
                                      index = temporaryIndex;
                                    }

                                    temporaryIndex++;
                                  });
                                  if (flagUpdated == true) {
                                    trainer = updatedTrainer;
                                    double rating = 0;
                                    int mediaAritmetica = 0;
                                    if (widget.imClient.votesMap.length != 0) {
                                      widget.imClient.votesMap
                                          .forEach((element) {
                                        mediaAritmetica++;
                                        rating += element.vote.toDouble();
                                      });
                                      rating /= mediaAritmetica;
                                    }
                                    bool overLap = false;
                                    if (widget.imClient.counterClassesClient >
                                        0) {
                                      var time1 = [];
                                      var time2 = [];
                                      widget.imClient.classes
                                          .forEach((actualClass) {
                                        time1.add(
                                            actualClass.dateAndTimeDateTime);
                                        time2.add(actualClass
                                            .dateAndTimeDateTime
                                            .add(Duration(
                                                hours: actualClass.duration
                                                    .toDate()
                                                    .hour,
                                                minutes: actualClass.duration
                                                    .toDate()
                                                    .minute)));
                                      });
                                      for (int i = 0;
                                          i <
                                              widget.imClient
                                                      .counterClassesClient -
                                                  1;
                                          i++) {
                                        for (int j = i + 1;
                                            j <
                                                widget.imClient
                                                    .counterClassesClient;
                                            j++) {
                                          if (time1[i].isAfter(time1[j])) {
                                            var aux1 = time1[i];
                                            time1[i] = time1[j];
                                            time1[j] = aux1;

                                            var aux2 = time2[i];
                                            time2[i] = time2[j];
                                            time2[j] = aux2;
                                          }
                                        }
                                      }
                                      for (int i = 0;
                                          i <
                                              widget.imClient
                                                      .counterClassesClient -
                                                  1;
                                          i++) {
                                        if (time2[i].isBefore(trainer
                                                .classes[index]
                                                .dateAndTimeDateTime) &&
                                            time1[i + 1].isAfter(trainer
                                                .classes[index]
                                                .dateAndTimeDateTime
                                                .add(Duration(
                                                    hours: trainer
                                                        .classes[index].duration
                                                        .toDate()
                                                        .hour,
                                                    minutes: trainer
                                                        .classes[index].duration
                                                        .toDate()
                                                        .minute)))) {
                                          overLap = true;
                                        }
                                      }

                                      if (time1[0].isAfter(trainer
                                          .classes[index].dateAndTimeDateTime
                                          .add(Duration(
                                              hours: trainer
                                                  .classes[index].duration
                                                  .toDate()
                                                  .hour,
                                              minutes: trainer
                                                  .classes[index].duration
                                                  .toDate()
                                                  .minute)))) {
                                        overLap = true;
                                      }

                                      if (time2[widget.imClient
                                                  .counterClassesClient -
                                              1]
                                          .isBefore(trainer.classes[index]
                                              .dateAndTimeDateTime)) {
                                        overLap = true;
                                      }
                                    } else {
                                      overLap = true;
                                    }
                                    if (overLap == true) {
                                      if (updatedTrainer.classes[index]
                                              .occupiedSpots.length >=
                                          updatedTrainer.classes[index].spots) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "All spots in this class have been occupied. ",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18.0 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color: mainColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ));

                                        setState(() {
                                          int followingTemp = 0;
                                          int followingFirst = 0;
                                          int followingSecond = 0;
                                          int followingThird = 0;
                                          int followingFourth = 0;
                                          int followingFifth = 0;
                                          int followingSixth = 0;
                                          int followingSeventh = 0;
                                          int rememberIndexTemp = -1;
                                          int rememberIndexFirstButton = -1;
                                          int rememberIndexSecondButton = -1;
                                          int rememberIndexThirdButton = -1;
                                          int rememberIndexFourthButton = -1;
                                          int rememberIndexFifthButton = -1;
                                          int rememberIndexSisxthButton = -1;
                                          int rememberIndexSeventhButton = -1;
                                          tempSearchStore.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexTemp = followingTemp;
                                            }
                                            followingTemp++;
                                          });
                                          firstButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexFirstButton =
                                                  followingFirst;
                                            }
                                            followingFirst++;
                                          });
                                          secondButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexSecondButton =
                                                  followingSecond;
                                            }
                                            followingSecond++;
                                          });
                                          thirdButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexThirdButton =
                                                  followingThird;
                                            }
                                            followingThird++;
                                          });
                                          fourthButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexFourthButton =
                                                  followingFourth;
                                            }
                                            followingFourth++;
                                          });
                                          fifthButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexFifthButton =
                                                  followingFifth;
                                            }
                                            followingFifth++;
                                          });
                                          sixthButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexSisxthButton =
                                                  followingSixth;
                                            }
                                            followingSixth++;
                                          });
                                          seventhButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexSeventhButton =
                                                  followingSeventh;
                                            }
                                            followingSeventh++;
                                          });
                                          if (rememberIndexTemp != -1) {
                                            tempSearchStore.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            tempSearchStore.insert(
                                                rememberIndexTemp,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexFirstButton != -1) {
                                            firstButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            firstButton.insert(
                                                rememberIndexFirstButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexSecondButton != -1) {
                                            secondButton.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            secondButton.insert(
                                                rememberIndexSecondButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexThirdButton != -1) {
                                            thirdButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            thirdButton.insert(
                                                rememberIndexThirdButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexFourthButton != -1) {
                                            fourthButton.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            fourthButton.insert(
                                                rememberIndexFourthButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexFifthButton != -1) {
                                            fifthButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            fifthButton.insert(
                                                rememberIndexFifthButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexSisxthButton != -1) {
                                            sixthButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            sixthButton.insert(
                                                rememberIndexSisxthButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexSeventhButton !=
                                              -1) {
                                            seventhButton.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            seventhButton.insert(
                                                rememberIndexSeventhButton,
                                                updatedTrainer);
                                          }
                                        });
                                      } else {
                                        Navigator.push(
                                          context,
                                          CongratsPopup(),
                                        );
                                        var db = Firestore.instance;
                                        var batch = db.batch();

                                        batch.updateData(
                                          db
                                              .collection('clientUsers')
                                              .document(trainer.id),
                                          {
                                            'newMemberJoined': true,
                                            'class${index + 1}.occupiedSpots.${widget.imClient.id}':
                                                true,
                                            'class${index + 1}.clientsFirstName.${prefs.getString('id')}':
                                                widget.imClient.firstName,
                                            'class${index + 1}.clientsAge.${prefs.getString('id')}':
                                                widget.imClient.age.toString(),
                                            'class${index + 1}.clientsGender.${prefs.getString('id')}':
                                                widget.imClient.gender,
                                            'class${index + 1}.clientsLastName.${prefs.getString('id')}':
                                                widget.imClient.lastName,
                                            'class${index + 1}.clientsPhotoUrl.${prefs.getString('id')}':
                                                widget.imClient.photoUrl,
                                            'class${index + 1}.clientsColorRed.${prefs.getString('id')}':
                                                widget.imClient.colorRed
                                                    .toString(),
                                            'class${index + 1}.clientsColorGreen.${prefs.getString('id')}':
                                                widget.imClient.colorGreen
                                                    .toString(),
                                            'class${index + 1}.clientsColorBlue.${prefs.getString('id')}':
                                                widget.imClient.colorBlue
                                                    .toString(),
                                            'class${index + 1}.clientsRating.${prefs.getString('id')}':
                                                rating.toString(),
                                          },
                                        );
                                        batch.setData(
                                          db
                                              .collection('newMemberJoined')
                                              .document(trainer.id),
                                          {
                                            'idFrom': prefs.getString('id'),
                                            'idTo': trainer.id,
                                            'pushToken': trainer.pushToken,
                                            'firstName':
                                                widget.imClient.firstName
                                          },
                                        );
                                        batch.updateData(
                                          db
                                              .collection('clientUsers')
                                              .document(prefs.getString('id')),
                                          {
                                            'class${widget.imClient.counterClassesClient + 1}':
                                                {},
                                          },
                                        );

                                        batch.updateData(
                                          db
                                              .collection('clientUsers')
                                              .document(prefs.getString('id')),
                                          {
                                            'deletedClient': true,
                                            'class${widget.imClient.counterClassesClient + 1}.public':
                                                trainer.classes[index].public,
                                            'class${widget.imClient.counterClassesClient + 1}.classLevel':
                                                trainer
                                                    .classes[index].classLevel,
                                            'class${widget.imClient.counterClassesClient + 1}.locationName':
                                                trainer.classes[index]
                                                    .locationName,
                                            'class${widget.imClient.counterClassesClient + 1}.gymWebsite':
                                                trainer
                                                    .classes[index].gymWebsite,
                                            'class${widget.imClient.counterClassesClient + 1}.locationDistrict':
                                                trainer.classes[index]
                                                    .locationDistrict,
                                            'class${widget.imClient.counterClassesClient + 1}.number':
                                                widget.imClient
                                                        .counterClassesClient +
                                                    1,
                                            'class${widget.imClient.counterClassesClient + 1}.individualPrice':
                                                trainer.classes[index]
                                                    .individualPrice,
                                            'class${widget.imClient.counterClassesClient + 1}.memberPrice':
                                                trainer
                                                    .classes[index].memberPrice,
                                            'class${widget.imClient.counterClassesClient + 1}.type':
                                                trainer.classes[index].type,
                                            'class${widget.imClient.counterClassesClient + 1}.dateAndTime':
                                                trainer
                                                    .classes[index].dateAndTime,
                                            'counterClassesClient': widget
                                                    .imClient
                                                    .counterClassesClient +
                                                1,
                                            'class${widget.imClient.counterClassesClient + 1}.dateAndTimeDateTime':
                                                trainer.classes[index]
                                                    .dateAndTimeDateTime,
                                            'class${widget.imClient.counterClassesClient + 1}.duration':
                                                trainer.classes[index].duration,
                                            'class${widget.imClient.counterClassesClient + 1}.locationStreet':
                                                trainer.classes[index]
                                                    .locationStreet,
                                            'class${widget.imClient.counterClassesClient + 1}.trainerId':
                                                trainer.id,
                                            'class${widget.imClient.counterClassesClient + 1}.trainerFirstName':
                                                trainer.firstName,
                                            'class${widget.imClient.counterClassesClient + 1}.trainerLastName':
                                                trainer.lastName,
                                          },
                                        );
                                        batch.commit();
                                      }
                                    } else {
                                      if (overLap == false) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "You`re already attending a class scheduled at that time.",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18.0 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color: mainColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ));

                                        setState(() {
                                          int followingTemp = 0;
                                          int followingFirst = 0;
                                          int followingSecond = 0;
                                          int followingThird = 0;
                                          int followingFourth = 0;
                                          int followingFifth = 0;
                                          int followingSixth = 0;
                                          int followingSeventh = 0;
                                          int rememberIndexTemp = -1;
                                          int rememberIndexFirstButton = -1;
                                          int rememberIndexSecondButton = -1;
                                          int rememberIndexThirdButton = -1;
                                          int rememberIndexFourthButton = -1;
                                          int rememberIndexFifthButton = -1;
                                          int rememberIndexSisxthButton = -1;
                                          int rememberIndexSeventhButton = -1;
                                          tempSearchStore.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexTemp = followingTemp;
                                            }
                                            followingTemp++;
                                          });
                                          firstButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexFirstButton =
                                                  followingFirst;
                                            }
                                            followingFirst++;
                                          });
                                          secondButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexSecondButton =
                                                  followingSecond;
                                            }
                                            followingSecond++;
                                          });
                                          thirdButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexThirdButton =
                                                  followingThird;
                                            }
                                            followingThird++;
                                          });
                                          fourthButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexFourthButton =
                                                  followingFourth;
                                            }
                                            followingFourth++;
                                          });
                                          fifthButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexFifthButton =
                                                  followingFifth;
                                            }
                                            followingFifth++;
                                          });
                                          sixthButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexSisxthButton =
                                                  followingSixth;
                                            }
                                            followingSixth++;
                                          });
                                          seventhButton.forEach((element) {
                                            if (element.id ==
                                                updatedTrainer.id) {
                                              rememberIndexSeventhButton =
                                                  followingSeventh;
                                            }
                                            followingSeventh++;
                                          });
                                          if (rememberIndexTemp != -1) {
                                            tempSearchStore.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            tempSearchStore.insert(
                                                rememberIndexTemp,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexFirstButton != -1) {
                                            firstButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            firstButton.insert(
                                                rememberIndexFirstButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexSecondButton != -1) {
                                            secondButton.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            secondButton.insert(
                                                rememberIndexSecondButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexThirdButton != -1) {
                                            thirdButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            thirdButton.insert(
                                                rememberIndexThirdButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexFourthButton != -1) {
                                            fourthButton.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            fourthButton.insert(
                                                rememberIndexFourthButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexFifthButton != -1) {
                                            fifthButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            fifthButton.insert(
                                                rememberIndexFifthButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexSisxthButton != -1) {
                                            sixthButton.removeWhere((element) =>
                                                element.id ==
                                                updatedTrainer.id);
                                            sixthButton.insert(
                                                rememberIndexSisxthButton,
                                                updatedTrainer);
                                          }
                                          if (rememberIndexSeventhButton !=
                                              -1) {
                                            seventhButton.removeWhere(
                                                (element) =>
                                                    element.id ==
                                                    updatedTrainer.id);
                                            seventhButton.insert(
                                                rememberIndexSeventhButton,
                                                updatedTrainer);
                                          }
                                        });
                                      } else {
                                        if (enrolledFlag == true) {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "You have already signed up for this class",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18.0 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w500,
                                                  color: mainColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                        }
                                      }
                                    }
                                    setState(() {
                                      int followingTemp = 0;
                                      int followingFirst = 0;
                                      int followingSecond = 0;
                                      int followingThird = 0;
                                      int followingFourth = 0;
                                      int followingFifth = 0;
                                      int followingSixth = 0;
                                      int followingSeventh = 0;
                                      int rememberIndexTemp = -1;
                                      int rememberIndexFirstButton = -1;
                                      int rememberIndexSecondButton = -1;
                                      int rememberIndexThirdButton = -1;
                                      int rememberIndexFourthButton = -1;
                                      int rememberIndexFifthButton = -1;
                                      int rememberIndexSisxthButton = -1;
                                      int rememberIndexSeventhButton = -1;
                                      tempSearchStore.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexTemp = followingTemp;
                                        }
                                        followingTemp++;
                                      });
                                      firstButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexFirstButton =
                                              followingFirst;
                                        }
                                        followingFirst++;
                                      });
                                      secondButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexSecondButton =
                                              followingSecond;
                                        }
                                        followingSecond++;
                                      });
                                      thirdButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexThirdButton =
                                              followingThird;
                                        }
                                        followingThird++;
                                      });
                                      fourthButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexFourthButton =
                                              followingFourth;
                                        }
                                        followingFourth++;
                                      });
                                      fifthButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexFifthButton =
                                              followingFifth;
                                        }
                                        followingFifth++;
                                      });
                                      sixthButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexSisxthButton =
                                              followingSixth;
                                        }
                                        followingSixth++;
                                      });
                                      seventhButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexSeventhButton =
                                              followingSeventh;
                                        }
                                        followingSeventh++;
                                      });
                                      if (rememberIndexTemp != -1) {
                                        tempSearchStore.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        tempSearchStore.insert(
                                            rememberIndexTemp, updatedTrainer);
                                      }
                                      if (rememberIndexFirstButton != -1) {
                                        firstButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        firstButton.insert(
                                            rememberIndexFirstButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexSecondButton != -1) {
                                        secondButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        secondButton.insert(
                                            rememberIndexSecondButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexThirdButton != -1) {
                                        thirdButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        thirdButton.insert(
                                            rememberIndexThirdButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexFourthButton != -1) {
                                        fourthButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        fourthButton.insert(
                                            rememberIndexFourthButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexFifthButton != -1) {
                                        fifthButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        fifthButton.insert(
                                            rememberIndexFifthButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexSisxthButton != -1) {
                                        sixthButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        sixthButton.insert(
                                            rememberIndexSisxthButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexSeventhButton != -1) {
                                        seventhButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        seventhButton.insert(
                                            rememberIndexSeventhButton,
                                            updatedTrainer);
                                      }
                                    });
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "This class has been canceled.",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18.0 *
                                                prefs.getDouble('height'),
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            color: mainColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));

                                    setState(() {
                                      int followingTemp = 0;
                                      int followingFirst = 0;
                                      int followingSecond = 0;
                                      int followingThird = 0;
                                      int followingFourth = 0;
                                      int followingFifth = 0;
                                      int followingSixth = 0;
                                      int followingSeventh = 0;
                                      int rememberIndexTemp = -1;
                                      int rememberIndexFirstButton = -1;
                                      int rememberIndexSecondButton = -1;
                                      int rememberIndexThirdButton = -1;
                                      int rememberIndexFourthButton = -1;
                                      int rememberIndexFifthButton = -1;
                                      int rememberIndexSisxthButton = -1;
                                      int rememberIndexSeventhButton = -1;
                                      tempSearchStore.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexTemp = followingTemp;
                                        }
                                        followingTemp++;
                                      });
                                      firstButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexFirstButton =
                                              followingFirst;
                                        }
                                        followingFirst++;
                                      });
                                      secondButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexSecondButton =
                                              followingSecond;
                                        }
                                        followingSecond++;
                                      });
                                      thirdButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexThirdButton =
                                              followingThird;
                                        }
                                        followingThird++;
                                      });
                                      fourthButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexFourthButton =
                                              followingFourth;
                                        }
                                        followingFourth++;
                                      });
                                      fifthButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexFifthButton =
                                              followingFifth;
                                        }
                                        followingFifth++;
                                      });
                                      sixthButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexSisxthButton =
                                              followingSixth;
                                        }
                                        followingSixth++;
                                      });
                                      seventhButton.forEach((element) {
                                        if (element.id == updatedTrainer.id) {
                                          rememberIndexSeventhButton =
                                              followingSeventh;
                                        }
                                        followingSeventh++;
                                      });
                                      if (rememberIndexTemp != -1) {
                                        tempSearchStore.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        tempSearchStore.insert(
                                            rememberIndexTemp, updatedTrainer);
                                      }
                                      if (rememberIndexFirstButton != -1) {
                                        firstButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        firstButton.insert(
                                            rememberIndexFirstButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexSecondButton != -1) {
                                        secondButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        secondButton.insert(
                                            rememberIndexSecondButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexThirdButton != -1) {
                                        thirdButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        thirdButton.insert(
                                            rememberIndexThirdButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexFourthButton != -1) {
                                        fourthButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        fourthButton.insert(
                                            rememberIndexFourthButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexFifthButton != -1) {
                                        fifthButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        fifthButton.insert(
                                            rememberIndexFifthButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexSisxthButton != -1) {
                                        sixthButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        sixthButton.insert(
                                            rememberIndexSisxthButton,
                                            updatedTrainer);
                                      }
                                      if (rememberIndexSeventhButton != -1) {
                                        seventhButton.removeWhere((element) =>
                                            element.id == updatedTrainer.id);
                                        seventhButton.insert(
                                            rememberIndexSeventhButton,
                                            updatedTrainer);
                                      }
                                    });
                                  }
                                }
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: Text(
                              unavailable == true
                                  ? 'Unavailable'
                                  : enrolledFlag == false
                                      ? 'Enroll in this class!'
                                      : 'Enrolled',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 12.0 * prefs.getDouble('height'),
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.06),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(height: 8.0 * prefs.getDouble('height'))
        ],
      );
    }

    return Container();
  }

  Widget buildItem(trainer) {
    String trainersSpecializations = "";
    trainer.specializations.forEach((special) {
      if (special.certified == true) {
        if (special.specialization == 'kangooJumps') {
          trainersSpecializations = trainersSpecializations + "Kangoo Jumps, ";
        } else {
          trainersSpecializations = trainersSpecializations +
              special.specialization[0].toUpperCase() +
              special.specialization.substring(1) +
              ", ";
        }
      }
    });

    if (trainersSpecializations.length > 2) {
      trainersSpecializations = trainersSpecializations.substring(
          0, trainersSpecializations.length - 2);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(
          10.0 * prefs.getDouble('width'),
          5.0 * prefs.getDouble('height'),
          10.0 * prefs.getDouble('width'),
          5.0 * prefs.getDouble('height')),
      height: 110 * prefs.getDouble('height'),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => TrainerProfilePageBooking(
                bookedTrainer: trainer,
                bookedTrainerId: trainer.id,
                actualClient: widget.imClient,
                parent: this,
              ),
            ),
          );
          setState(() {});
        },
        child: Container(
          width: 343 * prefs.getDouble('width'),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0 * prefs.getDouble('height')),
              color: secondaryColor),
          height: 100.0 * prefs.getDouble('height'),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100 * prefs.getDouble('height'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 30.0 * prefs.getDouble('width'),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: prefix0.backgroundColor,
                        ),
                        padding:
                            EdgeInsets.all(2.0 * prefs.getDouble('height')),
                        child: trainer.photoUrl == null
                            ? ClipOval(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(
                                          255,
                                          trainer.colorRed,
                                          trainer.colorGreen,
                                          trainer.colorBlue),
                                      shape: BoxShape.circle,
                                    ),
                                    height: (60 * prefs.getDouble('height')),
                                    width: (60 * prefs.getDouble('height')),
                                    child: Center(
                                      child: Text(trainer.firstName[0],
                                          style: TextStyle(
                                            fontSize:
                                                35 * prefs.getDouble('height'),
                                            color: Colors.white,
                                          )),
                                    )),
                              )
                            : Material(
                                child: Container(
                                  width: 60 * prefs.getDouble('height'),
                                  height: 60 * prefs.getDouble('height'),
                                  decoration: BoxDecoration(
                                      color: prefix0.backgroundColor,
                                      shape: BoxShape.circle),
                                  child: Image.network(
                                    trainer.photoUrl,
                                    fit: BoxFit.cover,
                                    scale: 1.0,
                                    loadingBuilder: (BuildContext ctx,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    prefix0.mainColor),
                                            backgroundColor:
                                                prefix0.backgroundColor,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(77.5),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                      ),
                      SizedBox(
                        width: 15.0 * prefs.getDouble('width'),
                      ),
                      Container(
                          width: 225 * prefs.getDouble('width'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 40.0 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              trainer.firstName,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255),
                                                  fontSize: 17 *
                                                      prefs
                                                          .getDouble('height')),
                                            ),
                                            SizedBox(
                                              width: 4.0 *
                                                  prefs.getDouble('width'),
                                            ),
                                            Text(
                                              trainer.lastName,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255),
                                                  fontSize: 17 *
                                                      prefs
                                                          .getDouble('height')),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              3.0 * prefs.getDouble('height'),
                                        ),
                                        Container(
                                          height:
                                              13 * prefs.getDouble('height'),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: 15 *
                                                    prefs.getDouble('height'),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Age: " +
                                                          trainer.age
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromARGB(
                                                            100, 255, 255, 255),
                                                        fontSize: 12 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.0 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Container(
                                                height: 15 *
                                                    prefs.getDouble('height'),
                                                child: Text(
                                                  "|",
                                                  style: TextStyle(
                                                      fontSize: 12.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          100, 255, 255, 255)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.0 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Container(
                                                height: 15 *
                                                    prefs.getDouble('height'),
                                                child: Text(
                                                  "Clients: ",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        100, 255, 255, 255),
                                                    fontSize: 12 *
                                                        prefs.getDouble(
                                                            'height'),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 15 *
                                                    prefs.getDouble('height'),
                                                child: Text(
                                                  trainer.clients.length
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromARGB(
                                                        100, 255, 255, 255),
                                                    fontSize: 12 *
                                                        prefs.getDouble(
                                                            'height'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: 70 * prefs.getDouble('width'),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${((trainer.attributeMap.attribute1 + trainer.attributeMap.attribute2) / 2).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 17.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight: FontWeight.w700,
                                                    color: prefix0.mainColor),
                                              ),
                                              SizedBox(
                                                width: 5.0 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 24.0 *
                                                    prefs.getDouble('height'),
                                                color: prefix0.mainColor,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                trainersSpecializations,
                                style: TextStyle(
                                    fontSize: 12.0 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(220, 255, 255, 255)),
                                textAlign: TextAlign.start,
                                maxLines: 2,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGraphRight extends CustomPainter {
  final double attribute1;
  final double originn;

  CustomGraphRight({this.attribute1, this.originn});

  Paint trackBarPaint = Paint()
    ..color = mainColor
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12 * prefs.getDouble('height');

  Paint trackPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12 * prefs.getDouble('height');

  @override
  void paint(Canvas canvas, Size size) {
    Path trackPath = Path();
    Path trackBarPath = Path();
    double valoare = attribute1 / 5;
    double origin = 0;

    trackPath.moveTo(310 * prefs.getDouble('width'), origin);
    trackPath.lineTo(0, origin);

    trackBarPath.moveTo(0, origin);
    trackBarPath.lineTo(valoare * 310 * prefs.getDouble('width'), origin);

    canvas.drawPath(trackPath, trackPaint);
    canvas.drawPath(trackBarPath, trackBarPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TrainerProfilePageBooking extends StatefulWidget {
  TrainerProfilePageBooking(
      {@required this.bookedTrainerId,
      @required this.actualClient,
      this.bookedTrainer,
      this.parent});
  final _TrainerBookingPageState parent;
  TrainerUser bookedTrainer;
  final ClientUser actualClient;
  final String bookedTrainerId;
  @override
  _TrainerProfilePageBookingState createState() =>
      new _TrainerProfilePageBookingState();
}

class _TrainerProfilePageBookingState extends State<TrainerProfilePageBooking>
    with SingleTickerProviderStateMixin {
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;
  String classOrWorkout;

  TrainerUser lastTrainer;
  bool restart = false;
  bool flagBusinessAccepted;
  bool flagFriendshipAccepted;
  bool flagBusinessPending;
  bool flagFriendshipPending;
  updateVisits() async {
    QuerySnapshot query = await Firestore.instance
        .collection('profileVisits')
        .where('id', isEqualTo: widget.bookedTrainerId)
        .getDocuments();
    if (query.documents.length != 0) {
      await Firestore.instance
          .collection('profileVisits')
          .document(widget.bookedTrainerId)
          .updateData(
        {
          'visits': TrainerProfileVisits(query.documents[0]).visits + 1,
          'graphViews.30': TrainerProfileVisits(query.documents[0])
                  .viewsList
                  .where((element) => element.number == '30')
                  .toList()[0]
                  .views +
              1,
          'id': widget.bookedTrainerId
        },
      );
    }
  }

  votingFlagFunction(String trainerId) async {
    if (widget.bookedTrainer.trophies > 0) {
      votingFlag = true;
    } else {
      votingFlag = false;
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    updateVisits();
    restart = false;

    votingFlag = null;
    flagBusinessAccepted = false;
    flagFriendshipAccepted = false;
    flagBusinessPending = false;
    flagFriendshipPending = false;

    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    cardAnimation = Tween(begin: 0.0, end: -0.025).animate(
      CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
    );

    delayedCardAnimation = Tween(begin: 0.0, end: -0.05).animate(
      CurvedAnimation(
          curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
          parent: controller),
    );

    fabButtonanim = Tween(begin: 1.0, end: -0.0008).animate(
      CurvedAnimation(
          curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn),
          parent: controller),
    );

    infoAnimation = Tween(begin: 0.0, end: 0.015).animate(
      CurvedAnimation(
          curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
          parent: controller),
    );
  }

  bool flagTrainerRequestPending = false;
  bool publicSessions = false;
  bool votingFlag;
  bool acceptRequest = false;
  bool seenFlag = false;
  String trainersSpecializations = "";
  bool rateFlag = false;

  @override
  Widget build(BuildContext context) {
    if (lastTrainer != null) {
      widget.bookedTrainer = lastTrainer;
    }
    controller.forward();
    publicSessions = false;
    votingFlag = false;
    seenFlag = false;
    trainersSpecializations = "";
    flagBusinessAccepted = false;
    flagBusinessPending = false;
    flagFriendshipAccepted = false;
    flagFriendshipPending = false;
    flagTrainerRequestPending = false;
    widget.actualClient.nearbyList.forEach((element) {
      if (element.id == widget.bookedTrainer.id && element.flag == true) {
        flagTrainerRequestPending = true;
      }
    });
    widget.actualClient.trainers.forEach((trainer) {
      if (trainer.trainerId == widget.bookedTrainer.id &&
          trainer.trainerAccepted == true) {
        flagBusinessAccepted = true;
      }
    });
    widget.actualClient.trainers.forEach((trainer) {
      if (trainer.trainerId == widget.bookedTrainer.id &&
          trainer.trainerAccepted == false) {
        flagBusinessPending = true;
      }
    });
    widget.actualClient.friends.forEach((friend) {
      if (friend.friendId == widget.bookedTrainer.id &&
          friend.friendAccepted == true) {
        flagFriendshipAccepted = true;
      }
    });
    widget.actualClient.friends.forEach((friend) {
      if (friend.friendId == widget.bookedTrainer.id &&
          friend.friendAccepted == false) {
        flagFriendshipPending = true;
      }
    });

    DateTime timestamp = Timestamp.now().toDate();

    if (timestamp.isAfter(
                widget.actualClient.scheduleFirstEndWeek.day1.toDate()) ==
            true &&
        timestamp.day ==
            widget.actualClient.scheduleFirstEndWeek.day1.toDate().day &&
        widget.actualClient.checkFirstSchedule.day1 == 'true' &&
        widget.actualClient.dailyVote == false &&
        widget.actualClient.trainingSessionTrainerId.day1 ==
            widget.bookedTrainerId) {
      widget.actualClient.trainers.forEach((element) {
        if (element.trainerAccepted == true &&
            element.trainerId == widget.bookedTrainerId) {
          classOrWorkout = "workout";
          votingFlagFunction(widget.bookedTrainerId);
        }
      });
    } else {
      if (widget.actualClient.dailyVote == false &&
          widget.actualClient.classVote == widget.bookedTrainerId) {
        widget.actualClient.trainers.forEach((element) {
          if (element.trainerAccepted == true &&
              element.trainerId == widget.bookedTrainerId) {
            classOrWorkout = "class";
            votingFlagFunction(widget.actualClient.classVote);
          }
        });
      }
    }

    widget.bookedTrainer.specializations.forEach((special) {
      if (special.certified == true) {
        trainersSpecializations = trainersSpecializations +
            special.specialization[0].toUpperCase() +
            special.specialization.substring(1) +
            ", ";
      }
    });
    if (trainersSpecializations.length > 2) {
      trainersSpecializations = trainersSpecializations.substring(
          0, trainersSpecializations.length - 2);
    }

    widget.bookedTrainer.classes.forEach((element) {
      if (element.public == true) {
        publicSessions = true;
      }
      if (element.public != true && flagBusinessAccepted == true) {
        publicSessions = true;
      }
    });
    widget.actualClient.unseenMessagesCounter.forEach((user) {
      if (user.userId == widget.bookedTrainer.id) {
        seenFlag = true;
      }
    });
    return new AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          color: backgroundColor,
          child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  centerTitle: true,
                  backgroundColor: backgroundColor,
                  elevation: 0.0,
                  title: Text(
                    widget.bookedTrainer.firstName +
                        " " +
                        widget.bookedTrainer.lastName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        letterSpacing: 0.8 * prefs.getDouble('height'),
                        wordSpacing: 7 * prefs.getDouble('height'),
                        fontSize: 20.0 * prefs.getDouble('height'),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                  ),
                ),
              ),
              backgroundColor: backgroundColor,
              body: IgnorePointer(
                ignoring: rateFlag,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 8 * prefs.getDouble('height'),
                      ),
                      Container(
                        height: 80 * prefs.getDouble('height'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 32 * prefs.getDouble('width')),
                                child: widget.bookedTrainer.photoUrl == null
                                    ? ClipOval(
                                        child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255,
                                              widget.bookedTrainer.colorRed,
                                              widget.bookedTrainer.colorGreen,
                                              widget.bookedTrainer.colorBlue),
                                          shape: BoxShape.circle,
                                        ),
                                        height:
                                            (80 * prefs.getDouble('height')),
                                        width: (80 * prefs.getDouble('height')),
                                        child: Center(
                                          child: Text(
                                            widget.bookedTrainer.firstName[0],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 50 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ))
                                    : InkWell(
                                        onTap: () {
                                          if (widget.bookedTrainer.photoUrl !=
                                              null) {
                                            Navigator.push(
                                                context,
                                                ProfilePhotoPopUp(
                                                  trainerUser:
                                                      widget.bookedTrainer,
                                                ));
                                          }
                                        },
                                        child: Material(
                                          child: Container(
                                            width:
                                                80 * prefs.getDouble('height'),
                                            height:
                                                80 * prefs.getDouble('height'),
                                            decoration: BoxDecoration(
                                                color: backgroundColor,
                                                shape: BoxShape.circle),
                                            child: Image.network(
                                              widget.bookedTrainer.photoUrl,
                                              fit: BoxFit.cover,
                                              scale: 1.0,
                                              loadingBuilder: (BuildContext ctx,
                                                  Widget child,
                                                  ImageChunkEvent
                                                      loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(mainColor),
                                                      backgroundColor:
                                                          backgroundColor,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(77.5),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                      )),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 32 * prefs.getDouble('width')),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 220 * prefs.getDouble('width'),
                                    child: Text(
                                      trainersSpecializations,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        letterSpacing:
                                            -0.408 * prefs.getDouble('width'),
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize:
                                            16.0 * prefs.getDouble('height'),
                                        color:
                                            Color.fromARGB(80, 255, 255, 255),
                                      ),
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Text(
                                    (widget.bookedTrainer.gender == 'male'
                                            ? 'Male, '
                                            : 'Female, ') +
                                        (widget.bookedTrainer.age.toString() +
                                            " years" +
                                            " | ") +
                                        (widget.bookedTrainer.clients.length
                                                .toString() +
                                            " clients"),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing:
                                          -0.408 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          16.0 * prefs.getDouble('height'),
                                      color: Color.fromARGB(80, 255, 255, 255),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    widget.bookedTrainer.freeTraining == true
                                        ? "First session is free"
                                        : "",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing:
                                          -0.408 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          16.0 * prefs.getDouble('height'),
                                      color: mainColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20 * prefs.getDouble('height'),
                      ),
                      publicSessions == true
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8 * prefs.getDouble('height'),
                                  horizontal: 32 * prefs.getDouble('width')),
                              child: InkWell(
                                onTap: () {
                                  QuerySnapshot query;
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TrainerPublicClasses(
                                              imTrainer: widget.bookedTrainer,
                                              imClient: widget.actualClient,
                                              parent: this,
                                              mainParent: widget.parent,
                                            )),
                                  ).whenComplete(() async => {
                                        query = await Firestore.instance
                                            .collection('clientUsers')
                                            .where('id',
                                                isEqualTo:
                                                    widget.bookedTrainer.id)
                                            .getDocuments(),
                                        lastTrainer =
                                            TrainerUser(query.documents[0]),
                                        widget.bookedTrainer =
                                            TrainerUser(query.documents[0])
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          16 * prefs.getDouble('width')),
                                  height: 32 * prefs.getDouble('height'),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: mainColor,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "This trainer has group classes",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                12 * prefs.getDouble('height')),
                                      ),
                                      Text(
                                        "View",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                12 * prefs.getDouble('height')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32 * prefs.getDouble('width')),
                            child: flagTrainerRequestPending == true
                                ? Container(
                                    height: 70 * prefs.getDouble('height'),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              38 * prefs.getDouble('height')),
                                      width: 310 * prefs.getDouble('width'),
                                      height: 32 * prefs.getDouble('height'),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(4),
                                        color: mainColor,
                                        child: MaterialButton(
                                            onPressed: () async {
                                              var db = Firestore.instance;
                                              var batch = db.batch();
                                              batch.updateData(
                                                db
                                                    .collection('clientUsers')
                                                    .document(widget
                                                        .bookedTrainer.id),
                                                {
                                                  'friendsMap.${prefs.getString('id')}':
                                                      true,
                                                  'acceptedFriendship': true,
                                                  'nearby.${prefs.getString('id')}':
                                                      false
                                                },
                                              );
                                              batch.updateData(
                                                db
                                                    .collection('clientUsers')
                                                    .document(
                                                        widget.actualClient.id),
                                                {
                                                  'friendsMap.${widget.bookedTrainer.id}':
                                                      true,
                                                  'nearby.${widget.bookedTrainer.id}':
                                                      FieldValue.delete()
                                                },
                                              );
                                              batch.setData(
                                                db
                                                    .collection(
                                                        'acceptedFriendship')
                                                    .document(widget
                                                        .bookedTrainer.id),
                                                {
                                                  'idFrom':
                                                      prefs.getString('id'),
                                                  'idTo':
                                                      widget.bookedTrainer.id,
                                                  'pushToken': widget
                                                      .bookedTrainer.pushToken,
                                                  'nickname': widget
                                                      .actualClient.firstName
                                                },
                                              );
                                              batch.commit();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.person_add,
                                                  color: Colors.white,
                                                  size: 16 *
                                                      prefs.getDouble('height'),
                                                ),
                                                SizedBox(
                                                  width: 10.0 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Text(
                                                  "Accept friend request",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12 *
                                                          prefs.getDouble(
                                                              'height')),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  )
                                : widget.actualClient.trainers
                                            .asMap()
                                            .keys
                                            .toList()
                                            .contains(
                                                widget.bookedTrainer.id) ==
                                        false
                                    ? (acceptRequest == false
                                        ? (flagBusinessAccepted == true
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        width: 150 *
                                                            prefs.getDouble(
                                                                'width'),
                                                        height: 32 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: secondaryColor,
                                                          child: MaterialButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.push(
                                                                    context,
                                                                    DeletePermissionPopup(
                                                                        trainer:
                                                                            widget
                                                                                .bookedTrainer,
                                                                        parent:
                                                                            this,
                                                                        friendOrBusiness:
                                                                            true));
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.0 *
                                                                        prefs.getDouble(
                                                                            'width'),
                                                                  ),
                                                                  Text(
                                                                    "End collaboration",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: Colors
                                                                            .white,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            11 *
                                                                                prefs.getDouble('height')),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 150 *
                                                            prefs.getDouble(
                                                                'width'),
                                                        height: 32 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        child: Material(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: seenFlag ==
                                                                  true
                                                              ? mainColor
                                                              : secondaryColor,
                                                          child: MaterialButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  new MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        Chat(
                                                                      peerId: widget
                                                                          .bookedTrainer
                                                                          .id,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons.chat,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.0 *
                                                                        prefs.getDouble(
                                                                            'width'),
                                                                  ),
                                                                  Text(
                                                                    "Chat",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        color: Colors
                                                                            .white,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            12 *
                                                                                prefs.getDouble('height')),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: 5.0 *
                                                          prefs.getDouble(
                                                              'height')),
                                                  votingFlag == true
                                                      ? Container(
                                                          child: Container(
                                                          width: 310 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color:
                                                                secondaryColor,
                                                            child:
                                                                MaterialButton(
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        rateFlag =
                                                                            true;
                                                                      });
                                                                      QuerySnapshot query = await Firestore
                                                                          .instance
                                                                          .collection(
                                                                              'clientUsers')
                                                                          .where(
                                                                              'id',
                                                                              isEqualTo: widget.bookedTrainer.id)
                                                                          .getDocuments();
                                                                      if (query.documents.length !=
                                                                              0 &&
                                                                          TrainerUser(query.documents[0]).trophies >
                                                                              0) {
                                                                        voteFlag =
                                                                            true;
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          Vote(
                                                                              clientUser: widget.actualClient,
                                                                              trainer: widget.bookedTrainer,
                                                                              parent: this,
                                                                              mainParent: widget.parent,
                                                                              workoutOrClass: classOrWorkout),
                                                                        );
                                                                      } else {
                                                                        widget
                                                                            .parent
                                                                            .setState(() {
                                                                          int followingTemp =
                                                                              0;
                                                                          int followingFirst =
                                                                              0;
                                                                          int followingSecond =
                                                                              0;
                                                                          int followingThird =
                                                                              0;
                                                                          int followingFourth =
                                                                              0;
                                                                          int followingFifth =
                                                                              0;
                                                                          int followingSixth =
                                                                              0;
                                                                          int followingSeventh =
                                                                              0;
                                                                          int rememberIndexTemp =
                                                                              -1;
                                                                          int rememberIndexFirstButton =
                                                                              -1;
                                                                          int rememberIndexSecondButton =
                                                                              -1;
                                                                          int rememberIndexThirdButton =
                                                                              -1;
                                                                          int rememberIndexFourthButton =
                                                                              -1;
                                                                          int rememberIndexFifthButton =
                                                                              -1;
                                                                          int rememberIndexSisxthButton =
                                                                              -1;
                                                                          int rememberIndexSeventhButton =
                                                                              -1;
                                                                          widget
                                                                              .parent
                                                                              .tempSearchStore
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainerId) {
                                                                              rememberIndexTemp = followingTemp;
                                                                            }
                                                                            followingTemp++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .firstButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainerId) {
                                                                              rememberIndexFirstButton = followingFirst;
                                                                            }
                                                                            followingFirst++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .secondButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainer.id) {
                                                                              rememberIndexSecondButton = followingSecond;
                                                                            }
                                                                            followingSecond++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .thirdButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainer.id) {
                                                                              rememberIndexThirdButton = followingThird;
                                                                            }
                                                                            followingThird++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .fourthButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainer.id) {
                                                                              rememberIndexFourthButton = followingFourth;
                                                                            }
                                                                            followingFourth++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .fifthButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainer.id) {
                                                                              rememberIndexFifthButton = followingFifth;
                                                                            }
                                                                            followingFifth++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .sixthButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainer.id) {
                                                                              rememberIndexSisxthButton = followingSixth;
                                                                            }
                                                                            followingSixth++;
                                                                          });
                                                                          widget
                                                                              .parent
                                                                              .seventhButton
                                                                              .forEach((element) {
                                                                            if (element.id ==
                                                                                widget.bookedTrainer.id) {
                                                                              rememberIndexSeventhButton = followingSeventh;
                                                                            }
                                                                            followingSeventh++;
                                                                          });
                                                                          if (rememberIndexTemp !=
                                                                              -1) {
                                                                            widget.parent.tempSearchStore.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.tempSearchStore.insert(rememberIndexTemp,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexFirstButton !=
                                                                              -1) {
                                                                            widget.parent.firstButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.firstButton.insert(rememberIndexFirstButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexSecondButton !=
                                                                              -1) {
                                                                            widget.parent.secondButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.secondButton.insert(rememberIndexSecondButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexThirdButton !=
                                                                              -1) {
                                                                            widget.parent.thirdButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.thirdButton.insert(rememberIndexThirdButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexFourthButton !=
                                                                              -1) {
                                                                            widget.parent.fourthButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.fourthButton.insert(rememberIndexFourthButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexFifthButton !=
                                                                              -1) {
                                                                            widget.parent.fifthButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.fifthButton.insert(rememberIndexFifthButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexSisxthButton !=
                                                                              -1) {
                                                                            widget.parent.sixthButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.sixthButton.insert(rememberIndexSisxthButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          if (rememberIndexSeventhButton !=
                                                                              -1) {
                                                                            widget.parent.seventhButton.removeWhere((element) =>
                                                                                element.id ==
                                                                                widget.bookedTrainer.id);
                                                                            widget.parent.seventhButton.insert(rememberIndexSeventhButton,
                                                                                TrainerUser(query.documents[0]));
                                                                          }
                                                                          setState(
                                                                              () {
                                                                            lastTrainer =
                                                                                TrainerUser(query.documents[0]);
                                                                            votingFlag =
                                                                                false;
                                                                            restart =
                                                                                true;
                                                                          });
                                                                        });
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PopUpMissingRoute(),
                                                                        );
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        rateFlag =
                                                                            false;
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          Icons
                                                                              .fitness_center,
                                                                          color:
                                                                              Colors.white,
                                                                          size: 16 *
                                                                              prefs.getDouble('height'),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10.0 * prefs.getDouble('width'),
                                                                        ),
                                                                        Text(
                                                                          "Rate your trainer",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              color: Colors.white,
                                                                              fontStyle: FontStyle.normal,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 12 * prefs.getDouble('height')),
                                                                        ),
                                                                      ],
                                                                    )),
                                                          ),
                                                        ))
                                                      : Container(
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        )
                                                ],
                                              )
                                            : flagBusinessPending == true
                                                ? Container(
                                                    height: 70 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 150 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color:
                                                                secondaryColor,
                                                            child:
                                                                MaterialButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.push(
                                                                          context,
                                                                          DeletePermissionPopup(
                                                                              trainer: widget.bookedTrainer,
                                                                              parent: this,
                                                                              friendOrBusiness: false));
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          Icons
                                                                              .cancel,
                                                                          color:
                                                                              Colors.white,
                                                                          size: 16 *
                                                                              prefs.getDouble('height'),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10.0 * prefs.getDouble('width'),
                                                                        ),
                                                                        Text(
                                                                          "Ignore friendship",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              color: Colors.white,
                                                                              fontStyle: FontStyle.normal,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 12 * prefs.getDouble('height')),
                                                                        ),
                                                                      ],
                                                                    )),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: 10 *
                                                                prefs.getDouble(
                                                                    'width')),
                                                        Container(
                                                          width: 150 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          child: Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: seenFlag ==
                                                                    false
                                                                ? secondaryColor
                                                                : mainColor,
                                                            child:
                                                                MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          new MaterialPageRoute(
                                                                            builder: (BuildContext context) =>
                                                                                Chat(
                                                                              peerId: widget.bookedTrainer.id,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          Icons
                                                                              .message,
                                                                          color:
                                                                              Colors.white,
                                                                          size: 16 *
                                                                              prefs.getDouble('height'),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10.0 * prefs.getDouble('width'),
                                                                        ),
                                                                        Text(
                                                                          "Chat",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              color: Colors.white,
                                                                              fontStyle: FontStyle.normal,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 12 * prefs.getDouble('height')),
                                                                        ),
                                                                      ],
                                                                    )),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : flagFriendshipAccepted == true
                                                    ? Container(
                                                        height: 70 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 149 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  child:
                                                                      Material(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    color:
                                                                        secondaryColor,
                                                                    child: MaterialButton(
                                                                        onPressed: () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              DeletePermissionPopup(trainer: widget.bookedTrainer, parent: this, friendOrBusiness: false));
                                                                        },
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.cancel,
                                                                              color: Colors.white,
                                                                              size: 16 * prefs.getDouble('height'),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.0 * prefs.getDouble('width'),
                                                                            ),
                                                                            Text(
                                                                              "Ignore friendship",
                                                                              style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 11 * prefs.getDouble('height')),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                ),
                                                                Container(
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  child:
                                                                      Material(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                    color: seenFlag ==
                                                                            false
                                                                        ? secondaryColor
                                                                        : mainColor,
                                                                    child: MaterialButton(
                                                                        onPressed: () {
                                                                          setState(
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              new MaterialPageRoute(
                                                                                builder: (BuildContext context) => Chat(
                                                                                  peerId: widget.bookedTrainer.id,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.chat,
                                                                              color: Colors.white,
                                                                              size: 16 * prefs.getDouble('height'),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.0 * prefs.getDouble('width'),
                                                                            ),
                                                                            Text(
                                                                              "Chat",
                                                                              style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 12 * prefs.getDouble('height')),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 5.0 *
                                                                    prefs.getDouble(
                                                                        'height')),
                                                            Container(
                                                              width: 310 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              child: Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color:
                                                                    mainColor,
                                                                child:
                                                                    MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          bool
                                                                              isStillMyTrainer =
                                                                              false;
                                                                          widget
                                                                              .actualClient
                                                                              .friends
                                                                              .forEach((element) {
                                                                            if (element.friendAccepted == true &&
                                                                                element.friendId == widget.bookedTrainerId) {
                                                                              isStillMyTrainer = true;
                                                                            }
                                                                          });
                                                                          if (isStillMyTrainer ==
                                                                              true) {
                                                                            var db =
                                                                                Firestore.instance;
                                                                            var batch =
                                                                                db.batch();
                                                                            batch.updateData(
                                                                              db.collection('clientUsers').document(widget.bookedTrainer.id),
                                                                              {
                                                                                'trainerMap.${prefs.getString('id')}': false,
                                                                                'newBusinessRequest': true,
                                                                                'businessRequestDate.${prefs.getString('id')}': DateTime.now()
                                                                              },
                                                                            );

                                                                            batch.updateData(
                                                                              db.collection('clientUsers').document(widget.actualClient.id),
                                                                              {
                                                                                'trainersMap.${widget.bookedTrainer.id}': false,
                                                                              },
                                                                            );

                                                                            QuerySnapshot
                                                                                query3 =
                                                                                await Firestore.instance.collection('trainerCollaborationRequestsReceived').where('id', isEqualTo: "IZbrg6TZg7BzyoOTsj8e").getDocuments();
                                                                            batch.updateData(
                                                                              db.collection('trainerCollaborationRequestsReceived').document('IZbrg6TZg7BzyoOTsj8e'),
                                                                              {
                                                                                'number': query3.documents[0].data['number'] + 1,
                                                                              },
                                                                            );
                                                                            batch.setData(
                                                                              db.collection('trainerRequests').document(widget.bookedTrainer.id),
                                                                              {
                                                                                'idFrom': prefs.getString('id'),
                                                                                'idTo': widget.bookedTrainer.id,
                                                                                'pushToken': widget.bookedTrainer.pushToken,
                                                                                'nickname': widget.actualClient.firstName
                                                                              },
                                                                            );
                                                                            batch.commit();
                                                                            AppReview.requestReview.then((String
                                                                                onValue) {
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.fitness_center,
                                                                              color: Colors.white,
                                                                              size: 16 * prefs.getDouble('height'),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.0 * prefs.getDouble('width'),
                                                                            ),
                                                                            Text(
                                                                              "Collaboration",
                                                                              style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 12 * prefs.getDouble('height')),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : flagFriendshipPending ==
                                                            false
                                                        ? Container(
                                                            height: 70 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  bottom: 38 *
                                                                      prefs.getDouble(
                                                                          'height')),
                                                              width: 310 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              child: Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color:
                                                                    secondaryColor,
                                                                child:
                                                                    MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          bool
                                                                              myTrainerFlag =
                                                                              false;
                                                                          widget
                                                                              .actualClient
                                                                              .friends
                                                                              .forEach((element) {
                                                                            if (element.friendId ==
                                                                                widget.bookedTrainerId) {
                                                                              myTrainerFlag = true;
                                                                            }
                                                                          });
                                                                          widget
                                                                              .actualClient
                                                                              .trainers
                                                                              .forEach((element) {
                                                                            if (element.trainerId ==
                                                                                widget.bookedTrainerId) {
                                                                              myTrainerFlag = true;
                                                                            }
                                                                          });

                                                                          if (myTrainerFlag ==
                                                                              false) {
                                                                            var db =
                                                                                Firestore.instance;
                                                                            var batch =
                                                                                db.batch();
                                                                            batch.updateData(
                                                                              db.collection('clientUsers').document(widget.bookedTrainer.id),
                                                                              {
                                                                                'friendsMap.${prefs.getString('id')}': false,
                                                                                'newFriendRequest': true,
                                                                                'friendRequestDate.${prefs.getString('id')}': DateTime.now()
                                                                              },
                                                                            );
                                                                            batch.updateData(
                                                                              db.collection('clientUsers').document(widget.actualClient.id),
                                                                              {
                                                                                'friendsMap.${widget.bookedTrainerId}': false,
                                                                              },
                                                                            );

                                                                            batch.setData(
                                                                              db.collection('friendRequests').document(widget.bookedTrainer.id),
                                                                              {
                                                                                'idFrom': prefs.getString('id'),
                                                                                'idTo': widget.bookedTrainer.id,
                                                                                'pushToken': widget.bookedTrainer.pushToken,
                                                                                'nickname': widget.actualClient.firstName
                                                                              },
                                                                            );

                                                                            QuerySnapshot
                                                                                query2 =
                                                                                await Firestore.instance.collection('trainerFriendRequestsReceived').where('id', isEqualTo: "hXlbrNjt6NFFiRG86B8j").getDocuments();
                                                                            batch.updateData(
                                                                              db.collection('trainerFriendRequestsReceived').document('hXlbrNjt6NFFiRG86B8j'),
                                                                              {
                                                                                'number': query2.documents[0].data['number'] + 1,
                                                                              },
                                                                            );
                                                                            batch.commit();
                                                                          }
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(
                                                                              Icons.person_add,
                                                                              color: Colors.white,
                                                                              size: 16 * prefs.getDouble('height'),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10.0 * prefs.getDouble('width'),
                                                                            ),
                                                                            Text(
                                                                              "Friend request",
                                                                              style: TextStyle(fontFamily: 'Roboto', color: Colors.white, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, fontSize: 12 * prefs.getDouble('height')),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            height: 70 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ))
                                        : Container(
                                            height:
                                                70 * prefs.getDouble('height'),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 38 *
                                                      prefs
                                                          .getDouble('height')),
                                              width: 310 *
                                                  prefs.getDouble('width'),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: secondaryColor,
                                                child: MaterialButton(
                                                    onPressed: () async {
                                                      var db =
                                                          Firestore.instance;
                                                      var batch = db.batch();
                                                      batch.updateData(
                                                        db
                                                            .collection(
                                                                'clientUsers')
                                                            .document(widget
                                                                .bookedTrainer
                                                                .id),
                                                        {
                                                          'friendsMap.${prefs.getString('id')}':
                                                              true,
                                                          'acceptedFriendship':
                                                              true
                                                        },
                                                      );
                                                      batch.updateData(
                                                        db
                                                            .collection(
                                                                'clientUsers')
                                                            .document(widget
                                                                .actualClient
                                                                .id),
                                                        {
                                                          'friendsMap.${widget.bookedTrainer.id}':
                                                              true,
                                                        },
                                                      );
                                                      batch.updateData(
                                                        db
                                                            .collection(
                                                                'acceptedFriendship')
                                                            .document(widget
                                                                .bookedTrainer
                                                                .id),
                                                        {
                                                          'idFrom': prefs
                                                              .getString('id'),
                                                          'idTo': widget
                                                              .bookedTrainer.id,
                                                          'pushToken': widget
                                                              .bookedTrainer
                                                              .pushToken,
                                                          'nickname': widget
                                                              .actualClient
                                                              .firstName
                                                        },
                                                      );
                                                      batch.commit();
                                                      setState(
                                                        () {
                                                          var i = 0;
                                                          widget.actualClient
                                                              .friends
                                                              .forEach(
                                                                  (element) {
                                                            if (element
                                                                    .friendId ==
                                                                widget
                                                                    .bookedTrainer
                                                                    .id) {
                                                              widget
                                                                  .actualClient
                                                                  .friends[i]
                                                                  .friendAccepted = true;
                                                            }
                                                            i++;
                                                          });

                                                          restart = true;
                                                          flagFriendshipAccepted =
                                                              true;
                                                          acceptRequest = false;
                                                        },
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.person_add,
                                                          color: Colors.white,
                                                          size: 16 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                        ),
                                                        Text(
                                                          "Accept friend request",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ))
                                    : flagBusinessAccepted == true
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 150 *
                                                        prefs
                                                            .getDouble('width'),
                                                    height: 32 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: secondaryColor,
                                                      child: MaterialButton(
                                                          onPressed: () async {
                                                            Navigator.push(
                                                                context,
                                                                DeletePermissionPopup(
                                                                    trainer: widget
                                                                        .bookedTrainer,
                                                                    parent:
                                                                        this,
                                                                    friendOrBusiness:
                                                                        true));
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .white,
                                                                size: 16 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              SizedBox(
                                                                width: 10.0 *
                                                                    prefs.getDouble(
                                                                        'width'),
                                                              ),
                                                              Text(
                                                                "End collaboration",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: Colors
                                                                        .white,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 11 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150 *
                                                        prefs
                                                            .getDouble('width'),
                                                    height: 32 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: seenFlag == true
                                                          ? mainColor
                                                          : secondaryColor,
                                                      child: MaterialButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              new MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                            context) =>
                                                                        Chat(
                                                                  peerId: widget
                                                                      .bookedTrainer
                                                                      .id,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.chat,
                                                                color: Colors
                                                                    .white,
                                                                size: 16 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              SizedBox(
                                                                width: 10.0 *
                                                                    prefs.getDouble(
                                                                        'width'),
                                                              ),
                                                              Text(
                                                                "Chat",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: Colors
                                                                        .white,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 12 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: 5.0 *
                                                      prefs
                                                          .getDouble('height')),
                                              votingFlag == true
                                                  ? Container(
                                                      child: Container(
                                                      width: 310 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      height: 32 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: secondaryColor,
                                                        child: MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                rateFlag = true;
                                                              });
                                                              QuerySnapshot query = await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .where('id',
                                                                      isEqualTo:
                                                                          widget
                                                                              .bookedTrainer
                                                                              .id)
                                                                  .getDocuments();
                                                              if (query.documents
                                                                          .length !=
                                                                      0 &&
                                                                  TrainerUser(query
                                                                              .documents[0])
                                                                          .trophies >
                                                                      0) {
                                                                voteFlag = true;
                                                                Navigator.push(
                                                                  context,
                                                                  Vote(
                                                                      clientUser:
                                                                          widget
                                                                              .actualClient,
                                                                      trainer:
                                                                          widget
                                                                              .bookedTrainer,
                                                                      parent:
                                                                          this,
                                                                      mainParent:
                                                                          widget
                                                                              .parent,
                                                                      workoutOrClass:
                                                                          classOrWorkout),
                                                                );
                                                              } else {
                                                                widget.parent
                                                                    .setState(
                                                                        () {
                                                                  int followingTemp =
                                                                      0;
                                                                  int followingFirst =
                                                                      0;
                                                                  int followingSecond =
                                                                      0;
                                                                  int followingThird =
                                                                      0;
                                                                  int followingFourth =
                                                                      0;
                                                                  int followingFifth =
                                                                      0;
                                                                  int followingSixth =
                                                                      0;
                                                                  int followingSeventh =
                                                                      0;
                                                                  int rememberIndexTemp =
                                                                      -1;
                                                                  int rememberIndexFirstButton =
                                                                      -1;
                                                                  int rememberIndexSecondButton =
                                                                      -1;
                                                                  int rememberIndexThirdButton =
                                                                      -1;
                                                                  int rememberIndexFourthButton =
                                                                      -1;
                                                                  int rememberIndexFifthButton =
                                                                      -1;
                                                                  int rememberIndexSisxthButton =
                                                                      -1;
                                                                  int rememberIndexSeventhButton =
                                                                      -1;
                                                                  widget.parent
                                                                      .tempSearchStore
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainerId) {
                                                                      rememberIndexTemp =
                                                                          followingTemp;
                                                                    }
                                                                    followingTemp++;
                                                                  });
                                                                  widget.parent
                                                                      .firstButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainerId) {
                                                                      rememberIndexFirstButton =
                                                                          followingFirst;
                                                                    }
                                                                    followingFirst++;
                                                                  });
                                                                  widget.parent
                                                                      .secondButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainer
                                                                            .id) {
                                                                      rememberIndexSecondButton =
                                                                          followingSecond;
                                                                    }
                                                                    followingSecond++;
                                                                  });
                                                                  widget.parent
                                                                      .thirdButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainer
                                                                            .id) {
                                                                      rememberIndexThirdButton =
                                                                          followingThird;
                                                                    }
                                                                    followingThird++;
                                                                  });
                                                                  widget.parent
                                                                      .fourthButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainer
                                                                            .id) {
                                                                      rememberIndexFourthButton =
                                                                          followingFourth;
                                                                    }
                                                                    followingFourth++;
                                                                  });
                                                                  widget.parent
                                                                      .fifthButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainer
                                                                            .id) {
                                                                      rememberIndexFifthButton =
                                                                          followingFifth;
                                                                    }
                                                                    followingFifth++;
                                                                  });
                                                                  widget.parent
                                                                      .sixthButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainer
                                                                            .id) {
                                                                      rememberIndexSisxthButton =
                                                                          followingSixth;
                                                                    }
                                                                    followingSixth++;
                                                                  });
                                                                  widget.parent
                                                                      .seventhButton
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        widget
                                                                            .bookedTrainer
                                                                            .id) {
                                                                      rememberIndexSeventhButton =
                                                                          followingSeventh;
                                                                    }
                                                                    followingSeventh++;
                                                                  });
                                                                  if (rememberIndexTemp !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .tempSearchStore
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .tempSearchStore
                                                                        .insert(
                                                                            rememberIndexTemp,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexFirstButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .firstButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .firstButton
                                                                        .insert(
                                                                            rememberIndexFirstButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexSecondButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .secondButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .secondButton
                                                                        .insert(
                                                                            rememberIndexSecondButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexThirdButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .thirdButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .thirdButton
                                                                        .insert(
                                                                            rememberIndexThirdButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexFourthButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .fourthButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .fourthButton
                                                                        .insert(
                                                                            rememberIndexFourthButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexFifthButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .fifthButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .fifthButton
                                                                        .insert(
                                                                            rememberIndexFifthButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexSisxthButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .sixthButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .sixthButton
                                                                        .insert(
                                                                            rememberIndexSisxthButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  if (rememberIndexSeventhButton !=
                                                                      -1) {
                                                                    widget
                                                                        .parent
                                                                        .seventhButton
                                                                        .removeWhere((element) =>
                                                                            element.id ==
                                                                            widget.bookedTrainer.id);
                                                                    widget
                                                                        .parent
                                                                        .seventhButton
                                                                        .insert(
                                                                            rememberIndexSeventhButton,
                                                                            widget.bookedTrainer);
                                                                  }
                                                                  setState(() {
                                                                    lastTrainer =
                                                                        widget
                                                                            .bookedTrainer;
                                                                    votingFlag =
                                                                        false;
                                                                    restart =
                                                                        true;
                                                                  });
                                                                });
                                                                Navigator.push(
                                                                  context,
                                                                  PopUpMissingRoute(),
                                                                );
                                                              }
                                                              setState(() {
                                                                rateFlag =
                                                                    false;
                                                              });
                                                            },
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .fitness_center,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                ),
                                                                SizedBox(
                                                                  width: 10.0 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                ),
                                                                Text(
                                                                  "Rate your trainer",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      color: Colors
                                                                          .white,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 12 *
                                                                          prefs.getDouble(
                                                                              'height')),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    ))
                                                  : Container(
                                                      height: 32 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                            ],
                                          )
                                        : Container(
                                            height:
                                                70 * prefs.getDouble('height'),
                                          )),
                      ),
                      publicSessions == false
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8 * prefs.getDouble('height'),
                                  horizontal: 32 * prefs.getDouble('width')),
                              child: Container(
                                height: 32 * prefs.getDouble('height'),
                              ))
                          : Container(),
                      SizedBox(
                        height: 18.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        width: double.infinity,
                        height: 20 * prefs.getDouble('height'),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32 * prefs.getDouble('width')),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Trainer rating: ${((widget.bookedTrainer.attributeMap.attribute1 + widget.bookedTrainer.attributeMap.attribute2) / 2).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: -0.408,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          17.0 * prefs.getDouble('height'),
                                      color:
                                          Color.fromARGB(200, 255, 255, 255)),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      DetailsPopUpReviews(
                                        trainerUser: widget.bookedTrainer,
                                      ));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Reviews",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            letterSpacing: -0.408,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0 *
                                                prefs.getDouble('height'),
                                            color: Color.fromARGB(
                                                150, 255, 255, 255)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0 * prefs.getDouble('width'),
                                    ),
                                    Icon(
                                      Icons.add_box,
                                      size: 15 * prefs.getDouble('height'),
                                      color: Color.fromARGB(150, 255, 255, 255),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.0 * prefs.getDouble('height'),
                      ),
                      RepaintBoundary(
                        child: Container(
                          height: 135 * prefs.getDouble('height'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: 32 * prefs.getDouble('width'),
                                ),
                                child: Text(
                                  "Communication: ${widget.bookedTrainer.attributeMap.attribute1.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(150, 255, 255, 255),
                                      fontSize:
                                          12.0 * prefs.getDouble('height'),
                                      letterSpacing: -0.066,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                height: 10.0 * prefs.getDouble('height'),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 34 * prefs.getDouble('width')),
                                height: 25 * prefs.getDouble('height'),
                                child: CustomPaint(
                                  foregroundPainter: CustomGraphRight(
                                    attribute1: widget
                                        .bookedTrainer.attributeMap.attribute1,
                                  ),
                                  child: Container(
                                    height: 25 * prefs.getDouble('height'),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: 32 * prefs.getDouble('width'),
                                ),
                                child: Text(
                                  "Profesionalism: ${widget.bookedTrainer.attributeMap.attribute2.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(150, 255, 255, 255),
                                      fontSize:
                                          12.0 * prefs.getDouble('height'),
                                      letterSpacing: -0.066,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(
                                height: 10.0 * prefs.getDouble('height'),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 34 * prefs.getDouble('width')),
                                height: 25 * prefs.getDouble('height'),
                                child: CustomPaint(
                                  foregroundPainter: CustomGraphRight(
                                    attribute1: widget
                                        .bookedTrainer.attributeMap.attribute2,
                                  ),
                                  child: Container(
                                    height: 25 * prefs.getDouble('height'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: 30 * prefs.getDouble('height'),
                          padding: EdgeInsets.only(
                              left: 32 * prefs.getDouble('width')),
                          child: Text(
                            "Gyms",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15 * prefs.getDouble('height'),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Color.fromARGB(120, 255, 255, 255)),
                            textAlign: TextAlign.start,
                          )),
                      Center(
                        child: Container(
                          width: 410 * prefs.getDouble('width'),
                          height: 250 * prefs.getDouble('height'),
                          child: CardSlider(
                            trainerUser: widget.bookedTrainer,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25 * prefs.getDouble('height'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Consts {
  Consts._();

  static const double padding = 8.0;
  static const double avatarRadius = 66.0;
}

class CardSlider extends StatefulWidget {
  final double height;
  final TrainerUser trainerUser;
  CardSlider({Key key, this.height, this.trainerUser}) : super(key: key);

  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  double positionY_line1;
  double positionY_line2;
  double _middleAreaHeight;
  double _outsideCardInterval;
  double scrollOffsetY;
  List<CardInfo> _cardInfoList;
  bool edit = false;
  List<double> cardsOpacity = [0, 0, 0, 0];

  int currentCard = 3;

  @override
  void initState() {
    super.initState();

    positionY_line1 = 3 * prefs.getDouble('height');
    positionY_line2 = (positionY_line1 + 105) * prefs.getDouble('height');

    _middleAreaHeight = positionY_line2 - positionY_line1;
    _outsideCardInterval = 22.0 * prefs.getDouble('height');
    scrollOffsetY = 0;

    _cardInfoList = [
      CardInfo(
          leftColor: mainColor,
          rightColor: mainColor,
          hintTextGym: widget.trainerUser.gym1,
          hintTextGymAddress: widget.trainerUser.gym1Street),
      CardInfo(
          leftColor: Color(0xffAC70F1),
          rightColor: Color(0xffAC70F1),
          hintTextGym: widget.trainerUser.gym2,
          hintTextGymAddress: widget.trainerUser.gym2Street),
      CardInfo(
          leftColor: Color(0xff8D5BC7),
          rightColor: Color(0xff8D5BC7),
          hintTextGym: widget.trainerUser.gym3,
          hintTextGymAddress: widget.trainerUser.gym3Street),
      CardInfo(
          leftColor: Color(0xff683E99),
          rightColor: Color(0xff683E99),
          hintTextGym: widget.trainerUser.gym4,
          hintTextGymAddress: widget.trainerUser.gym4Street)
    ];

    for (var i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[i];
      if (i == 0) {
        cardInfo.positionY = positionY_line1;
        cardInfo.opacity = 1.0;
        cardInfo.scale = 1.0;
        cardInfo.rotate = 1.0;
      } else {
        cardInfo.positionY = positionY_line2 + (i - 1) * _outsideCardInterval;
        cardInfo.opacity = 0.7;
        cardsOpacity[3 - i] = 0.85 - (3 - i) * 0.1;
        cardInfo.scale = 0.9;
        cardInfo.rotate = -60.0;
      }
    }

    _cardInfoList = _cardInfoList.reversed.toList();
  }

  _buildCards() {
    List widgetList = [];

    for (CardInfo cardInfo in _cardInfoList) {
      widgetList.add(Positioned(
        top: cardInfo.positionY,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(pi / 180 * cardInfo.rotate)
            ..scale(cardInfo.scale),
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: cardInfo.opacity,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10 * prefs.getDouble('height'),
                      offset: Offset(5 * prefs.getDouble('height'),
                          10 * prefs.getDouble('height')))
                ],
                borderRadius:
                    BorderRadius.circular(16 * prefs.getDouble('height')),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardInfo.leftColor,
                      cardInfo.rightColor,
                    ]),
              ),
              width: 310 * prefs.getDouble('width'),
              height: 150.0 * prefs.getDouble('height'),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 20 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "Name: " +
                          (cardInfo == _cardInfoList[3]
                              ? widget.trainerUser.gym1
                              : cardInfo == _cardInfoList[2]
                                  ? widget.trainerUser.gym2
                                  : cardInfo == _cardInfoList[1]
                                      ? widget.trainerUser.gym3
                                      : widget.trainerUser.gym4),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 20 * prefs.getDouble('height'),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                      top: 20 * prefs.getDouble('height'),
                      right: 20 * prefs.getDouble('width'),
                      child: InkWell(
                        onTap: () {
                          if (cardInfo == _cardInfoList[3]) {
                            if (widget.trainerUser.gym1Website != null) {
                              try {
                                launch(widget.trainerUser.gym1Website);
                              } catch (e) {}
                            }
                          }
                          if (cardInfo == _cardInfoList[2]) {
                            if (widget.trainerUser.gym2Website != null) {
                              try {
                                launch(widget.trainerUser.gym2Website);
                              } catch (e) {}
                            }
                          }
                          if (cardInfo == _cardInfoList[1]) {
                            if (widget.trainerUser.gym3Website != null) {
                              try {
                                launch(widget.trainerUser.gym3Website);
                              } catch (e) {}
                            }
                          }
                          if (cardInfo == _cardInfoList[0]) {
                            if (widget.trainerUser.gym4Website != null) {
                              try {
                                launch(widget.trainerUser.gym4Website);
                              } catch (e) {}
                            }
                          }
                        },
                        child: Icon(Icons.public,
                            size: 22 * prefs.getDouble('height'),
                            color: Colors.white),
                      )),
                  Positioned(
                    top: 68 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "Address",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 11 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Positioned(
                    top: 100 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "Street: " +
                          ((cardInfo == _cardInfoList[3]
                                      ? widget.trainerUser.gym1Street
                                      : cardInfo == _cardInfoList[2]
                                          ? widget.trainerUser.gym2Street
                                          : cardInfo == _cardInfoList[1]
                                              ? widget.trainerUser.gym3Street
                                              : widget
                                                  .trainerUser.gym4Street) ==
                                  ""
                              ? ""
                              : (cardInfo == _cardInfoList[3]
                                  ? widget.trainerUser.gym1Street
                                  : cardInfo == _cardInfoList[2]
                                      ? widget.trainerUser.gym2Street
                                      : cardInfo == _cardInfoList[1]
                                          ? widget.trainerUser.gym3Street
                                          : widget.trainerUser.gym4Street)),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 14 * prefs.getDouble('height'),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Positioned(
                    top: 120 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "District: " +
                          ((cardInfo == _cardInfoList[3]
                                      ? widget.trainerUser.gym1Sector
                                      : cardInfo == _cardInfoList[2]
                                          ? widget.trainerUser.gym2Sector
                                          : cardInfo == _cardInfoList[1]
                                              ? widget.trainerUser.gym3Sector
                                              : widget
                                                  .trainerUser.gym4Sector) ==
                                  ""
                              ? ""
                              : (cardInfo == _cardInfoList[3]
                                  ? widget.trainerUser.gym1Sector
                                  : cardInfo == _cardInfoList[2]
                                      ? widget.trainerUser.gym2Sector
                                      : cardInfo == _cardInfoList[1]
                                          ? widget.trainerUser.gym3Sector
                                          : widget.trainerUser.gym4Sector)),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 14 * prefs.getDouble('height'),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return widgetList;
  }

  _updateCardsPosition(double offsetY) {
    void updatePosition(
        CardInfo cardInfo, double firstCardAtAreaIdx, int cardIdx) {
      double currentCardAtAreaIdx = firstCardAtAreaIdx + cardIdx;
      if (currentCardAtAreaIdx < 0) {
        cardInfo.positionY =
            positionY_line1 + currentCardAtAreaIdx * _outsideCardInterval;
        cardInfo.rotate = -90.0 /
            _outsideCardInterval *
            (positionY_line1 - cardInfo.positionY);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -90.0) cardInfo.rotate = -90.0;

        cardInfo.scale = 1.0 -
            0.2 / _outsideCardInterval * (positionY_line1 - cardInfo.positionY);
        if (cardInfo.scale < 0.8) cardInfo.scale = 0.8;
        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;
      } else if (currentCardAtAreaIdx >= 0 && currentCardAtAreaIdx < 1) {
        cardInfo.positionY =
            positionY_line1 + currentCardAtAreaIdx * _middleAreaHeight;
        cardInfo.rotate = -60.0 /
            (positionY_line2 - positionY_line1) *
            (cardInfo.positionY - positionY_line1);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;
        cardInfo.textOpacity = 0;
        cardInfo.scale = 1.0 -
            0.1 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.scale < 0.9) cardInfo.scale = 0.9;
        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;

        cardInfo.opacity = 1.0 -
            0.3 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAreaIdx >= 1) {
        cardInfo.positionY =
            positionY_line2 + (currentCardAtAreaIdx - 1) * _outsideCardInterval;
        cardInfo.textOpacity = 0;
        cardInfo.rotate = -60.0;
        cardInfo.scale = 0.9;
        cardInfo.opacity = 0.7;
      }
    }

    scrollOffsetY += offsetY;

    double firstCardAtAreaIdx = scrollOffsetY / _middleAreaHeight;

    prefs.setDouble('edgeParameter', firstCardAtAreaIdx);
    for (var i = 0; i < _cardInfoList.length; i++) {
      if (firstCardAtAreaIdx + 3 == _cardInfoList.length - 1 - i) {
        currentCard = _cardInfoList.length - 1 - i;
      }
      CardInfo cardInfo = _cardInfoList[_cardInfoList.length - 1 - i];
      updatePosition(cardInfo, firstCardAtAreaIdx, i);
    }
    setState(() {});
  }

  double deltaY = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails d) {
              deltaY = d.delta.dy;
              if (prefs.getDouble('edgeParameter') >= -3.01 &&
                  prefs.getDouble('edgeParameter') <= 0) {
                _updateCardsPosition(d.delta.dy);
              }
            },
            onVerticalDragEnd: (DragEndDetails d) {
              scrollOffsetY = (scrollOffsetY / _middleAreaHeight).round() *
                  _middleAreaHeight;
              _updateCardsPosition(0);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Positioned(
                    top: positionY_line1,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: positionY_line2,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  ..._buildCards(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 140.0 * prefs.getDouble('height'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: 9.0 * prefs.getDouble('height')),
                      width: 90.0 * prefs.getDouble('width'),
                      height: 35.0 * prefs.getDouble('height'),
                      child: FlatButton(
                        onPressed: () => {
                          setState(() {
                            edit = true;
                          })
                        },
                        shape: StadiumBorder(),
                        child: Align(
                            alignment: Alignment.center, child: Container()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardInfo {
  String hintTextGym;
  String hintTextGymAddress;
  Color leftColor;
  Color rightColor;
  String userName;
  String cardCategory;
  double positionY = 0;
  double rotate = 0;
  double opacity = 0;
  double scale = 0;
  double textOpacity = 1;
  CardInfo(
      {this.userName,
      this.cardCategory,
      this.positionY,
      this.rotate,
      this.opacity,
      this.scale,
      this.leftColor,
      this.rightColor,
      this.hintTextGym,
      this.hintTextGymAddress});
}

class ProfilePhotoPopUp extends PopupRoute<void> {
  ProfilePhotoPopUp({this.trainerUser, this.currentCard});
  final int currentCard;
  final TrainerUser trainerUser;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      ProfilePhoto(
        trainer: trainerUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ProfilePhoto extends StatefulWidget {
  final TrainerUser trainer;
  ProfilePhoto({Key key, @required this.trainer}) : super(key: key);

  @override
  State createState() => ProfilePhotoState(trainer: trainer);
}

class ProfilePhotoState extends State<ProfilePhoto> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector;

  ProfilePhotoState({
    @required this.trainer,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent),
              child: Material(
                child: Container(
                  width: 250 * prefs.getDouble('width'),
                  height: 400 * prefs.getDouble('height'),
                  decoration: BoxDecoration(
                      color: Colors.transparent, shape: BoxShape.circle),
                  child: Image.network(
                    trainer.photoUrl,
                    fit: BoxFit.cover,
                    scale: 1.0,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor),
                            backgroundColor: backgroundColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeletePermissionPopup extends PopupRoute<void> {
  DeletePermissionPopup({this.trainer, this.parent, this.friendOrBusiness});
  final bool friendOrBusiness;
  final _TrainerProfilePageBookingState parent;
  final TrainerUser trainer;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      DeletePermission(
          trainer: trainer, parent: parent, friendOrBusiness: friendOrBusiness);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission extends StatefulWidget {
  final _TrainerProfilePageBookingState parent;
  final TrainerUser trainer;
  final bool friendOrBusiness;
  DeletePermission(
      {Key key,
      @required this.trainer,
      @required this.parent,
      this.friendOrBusiness})
      : super(key: key);

  @override
  State createState() => DeletePermissionState(trainer: trainer);
}

class DeletePermissionState extends State<DeletePermission> {
  final TrainerUser trainer;
  DeletePermissionState({Key key, @required this.trainer});

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 310 * prefs.getDouble('width'),
          height: 280 * prefs.getDouble('height'),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0 * prefs.getDouble('height')),
              color: backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Warning",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(200, 255, 255, 255),
                    fontSize: 20 * prefs.getDouble('height')),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16 * prefs.getDouble('height'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16 * prefs.getDouble('width')),
                child: Text(
                  widget.friendOrBusiness == false
                      ? "Are you sure you want to delete your friendship with ${trainer.firstName} ${trainer.lastName}?"
                      : "Are you sure you want to stop the training partnership with ${trainer.firstName} ${trainer.lastName}? The friendship will be deleted as well.",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(120, 255, 255, 255),
                    fontSize: 13 * prefs.getDouble('height'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 15.0 * prefs.getDouble('height')),
                child: Container(
                  width: 150.0 * prefs.getDouble('width'),
                  height: 50.0 * prefs.getDouble('height'),
                  child: Material(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () async {
                        var db = Firestore.instance;
                        var batch = db.batch();
                        batch.updateData(
                          db
                              .collection('clientUsers')
                              .document(prefs.getString('id')),
                          {
                            'trainersMap.${trainer.id}': FieldValue.delete(),
                            'friendsMap.${trainer.id}': FieldValue.delete()
                          },
                        );

                        batch.updateData(
                          db.collection('clientUsers').document(trainer.id),
                          {
                            'trainerMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );
                        batch.commit();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.friendOrBusiness == false
                            ? 'End friendship'
                            : "Stop training",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 17.0 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8 * prefs.getDouble('height'),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 32 * prefs.getDouble('height'),
                  width: 150 * prefs.getDouble('width'),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17 * prefs.getDouble('height'),
                          letterSpacing: -0.408,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Vote extends PopupRoute<void> {
  Vote(
      {this.clientUser,
      this.trainer,
      this.parent,
      this.mainParent,
      this.workoutOrClass});
  final _TrainerProfilePageBookingState parent;
  final _TrainerBookingPageState mainParent;
  final TrainerUser trainer;
  final ClientUser clientUser;
  final String workoutOrClass;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      GestureDetector(
        onTap: () {
          voteFlag = false;
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.transparent,
          child: CustomDialogVote(
              actualClient: clientUser,
              trainer: trainer,
              parent: parent,
              mainParent: mainParent,
              workoutOrClass: workoutOrClass),
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomDialogVote extends StatefulWidget {
  final _TrainerBookingPageState mainParent;
  final _TrainerProfilePageBookingState parent;
  final TrainerUser trainer;
  final ClientUser actualClient;
  final String workoutOrClass;

  CustomDialogVote(
      {Key key,
      @required this.trainer,
      @required this.parent,
      this.actualClient,
      this.mainParent,
      this.workoutOrClass})
      : super(key: key);

  @override
  State createState() =>
      CustomDialogVoteState(trainer: trainer, parent: parent);
}

class CustomDialogVoteState extends State<CustomDialogVote> {
  String hinttText = "Scrie";
  Image image;
  final _TrainerProfilePageBookingState parent;
  final TrainerUser trainer;
  bool insufficientTrophies = false;

  CustomDialogVoteState(
      {@required this.trainer, this.image, @required this.parent});
  String reviewText;
  int localAttribute1 = 1, localAttribute2 = 1;
  bool flagSpecialCharacters = false;
  bool rateFlag = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: IgnorePointer(
              ignoring: rateFlag,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 24 * prefs.getDouble('width')),
                height: 526 * prefs.getDouble('height'),
                width: 310 * prefs.getDouble('width'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: secondaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    SizedBox(
                      height: 25.0 * prefs.getDouble('height'),
                    ),
                    Text(
                      "Rate your training session accomplished by ${trainer.firstName} ${trainer.lastName}!",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(200, 255, 255, 255)),
                    ),
                    SizedBox(
                      height: 33.0 * prefs.getDouble('height'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Communication",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontSize: 13 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal),
                        ),
                        Rating(
                          initialRating: localAttribute1,
                          onRated: (value) {
                            setState(
                              () {
                                localAttribute1 = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0 * prefs.getDouble('height'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Profesionalism",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontSize: 13 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal),
                        ),
                        Rating(
                          initialRating: localAttribute2,
                          onRated: (value) {
                            setState(
                              () {
                                localAttribute2 = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Review(optional)",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontSize: 13 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal),
                        ),
                        Container(),
                      ],
                    ),
                    SizedBox(height: 24.0 * prefs.getDouble('height')),
                    Container(
                      height: 128 * prefs.getDouble('height'),
                      width: 280 * prefs.getDouble('width'),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Color(0xff57575E)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 128.0 * prefs.getDouble('height')),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SizedBox(
                              height: 128.0 * prefs.getDouble('height'),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16 * prefs.getDouble('width')),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: mainColor),
                                    ),
                                  ),
                                  cursorColor: mainColor,
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize:
                                          12.0 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                  onChanged: (String txt) {
                                    reviewText = txt;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0 * prefs.getDouble('height')),
                      child: Container(
                        width: 150.0 * prefs.getDouble('width'),
                        height: 50.0 * prefs.getDouble('height'),
                        child: Material(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(30.0),
                          child: MaterialButton(
                            onPressed: () async {
                              setState(() {
                                rateFlag = true;
                              });
                              TrainerUser updatedTrainer;
                              DateTime timestamp = Timestamp.now().toDate();
                              QuerySnapshot query = await Firestore.instance
                                  .collection('clientUsers')
                                  .where('id', isEqualTo: trainer.id)
                                  .getDocuments();
                              if (query.documents.length != 0) {
                                updatedTrainer =
                                    TrainerUser(query.documents[0]);
                                if (widget.workoutOrClass == "workout") {
                                  if (timestamp.isAfter(
                                              widget.actualClient
                                                  .scheduleFirstWeek.day1
                                                  .toDate()) ==
                                          true &&
                                      timestamp.day ==
                                          widget.actualClient.scheduleFirstWeek
                                              .day1
                                              .toDate()
                                              .day &&
                                      widget.actualClient.checkFirstSchedule
                                              .day1 ==
                                          'true' &&
                                      widget.actualClient.dailyVote == false) {
                                    if (updatedTrainer.trophies > 0) {
                                      var db = Firestore.instance;
                                      var batch = db.batch();
                                      updatedTrainer.clients
                                          .forEach((element) async {
                                        if (element.clientId ==
                                            prefs.getString('id')) {
                                          if (reviewText != null &&
                                              reviewText != "") {
                                            if (reviewText
                                                        .contains("~") ==
                                                    true ||
                                                reviewText
                                                        .contains("*") ==
                                                    true ||
                                                reviewText
                                                        .contains("[") ==
                                                    true ||
                                                reviewText.contains("]") ==
                                                    true ||
                                                reviewText.contains("/")) {
                                              flagSpecialCharacters = true;
                                              Navigator.push(context,
                                                  ReviewTextErrorClientPopUp());
                                            } else {
                                              flagSpecialCharacters = false;
                                              batch.updateData(
                                                db
                                                    .collection('clientUsers')
                                                    .document(
                                                        updatedTrainer.id),
                                                {
                                                  'attributeMap.1': (updatedTrainer
                                                                  .attributeMap
                                                                  .attribute1 *
                                                              updatedTrainer
                                                                  .votes +
                                                          localAttribute1) /
                                                      (updatedTrainer.votes +
                                                          1),
                                                  'attributeMap.2': (updatedTrainer
                                                                  .attributeMap
                                                                  .attribute2 *
                                                              updatedTrainer
                                                                  .votes +
                                                          localAttribute2) /
                                                      (updatedTrainer.votes +
                                                          1),
                                                  'votes':
                                                      updatedTrainer.votes + 1,
                                                  'month1.1': updatedTrainer
                                                          .month1.attribute1 +
                                                      (localAttribute1 == 5
                                                          ? 10
                                                          : localAttribute1 == 4
                                                              ? 5
                                                              : localAttribute1 ==
                                                                      3
                                                                  ? 0
                                                                  : localAttribute1 ==
                                                                          2
                                                                      ? -15
                                                                      : -30),
                                                  'month1.2': updatedTrainer
                                                          .month1.attribute2 +
                                                      (localAttribute2 == 5
                                                          ? 10
                                                          : localAttribute2 == 4
                                                              ? 5
                                                              : localAttribute2 ==
                                                                      3
                                                                  ? 0
                                                                  : localAttribute2 ==
                                                                          2
                                                                      ? -15
                                                                      : -30),
                                                  'reviewMap.${reviewText.contains(".") == true ? reviewText.replaceAll(".", ")()()(") : reviewText}':
                                                      DateTime.now(),
                                                  'trophies':
                                                      trainer.trophies - 1
                                                },
                                              );
                                              updatedTrainer.reviewMap.add(ReviewMap(
                                                  reviewText,
                                                  Timestamp
                                                      .fromMillisecondsSinceEpoch(
                                                          DateTime.now()
                                                              .millisecondsSinceEpoch)));
                                              updatedTrainer.attributeMap
                                                  .attribute1 = (updatedTrainer
                                                              .attributeMap
                                                              .attribute1 *
                                                          updatedTrainer.votes +
                                                      localAttribute1) /
                                                  (updatedTrainer.votes + 1);
                                              updatedTrainer.attributeMap
                                                  .attribute2 = (updatedTrainer
                                                              .attributeMap
                                                              .attribute2 *
                                                          updatedTrainer.votes +
                                                      localAttribute2) /
                                                  (updatedTrainer.votes + 1);
                                              batch.updateData(
                                                db
                                                    .collection('clientUsers')
                                                    .document(
                                                        prefs.getString('id')),
                                                {'dailyVote': true},
                                              );
                                              batch.commit();

                                              widget.mainParent.setState(() {
                                                int followingTemp = 0;
                                                int followingFirst = 0;
                                                int followingSecond = 0;
                                                int followingThird = 0;
                                                int followingFourth = 0;
                                                int followingFifth = 0;
                                                int followingSixth = 0;
                                                int followingSeventh = 0;
                                                int rememberIndexTemp = -1;
                                                int rememberIndexFirstButton =
                                                    -1;
                                                int rememberIndexSecondButton =
                                                    -1;
                                                int rememberIndexThirdButton =
                                                    -1;
                                                int rememberIndexFourthButton =
                                                    -1;
                                                int rememberIndexFifthButton =
                                                    -1;
                                                int rememberIndexSisxthButton =
                                                    -1;
                                                int rememberIndexSeventhButton =
                                                    -1;
                                                widget
                                                    .mainParent.tempSearchStore
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexTemp =
                                                        followingTemp;
                                                  }
                                                  followingTemp++;
                                                });
                                                widget.mainParent.firstButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexFirstButton =
                                                        followingFirst;
                                                  }
                                                  followingFirst++;
                                                });
                                                widget.mainParent.secondButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexSecondButton =
                                                        followingSecond;
                                                  }
                                                  followingSecond++;
                                                });
                                                widget.mainParent.thirdButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexThirdButton =
                                                        followingThird;
                                                  }
                                                  followingThird++;
                                                });
                                                widget.mainParent.fourthButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexFourthButton =
                                                        followingFourth;
                                                  }
                                                  followingFourth++;
                                                });
                                                widget.mainParent.fifthButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexFifthButton =
                                                        followingFifth;
                                                  }
                                                  followingFifth++;
                                                });
                                                widget.mainParent.sixthButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexSisxthButton =
                                                        followingSixth;
                                                  }
                                                  followingSixth++;
                                                });
                                                widget.mainParent.seventhButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexSeventhButton =
                                                        followingSeventh;
                                                  }
                                                  followingSeventh++;
                                                });
                                                if (rememberIndexTemp != -1) {
                                                  widget.mainParent
                                                      .tempSearchStore
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent
                                                      .tempSearchStore
                                                      .insert(rememberIndexTemp,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexFirstButton !=
                                                    -1) {
                                                  widget.mainParent.firstButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.firstButton
                                                      .insert(
                                                          rememberIndexFirstButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexSecondButton !=
                                                    -1) {
                                                  widget.mainParent.secondButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.secondButton
                                                      .insert(
                                                          rememberIndexSecondButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexThirdButton !=
                                                    -1) {
                                                  widget.mainParent.thirdButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.thirdButton
                                                      .insert(
                                                          rememberIndexThirdButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexFourthButton !=
                                                    -1) {
                                                  widget.mainParent.fourthButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.fourthButton
                                                      .insert(
                                                          rememberIndexFourthButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexFifthButton !=
                                                    -1) {
                                                  widget.mainParent.fifthButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.fifthButton
                                                      .insert(
                                                          rememberIndexFifthButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexSisxthButton !=
                                                    -1) {
                                                  widget.mainParent.sixthButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.sixthButton
                                                      .insert(
                                                          rememberIndexSisxthButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexSeventhButton !=
                                                    -1) {
                                                  widget
                                                      .mainParent.seventhButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget
                                                      .mainParent.seventhButton
                                                      .insert(
                                                          rememberIndexSeventhButton,
                                                          updatedTrainer);
                                                }
                                                widget.parent.setState(() {
                                                  widget.parent.lastTrainer =
                                                      updatedTrainer;
                                                  widget.parent.votingFlag =
                                                      false;
                                                  widget.parent.restart = true;
                                                });
                                              });
                                            }
                                          } else {
                                            flagSpecialCharacters = false;
                                            batch.updateData(
                                              db
                                                  .collection('clientUsers')
                                                  .document(updatedTrainer.id),
                                              {
                                                'attributeMap.1': (updatedTrainer
                                                                .attributeMap
                                                                .attribute1 *
                                                            updatedTrainer
                                                                .votes +
                                                        localAttribute1) /
                                                    (updatedTrainer.votes + 1),
                                                'attributeMap.2': (updatedTrainer
                                                                .attributeMap
                                                                .attribute2 *
                                                            updatedTrainer
                                                                .votes +
                                                        localAttribute2) /
                                                    (updatedTrainer.votes + 1),
                                                'votes':
                                                    updatedTrainer.votes + 1,
                                                'month1.1': updatedTrainer
                                                        .month1.attribute1 +
                                                    (localAttribute1 == 5
                                                        ? 10
                                                        : localAttribute1 == 4
                                                            ? 5
                                                            : localAttribute1 ==
                                                                    3
                                                                ? 0
                                                                : localAttribute1 ==
                                                                        2
                                                                    ? -15
                                                                    : -30),
                                                'month1.2': updatedTrainer
                                                        .month1.attribute2 +
                                                    (localAttribute2 == 5
                                                        ? 10
                                                        : localAttribute2 == 4
                                                            ? 5
                                                            : localAttribute2 ==
                                                                    3
                                                                ? 0
                                                                : localAttribute2 ==
                                                                        2
                                                                    ? -15
                                                                    : -30),
                                                'trophies': trainer.trophies - 1
                                              },
                                            );
                                          }
                                          updatedTrainer.attributeMap
                                              .attribute1 = (updatedTrainer
                                                          .attributeMap
                                                          .attribute1 *
                                                      updatedTrainer.votes +
                                                  localAttribute1) /
                                              (updatedTrainer.votes + 1);
                                          updatedTrainer.attributeMap
                                              .attribute2 = (updatedTrainer
                                                          .attributeMap
                                                          .attribute2 *
                                                      updatedTrainer.votes +
                                                  localAttribute2) /
                                              (updatedTrainer.votes + 1);
                                          updatedTrainer.trophies =
                                              updatedTrainer.trophies - 1;
                                          batch.updateData(
                                            db
                                                .collection('clientUsers')
                                                .document(
                                                    prefs.getString('id')),
                                            {'dailyVote': true},
                                          );
                                          batch.commit();

                                          widget.mainParent.setState(() {
                                            int followingTemp = 0;
                                            int followingFirst = 0;
                                            int followingSecond = 0;
                                            int followingThird = 0;
                                            int followingFourth = 0;
                                            int followingFifth = 0;
                                            int followingSixth = 0;
                                            int followingSeventh = 0;
                                            int rememberIndexTemp = -1;
                                            int rememberIndexFirstButton = -1;
                                            int rememberIndexSecondButton = -1;
                                            int rememberIndexThirdButton = -1;
                                            int rememberIndexFourthButton = -1;
                                            int rememberIndexFifthButton = -1;
                                            int rememberIndexSisxthButton = -1;
                                            int rememberIndexSeventhButton = -1;
                                            widget.mainParent.tempSearchStore
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexTemp =
                                                    followingTemp;
                                              }
                                              followingTemp++;
                                            });
                                            widget.mainParent.firstButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexFirstButton =
                                                    followingFirst;
                                              }
                                              followingFirst++;
                                            });
                                            widget.mainParent.secondButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexSecondButton =
                                                    followingSecond;
                                              }
                                              followingSecond++;
                                            });
                                            widget.mainParent.thirdButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexThirdButton =
                                                    followingThird;
                                              }
                                              followingThird++;
                                            });
                                            widget.mainParent.fourthButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexFourthButton =
                                                    followingFourth;
                                              }
                                              followingFourth++;
                                            });
                                            widget.mainParent.fifthButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexFifthButton =
                                                    followingFifth;
                                              }
                                              followingFifth++;
                                            });
                                            widget.mainParent.sixthButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexSisxthButton =
                                                    followingSixth;
                                              }
                                              followingSixth++;
                                            });
                                            widget.mainParent.seventhButton
                                                .forEach((element) {
                                              if (element.id ==
                                                  updatedTrainer.id) {
                                                rememberIndexSeventhButton =
                                                    followingSeventh;
                                              }
                                              followingSeventh++;
                                            });
                                            if (rememberIndexTemp != -1) {
                                              widget.mainParent.tempSearchStore
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.tempSearchStore
                                                  .insert(rememberIndexTemp,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexFirstButton !=
                                                -1) {
                                              widget.mainParent.firstButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.firstButton
                                                  .insert(
                                                      rememberIndexFirstButton,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexSecondButton !=
                                                -1) {
                                              widget.mainParent.secondButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.secondButton
                                                  .insert(
                                                      rememberIndexSecondButton,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexThirdButton !=
                                                -1) {
                                              widget.mainParent.thirdButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.thirdButton
                                                  .insert(
                                                      rememberIndexThirdButton,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexFourthButton !=
                                                -1) {
                                              widget.mainParent.fourthButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.fourthButton
                                                  .insert(
                                                      rememberIndexFourthButton,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexFifthButton !=
                                                -1) {
                                              widget.mainParent.fifthButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.fifthButton
                                                  .insert(
                                                      rememberIndexFifthButton,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexSisxthButton !=
                                                -1) {
                                              widget.mainParent.sixthButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.sixthButton
                                                  .insert(
                                                      rememberIndexSisxthButton,
                                                      updatedTrainer);
                                            }
                                            if (rememberIndexSeventhButton !=
                                                -1) {
                                              widget.mainParent.seventhButton
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      updatedTrainer.id);
                                              widget.mainParent.seventhButton
                                                  .insert(
                                                      rememberIndexSeventhButton,
                                                      updatedTrainer);
                                            }
                                            widget.parent.setState(() {
                                              widget.parent.lastTrainer =
                                                  updatedTrainer;
                                              widget.parent.votingFlag = false;
                                              widget.parent.restart = true;
                                            });
                                          });
                                        }
                                      });
                                    } else {
                                      insufficientTrophies = true;
                                    }
                                  }
                                } else {
                                  if (widget.workoutOrClass == "class") {
                                    if (widget.actualClient.classVote ==
                                            widget.trainer.id &&
                                        widget.actualClient.dailyVote ==
                                            false) {
                                      QuerySnapshot query1 = await Firestore
                                          .instance
                                          .collection('classVote')
                                          .where('trainerId',
                                              isEqualTo:
                                                  widget.actualClient.classVote)
                                          .where('votingIds',
                                              arrayContains:
                                                  prefs.getString('id'))
                                          .getDocuments();
                                      query = await Firestore.instance
                                          .collection('clientUsers')
                                          .where('id',
                                              isEqualTo:
                                                  widget.actualClient.classVote)
                                          .getDocuments();
                                      if (query1.documents.length != 0 &&
                                          query.documents.length != 0) {
                                        TrainerUser trainer =
                                            TrainerUser(query.documents[0]);
                                        if (trainer.trophies > 0) {
                                          var db = Firestore.instance;
                                          var batch = db.batch();
                                          trainer.clients
                                              .forEach((element) async {
                                            if (element.clientId ==
                                                    prefs.getString('id') &&
                                                element.clientAccepted ==
                                                    true) {
                                              if (reviewText != null &&
                                                  reviewText != "") {
                                                if (reviewText
                                                            .contains("~") ==
                                                        true ||
                                                    reviewText
                                                            .contains("*") ==
                                                        true ||
                                                    reviewText
                                                            .contains("[") ==
                                                        true ||
                                                    reviewText.contains("]") ==
                                                        true ||
                                                    reviewText.contains("/")) {
                                                  flagSpecialCharacters = true;
                                                  Navigator.push(context,
                                                      ReviewTextErrorClientPopUp());
                                                } else {
                                                  flagSpecialCharacters = false;
                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(trainer.id),
                                                    {
                                                      'attributeMap.1': (trainer
                                                                      .attributeMap
                                                                      .attribute1 *
                                                                  trainer
                                                                      .votes +
                                                              localAttribute1) /
                                                          (trainer.votes + 1),
                                                      'attributeMap.2': (trainer
                                                                      .attributeMap
                                                                      .attribute2 *
                                                                  trainer
                                                                      .votes +
                                                              localAttribute2) /
                                                          (trainer.votes + 1),
                                                      'votes':
                                                          trainer.votes + 1,
                                                      'reviewMap.${reviewText.contains(".") == true ? reviewText.replaceAll(".", ")()()(") : reviewText}':
                                                          DateTime.now(),
                                                      'trophies':
                                                          trainer.trophies - 1
                                                    },
                                                  );
                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(prefs
                                                            .getString('id')),
                                                    {'dailyVote': true},
                                                  );
                                                  batch.updateData(
                                                    db
                                                        .collection('classVote')
                                                        .document(query1
                                                            .documents[0]
                                                            .documentID),
                                                    {
                                                      'attribute1.${prefs.getString('id')}':
                                                          (localAttribute1 == 5
                                                              ? 10
                                                              : localAttribute1 ==
                                                                      4
                                                                  ? 5
                                                                  : localAttribute1 ==
                                                                          3
                                                                      ? 0
                                                                      : localAttribute1 ==
                                                                              2
                                                                          ? -5
                                                                          : -10),
                                                      'attribute2.${prefs.getString('id')}':
                                                          (localAttribute2 == 5
                                                              ? 10
                                                              : localAttribute2 ==
                                                                      4
                                                                  ? 5
                                                                  : localAttribute2 ==
                                                                          3
                                                                      ? 0
                                                                      : localAttribute2 ==
                                                                              2
                                                                          ? -5
                                                                          : -10),
                                                    },
                                                  );
                                                  batch.commit();

                                                  updatedTrainer.attributeMap
                                                      .attribute1 = (updatedTrainer
                                                                  .attributeMap
                                                                  .attribute1 *
                                                              updatedTrainer
                                                                  .votes +
                                                          localAttribute1) /
                                                      (updatedTrainer.votes +
                                                          1);
                                                  updatedTrainer.attributeMap
                                                      .attribute2 = (updatedTrainer
                                                                  .attributeMap
                                                                  .attribute2 *
                                                              updatedTrainer
                                                                  .votes +
                                                          localAttribute2) /
                                                      (updatedTrainer.votes +
                                                          1);
                                                  updatedTrainer.trophies =
                                                      updatedTrainer.trophies -
                                                          1;
                                                  updatedTrainer.reviewMap.add(
                                                      ReviewMap(
                                                          reviewText,
                                                          Timestamp
                                                              .fromMillisecondsSinceEpoch(
                                                                  DateTime.now()
                                                                      .millisecondsSinceEpoch)));

                                                  widget.mainParent
                                                      .setState(() {
                                                    int followingTemp = 0;
                                                    int followingFirst = 0;
                                                    int followingSecond = 0;
                                                    int followingThird = 0;
                                                    int followingFourth = 0;
                                                    int followingFifth = 0;
                                                    int followingSixth = 0;
                                                    int followingSeventh = 0;
                                                    int rememberIndexTemp = -1;
                                                    int rememberIndexFirstButton =
                                                        -1;
                                                    int rememberIndexSecondButton =
                                                        -1;
                                                    int rememberIndexThirdButton =
                                                        -1;
                                                    int rememberIndexFourthButton =
                                                        -1;
                                                    int rememberIndexFifthButton =
                                                        -1;
                                                    int rememberIndexSisxthButton =
                                                        -1;
                                                    int rememberIndexSeventhButton =
                                                        -1;
                                                    widget.mainParent
                                                        .tempSearchStore
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexTemp =
                                                            followingTemp;
                                                      }
                                                      followingTemp++;
                                                    });
                                                    widget
                                                        .mainParent.firstButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFirstButton =
                                                            followingFirst;
                                                      }
                                                      followingFirst++;
                                                    });
                                                    widget
                                                        .mainParent.secondButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSecondButton =
                                                            followingSecond;
                                                      }
                                                      followingSecond++;
                                                    });
                                                    widget
                                                        .mainParent.thirdButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexThirdButton =
                                                            followingThird;
                                                      }
                                                      followingThird++;
                                                    });
                                                    widget
                                                        .mainParent.fourthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFourthButton =
                                                            followingFourth;
                                                      }
                                                      followingFourth++;
                                                    });
                                                    widget
                                                        .mainParent.fifthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFifthButton =
                                                            followingFifth;
                                                      }
                                                      followingFifth++;
                                                    });
                                                    widget
                                                        .mainParent.sixthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSisxthButton =
                                                            followingSixth;
                                                      }
                                                      followingSixth++;
                                                    });
                                                    widget.mainParent
                                                        .seventhButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSeventhButton =
                                                            followingSeventh;
                                                      }
                                                      followingSeventh++;
                                                    });
                                                    if (rememberIndexTemp !=
                                                        -1) {
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .insert(
                                                              rememberIndexTemp,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFirstButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .firstButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .firstButton
                                                          .insert(
                                                              rememberIndexFirstButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSecondButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .secondButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .secondButton
                                                          .insert(
                                                              rememberIndexSecondButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexThirdButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .thirdButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .thirdButton
                                                          .insert(
                                                              rememberIndexThirdButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFourthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fourthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fourthButton
                                                          .insert(
                                                              rememberIndexFourthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFifthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fifthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fifthButton
                                                          .insert(
                                                              rememberIndexFifthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSisxthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .sixthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .sixthButton
                                                          .insert(
                                                              rememberIndexSisxthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSeventhButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .seventhButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .seventhButton
                                                          .insert(
                                                              rememberIndexSeventhButton,
                                                              updatedTrainer);
                                                    }
                                                    widget.parent.setState(() {
                                                      widget.parent
                                                              .lastTrainer =
                                                          updatedTrainer;
                                                      widget.parent.votingFlag =
                                                          false;
                                                      widget.parent.restart =
                                                          true;
                                                    });
                                                  });
                                                }
                                              } else {
                                                flagSpecialCharacters = false;
                                                batch.updateData(
                                                  db
                                                      .collection('clientUsers')
                                                      .document(trainer.id),
                                                  {
                                                    'attributeMap.1': (trainer
                                                                    .attributeMap
                                                                    .attribute1 *
                                                                trainer.votes +
                                                            localAttribute1) /
                                                        (trainer.votes + 1),
                                                    'attributeMap.2': (trainer
                                                                    .attributeMap
                                                                    .attribute2 *
                                                                trainer.votes +
                                                            localAttribute2) /
                                                        (trainer.votes + 1),
                                                    'votes': trainer.votes + 1,
                                                    'trophies':
                                                        trainer.trophies - 1
                                                  },
                                                );
                                                batch.updateData(
                                                  db
                                                      .collection('clientUsers')
                                                      .document(prefs
                                                          .getString('id')),
                                                  {'dailyVote': true},
                                                );
                                                batch.updateData(
                                                  db
                                                      .collection('classVote')
                                                      .document(query1
                                                          .documents[0]
                                                          .documentID),
                                                  {
                                                    'attribute1.${prefs.getString('id')}':
                                                        (localAttribute1 == 5
                                                            ? 10
                                                            : localAttribute1 ==
                                                                    4
                                                                ? 5
                                                                : localAttribute1 ==
                                                                        3
                                                                    ? 0
                                                                    : localAttribute1 ==
                                                                            2
                                                                        ? -5
                                                                        : -10),
                                                    'attribute2.${prefs.getString('id')}':
                                                        (localAttribute2 == 5
                                                            ? 10
                                                            : localAttribute2 ==
                                                                    4
                                                                ? 5
                                                                : localAttribute2 ==
                                                                        3
                                                                    ? 0
                                                                    : localAttribute2 ==
                                                                            2
                                                                        ? -5
                                                                        : -10),
                                                  },
                                                );
                                                batch.commit();
                                                updatedTrainer.attributeMap
                                                    .attribute1 = (updatedTrainer
                                                                .attributeMap
                                                                .attribute1 *
                                                            updatedTrainer
                                                                .votes +
                                                        localAttribute1) /
                                                    (updatedTrainer.votes + 1);
                                                updatedTrainer.attributeMap
                                                    .attribute2 = (updatedTrainer
                                                                .attributeMap
                                                                .attribute2 *
                                                            updatedTrainer
                                                                .votes +
                                                        localAttribute2) /
                                                    (updatedTrainer.votes + 1);
                                                updatedTrainer.trophies =
                                                    updatedTrainer.trophies - 1;
                                                widget.mainParent.setState(() {
                                                  int followingTemp = 0;
                                                  int followingFirst = 0;
                                                  int followingSecond = 0;
                                                  int followingThird = 0;
                                                  int followingFourth = 0;
                                                  int followingFifth = 0;
                                                  int followingSixth = 0;
                                                  int followingSeventh = 0;
                                                  int rememberIndexTemp = -1;
                                                  int rememberIndexFirstButton =
                                                      -1;
                                                  int rememberIndexSecondButton =
                                                      -1;
                                                  int rememberIndexThirdButton =
                                                      -1;
                                                  int rememberIndexFourthButton =
                                                      -1;
                                                  int rememberIndexFifthButton =
                                                      -1;
                                                  int rememberIndexSisxthButton =
                                                      -1;
                                                  int rememberIndexSeventhButton =
                                                      -1;
                                                  widget.mainParent
                                                      .tempSearchStore
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexTemp =
                                                          followingTemp;
                                                    }
                                                    followingTemp++;
                                                  });
                                                  widget.mainParent.firstButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexFirstButton =
                                                          followingFirst;
                                                    }
                                                    followingFirst++;
                                                  });
                                                  widget.mainParent.secondButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexSecondButton =
                                                          followingSecond;
                                                    }
                                                    followingSecond++;
                                                  });
                                                  widget.mainParent.thirdButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexThirdButton =
                                                          followingThird;
                                                    }
                                                    followingThird++;
                                                  });
                                                  widget.mainParent.fourthButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexFourthButton =
                                                          followingFourth;
                                                    }
                                                    followingFourth++;
                                                  });
                                                  widget.mainParent.fifthButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexFifthButton =
                                                          followingFifth;
                                                    }
                                                    followingFifth++;
                                                  });
                                                  widget.mainParent.sixthButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexSisxthButton =
                                                          followingSixth;
                                                    }
                                                    followingSixth++;
                                                  });
                                                  widget
                                                      .mainParent.seventhButton
                                                      .forEach((element) {
                                                    if (element.id ==
                                                        updatedTrainer.id) {
                                                      rememberIndexSeventhButton =
                                                          followingSeventh;
                                                    }
                                                    followingSeventh++;
                                                  });
                                                  if (rememberIndexTemp != -1) {
                                                    widget.mainParent
                                                        .tempSearchStore
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget.mainParent
                                                        .tempSearchStore
                                                        .insert(
                                                            rememberIndexTemp,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexFirstButton !=
                                                      -1) {
                                                    widget
                                                        .mainParent.firstButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget
                                                        .mainParent.firstButton
                                                        .insert(
                                                            rememberIndexFirstButton,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexSecondButton !=
                                                      -1) {
                                                    widget
                                                        .mainParent.secondButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element
                                                                    .id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget
                                                        .mainParent.secondButton
                                                        .insert(
                                                            rememberIndexSecondButton,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexThirdButton !=
                                                      -1) {
                                                    widget
                                                        .mainParent.thirdButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget
                                                        .mainParent.thirdButton
                                                        .insert(
                                                            rememberIndexThirdButton,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexFourthButton !=
                                                      -1) {
                                                    widget
                                                        .mainParent.fourthButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element
                                                                    .id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget
                                                        .mainParent.fourthButton
                                                        .insert(
                                                            rememberIndexFourthButton,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexFifthButton !=
                                                      -1) {
                                                    widget
                                                        .mainParent.fifthButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget
                                                        .mainParent.fifthButton
                                                        .insert(
                                                            rememberIndexFifthButton,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexSisxthButton !=
                                                      -1) {
                                                    widget
                                                        .mainParent.sixthButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget
                                                        .mainParent.sixthButton
                                                        .insert(
                                                            rememberIndexSisxthButton,
                                                            updatedTrainer);
                                                  }
                                                  if (rememberIndexSeventhButton !=
                                                      -1) {
                                                    widget.mainParent
                                                        .seventhButton
                                                        .removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                updatedTrainer
                                                                    .id);
                                                    widget.mainParent
                                                        .seventhButton
                                                        .insert(
                                                            rememberIndexSeventhButton,
                                                            updatedTrainer);
                                                  }
                                                  widget.parent.setState(() {
                                                    widget.parent.lastTrainer =
                                                        updatedTrainer;
                                                    widget.parent.votingFlag =
                                                        false;
                                                    widget.parent.restart =
                                                        true;
                                                  });
                                                });
                                              }
                                            }
                                          });
                                        } else {
                                          insufficientTrophies = true;
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                              if (flagSpecialCharacters != true) {
                                voteFlag = false;
                                if (query.documents.length != 0) {
                                  widget.mainParent.setState(() {
                                    int followingTemp = 0;
                                    int followingFirst = 0;
                                    int followingSecond = 0;
                                    int followingThird = 0;
                                    int followingFourth = 0;
                                    int followingFifth = 0;
                                    int followingSixth = 0;
                                    int followingSeventh = 0;
                                    int rememberIndexTemp = -1;
                                    int rememberIndexFirstButton = -1;
                                    int rememberIndexSecondButton = -1;
                                    int rememberIndexThirdButton = -1;
                                    int rememberIndexFourthButton = -1;
                                    int rememberIndexFifthButton = -1;
                                    int rememberIndexSisxthButton = -1;
                                    int rememberIndexSeventhButton = -1;
                                    widget.mainParent.tempSearchStore
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexTemp = followingTemp;
                                      }
                                      followingTemp++;
                                    });
                                    widget.mainParent.firstButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexFirstButton =
                                            followingFirst;
                                      }
                                      followingFirst++;
                                    });
                                    widget.mainParent.secondButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexSecondButton =
                                            followingSecond;
                                      }
                                      followingSecond++;
                                    });
                                    widget.mainParent.thirdButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexThirdButton =
                                            followingThird;
                                      }
                                      followingThird++;
                                    });
                                    widget.mainParent.fourthButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexFourthButton =
                                            followingFourth;
                                      }
                                      followingFourth++;
                                    });
                                    widget.mainParent.fifthButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexFifthButton =
                                            followingFifth;
                                      }
                                      followingFifth++;
                                    });
                                    widget.mainParent.sixthButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexSisxthButton =
                                            followingSixth;
                                      }
                                      followingSixth++;
                                    });
                                    widget.mainParent.seventhButton
                                        .forEach((element) {
                                      if (element.id == updatedTrainer.id) {
                                        rememberIndexSeventhButton =
                                            followingSeventh;
                                      }
                                      followingSeventh++;
                                    });
                                    if (rememberIndexTemp != -1) {
                                      widget.mainParent.tempSearchStore
                                          .removeWhere((element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.tempSearchStore.insert(
                                          rememberIndexTemp, updatedTrainer);
                                    }
                                    if (rememberIndexFirstButton != -1) {
                                      widget.mainParent.firstButton.removeWhere(
                                          (element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.firstButton.insert(
                                          rememberIndexFirstButton,
                                          updatedTrainer);
                                    }
                                    if (rememberIndexSecondButton != -1) {
                                      widget.mainParent.secondButton
                                          .removeWhere((element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.secondButton.insert(
                                          rememberIndexSecondButton,
                                          updatedTrainer);
                                    }
                                    if (rememberIndexThirdButton != -1) {
                                      widget.mainParent.thirdButton.removeWhere(
                                          (element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.thirdButton.insert(
                                          rememberIndexThirdButton,
                                          updatedTrainer);
                                    }
                                    if (rememberIndexFourthButton != -1) {
                                      widget.mainParent.fourthButton
                                          .removeWhere((element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.fourthButton.insert(
                                          rememberIndexFourthButton,
                                          updatedTrainer);
                                    }
                                    if (rememberIndexFifthButton != -1) {
                                      widget.mainParent.fifthButton.removeWhere(
                                          (element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.fifthButton.insert(
                                          rememberIndexFifthButton,
                                          updatedTrainer);
                                    }
                                    if (rememberIndexSisxthButton != -1) {
                                      widget.mainParent.sixthButton.removeWhere(
                                          (element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.sixthButton.insert(
                                          rememberIndexSisxthButton,
                                          updatedTrainer);
                                    }
                                    if (rememberIndexSeventhButton != -1) {
                                      widget.mainParent.seventhButton
                                          .removeWhere((element) =>
                                              element.id == updatedTrainer.id);
                                      widget.mainParent.seventhButton.insert(
                                          rememberIndexSeventhButton,
                                          updatedTrainer);
                                    }
                                    widget.parent.setState(() {
                                      widget.parent.lastTrainer =
                                          updatedTrainer;
                                      widget.parent.votingFlag = false;
                                      widget.parent.restart = true;
                                    });
                                  });
                                }

                                Navigator.of(context).pop();
                                if (insufficientTrophies == true) {
                                  Navigator.push(
                                    context,
                                    PopUpMissingRoute(),
                                  );
                                }
                              }
                              setState(() {
                                rateFlag = false;
                              });
                            },
                            child: Text(
                              'Rate',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 17.0 * prefs.getDouble('height'),
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5 * prefs.getDouble('height')),
                    GestureDetector(
                      onTap: () {
                        voteFlag = false;
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 30 * prefs.getDouble('height'),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontSize: 17 * prefs.getDouble('height'),
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrainerPublicClasses extends StatefulWidget {
  final ClientUser imClient;
  final _TrainerBookingPageState mainParent;
  final _TrainerProfilePageBookingState parent;
  TrainerUser imTrainer;
  TrainerPublicClasses(
      {this.imTrainer, this.imClient, this.parent, this.mainParent});
  @override
  _TrainerPublicClassesState createState() => _TrainerPublicClassesState();
}

List<int> indexes = [];

class _TrainerPublicClassesState extends State<TrainerPublicClasses> {
  bool loading = false;
  List<String> daysOfTheWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  List<String> monthsOfTheYear = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "Octomber",
    "November",
    "December"
  ];
  TrainerUser updatedTrainer;

  Widget item(BuildContext context, TrainerUser trainer, int index) {
    bool enrolledFlag = false;
    widget.imClient.classes.forEach((actualClass) {
      if (actualClass.duration == trainer.classes[index].duration &&
          actualClass.dateAndTimeDateTime ==
              trainer.classes[index].dateAndTimeDateTime &&
          actualClass.dateAndTime == trainer.classes[index].dateAndTime &&
          actualClass.trainerId == trainer.id) {
        enrolledFlag = true;
      }
    });

    if (trainer.classes[index] != null) {
      bool itsClient = false;
      widget.imClient.trainers.forEach((actualTrainer) {
        if (actualTrainer.trainerId == trainer.id &&
            actualTrainer.trainerAccepted == true) {
          itsClient = true;
        }
      });
      if (itsClient == false && trainer.classes[index].public != true) {
        return Container();
      } else {
        if (indexes.contains(index)) {
          indexes.remove(index);
        }
        String hour = trainer.classes[index].dateAndTimeDateTime.hour < 10
            ? ("0" + trainer.classes[index].dateAndTimeDateTime.hour.toString())
            : trainer.classes[index].dateAndTimeDateTime.hour.toString();
        String minute = trainer.classes[index].dateAndTimeDateTime.minute < 10
            ? ("0" +
                trainer.classes[index].dateAndTimeDateTime.minute.toString())
            : trainer.classes[index].dateAndTimeDateTime.minute.toString();
        String duration;
        if (trainer.classes[index].duration.toDate().hour < 1) {
          if (trainer.classes[index].duration.toDate().minute >= 0 &&
              trainer.classes[index].duration.toDate().minute < 10) {
            duration = "0${trainer.classes[index].duration.toDate().minute}m";
          }
          if (trainer.classes[index].duration.toDate().minute > 9 &&
              trainer.classes[index].duration.toDate().minute < 60) {
            duration = "${trainer.classes[index].duration.toDate().minute}m";
          }
        } else {
          if (trainer.classes[index].duration.toDate().hour > 0 &&
              trainer.classes[index].duration.toDate().hour < 10) {
            duration = "0${trainer.classes[index].duration.toDate().hour}h";
          }
          if (trainer.classes[index].duration.toDate().hour > 9 &&
              trainer.classes[index].duration.toDate().hour < 60) {
            duration = "${trainer.classes[index].duration.toDate().hour}h";
          }

          if (trainer.classes[index].duration.toDate().minute >= 0 &&
              trainer.classes[index].duration.toDate().minute < 10) {
            duration = duration +
                " " +
                "0${trainer.classes[index].duration.toDate().minute}m";
          }
          if (trainer.classes[index].duration.toDate().minute > 9 &&
              trainer.classes[index].duration.toDate().minute < 60) {
            duration = duration +
                " " +
                "${trainer.classes[index].duration.toDate().minute}m";
          }
        }

        bool unavailable = false;
        if (trainer.classes[index].occupiedSpots.length >=
                trainer.classes[index].spots &&
            enrolledFlag == false) {
          unavailable = true;
        }
        return IgnorePointer(
          ignoring: loading,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 343 * prefs.getDouble('width'),
                      height: 306 * prefs.getDouble('height'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: secondaryColor,
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16 * prefs.getDouble('width'),
                              vertical: 16 * prefs.getDouble('height')),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 56 * prefs.getDouble('height'),
                                    width: 216 * prefs.getDouble('width'),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            "${trainer.classes[index].dateAndTimeDateTime.year}" +
                                                "-" +
                                                "${monthsOfTheYear[trainer.classes[index].dateAndTimeDateTime.month - 1]}" +
                                                "-" +
                                                "${trainer.classes[index].dateAndTimeDateTime.day}" +
                                                "-" +
                                                "${daysOfTheWeek[trainer.classes[index].dateAndTimeDateTime.weekday - 1]}" +
                                                " " +
                                                hour +
                                                ":" +
                                                minute,
                                            style: TextStyle(
                                                letterSpacing: 0.066,
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Roboto',
                                                color: mainColor)),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 15 *
                                                    prefs.getDouble('height'),
                                                fontFamily: 'Roboto',
                                                letterSpacing: -0.24),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: trainer.classes[index]
                                                        .classLevel +
                                                    " " +
                                                    trainer
                                                        .classes[index].type +
                                                    " Class with " +
                                                    trainer.firstName +
                                                    " " +
                                                    trainer.lastName,
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    letterSpacing: -0.408,
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                  text: trainer.classes[index]
                                                              .public ==
                                                          true
                                                      ? " - PUBLIC"
                                                      : " - PRIVATE",
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: 12 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 25 * prefs.getDouble('height'),
                                    width: 94 * prefs.getDouble('width'),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(duration,
                                              style: TextStyle(
                                                  fontSize: 15 *
                                                      prefs.getDouble('height'),
                                                  letterSpacing: -0.24,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255),
                                                  fontFamily: 'Roboto')),
                                          SizedBox(
                                              width: 8.0 *
                                                  prefs.getDouble('width')),
                                          Icon(Icons.alarm,
                                              color: mainColor,
                                              size: 24 *
                                                  prefs.getDouble('height'))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 16 * prefs.getDouble('height')),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 24 * prefs.getDouble('height'),
                                    color: mainColor,
                                  ),
                                  SizedBox(width: 8 * prefs.getDouble('width')),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 15 *
                                                  prefs.getDouble('height'),
                                              fontFamily: 'Roboto',
                                              letterSpacing: -0.24),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "At ",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    150, 255, 255, 255),
                                              ),
                                            ),
                                            TextSpan(
                                              text: trainer
                                                  .classes[index].locationName,
                                              style:
                                                  TextStyle(color: mainColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        trainer.classes[index].locationStreet +
                                            ", " +
                                            trainer.classes[index]
                                                .locationDistrict,
                                        style: TextStyle(
                                            fontSize:
                                                15 * prefs.getDouble('height'),
                                            fontFamily: 'Roboto',
                                            letterSpacing: -0.24,
                                            color: Color.fromARGB(
                                                150, 255, 255, 255)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 16 * prefs.getDouble('height')),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.people,
                                    size: 24 * prefs.getDouble('height'),
                                    color: mainColor,
                                  ),
                                  SizedBox(width: 8 * prefs.getDouble('width')),
                                  Text(
                                    trainer.classes[index].occupiedSpots.length
                                            .toString() +
                                        "/" +
                                        trainer.classes[index].spots
                                            .toString() +
                                        " occupied spots in this class",
                                    style: TextStyle(
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        fontFamily: 'Roboto',
                                        letterSpacing: -0.24,
                                        color:
                                            Color.fromARGB(150, 255, 255, 255)),
                                  )
                                ],
                              ),
                              SizedBox(height: 16 * prefs.getDouble('height')),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.monetization_on,
                                    size: 24 * prefs.getDouble('height'),
                                    color: mainColor,
                                  ),
                                  SizedBox(width: 8 * prefs.getDouble('width')),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: trainer.classes[index]
                                                  .individualPrice,
                                              style: TextStyle(
                                                color: mainColor,
                                                fontSize: 22 *
                                                    prefs.getDouble('height'),
                                              ),
                                            ),
                                            TextSpan(
                                              text: " individual price",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      150, 255, 255, 255),
                                                  fontSize: 15 *
                                                      prefs.getDouble('height'),
                                                  letterSpacing: -0.24),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "or " +
                                            trainer.classes[index].memberPrice +
                                            " member price",
                                        style: TextStyle(
                                            fontSize:
                                                15 * prefs.getDouble('height'),
                                            fontFamily: 'Roboto',
                                            letterSpacing: -0.24,
                                            color: Color.fromARGB(
                                                150, 255, 255, 255)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 24.0 * prefs.getDouble('height')),
                                child: Container(
                                  width: 310.0 * prefs.getDouble('width'),
                                  height: 42.0 * prefs.getDouble('height'),
                                  child: Material(
                                    color: unavailable == true
                                        ? Color(0xff57575E)
                                        : enrolledFlag == false
                                            ? mainColor
                                            : Color(0xff57575E),
                                    borderRadius: BorderRadius.circular(90.0),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        if (unavailable == false) {
                                          if (enrolledFlag == true) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "You have already signed up for this class",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 18.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    color: mainColor),
                                                textAlign: TextAlign.center,
                                              ),
                                            ));
                                          } else {
                                            QuerySnapshot query =
                                                await Firestore.instance
                                                    .collection('clientUsers')
                                                    .where('id',
                                                        isEqualTo: trainer.id)
                                                    .getDocuments();

                                            updatedTrainer =
                                                TrainerUser(query.documents[0]);
                                            bool flagUpdated = false;
                                            int temporaryIndex = 0;
                                            updatedTrainer.classes
                                                .forEach((actualClass) async {
                                              if (actualClass.dateAndTime ==
                                                      trainer.classes[index]
                                                          .dateAndTime &&
                                                  actualClass
                                                          .dateAndTimeDateTime ==
                                                      trainer.classes[index]
                                                          .dateAndTimeDateTime &&
                                                  actualClass.duration ==
                                                      trainer.classes[index]
                                                          .duration &&
                                                  actualClass.firstName ==
                                                      trainer.classes[index]
                                                          .firstName &&
                                                  trainer.classes[index]
                                                          .lastName ==
                                                      actualClass.lastName) {
                                                flagUpdated = true;
                                                index = temporaryIndex;
                                              }

                                              temporaryIndex++;
                                            });
                                            if (flagUpdated == true) {
                                              trainer = updatedTrainer;
                                              double rating = 0;
                                              int mediaAritmetica = 0;
                                              if (widget.imClient.votesMap
                                                      .length !=
                                                  0) {
                                                widget.imClient.votesMap
                                                    .forEach((element) {
                                                  mediaAritmetica++;
                                                  rating +=
                                                      element.vote.toDouble();
                                                });
                                                rating /= mediaAritmetica;
                                              }
                                              bool overLap = false;
                                              if (widget.imClient
                                                      .counterClassesClient >
                                                  0) {
                                                var time1 = [];
                                                var time2 = [];
                                                widget.imClient.classes
                                                    .forEach((actualClass) {
                                                  time1.add(actualClass
                                                      .dateAndTimeDateTime);
                                                  time2.add(actualClass
                                                      .dateAndTimeDateTime
                                                      .add(Duration(
                                                          hours: actualClass
                                                              .duration
                                                              .toDate()
                                                              .hour,
                                                          minutes: actualClass
                                                              .duration
                                                              .toDate()
                                                              .minute)));
                                                });
                                                for (int i = 0;
                                                    i <
                                                        widget.imClient
                                                                .counterClassesClient -
                                                            1;
                                                    i++) {
                                                  for (int j = i + 1;
                                                      j <
                                                          widget.imClient
                                                              .counterClassesClient;
                                                      j++) {
                                                    if (time1[i]
                                                        .isAfter(time1[j])) {
                                                      var aux1 = time1[i];
                                                      time1[i] = time1[j];
                                                      time1[j] = aux1;

                                                      var aux2 = time2[i];
                                                      time2[i] = time2[j];
                                                      time2[j] = aux2;
                                                    }
                                                  }
                                                }
                                                for (int i = 0;
                                                    i <
                                                        widget.imClient
                                                                .counterClassesClient -
                                                            1;
                                                    i++) {
                                                  if (time2[i].isBefore(trainer
                                                          .classes[index]
                                                          .dateAndTimeDateTime) &&
                                                      time1[i + 1].isAfter(trainer
                                                          .classes[index]
                                                          .dateAndTimeDateTime
                                                          .add(Duration(
                                                              hours: trainer
                                                                  .classes[
                                                                      index]
                                                                  .duration
                                                                  .toDate()
                                                                  .hour,
                                                              minutes: trainer
                                                                  .classes[
                                                                      index]
                                                                  .duration
                                                                  .toDate()
                                                                  .minute)))) {
                                                    overLap = true;
                                                  }
                                                }

                                                if (time1[0].isAfter(trainer
                                                    .classes[index]
                                                    .dateAndTimeDateTime
                                                    .add(Duration(
                                                        hours: trainer
                                                            .classes[index]
                                                            .duration
                                                            .toDate()
                                                            .hour,
                                                        minutes: trainer
                                                            .classes[index]
                                                            .duration
                                                            .toDate()
                                                            .minute)))) {
                                                  overLap = true;
                                                }

                                                if (time2[widget.imClient
                                                            .counterClassesClient -
                                                        1]
                                                    .isBefore(trainer
                                                        .classes[index]
                                                        .dateAndTimeDateTime)) {
                                                  overLap = true;
                                                }
                                              } else {
                                                overLap = true;
                                              }
                                              if (enrolledFlag == true) {
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    "You have already signed up for this class",
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 18.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: mainColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ));
                                                setState(() {
                                                  widget.imTrainer =
                                                      updatedTrainer;

                                                  widget.mainParent
                                                      .setState(() {
                                                    int followingTemp = 0;
                                                    int followingFirst = 0;
                                                    int followingSecond = 0;
                                                    int followingThird = 0;
                                                    int followingFourth = 0;
                                                    int followingFifth = 0;
                                                    int followingSixth = 0;
                                                    int followingSeventh = 0;
                                                    int rememberIndexTemp = -1;
                                                    int rememberIndexFirstButton =
                                                        -1;
                                                    int rememberIndexSecondButton =
                                                        -1;
                                                    int rememberIndexThirdButton =
                                                        -1;
                                                    int rememberIndexFourthButton =
                                                        -1;
                                                    int rememberIndexFifthButton =
                                                        -1;
                                                    int rememberIndexSisxthButton =
                                                        -1;
                                                    int rememberIndexSeventhButton =
                                                        -1;
                                                    widget.mainParent
                                                        .tempSearchStore
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexTemp =
                                                            followingTemp;
                                                      }
                                                      followingTemp++;
                                                    });
                                                    widget
                                                        .mainParent.firstButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFirstButton =
                                                            followingFirst;
                                                      }
                                                      followingFirst++;
                                                    });
                                                    widget
                                                        .mainParent.secondButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSecondButton =
                                                            followingSecond;
                                                      }
                                                      followingSecond++;
                                                    });
                                                    widget
                                                        .mainParent.thirdButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexThirdButton =
                                                            followingThird;
                                                      }
                                                      followingThird++;
                                                    });
                                                    widget
                                                        .mainParent.fourthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFourthButton =
                                                            followingFourth;
                                                      }
                                                      followingFourth++;
                                                    });
                                                    widget
                                                        .mainParent.fifthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFifthButton =
                                                            followingFifth;
                                                      }
                                                      followingFifth++;
                                                    });
                                                    widget
                                                        .mainParent.sixthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSisxthButton =
                                                            followingSixth;
                                                      }
                                                      followingSixth++;
                                                    });
                                                    widget.mainParent
                                                        .seventhButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSeventhButton =
                                                            followingSeventh;
                                                      }
                                                      followingSeventh++;
                                                    });
                                                    if (rememberIndexTemp !=
                                                        -1) {
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .insert(
                                                              rememberIndexTemp,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFirstButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .firstButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .firstButton
                                                          .insert(
                                                              rememberIndexFirstButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSecondButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .secondButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .secondButton
                                                          .insert(
                                                              rememberIndexSecondButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexThirdButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .thirdButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .thirdButton
                                                          .insert(
                                                              rememberIndexThirdButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFourthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fourthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fourthButton
                                                          .insert(
                                                              rememberIndexFourthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFifthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fifthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fifthButton
                                                          .insert(
                                                              rememberIndexFifthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSisxthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .sixthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .sixthButton
                                                          .insert(
                                                              rememberIndexSisxthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSeventhButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .seventhButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .seventhButton
                                                          .insert(
                                                              rememberIndexSeventhButton,
                                                              updatedTrainer);
                                                    }
                                                  });
                                                });
                                              }
                                              if (overLap == true) {
                                                if (updatedTrainer
                                                        .classes[index]
                                                        .occupiedSpots
                                                        .length >=
                                                    updatedTrainer
                                                        .classes[index].spots) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "All spots in this class have been occupied.",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 18.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: mainColor),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                                  setState(() {
                                                    widget.mainParent
                                                        .setState(() {
                                                      int followingTemp = 0;
                                                      int followingFirst = 0;
                                                      int followingSecond = 0;
                                                      int followingThird = 0;
                                                      int followingFourth = 0;
                                                      int followingFifth = 0;
                                                      int followingSixth = 0;
                                                      int followingSeventh = 0;
                                                      int rememberIndexTemp =
                                                          -1;
                                                      int rememberIndexFirstButton =
                                                          -1;
                                                      int rememberIndexSecondButton =
                                                          -1;
                                                      int rememberIndexThirdButton =
                                                          -1;
                                                      int rememberIndexFourthButton =
                                                          -1;
                                                      int rememberIndexFifthButton =
                                                          -1;
                                                      int rememberIndexSisxthButton =
                                                          -1;
                                                      int rememberIndexSeventhButton =
                                                          -1;
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexTemp =
                                                              followingTemp;
                                                        }
                                                        followingTemp++;
                                                      });
                                                      widget.mainParent
                                                          .firstButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexFirstButton =
                                                              followingFirst;
                                                        }
                                                        followingFirst++;
                                                      });
                                                      widget.mainParent
                                                          .secondButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexSecondButton =
                                                              followingSecond;
                                                        }
                                                        followingSecond++;
                                                      });
                                                      widget.mainParent
                                                          .thirdButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexThirdButton =
                                                              followingThird;
                                                        }
                                                        followingThird++;
                                                      });
                                                      widget.mainParent
                                                          .fourthButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexFourthButton =
                                                              followingFourth;
                                                        }
                                                        followingFourth++;
                                                      });
                                                      widget.mainParent
                                                          .fifthButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexFifthButton =
                                                              followingFifth;
                                                        }
                                                        followingFifth++;
                                                      });
                                                      widget.mainParent
                                                          .sixthButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexSisxthButton =
                                                              followingSixth;
                                                        }
                                                        followingSixth++;
                                                      });
                                                      widget.mainParent
                                                          .seventhButton
                                                          .forEach((element) {
                                                        if (element.id ==
                                                            updatedTrainer.id) {
                                                          rememberIndexSeventhButton =
                                                              followingSeventh;
                                                        }
                                                        followingSeventh++;
                                                      });
                                                      if (rememberIndexTemp !=
                                                          -1) {
                                                        widget.mainParent
                                                            .tempSearchStore
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .tempSearchStore
                                                            .insert(
                                                                rememberIndexTemp,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexFirstButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .firstButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .firstButton
                                                            .insert(
                                                                rememberIndexFirstButton,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexSecondButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .secondButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .secondButton
                                                            .insert(
                                                                rememberIndexSecondButton,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexThirdButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .thirdButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .thirdButton
                                                            .insert(
                                                                rememberIndexThirdButton,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexFourthButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .fourthButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .fourthButton
                                                            .insert(
                                                                rememberIndexFourthButton,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexFifthButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .fifthButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .fifthButton
                                                            .insert(
                                                                rememberIndexFifthButton,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexSisxthButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .sixthButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .sixthButton
                                                            .insert(
                                                                rememberIndexSisxthButton,
                                                                updatedTrainer);
                                                      }
                                                      if (rememberIndexSeventhButton !=
                                                          -1) {
                                                        widget.mainParent
                                                            .seventhButton
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    updatedTrainer
                                                                        .id);
                                                        widget.mainParent
                                                            .seventhButton
                                                            .insert(
                                                                rememberIndexSeventhButton,
                                                                updatedTrainer);
                                                      }
                                                    });
                                                    widget.imTrainer =
                                                        updatedTrainer;
                                                  });
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    CongratsPopup(),
                                                  );
                                                  var db = Firestore.instance;
                                                  var batch = db.batch();
                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(trainer.id),
                                                    {
                                                      'newMemberJoined': true,
                                                      'class${index + 1}.occupiedSpots.${widget.imClient.id}':
                                                          true,
                                                      'class${index + 1}.clientsFirstName.${prefs.getString('id')}':
                                                          widget.imClient
                                                              .firstName,
                                                      'class${index + 1}.clientsAge.${prefs.getString('id')}':
                                                          widget.imClient.age
                                                              .toString(),
                                                      'class${index + 1}.clientsGender.${prefs.getString('id')}':
                                                          widget
                                                              .imClient.gender,
                                                      'class${index + 1}.clientsLastName.${prefs.getString('id')}':
                                                          widget.imClient
                                                              .lastName,
                                                      'class${index + 1}.clientsPhotoUrl.${prefs.getString('id')}':
                                                          widget.imClient
                                                              .photoUrl,
                                                      'class${index + 1}.clientsColorRed.${prefs.getString('id')}':
                                                          widget
                                                              .imClient.colorRed
                                                              .toString(),
                                                      'class${index + 1}.clientsColorGreen.${prefs.getString('id')}':
                                                          widget.imClient
                                                              .colorGreen
                                                              .toString(),
                                                      'class${index + 1}.clientsColorBlue.${prefs.getString('id')}':
                                                          widget.imClient
                                                              .colorBlue
                                                              .toString(),
                                                      'class${index + 1}.clientsRating.${prefs.getString('id')}':
                                                          rating.toString(),
                                                    },
                                                  );

                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(prefs
                                                            .getString('id')),
                                                    {
                                                      'deletedClient': true,
                                                      'class${widget.imClient.counterClassesClient + 1}':
                                                          {},
                                                    },
                                                  );
                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(prefs
                                                            .getString('id')),
                                                    {
                                                      'class${widget.imClient.counterClassesClient + 1}.public':
                                                          trainer.classes[index]
                                                              .public,
                                                      'class${widget.imClient.counterClassesClient + 1}.classLevel':
                                                          trainer.classes[index]
                                                              .classLevel,
                                                      'class${widget.imClient.counterClassesClient + 1}.locationName':
                                                          trainer.classes[index]
                                                              .locationName,
                                                      'class${widget.imClient.counterClassesClient + 1}.locationDistrict':
                                                          trainer.classes[index]
                                                              .locationDistrict,
                                                      'class${widget.imClient.counterClassesClient + 1}.number':
                                                          widget.imClient
                                                                  .counterClassesClient +
                                                              1,
                                                      'class${widget.imClient.counterClassesClient + 1}.individualPrice':
                                                          trainer.classes[index]
                                                              .individualPrice,
                                                      'class${widget.imClient.counterClassesClient + 1}.memberPrice':
                                                          trainer.classes[index]
                                                              .memberPrice,
                                                      'class${widget.imClient.counterClassesClient + 1}.type':
                                                          trainer.classes[index]
                                                              .type,
                                                      'class${widget.imClient.counterClassesClient + 1}.dateAndTime':
                                                          trainer.classes[index]
                                                              .dateAndTime,
                                                      'counterClassesClient': widget
                                                              .imClient
                                                              .counterClassesClient +
                                                          1,
                                                      'class${widget.imClient.counterClassesClient + 1}.dateAndTimeDateTime':
                                                          trainer.classes[index]
                                                              .dateAndTimeDateTime,
                                                      'class${widget.imClient.counterClassesClient + 1}.duration':
                                                          trainer.classes[index]
                                                              .duration,
                                                      'class${widget.imClient.counterClassesClient + 1}.locationStreet':
                                                          trainer.classes[index]
                                                              .locationStreet,
                                                      'class${widget.imClient.counterClassesClient + 1}.trainerId':
                                                          trainer.id,
                                                      'class${widget.imClient.counterClassesClient + 1}.trainerFirstName':
                                                          trainer.firstName,
                                                      'class${widget.imClient.counterClassesClient + 1}.trainerLastName':
                                                          trainer.lastName,
                                                    },
                                                  );

                                                  batch.setData(
                                                    db
                                                        .collection(
                                                            'newMemberJoined')
                                                        .document(trainer.id),
                                                    {
                                                      'idFrom':
                                                          prefs.getString('id'),
                                                      'idTo': trainer.id,
                                                      'pushToken':
                                                          trainer.pushToken,
                                                      'firstName': widget
                                                          .imClient.firstName
                                                    },
                                                  );
                                                  widget.mainParent
                                                      .setState(() {
                                                    int followingTemp = 0;
                                                    int followingFirst = 0;
                                                    int followingSecond = 0;
                                                    int followingThird = 0;
                                                    int followingFourth = 0;
                                                    int followingFifth = 0;
                                                    int followingSixth = 0;
                                                    int followingSeventh = 0;
                                                    int rememberIndexTemp = -1;
                                                    int rememberIndexFirstButton =
                                                        -1;
                                                    int rememberIndexSecondButton =
                                                        -1;
                                                    int rememberIndexThirdButton =
                                                        -1;
                                                    int rememberIndexFourthButton =
                                                        -1;
                                                    int rememberIndexFifthButton =
                                                        -1;
                                                    int rememberIndexSisxthButton =
                                                        -1;
                                                    int rememberIndexSeventhButton =
                                                        -1;
                                                    widget.mainParent
                                                        .tempSearchStore
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexTemp =
                                                            followingTemp;
                                                      }
                                                      followingTemp++;
                                                    });
                                                    widget
                                                        .mainParent.firstButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFirstButton =
                                                            followingFirst;
                                                      }
                                                      followingFirst++;
                                                    });
                                                    widget
                                                        .mainParent.secondButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSecondButton =
                                                            followingSecond;
                                                      }
                                                      followingSecond++;
                                                    });
                                                    widget
                                                        .mainParent.thirdButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexThirdButton =
                                                            followingThird;
                                                      }
                                                      followingThird++;
                                                    });
                                                    widget
                                                        .mainParent.fourthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFourthButton =
                                                            followingFourth;
                                                      }
                                                      followingFourth++;
                                                    });
                                                    widget
                                                        .mainParent.fifthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFifthButton =
                                                            followingFifth;
                                                      }
                                                      followingFifth++;
                                                    });
                                                    widget
                                                        .mainParent.sixthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSisxthButton =
                                                            followingSixth;
                                                      }
                                                      followingSixth++;
                                                    });
                                                    widget.mainParent
                                                        .seventhButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSeventhButton =
                                                            followingSeventh;
                                                      }
                                                      followingSeventh++;
                                                    });
                                                    if (rememberIndexTemp !=
                                                        -1) {
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .insert(
                                                              rememberIndexTemp,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFirstButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .firstButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .firstButton
                                                          .insert(
                                                              rememberIndexFirstButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSecondButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .secondButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .secondButton
                                                          .insert(
                                                              rememberIndexSecondButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexThirdButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .thirdButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .thirdButton
                                                          .insert(
                                                              rememberIndexThirdButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFourthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fourthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fourthButton
                                                          .insert(
                                                              rememberIndexFourthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFifthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fifthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fifthButton
                                                          .insert(
                                                              rememberIndexFifthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSisxthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .sixthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .sixthButton
                                                          .insert(
                                                              rememberIndexSisxthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSeventhButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .seventhButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .seventhButton
                                                          .insert(
                                                              rememberIndexSeventhButton,
                                                              updatedTrainer);
                                                    }
                                                  });
                                                  batch.commit();
                                                  setState(() {
                                                    indexes.add(index);
                                                  });
                                                }
                                              } else {
                                                if (overLap == false) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "You`re already attending a class scheduled at that time.",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 18.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: mainColor),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                                  widget.parent.setState(() {
                                                    widget.imTrainer =
                                                        updatedTrainer;
                                                    widget.parent.widget
                                                            .bookedTrainer =
                                                        updatedTrainer;
                                                  });
                                                  widget.mainParent
                                                      .setState(() {
                                                    int followingTemp = 0;
                                                    int followingFirst = 0;
                                                    int followingSecond = 0;
                                                    int followingThird = 0;
                                                    int followingFourth = 0;
                                                    int followingFifth = 0;
                                                    int followingSixth = 0;
                                                    int followingSeventh = 0;
                                                    int rememberIndexTemp = -1;
                                                    int rememberIndexFirstButton =
                                                        -1;
                                                    int rememberIndexSecondButton =
                                                        -1;
                                                    int rememberIndexThirdButton =
                                                        -1;
                                                    int rememberIndexFourthButton =
                                                        -1;
                                                    int rememberIndexFifthButton =
                                                        -1;
                                                    int rememberIndexSisxthButton =
                                                        -1;
                                                    int rememberIndexSeventhButton =
                                                        -1;
                                                    widget.mainParent
                                                        .tempSearchStore
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexTemp =
                                                            followingTemp;
                                                      }
                                                      followingTemp++;
                                                    });
                                                    widget
                                                        .mainParent.firstButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFirstButton =
                                                            followingFirst;
                                                      }
                                                      followingFirst++;
                                                    });
                                                    widget
                                                        .mainParent.secondButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSecondButton =
                                                            followingSecond;
                                                      }
                                                      followingSecond++;
                                                    });
                                                    widget
                                                        .mainParent.thirdButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexThirdButton =
                                                            followingThird;
                                                      }
                                                      followingThird++;
                                                    });
                                                    widget
                                                        .mainParent.fourthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFourthButton =
                                                            followingFourth;
                                                      }
                                                      followingFourth++;
                                                    });
                                                    widget
                                                        .mainParent.fifthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexFifthButton =
                                                            followingFifth;
                                                      }
                                                      followingFifth++;
                                                    });
                                                    widget
                                                        .mainParent.sixthButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSisxthButton =
                                                            followingSixth;
                                                      }
                                                      followingSixth++;
                                                    });
                                                    widget.mainParent
                                                        .seventhButton
                                                        .forEach((element) {
                                                      if (element.id ==
                                                          updatedTrainer.id) {
                                                        rememberIndexSeventhButton =
                                                            followingSeventh;
                                                      }
                                                      followingSeventh++;
                                                    });
                                                    if (rememberIndexTemp !=
                                                        -1) {
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .tempSearchStore
                                                          .insert(
                                                              rememberIndexTemp,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFirstButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .firstButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .firstButton
                                                          .insert(
                                                              rememberIndexFirstButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSecondButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .secondButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .secondButton
                                                          .insert(
                                                              rememberIndexSecondButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexThirdButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .thirdButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .thirdButton
                                                          .insert(
                                                              rememberIndexThirdButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFourthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fourthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fourthButton
                                                          .insert(
                                                              rememberIndexFourthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexFifthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .fifthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .fifthButton
                                                          .insert(
                                                              rememberIndexFifthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSisxthButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .sixthButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .sixthButton
                                                          .insert(
                                                              rememberIndexSisxthButton,
                                                              updatedTrainer);
                                                    }
                                                    if (rememberIndexSeventhButton !=
                                                        -1) {
                                                      widget.mainParent
                                                          .seventhButton
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  updatedTrainer
                                                                      .id);
                                                      widget.mainParent
                                                          .seventhButton
                                                          .insert(
                                                              rememberIndexSeventhButton,
                                                              updatedTrainer);
                                                    }
                                                  });
                                                }
                                              }
                                            } else {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "This class has been canceled. This page has been refreshed.",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 18.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: mainColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ));
                                              widget.mainParent.setState(() {
                                                int followingTemp = 0;
                                                int followingFirst = 0;
                                                int followingSecond = 0;
                                                int followingThird = 0;
                                                int followingFourth = 0;
                                                int followingFifth = 0;
                                                int followingSixth = 0;
                                                int followingSeventh = 0;
                                                int rememberIndexTemp = -1;
                                                int rememberIndexFirstButton =
                                                    -1;
                                                int rememberIndexSecondButton =
                                                    -1;
                                                int rememberIndexThirdButton =
                                                    -1;
                                                int rememberIndexFourthButton =
                                                    -1;
                                                int rememberIndexFifthButton =
                                                    -1;
                                                int rememberIndexSisxthButton =
                                                    -1;
                                                int rememberIndexSeventhButton =
                                                    -1;
                                                widget
                                                    .mainParent.tempSearchStore
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexTemp =
                                                        followingTemp;
                                                  }
                                                  followingTemp++;
                                                });
                                                widget.mainParent.firstButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexFirstButton =
                                                        followingFirst;
                                                  }
                                                  followingFirst++;
                                                });
                                                widget.mainParent.secondButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexSecondButton =
                                                        followingSecond;
                                                  }
                                                  followingSecond++;
                                                });
                                                widget.mainParent.thirdButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexThirdButton =
                                                        followingThird;
                                                  }
                                                  followingThird++;
                                                });
                                                widget.mainParent.fourthButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexFourthButton =
                                                        followingFourth;
                                                  }
                                                  followingFourth++;
                                                });
                                                widget.mainParent.fifthButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexFifthButton =
                                                        followingFifth;
                                                  }
                                                  followingFifth++;
                                                });
                                                widget.mainParent.sixthButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexSisxthButton =
                                                        followingSixth;
                                                  }
                                                  followingSixth++;
                                                });
                                                widget.mainParent.seventhButton
                                                    .forEach((element) {
                                                  if (element.id ==
                                                      updatedTrainer.id) {
                                                    rememberIndexSeventhButton =
                                                        followingSeventh;
                                                  }
                                                  followingSeventh++;
                                                });
                                                if (rememberIndexTemp != -1) {
                                                  widget.mainParent
                                                      .tempSearchStore
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent
                                                      .tempSearchStore
                                                      .insert(rememberIndexTemp,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexFirstButton !=
                                                    -1) {
                                                  widget.mainParent.firstButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.firstButton
                                                      .insert(
                                                          rememberIndexFirstButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexSecondButton !=
                                                    -1) {
                                                  widget.mainParent.secondButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.secondButton
                                                      .insert(
                                                          rememberIndexSecondButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexThirdButton !=
                                                    -1) {
                                                  widget.mainParent.thirdButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.thirdButton
                                                      .insert(
                                                          rememberIndexThirdButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexFourthButton !=
                                                    -1) {
                                                  widget.mainParent.fourthButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.fourthButton
                                                      .insert(
                                                          rememberIndexFourthButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexFifthButton !=
                                                    -1) {
                                                  widget.mainParent.fifthButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.fifthButton
                                                      .insert(
                                                          rememberIndexFifthButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexSisxthButton !=
                                                    -1) {
                                                  widget.mainParent.sixthButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget.mainParent.sixthButton
                                                      .insert(
                                                          rememberIndexSisxthButton,
                                                          updatedTrainer);
                                                }
                                                if (rememberIndexSeventhButton !=
                                                    -1) {
                                                  widget
                                                      .mainParent.seventhButton
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          updatedTrainer.id);
                                                  widget
                                                      .mainParent.seventhButton
                                                      .insert(
                                                          rememberIndexSeventhButton,
                                                          updatedTrainer);
                                                }
                                              });
                                              widget.parent.setState(() {
                                                widget.imTrainer =
                                                    updatedTrainer;
                                                widget.parent.lastTrainer =
                                                    updatedTrainer;
                                              });
                                            }
                                          }
                                        }
                                        setState(() {
                                          loading = false;
                                        });
                                      },
                                      child: Text(
                                        unavailable == true
                                            ? "Unavailable"
                                            : enrolledFlag == false
                                                ? 'Enroll in this class!'
                                                : 'Enrolled',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 12.0 *
                                                prefs.getDouble('height'),
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 0.06),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 8.0 * prefs.getDouble('height'))
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
    return Container();
  }

  List<int> indexxes = [];
  @override
  Widget build(BuildContext context) {
    if (updatedTrainer != null) {
      widget.imTrainer = updatedTrainer;
    }
    List<DateTime> dateTimeList = [];
    indexxes.clear();
    for (int i = 0; i < widget.imTrainer.classes.length; i++) {
      dateTimeList.add(widget.imTrainer.classes[i].dateAndTimeDateTime);
    }
    for (int i = 0; i < dateTimeList.length - 1; i++) {
      for (int j = i + 1; j < dateTimeList.length; j++) {
        if (dateTimeList[i].isAfter(dateTimeList[j])) {
          DateTime aux = dateTimeList[i];
          dateTimeList[i] = dateTimeList[j];
          dateTimeList[j] = aux;
        }
      }
    }
    for (int i = 0; i < dateTimeList.length; i++) {
      for (int j = 0; j < widget.imTrainer.classes.length; j++) {
        if (dateTimeList[i] ==
            widget.imTrainer.classes[j].dateAndTimeDateTime) {
          indexxes.add(j);
        }
      }
    }
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          centerTitle: true,
          title: Text(
            "${widget.imTrainer.firstName}'s classes",
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 20 * prefs.getDouble('height'),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        body: Builder(
          builder: (context) => Padding(
              padding: EdgeInsets.only(top: 8 * prefs.getDouble('height')),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.imTrainer.counterClasses,
                    itemBuilder: (context, int index) =>
                        item(context, widget.imTrainer, indexxes[index]),
                  ),
                  loading == true
                      ? Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8.0 * prefs.getDouble('height')),
                              color: secondaryColor,
                            ),
                            height: 80 * prefs.getDouble('height'),
                            width: 80 * prefs.getDouble('width'),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(mainColor),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              )),
        ));
  }
}

class PopUpMissingRoute extends PopupRoute<void> {
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      PopUpMissing();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpMissing extends StatefulWidget {
  @override
  State createState() => PopUpMissingState();
}

class PopUpMissingState extends State<PopUpMissing> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: secondaryColor,
          ),
          height: 256 * prefs.getDouble('height'),
          width: 313 * prefs.getDouble('width'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/waitf1.svg',
                width: 180.0 * prefs.getDouble('width'),
                height: 100.0 * prefs.getDouble('height'),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Text(
                "Your trainer has ran out of trophies",
                style: TextStyle(
                  fontSize: 16 * prefs.getDouble('height'),
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsPopUpReviews extends PopupRoute<void> {
  DetailsPopUpReviews({this.trainerUser});
  final TrainerUser trainerUser;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      DetailsPageReviews(
        trainer: trainerUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPageReviews extends StatefulWidget {
  final TrainerUser trainer;
  DetailsPageReviews({Key key, @required this.trainer}) : super(key: key);

  @override
  State createState() => DetailsPageReviewsState(trainer: trainer);
}

class DetailsPageReviewsState extends State<DetailsPageReviews> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector;

  DetailsPageReviewsState({
    @required this.trainer,
  });

  List<ReviewMap> revs = [];

  Widget buildItem(List<ReviewMap> reviews, int index) {
    if (index < 5) {
      if (reviews.length <= 5) {
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          index != (reviews.length - 1)
              ? Container(
                  width: double.infinity,
                  height: 1 * prefs.getDouble('height'),
                  color: Color.fromARGB(150, 255, 255, 255))
              : Container(),
          Container(
            height: 90 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            child: Padding(
              padding: EdgeInsets.all(
                10 * prefs.getDouble('height'),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  reviews[index].review.contains(")()()(") == true
                      ? reviews[index].review.replaceAll(")()()(", ".")
                      : reviews[index].review,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13 * prefs.getDouble('height'),
                      letterSpacing: -0.078,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
            ),
          ),
        ]);
      } else {
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          index < 4
              ? Container(
                  width: double.infinity,
                  height: 1 * prefs.getDouble('height'),
                  color: Color.fromARGB(150, 255, 255, 255))
              : Container(),
          Container(
            height: 90 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            child: Padding(
              padding: EdgeInsets.all(
                10 * prefs.getDouble('height'),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  reviews[index + reviews.length - 5]
                              .review
                              .contains(")()()(") ==
                          true
                      ? reviews[index + reviews.length - 5]
                          .review
                          .replaceAll(")()()(", ".")
                      : reviews[index + reviews.length - 5].review,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13 * prefs.getDouble('height'),
                      letterSpacing: -0.078,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
            ),
          ),
        ]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.trainer.reviewMap.length - 1; i++) {
      for (int j = i + 1; j < widget.trainer.reviewMap.length; j++) {
        if (widget.trainer.reviewMap[i].time
            .toDate()
            .isAfter(widget.trainer.reviewMap[j].time.toDate())) {
          var aux = widget.trainer.reviewMap[i];
          widget.trainer.reviewMap[i] = widget.trainer.reviewMap[j];
          widget.trainer.reviewMap[j] = aux;
        }
      }
    }
    setState(() {
      revs = widget.trainer.reviewMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Dialog(
            backgroundColor: Colors.transparent,
            child: trainer.reviewMap.length == 0
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff3E3E45)),
                    width: 310 * prefs.getDouble('width'),
                    height: 250 * prefs.getDouble('height'),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/reviewf1.svg',
                            width: 180.0 * prefs.getDouble('width'),
                            height: 100.0 * prefs.getDouble('height'),
                          ),
                          SizedBox(height: 24 * prefs.getDouble('height')),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 56 * prefs.getDouble('height')),
                              child: Text(
                                "${widget.trainer.firstName} did not receive reviews yet.",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14 * prefs.getDouble('height'),
                                    color: Color.fromARGB(200, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding:
                        EdgeInsets.only(top: 10.0 * prefs.getDouble('height')),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff3E3E45)),
                    height: (90 *
                                    (trainer.reviewMap.length < 5
                                        ? (trainer.reviewMap.length)
                                        : 5) +
                                60)
                            .toDouble() *
                        prefs.getDouble('height'),
                    child: Container(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0 * prefs.getDouble('height')),
                        itemBuilder: (context, index) => buildItem(revs, index),
                        itemCount: trainer.reviewMap.length < 5
                            ? trainer.reviewMap.length
                            : 5,
                        reverse: true,
                      ),
                    ),
                  )));
  }
}
