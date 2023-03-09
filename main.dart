import 'dart:io';

import 'package:Bsharkr/Client/Classes/AllClasses.dart';
import 'package:Bsharkr/Client/Client_Profile/Profile/SecondaryProfile.dart';
import 'package:Bsharkr/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:Bsharkr/Client/Trainer_Booking/Main/TrainerBooking.dart';
import 'package:Bsharkr/Client/Chats/Friendlist/Contacts.dart';
import 'package:Bsharkr/Client/Client_Profile/Profile/MyProfile.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart' as prefix0;

import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/root.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Client/ReviewTextError.dart';
import 'Client/Trainer_Booking/Voting_Page/Voting.dart';
import 'Client/chatscreen.dart';
import 'DeleteAccountInProcess.dart';
import 'disabledApp.dart';
import 'models/clientUser.dart';
import 'models/trainerUser.dart';

Future<void> initialization() async {
  prefs = await SharedPreferences.getInstance();
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: prefix0.backgroundColor, // Color for Android

      statusBarBrightness:
          Brightness.dark // Dark == white status bar -- for IOS.
      ,
      statusBarIconBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  initialization().then((x) {
    runApp(Phoenix(
      child: MaterialApp(
         debugShowCheckedModeBanner: false,
          color: backgroundColor,
          home: new RootPage(
            auth: Auth(),
          )),
    ));
  });
}

class MyApp extends StatefulWidget {
  MyApp({this.auth, this.onSignedOut, this.selectedPage});
  final BaseAuth auth;
  int selectedPage;
  final Function onSignedOut;
  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int _selectedPage;

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  getPermission() async {
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('id', isEqualTo: prefs.getString('id'))
        .getDocuments();
    if (ClientUser(query.documents[0]).acceptTrainerRequests == true) {
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

        permissionGranted = 'true';
        if (permissionGranted == 'true') {
          GeoFirePoint myLocation = geo.point(latitude: auxx, longitude: auxy);
          await Firestore.instance
              .collection('clientUsers')
              .document(prefs.getString('id'))
              .updateData({'location': myLocation.data});
        }
      }
    }
    await Firestore.instance
        .collection('clientUsers')
        .document(prefs.getString('id'))
        .updateData({'timeZone': DateTime.now().timeZoneName});
  }

  bool flag1 = false;
  bool flag2 = false;
  bool flag3 = false;
  bool flag4 = false;
  bool goToMyProfile = false;
  bool browsingTrainersAndClasses = false;
  bool seenFlagFriends;
  bool seenFlagTrainers;
  Map<PermissionGroup, PermissionStatus> permissions;
  ServiceStatus serviceStatus;
  String permissionGranted;
  double x;
  double y;
  _getLocation() async {
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('id', isEqualTo: prefs.getString('id'))
        .getDocuments();

    if (ClientUser(query.documents[0]).acceptTrainerRequests == true) {
      var location = new Location();
      try {
        await location.getLocation().then((onValue) async {
          permissionGranted = 'true';
          if (permissionGranted == 'true') {
            GeoFirePoint myLocation = geo.point(
                latitude: onValue.latitude, longitude: onValue.longitude);
            await Firestore.instance
                .collection('clientUsers')
                .document(prefs.getString('id'))
                .updateData({
              'location': myLocation.data,
              'timeZone': DateTime.now().timeZoneName
            });
          }
        });
      } catch (e) {
        if (e == 'PERMISSION_DENIED') {
          permissionGranted = 'false';
        }
        if (e == 'PERMISSION_DENIED_NEVER_ASK') {
          permissionGranted = 'never ask';
        }
      }
    }

    await Firestore.instance
        .collection('clientUsers')
        .document(prefs.getString('id'))
        .updateData({'timeZone': DateTime.now().timeZoneName});
  }

  Geoflutterfire geo = Geoflutterfire();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
   
    super.initState();
    if (Platform.isAndroid) {
      _getLocation();
    }
    if (Platform.isIOS) {
      getPermission();
    }
    _selectedPage = widget.selectedPage;
    registerNotification(prefs.getString('id'));

    prefs.setString("expectations", null);
  }

  checkVote() async {
    DateTime timestamp = Timestamp.now().toDate();
    if (((timestamp.isAfter(imClient.scheduleFirstEndWeek.day1.toDate()) ==
                true &&
            timestamp.day == imClient.scheduleFirstEndWeek.day1.toDate().day &&
            imClient.checkFirstSchedule.day1 == 'true')) &&
        imClient.dailyVote == false) {
      QuerySnapshot query = await Firestore.instance
          .collection('clientUsers')
          .where('id', isEqualTo: imClient.trainingSessionTrainerId.day1)
          .getDocuments();

      if (query.documents.length != 0) {
        if (TrainerUser(query.documents[0]).trophies > 0) {
          voteFlag = true;
          Navigator.push(
            context,
            VoteMain(
                clientUser: imClient,
                trainer: TrainerUser(query.documents[0]),
                classOrWorkout: "workout",
                parent: this),
          );
        }
      }
    } else {
      if (imClient.classVote != "" && imClient.dailyVote == false) {
        QuerySnapshot query = await Firestore.instance
            .collection('clientUsers')
            .where('id', isEqualTo: imClient.classVote)
            .getDocuments();
        if (query.documents.length != 0) {
          if (TrainerUser(query.documents[0]).trophies > 0) {
            voteFlag = true;
            Navigator.push(
              context,
              VoteMain(
                  clientUser: imClient,
                  trainer: TrainerUser(query.documents[0]),
                  classOrWorkout: "class",
                  parent: this),
            );
          }
        }
      }
    }
  }

  bool trainerRequestedClient = false;
  bool restartedFlagFriends = false;
  bool restartedFlagClients = false;
  bool acceptedFriendship;
  bool acceptedCollaboration;
  bool restartedFlag = false;
  bool newPrivateClass;
  bool deletedClient;
  Future<void> registerNotification(String id) async {
    _firebaseMessaging.requestNotificationPermissions();
    if (Platform.isAndroid) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          return;
        },
        onResume: (Map<String, dynamic> message) async {
          if (message['data']['screen'] == 'classReminderClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 4;
            });
          }
          if (message['data']['screen'] == 'deletedClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              deletedClient = true;
              _selectedPage = 4;
            });
          }
          if (message['data']['screen'] == 'newPrivateClass') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              newPrivateClass = true;
              _selectedPage = 4;
            });
          }
          if (message['data']['screen'] == 'trainerRequestedClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              trainerRequestedClient = true;
              _selectedPage = 1;
            });
          }
          if (message['data']['screen'] == 'meal') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              notification = 'meal';
              _selectedPage = 3;
            });
          }
          if (message['data']['screen'] == 'acceptedFriendship') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              acceptedFriendship = true;
              _selectedPage = 1;
            });
          }
          if (message['data']['screen'] == 'reminder') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 3;
            });
          }
          if (message['data']['screen'] == 'toClient' &&
              message['data']['receiver'] == prefs.getString('id')) {
            imClient.friends.forEach((element) {
              if (element.friendId == message['data']['sender'] &&
                  element.friendAccepted == true) {
                setState(() {
                  acceptedFriendship = true;
                  _selectedPage = 1;
                  if (restartedFlagFriends == false) {
                    restartedFlagFriends = true;
                    if (restartedFlagClients == true) {
                      restartedFlagClients = false;
                      Navigator.pop(context, true);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['data']['sender'],
                              parent: this),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['data']['sender'],
                              parent: this),
                        ),
                      );
                    }
                  }
                });
              }
            });
            imClient.trainers.forEach((element) {
              if (element.trainerId == message['data']['sender'] &&
                  element.trainerAccepted == true) {
                setState(() {
                  _selectedPage = 1;
                  acceptedCollaboration = true;
                  if (restartedFlagClients == false) {
                    restartedFlagClients = true;
                    if (restartedFlagFriends == true) {
                      restartedFlagFriends = false;
                      Navigator.pop(context, true);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['data']['sender'],
                              parent: this),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['data']['sender'],
                              parent: this),
                        ),
                      );
                    }
                  }
                });
              }
            });
          }
          if (message['data']['screen'] == 'acceptedCollaboration') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              acceptedCollaboration = true;
              _selectedPage = 1;
            });
          }
          if (message['data']['screen'] == 'schedule') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 3;
            });
          }
          return;
        },
        onLaunch: (Map<String, dynamic> message) async {
          if (message['data']['screen'] == 'classReminderClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 4;
            });
          }
          if (message['data']['screen'] == 'deletedClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              deletedClient = true;
              _selectedPage = 4;
            });
          }
          if (message['data']['screen'] == 'newPrivateClass') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              newPrivateClass = true;
              _selectedPage = 4;
            });
          }
          if (message['data']['screen'] == 'trainerRequestedClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              trainerRequestedClient = true;
              _selectedPage = 1;
            });
          }
          if (message['data']['screen'] == 'meal') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              notification = 'meal';
              _selectedPage = 3;
            });
          }
          if (message['data']['screen'] == 'acceptedFriendship') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              acceptedFriendship = true;
              _selectedPage = 1;
            });
          }
          if (message['data']['screen'] == 'reminder') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 3;
            });
          }

          if (message['data']['screen'] == 'toClient' &&
              message['data']['receiver'] == prefs.getString('id')) {
            setState(() {
              acceptedFriendship = true;
              _selectedPage = 1;
              if (restartedFlagFriends == false) {
                restartedFlagFriends = true;
                if (restartedFlagClients == true) {
                  restartedFlagClients = false;
                  Navigator.pop(context, true);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          fuckedUpKeyBoard: true,
                          peerId: message['data']['sender'],
                          parent: this),
                    ),
                  );
                } else {
                  flag4 = true;
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          fuckedUpKeyBoard: true,
                          peerId: message['data']['sender'],
                          parent: this),
                    ),
                  );
                }
              }
            });

            setState(() {
              _selectedPage = 1;
              acceptedCollaboration = true;
              if (restartedFlagClients == false) {
                restartedFlagClients = true;
                if (restartedFlagFriends == true) {
                  restartedFlagFriends = false;
                  Navigator.pop(context, true);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          fuckedUpKeyBoard: true,
                          peerId: message['data']['sender'],
                          parent: this),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          fuckedUpKeyBoard: true,
                          peerId: message['data']['sender'],
                          parent: this),
                    ),
                  );
                }
              }
            });
          }
          if (message['data']['screen'] == 'acceptedCollaboration') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              acceptedCollaboration = true;
              _selectedPage = 1;
            });
          }
          if (message['data']['screen'] == 'schedule') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 3;
            });
          }
          return;
        },
      );
    } else {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          return;
        },
        onResume: (Map<String, dynamic> message) async {
          if (message['screen'] == 'classReminderClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 4;
            });
          }
          if (message['data'] == 'deletedClient') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            deletedClient = true;
            _selectedPage = 4;
          }
          if (message['screen'] == 'newPrivateClass') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            newPrivateClass = true;
            _selectedPage = 4;
          }
          if (message['screen'] == 'trainerRequestedClient') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            trainerRequestedClient = true;
            _selectedPage = 1;
          }
          if (message['screen'] == 'meal') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            notification = 'meal';
            _selectedPage = 3;
          }
          if (message['screen'] == 'acceptedFriendship') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            acceptedFriendship = true;
            _selectedPage = 1;
          }
          if (message['screen'] == 'reminder') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 3;
          }

          if (message['screen'] == 'toClient' &&
              message['receiver'] == prefs.getString('id')) {
            imClient.friends.forEach((element) {
              if (element.friendId == message['sender'] &&
                  element.friendAccepted == true) {
                setState(() {
                  acceptedFriendship = true;
                  _selectedPage = 1;
                  if (restartedFlagFriends == false) {
                    restartedFlagFriends = true;
                    if (restartedFlagClients == true) {
                      restartedFlagClients = false;
                      Navigator.pop(context, true);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['sender'],
                              parent: this),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['sender'],
                              parent: this),
                        ),
                      );
                    }
                  }
                });
              }
            });
            imClient.trainers.forEach((element) {
              if (element.trainerId == message['sender'] &&
                  element.trainerAccepted == true) {
                setState(() {
                  _selectedPage = 1;
                  acceptedCollaboration = true;
                  if (restartedFlagClients == false) {
                    restartedFlagClients = true;
                    if (restartedFlagFriends == true) {
                      restartedFlagFriends = false;
                      Navigator.pop(context, true);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['sender'],
                              parent: this),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['sender'],
                              parent: this),
                        ),
                      );
                    }
                  }
                });
              }
            });
          }
          if (message['screen'] == 'acceptedCollaboration') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            acceptedCollaboration = true;
            _selectedPage = 1;
          }
          if (message['screen'] == 'schedule') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 3;
          }
          return;
        },
        onLaunch: (Map<String, dynamic> message) async {
          if (message['screen'] == 'classReminderClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 4;
            });
          }
          if (message['data'] == 'deletedClient') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            deletedClient = true;
            _selectedPage = 4;
          }
          if (message['screen'] == 'newPrivateClass') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            newPrivateClass = true;
            _selectedPage = 4;
          }
          if (message['screen'] == 'trainerRequestedClient') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            trainerRequestedClient = true;
            _selectedPage = 1;
          }
          if (message['screen'] == 'meal') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            notification = 'meal';
            _selectedPage = 3;
          }
          if (message['screen'] == 'acceptedFriendship') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            acceptedFriendship = true;
            _selectedPage = 1;
          }
          if (message['screen'] == 'reminder') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 3;
          }
          if (message['screen'] == 'toClient' &&
              message['receiver'] == prefs.getString('id')) {
            setState(() {
              acceptedFriendship = true;
              _selectedPage = 1;
              if (restartedFlagFriends == false) {
                restartedFlagFriends = true;
                if (restartedFlagClients == true) {
                  restartedFlagClients = false;
                  Navigator.pop(context, true);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          fuckedUpKeyBoard: true,
                          peerId: message['sender'],
                          parent: this),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          fuckedUpKeyBoard: true,
                          peerId: message['sender'],
                          parent: this),
                    ),
                  );
                }
              }
            });
            imClient.trainers.forEach((element) {
              if (element.trainerId == message['sender'] &&
                  element.trainerAccepted == true) {
                setState(() {
                  _selectedPage = 1;
                  acceptedCollaboration = true;
                  if (restartedFlagClients == false) {
                    restartedFlagClients = true;
                    if (restartedFlagFriends == true) {
                      restartedFlagFriends = false;
                      Navigator.pop(context, true);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['sender'],
                              parent: this),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => Chat(
                              fuckedUpKeyBoard: true,
                              peerId: message['sender'],
                              parent: this),
                        ),
                      );
                    }
                  }
                });
              }
            });
          }
          if (message['screen'] == 'acceptedCollaboration') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            acceptedCollaboration = true;
            _selectedPage = 1;
          }
          if (message['screen'] == 'schedule') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 3;
          }
          return;
        },
      );
    }
    _firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection('pushNotifications')
          .document(id)
          .updateData({
        'id': prefs.getString('id'),
        'pushToken': token,
        'chattingWith': null,
      });
      Firestore.instance.collection('clientUsers').document(id).updateData({
        'pushToken': token,
      });
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "$err",
          style: TextStyle(
              fontSize: 18.0 * prefs.getDouble('height'),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: mainColor),
          textAlign: TextAlign.center,
        ),
      ));
    });
  }

  String notification;
  List<Widget> _pageOptions;
  bool seenFlag;
  ClientUser imClient;
  bool restart = false;
  final PageStorageBucket bucket = PageStorageBucket();

  AppLifecycleState _notification;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (voteFlag != true) {
      _notification = state;
      if (_notification.index != 0) {
      } else {
        DateTime timestamp = Timestamp.now().toDate();
        if (((timestamp.isAfter(imClient.scheduleFirstEndWeek.day1.toDate()) ==
                    true &&
                timestamp.day ==
                    imClient.scheduleFirstEndWeek.day1.toDate().day &&
                imClient.checkFirstSchedule.day1 == 'true')) &&
            imClient.dailyVote == false &&
            imClient.appIsOn == true) {
          QuerySnapshot query = await Firestore.instance
              .collection('clientUsers')
              .where('id', isEqualTo: imClient.trainingSessionTrainerId.day1)
              .getDocuments();

          if (query.documents.length != 0) {
            if (TrainerUser(query.documents[0]).trophies > 0) {
              voteFlag = true;
              Navigator.push(
                context,
                VoteMain(
                    clientUser: imClient,
                    trainer: TrainerUser(query.documents[0]),
                    classOrWorkout: "workout",
                    parent: this),
              );
            }
          }
        } else {
          if (imClient.classVote != "" &&
              imClient.dailyVote == false &&
              imClient.appIsOn == true) {
            QuerySnapshot query = await Firestore.instance
                .collection('clientUsers')
                .where('id', isEqualTo: imClient.classVote)
                .getDocuments();
            if (query.documents.length != 0) {
              if (TrainerUser(query.documents[0]).trophies > 0) {
                voteFlag = true;
                Navigator.push(
                  context,
                  VoteMain(
                      clientUser: imClient,
                      trainer: TrainerUser(query.documents[0]),
                      classOrWorkout: "class",
                      parent: this),
                );
              }
            }
          }
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool finalFinalVote = false;

  checkIfItsDeleted() async {
    QuerySnapshot query = await Firestore.instance
        .collection('deleteAccountClient')
        .where('id', isEqualTo: prefs.getString('id'))
        .getDocuments();
    if (query.documents.length != 0) {
      Navigator.push(
        context,
        DeleteAccountInProcessPopup(auth: widget.auth, role: 'client'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    restartedFlag = false;
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: flag1 == true
          ? Container(
              height: 500,
              width: 300,
              color: Colors.red,
            )
          : flag3 == true
              ? Container(
                  height: 500,
                  width: 300,
                  color: Colors.green,
                )
              : StreamBuilder(
                  stream: Firestore.instance
                      .collection('clientUsers')
                      .where(
                        'id',
                        isEqualTo: prefs.getString('id'),
                      )
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                prefix0.mainColor),
                          ),
                        ),
                        color: prefix0.backgroundColor,
                      );
                    }
                    try {
                      checkIfItsDeleted();
                      seenFlagFriends = false;
                      seenFlagTrainers = false;
                      imClient =
                          imClient = ClientUser(snapshot.data.documents[0]);
                      if (imClient.appIsOn == false) {
                        return DisabledAppError();
                      }
                      if (finalFinalVote != true) {
                        checkVote();
                        finalFinalVote = true;
                      }
                      imClient.unseenMessagesCounter
                          .asMap()
                          .values
                          .forEach((element) {
                        imClient.friends
                            .asMap()
                            .values
                            .toList()
                            .forEach((element1) {
                          if (element.userId == element1.friendId &&
                              element1.friendAccepted == true) {
                            seenFlagFriends = true;
                          }
                        });

                        imClient.trainers
                            .asMap()
                            .values
                            .toList()
                            .forEach((element1) {
                          if (element.userId == element1.trainerId &&
                              element1.trainerAccepted == true) {
                            seenFlagTrainers = true;
                          }
                        });
                      });
                      if (browsingTrainersAndClasses == true) {
                        _selectedPage = 0;
                        browsingTrainersAndClasses = false;
                      }
                      if (goToMyProfile == true) {
                        _selectedPage = 2;
                        goToMyProfile = false;
                      }
                      _pageOptions = [
                        TrainerBookingPage(
                          imClient: imClient,
                        ),
                        acceptedCollaboration == true
                            ? MyTabsFriends(
                                newFriend: imClient.newFriend,
                                newTrainer: imClient.newBusiness,
                                seenFlagFriends: seenFlagFriends,
                                seenFlagTrainers: seenFlagTrainers,
                                trainerRequestedClient:
                                    imClient.trainerRequestedClient,
                                imClient: imClient,
                                selectedBarIndex: 2,
                                parent: this)
                            : acceptedFriendship == true
                                ? MyTabsFriends(
                                    newFriend: imClient.newFriend,
                                    newTrainer: imClient.newBusiness,
                                    seenFlagFriends: seenFlagFriends,
                                    seenFlagTrainers: seenFlagTrainers,
                                    trainerRequestedClient:
                                        imClient.trainerRequestedClient,
                                    imClient: imClient,
                                    selectedBarIndex: 1,
                                    parent: this)
                                : trainerRequestedClient == true
                                    ? MyTabsFriends(
                                        newFriend: imClient.newFriend,
                                        newTrainer: imClient.newBusiness,
                                        seenFlagFriends: seenFlagFriends,
                                        seenFlagTrainers: seenFlagTrainers,
                                        trainerRequestedClient:
                                            imClient.trainerRequestedClient,
                                        imClient: imClient,
                                        selectedBarIndex: 0,
                                        parent: this)
                                    : MyTabsFriends(
                                        newFriend: imClient.newFriend,
                                        newTrainer: imClient.newBusiness,
                                        seenFlagFriends: seenFlagFriends,
                                        trainerRequestedClient:
                                            imClient.trainerRequestedClient,
                                        seenFlagTrainers: seenFlagTrainers,
                                        imClient: imClient,
                                        parent: this),
                        ClientMainProfile(
                            clientUser: imClient,
                            auth: widget.auth,
                            onSignedOut: widget.onSignedOut,
                            snapshot: snapshot.data.documents[0]),
                        ClientSecondaryProfile(
                            auth: widget.auth,
                            onSignedOut: widget.onSignedOut,
                            imClient: imClient,
                            notification: notification),
                        (newPrivateClass == null && deletedClient == null)
                            ? AllClasses(
                                parent: this,
                                imClient: imClient,
                              )
                            : newPrivateClass == true
                                ? AllClasses(
                                    parent: this,
                                    imClient: imClient,
                                    newPrivateClass: true)
                                : AllClasses(
                                    parent: this,
                                    imClient: imClient,
                                    deletedClient: true,
                                  )
                      ];
                      newPrivateClass = null;
                      trainerRequestedClient = null;
                      acceptedCollaboration = null;
                      acceptedFriendship = null;
                      return ExtraPage(
                        parent: this,
                      );
                    } catch (e) {
                      try {
                        prefs.setString('id', null);
                        prefs.setString('logOut', 'true');
                        prefs.setString('expectations', null);
                        prefs.setDouble('height', null);
                        prefs.setDouble('width', null);
                        prefs.setString('nickname', null);
                        prefs.setString('role', null);
                        prefs.setString('email', null);
                        prefs.setString('password1', null);
                        prefs.setString('password2', null);
                        prefs.setString('firstName', null);
                        prefs.setString('lastName', null);
                        prefs.setInt('age', null);
                        prefs.setString('gender', null);
                        prefs.setString('photoUrl', null);
                        widget.auth.signOut();
                        if (mounted) {
                          Phoenix.rebirth(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          Phoenix.rebirth(context);
                        }
                      }
                    }
                  }),
    );
  }
}

class ExtraPage extends StatefulWidget {
  MyAppState parent;
  ExtraPage({
    this.parent,
  });
  @override
  _ExtraPageState createState() => _ExtraPageState();
}

class _ExtraPageState extends State<ExtraPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
         debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: prefix0.backgroundColor,
        body: widget.parent._pageOptions[widget.parent._selectedPage],
        bottomNavigationBar: SizedBox(
          height: 85 * prefs.getDouble('height'),
          child: BottomNavigationBar(
            selectedItemColor: prefix0.mainColor,
            unselectedItemColor: Color.fromARGB(150, 255, 255, 255),
            backgroundColor: prefix0.secondaryColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: widget.parent._selectedPage,
            onTap: (int index) {
              setState(() {
                widget.parent._selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Center(
                    child: Container(
                      width: 30 * prefs.getDouble('width'),
                      child: Icon(
                        Icons.search,
                        size: 24 * prefs.getDouble('height'),
                      ),
                    ),
                  ),
                  title: Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 10 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  )),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Center(
                    child: Container(
                      width: 30 * prefs.getDouble('width'),
                      child: (widget.parent.seenFlagFriends == true ||
                              widget.parent.seenFlagTrainers == true ||
                              widget.parent.imClient.newFriend == true ||
                              widget.parent.imClient.newBusiness == true ||
                              widget.parent.imClient.trainerRequestedClient ==
                                  true)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.brightness_1,
                                  color: Colors.red,
                                  size: 8.0 * prefs.getDouble('height'),
                                ),
                                SizedBox(
                                  height: 4 * prefs.getDouble('height'),
                                ),
                                Icon(
                                  Icons.people,
                                  size: 24.0 * prefs.getDouble('height'),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.people,
                              size: 24.0 * prefs.getDouble('height'),
                            ),
                    ),
                  ),
                  title: Text(
                    'Contacts',
                    style: TextStyle(
                        fontSize: 10 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  )),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Center(
                    child: Container(
                      width: 40 * prefs.getDouble('width'),
                      child: Icon(
                        Icons.perm_identity,
                        size: 24 * prefs.getDouble('height'),
                      ),
                    ),
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 10 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  )),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Center(
                    child: Container(
                      width: 40 * prefs.getDouble('width'),
                      child: Center(
                        child: (widget.parent.imClient.scheduleUpdated ==
                                    true ||
                                widget.parent.imClient.mealPlanUpdated == true)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.brightness_1,
                                    color: Colors.red,
                                    size: 8.0 * prefs.getDouble('height'),
                                  ),
                                  SizedBox(
                                    height: 4 * prefs.getDouble('height'),
                                  ),
                                  Icon(
                                    Icons.assignment_late,
                                    size: 24.0 * prefs.getDouble('height'),
                                  ),
                                ],
                              )
                            : Icon(
                                Icons.assignment_late,
                                size: 24.0 * prefs.getDouble('height'),
                              ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Plan',
                    style: TextStyle(
                        fontSize: 10 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  )),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: (widget.parent.imClient.newPrivateClass == true ||
                          widget.parent.imClient.deletedClient == true)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.brightness_1,
                              color: Colors.red,
                              size: 8.0 * prefs.getDouble('height'),
                            ),
                            SizedBox(
                              height: 4 * prefs.getDouble('height'),
                            ),
                            Icon(
                              Icons.assignment,
                              size: 24.0 * prefs.getDouble('height'),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            width: 40 * prefs.getDouble('width'),
                            child: Icon(
                              Icons.assignment,
                              size: 24.0 * prefs.getDouble('height'),
                            ),
                          ),
                        ),
                  title: Text(
                    'Classes',
                    style: TextStyle(
                        fontSize: 10 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class VoteMain extends PopupRoute<void> {
  VoteMain({this.clientUser, this.trainer, this.classOrWorkout, this.parent});
  final MyAppState parent;
  final String classOrWorkout;
  final TrainerUser trainer;
  final ClientUser clientUser;
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
              classOrWorkout: classOrWorkout,
              parent: parent),
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomDialogVote extends StatefulWidget {
  final String classOrWorkout;
  final MyAppState parent;
  final TrainerUser trainer;
  final ClientUser actualClient;
  CustomDialogVote(
      {Key key,
      @required this.trainer,
      this.actualClient,
      this.classOrWorkout,
      this.parent})
      : super(key: key);

  @override
  State createState() => CustomDialogVoteState(
        trainer: trainer,
      );
}

class CustomDialogVoteState extends State<CustomDialogVote> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  CustomDialogVoteState({
    @required this.trainer,
    this.image,
  });
  bool insufficientTrophies = false;
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
            voteFlag = false;
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: IgnorePointer(
              ignoring: rateFlag,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 24 * prefs.getDouble('width')),
                height: 529 * prefs.getDouble('height'),
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
                                if ((timestamp
                                            .isAfter(widget.actualClient
                                                .scheduleFirstEndWeek.day1
                                                .toDate()) ==
                                        true &&
                                    timestamp.day ==
                                        widget.actualClient.scheduleFirstEndWeek
                                            .day1
                                            .toDate()
                                            .day &&
                                    widget.actualClient.checkFirstSchedule
                                            .day1 ==
                                        'true' &&
                                    widget.actualClient.dailyVote == false)) {
                                  var db = Firestore.instance;
                                  var batch = db.batch();
                                  if (updatedTrainer.trophies > 0) {
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
                                                'reviewMap.${reviewText.contains(".") == true ? reviewText.replaceAll(".", ")()()(") : reviewText}':
                                                    DateTime.now(),
                                                'trophies':
                                                    updatedTrainer.trophies - 1
                                              },
                                            );
                                            batch.updateData(
                                              db
                                                  .collection('clientUsers')
                                                  .document(
                                                      prefs.getString('id')),
                                              {'dailyVote': true},
                                            );
                                            batch.commit();
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
                                                          updatedTrainer.votes +
                                                      localAttribute1) /
                                                  (updatedTrainer.votes + 1),
                                              'attributeMap.2': (updatedTrainer
                                                              .attributeMap
                                                              .attribute2 *
                                                          updatedTrainer.votes +
                                                      localAttribute2) /
                                                  (updatedTrainer.votes + 1),
                                              'votes': updatedTrainer.votes + 1,
                                              'month1.1': updatedTrainer
                                                      .month1.attribute1 +
                                                  (localAttribute1 == 5
                                                      ? 10
                                                      : localAttribute1 == 4
                                                          ? 5
                                                          : localAttribute1 == 3
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
                                                          : localAttribute2 == 3
                                                              ? 0
                                                              : localAttribute2 ==
                                                                      2
                                                                  ? -15
                                                                  : -30),
                                              'trophies':
                                                  updatedTrainer.trophies - 1
                                            },
                                          );
                                          batch.updateData(
                                            db
                                                .collection('clientUsers')
                                                .document(
                                                    prefs.getString('id')),
                                            {'dailyVote': true},
                                          );
                                          batch.commit();
                                        }
                                      }
                                    });
                                  } else {
                                    insufficientTrophies = true;
                                  }
                                } else {
                                  if (widget.actualClient.classVote != "" &&
                                      widget.actualClient.dailyVote == false) {
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

                                    if (query1.documents.length != 0) {
                                      TrainerUser updatedTrainer =
                                          TrainerUser(query.documents[0]);
                                      if (updatedTrainer.trophies > 0) {
                                        var db = Firestore.instance;
                                        var batch = db.batch();
                                        updatedTrainer.clients
                                            .forEach((element) async {
                                          if (element.clientId ==
                                                  prefs.getString('id') &&
                                              element.clientAccepted == true) {
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
                                                        updatedTrainer.votes +
                                                            1,
                                                    'reviewMap.${reviewText.contains(".") == true ? reviewText.replaceAll(".", ")()()(") : reviewText}':
                                                        DateTime.now(),
                                                    'trophies': updatedTrainer
                                                            .trophies -
                                                        1
                                                  },
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
                                                batch.updateData(
                                                  db
                                                      .collection('clientUsers')
                                                      .document(prefs
                                                          .getString('id')),
                                                  {'dailyVote': true},
                                                );
                                                batch.commit();
                                              }
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
                                                  'trophies':
                                                      updatedTrainer.trophies -
                                                          1
                                                },
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
                                                          : localAttribute1 == 4
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
                                                          : localAttribute2 == 4
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
                                              batch.updateData(
                                                db
                                                    .collection('clientUsers')
                                                    .document(
                                                        prefs.getString('id')),
                                                {'dailyVote': true},
                                              );
                                              batch.commit();
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
                              if (insufficientTrophies == true) {
                                Navigator.push(
                                  context,
                                  PopUpMissingRoute(),
                                );
                              }
                              if (flagSpecialCharacters != true &&
                                  insufficientTrophies != true) {
                                voteFlag = false;
                                Navigator.of(context).pop();
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
                    GestureDetector(
                      onTap: () {
                        voteFlag = false;
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 200 * prefs.getDouble('width'),
                        height: 50 * prefs.getDouble('height'),
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
