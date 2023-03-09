import 'dart:io';

import 'package:Bsharkr/Client/ReviewTextError.dart';
import 'package:Bsharkr/Trainer/Classes/Classes.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Chat/chatscreen.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Nearby.dart';
import 'package:Bsharkr/Trainer/Marketing/Trophies.dart';
import 'package:Bsharkr/Trainer/pendingTrainer.dart';
import 'package:Bsharkr/disabledApp.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Trainer/My_Profile/MyProfile.dart';
import 'package:Bsharkr/Trainer/Client_Requests/Client_Request_Main/ClientRequest.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Main/OfficialClients.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Friendlist/Friendlist.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../DeleteAccountInProcess.dart';

int selectedBarIndex1 = 0;

class MainTrainer extends StatefulWidget {
  MainTrainer({this.auth, this.onSignedOut, this.selectedPage});
  final int selectedPage;
  final BaseAuth auth;
  final Function onSignedOut;
  @override
  State createState() => MainTrainerState();
}

class MainTrainerState extends State<MainTrainer> with WidgetsBindingObserver {
  int _selectedPage;

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  updateTimezone() async {
    await Firestore.instance
        .collection('clientUsers')
        .document(prefs.getString('id'))
        .updateData({'timeZone': DateTime.now().timeZoneName});
  }

  checkIfItsDeleted() async {
    QuerySnapshot query = await Firestore.instance
        .collection('deleteAccountTrainer')
        .where('id', isEqualTo: prefs.getString('id'))
        .getDocuments();
    if (query.documents.length != 0) {
      Navigator.push(
        context,
        DeleteAccountInProcessPopup(auth: widget.auth, role: 'trainer'),
      );
    }
  }

  approvedTrainer() async {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          PendingApprovalPopUp(),
        );
      });
    }
  }

  var _pageOptions = [];
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
   
    super.initState();
    requestFlagFriend = null;
    newClientMessage = null;
    newFriendMessage = null;
    _selectedPage = widget.selectedPage;
    updateTimezone();
    registerNotification(prefs.getString('id'));
  }

  bool browseClients = false;
  bool restartedFlagFriends = false;
  bool restartedFlagClients = false;
  String newFriendMessage;
  String requestFlagFriend;
  String requestFlagClient;
  Future getMyData;
  String newClientMessage;
  bool acceptedFriendship;

  Future<void> registerNotification(String id) async {
    _firebaseMessaging.requestNotificationPermissions();
    if (Platform.isAndroid) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) {
          return;
        },
        onResume: (Map<String, dynamic> message) async {
          if (message['data']['screen'] == 'classReminder') {
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
          if (message['data']['screen'] == 'newMemberJoined') {
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
              _selectedPage = 2;
              acceptedFriendship = true;
            });
          }
          if (message['data']['screen'] == 'newFriend') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              _selectedPage = 0;
              requestFlagFriend = 'friend';
            });
          }
          if (message['data']['screen'] == 'toClient' &&
              message['data']['receiver'] == prefs.getString('id')) {
            imTrainer.clients.forEach((element) {
              if (element.clientId == message['data']['sender'] &&
                  element.clientAccepted == true) {
                setState(() {
                  _selectedPage = 2;
                  newClientMessage = 'client';
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
            imTrainer.friends.forEach((element) {
              if (element.friendId == message['data']['sender'] &&
                  element.friendAccepted == true) {
                setState(() {
                  _selectedPage = 2;
                  newFriendMessage = 'friend';
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
          }
          if (message['data']['screen'] == 'newClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              requestFlagClient = 'client';
              _selectedPage = 0;
            });
          }
          return;
        },
        onLaunch: (Map<String, dynamic> message) async {
          if (message['data']['screen'] == 'classReminder') {
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
          if (message['data']['screen'] == 'newMemberJoined') {
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
              _selectedPage = 2;
              acceptedFriendship = true;
            });
          }
          if (message['data']['screen'] == 'toClient' &&
              message['data']['receiver'] == prefs.getString('id')) {
            setState(() {
              _selectedPage = 2;
              newClientMessage = 'client';
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

            setState(() {
              _selectedPage = 2;
              newFriendMessage = 'friend';
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
          if (message['data']['screen'] == 'newFriend') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              requestFlagFriend = 'friend';
              _selectedPage = 0;
            });
          }
          if (message['data']['screen'] == 'newClient') {
            setState(() {
              if (restartedFlagFriends == true) {
                restartedFlagFriends = false;

                Navigator.pop(context, true);
              }
              if (restartedFlagClients == true) {
                restartedFlagClients = false;

                Navigator.pop(context, true);
              }
              requestFlagClient = 'client';
              _selectedPage = 0;
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
          if (message['data'] == 'classReminder') {
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
          if (message['screen'] == 'newMemberJoined') {
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
          if (message['screen'] == 'acceptedFriendship') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 2;
            acceptedFriendship = true;
          }
          if (message['screen'] == 'newFriend') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 0;
            requestFlagFriend = 'friend';
          }
          if (message['screen'] == 'toClient' &&
              message['receiver'] == prefs.getString('id')) {
            imTrainer.clients.forEach((element) {
              if (element.clientId == message['sender'] &&
                  element.clientAccepted == true) {
                setState(() {
                  _selectedPage = 2;
                  newClientMessage = 'client';
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
            imTrainer.friends.forEach((element) {
              if (element.friendId == message['sender'] &&
                  element.friendAccepted == true) {
                setState(() {
                  _selectedPage = 2;
                  newFriendMessage = 'friend';
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
          }
          if (message['screen'] == 'newClient') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            requestFlagClient = 'client';
            _selectedPage = 0;
          }
          return;
        },
        onLaunch: (Map<String, dynamic> message) async {
          if (message['data'] == 'classReminder') {
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
          if (message['screen'] == 'newMemberJoined') {
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
          if (message['screen'] == 'acceptedFriendship') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            _selectedPage = 2;
            acceptedFriendship = true;
          }
          if (message['screen'] == 'toClient' &&
              message['receiver'] == prefs.getString('id')) {
            setState(() {
              _selectedPage = 2;
              newClientMessage = 'client';
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

            setState(() {
              _selectedPage = 2;
              newFriendMessage = 'friend';
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
          if (message['screen'] == 'newFriend') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            requestFlagFriend = 'friend';
            _selectedPage = 0;
          }
          if (message['screen'] == 'newClient') {
            if (restartedFlagFriends == true) {
              restartedFlagFriends = false;

              Navigator.pop(context, true);
            }
            if (restartedFlagClients == true) {
              restartedFlagClients = false;

              Navigator.pop(context, true);
            }
            requestFlagClient = 'client';
            _selectedPage = 0;
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

  bool seenFlag;
  TrainerUser imTrainer;

  bool checked = false;
  bool approvedTrainerFlag = false;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state.index == 0) {
      if (imTrainer.approved != true) {
        approvedTrainer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.auth == null) {
      print("AUTH IS NULL");
    } else {
      print("AUTH IS NOT NULL");
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("DONT"),
                    actions: <Widget>[
                      FlatButton(onPressed: null, child: Text("NO")),
                      FlatButton(onPressed: null, child: Text("Yes")),
                    ],
                  ));
        },
        child: StreamBuilder(
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(prefix0.mainColor),
                      backgroundColor: backgroundColor,
                    ),
                  ),
                  color: prefix0.backgroundColor,
                );
              }
              try {
                checkIfItsDeleted();
                seenFlag = false;
                imTrainer = TrainerUser(snapshot.data.documents[0]);
                if (imTrainer.appIsOn == false) {
                  return DisabledAppError();
                }
                imTrainer.friends.forEach((element) {
                  if (element.friendAccepted == true) {
                    imTrainer.unseenMessagesCounter
                        .asMap()
                        .values
                        .forEach((element1) {
                      if (element1.userId == element.friendId) {
                        seenFlag = true;
                      }
                    });
                  }
                });

                imTrainer.clients.forEach((element) {
                  if (element.clientAccepted == true) {
                    imTrainer.unseenMessagesCounter
                        .asMap()
                        .values
                        .forEach((element1) {
                      if (element1.userId == element.clientId) {
                        seenFlag = true;
                      }
                    });
                  }
                });

                int clientsCounter = 0;
                imTrainer.clients.forEach((element) {
                  if (element.clientAccepted == true) {
                    clientsCounter++;
                  }
                });

                if (imTrainer.approved != true &&
                    approvedTrainerFlag == false) {
                  approvedTrainer();
                  approvedTrainerFlag = true;
                }
                if (prefs.getInt('clientsCounter') != null) {
                  if (clientsCounter < prefs.getInt('clientsCounter')) {
                    prefs
                        .getStringList('previousClients')
                        .forEach((client) async {
                      bool flag = false;
                      imTrainer.clients.forEach((client1) {
                        if (client1.clientId == client &&
                            client1.clientAccepted == true) {
                          flag = true;
                        }
                      });
                      if (flag == false) {
                        QuerySnapshot query = await Firestore.instance
                            .collection('clientUsers')
                            .where('id', isEqualTo: client)
                            .getDocuments();
                        Navigator.push(
                          context,
                          Vote(
                            clientUser: ClientUser(query.documents[0]),
                          ),
                        );
                      }
                    });
                  }
                }
                List<String> previousClients = [];
                prefs.setInt('clientsCounter', clientsCounter);
                imTrainer.clients.forEach((element) {
                  if (element.clientAccepted == true) {
                    previousClients.add(element.clientId);
                  }
                });
                prefs.setInt('clientsCounter', previousClients.length);
                prefs.setStringList('previousClients', previousClients);
                if (browseClients == true) {
                  _selectedPage = 2;
                }
                _pageOptions = [
                  requestFlagFriend == 'friend'
                      ? ClientRequestPage(
                          friendsNotif: imTrainer.newFriendRequest,
                          businessNotif: imTrainer.newBusinessRequest,
                          actualTrainer: imTrainer,
                          selectedBarIndex: 1,
                        )
                      : requestFlagClient == 'client'
                          ? ClientRequestPage(
                              friendsNotif: imTrainer.newFriendRequest,
                              businessNotif: imTrainer.newBusinessRequest,
                              actualTrainer: imTrainer,
                              selectedBarIndex: 0,
                            )
                          : ClientRequestPage(
                              friendsNotif: imTrainer.newFriendRequest,
                              businessNotif: imTrainer.newBusinessRequest,
                              actualTrainer: imTrainer,
                            ),
                  MyProfilePage(
                      auth: widget.auth,
                      onSignedOut: widget.onSignedOut,
                      trainerUser: imTrainer,
                      parent: this),
                  (browseClients == true || newClientMessage == 'client')
                      ? MyTabsFriends(
                          selectedBarIndex: 0,
                          imTrainer: imTrainer,
                        )
                      : newFriendMessage == 'friend'
                          ? MyTabsFriends(
                              selectedBarIndex: 1,
                              imTrainer: imTrainer,
                            )
                          : acceptedFriendship == true
                              ? MyTabsFriends(
                                  selectedBarIndex: 1,
                                  imTrainer: imTrainer,
                                )
                              : MyTabsFriends(
                                  imTrainer: imTrainer,
                                ),
                  Classes(
                    imTrainer: imTrainer,
                  ),
                  Trophies(
                    imTrainer: imTrainer,
                  )
                ];
                browseClients = false;
                requestFlagFriend = null;
                requestFlagClient = null;
                newClientMessage = null;
                newFriendMessage = null;
                acceptedFriendship = null;
                return MaterialApp(
         debugShowCheckedModeBanner: false,
                  home: ExtraTrainerPage(parent: this),
                );
              } catch (e) {
                try {
                  prefs.setDouble('height', null);
                  prefs.setDouble('width', null);
                  prefs.setString('id', null);
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
                  prefs.setString('certificateUrl', null);
                  prefs.setStringList('previousClients', null);
                  prefs.setInt('clientsCounter', null);
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
      ),
    );
  }
}

class MyTabsFriends extends StatefulWidget {
  TrainerUser imTrainer;
  int selectedBarIndex;
  MyTabsFriends({this.selectedBarIndex, this.imTrainer});
  @override
  MyTabsFriendsState createState() => new MyTabsFriendsState();
}

class MyTabsFriendsState extends State<MyTabsFriends>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(
        vsync: this,
        length: 3,
        initialIndex: widget.selectedBarIndex == null
            ? selectedBarIndex1
            : widget.selectedBarIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedBarIndex == null) {
      widget.selectedBarIndex = selectedBarIndex1;
    } else {
      selectedBarIndex1 = widget.selectedBarIndex;
    }
    return AppBarNavigation(
        selectedBarIndex: widget.selectedBarIndex,
        parent: this,
        imTrainer: widget.imTrainer,
        controller: controller);
  }
}

class AppBarNavigation extends StatefulWidget {
  TrainerUser imTrainer;
  final TabController controller;
  final MyTabsFriendsState parent;
  int selectedBarIndex;
  AppBarNavigation(
      {this.selectedBarIndex, this.parent, this.imTrainer, this.controller});
  final List<BarItem> barItems = [
    BarItem(
      text: "Clients",
      iconData: Icons.assignment_ind,
      color: Colors.white,
    ),
    BarItem(
      text: "Friends",
      iconData: Icons.person,
      color: Colors.white,
    ),
    BarItem(
      text: "Nearby",
      iconData: Icons.group_add,
      color: Colors.white,
    ),
  ];

  @override
  State createState() => AppNavigationState();
}

class AppNavigationState extends State<AppBarNavigation> {
  @override
  void initState() {
   
    super.initState();
  }

  bool acceptedFriendship;
  TrainerUser imTrainer;
  bool seenFlagClients;
  bool seenFlagFriends;
  @override
  Widget build(BuildContext context) {
    acceptedFriendship = false;
    seenFlagClients = false;
    seenFlagFriends = false;
    imTrainer = widget.imTrainer;
    imTrainer.friends.forEach((element) {
      if (element.friendAccepted == true) {
        imTrainer.unseenMessagesCounter.asMap().values.forEach((element1) {
          if (element1.userId == element.friendId) {
            seenFlagFriends = true;
          }
        });
      }
    });

    imTrainer.clients.forEach((element) {
      if (element.clientAccepted == true) {
        imTrainer.unseenMessagesCounter.asMap().values.forEach((element1) {
          if (element1.userId == element.clientId) {
            seenFlagClients = true;
          }
        });
      }
    });
    if (imTrainer.acceptedFriendship == true) {
      acceptedFriendship = true;
    }
    return Scaffold(
        backgroundColor: prefix0.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(86.0 * prefs.getDouble('height')),
          child: AppBar(
            backgroundColor: secondaryColor,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0 * prefs.getDouble('height')),
              child: AnimatedTopBar(
                  barStyle: BarStyle(
                      fontSize: 20.0 * prefs.getDouble('height'),
                      fontWeight: FontWeight.w400,
                      iconSize: 30.0 * prefs.getDouble('height')),
                  barItems: widget.barItems,
                  animationDuration: const Duration(milliseconds: 200),
                  seenFlagFriends: seenFlagFriends,
                  seenFlagClients: seenFlagClients,
                  selectedBarIndex: widget.selectedBarIndex,
                  newFriend: imTrainer.newFriend,
                  newClient: imTrainer.newClient,
                  acceptedFriendship: acceptedFriendship,
                  onBarTap: (index) {
                    widget.parent.setState(() {
                      widget.parent.widget.selectedBarIndex = index;
                      setState(() {
                        widget.selectedBarIndex = index;
                        selectedBarIndex1 = index;
                        widget.controller.animateTo(widget.selectedBarIndex);
                      });
                    });
                  }),
            ),
          ),
        ),
        body: TabBarView(
          controller: widget.controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            OfficialClients(
                actualTrainer: imTrainer, index: widget.selectedBarIndex),
            FriendList(
                actualTrainer: imTrainer, index: widget.selectedBarIndex),
            Nearby(
              actualTrainer: imTrainer,
            ),
          ],
        ));
  }
}

class AnimatedTopBar extends StatefulWidget {
  int selectedBarIndex;
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  final bool seenFlagFriends;
  final bool seenFlagClients;
  final bool acceptedFriendship;
  final bool newFriend;
  final bool newClient;

  AnimatedTopBar(
      {this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTap,
      this.barStyle,
      this.seenFlagFriends,
      this.seenFlagClients,
      this.selectedBarIndex,
      this.acceptedFriendship,
      this.newFriend,
      this.newClient});
  @override
  _AnimatedTopBarState createState() => _AnimatedTopBarState();
}

class _AnimatedTopBarState extends State<AnimatedTopBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Material(
        color: secondaryColor,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 18.0 * prefs.getDouble('height'),
              top: 0.0 * prefs.getDouble('height'),
              left: 16.0 * prefs.getDouble('width'),
              right: 16.0 * prefs.getDouble('width')),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: _buildBarItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      if (i == 2) {
        BarItem item = widget.barItems[i];
        bool isSelected = widget.selectedBarIndex == i;
        _barItems.add(InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              widget.selectedBarIndex = i;
              widget.onBarTap(widget.selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0 * prefs.getDouble('width'),
                vertical: 8.0 * prefs.getDouble('height')),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
                color: isSelected ? mainColor : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Row(
              children: <Widget>[
                Icon(
                  item.iconData,
                  color: isSelected
                      ? item.color
                      : Color.fromARGB(150, 255, 255, 255),
                  size: widget.barStyle.iconSize,
                ),
                SizedBox(
                  width: 10.0,
                ),
                AnimatedSize(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  vsync: this,
                  child: Text(
                    isSelected ? item.text : "",
                    style: TextStyle(
                        color: item.color,
                        fontWeight: widget.barStyle.fontWeight,
                        fontSize: widget.barStyle.fontSize),
                  ),
                )
              ],
            ),
          ),
        ));
      } else {
        if (i == 1) {
          BarItem item = widget.barItems[i];
          bool isSelected = widget.selectedBarIndex == i;
          _barItems.add(InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                widget.selectedBarIndex = i;
                widget.onBarTap(widget.selectedBarIndex);
              });
            },
            child: AnimatedContainer(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * prefs.getDouble('width'),
                  vertical: 8.0 * prefs.getDouble('height')),
              duration: widget.animationDuration,
              decoration: BoxDecoration(
                  color: isSelected ? mainColor : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: <Widget>[
                  (widget.seenFlagFriends == true ||
                          widget.acceptedFriendship == true ||
                          widget.newFriend == true)
                      ? Stack(
                          children: <Widget>[
                            Icon(
                              item.iconData,
                              color: isSelected
                                  ? item.color
                                  : Color.fromARGB(150, 255, 255, 255),
                              size: widget.barStyle.iconSize,
                            ),
                            Positioned(
                              left: 14.0 * prefs.getDouble('width'),
                              child: Icon(
                                Icons.brightness_1,
                                color: isSelected == false
                                    ? mainColor
                                    : Colors.transparent,
                                size: 11.0 * prefs.getDouble('height'),
                              ),
                            )
                          ],
                        )
                      : Icon(
                          item.iconData,
                          color: isSelected
                              ? item.color
                              : Color.fromARGB(150, 255, 255, 255),
                          size: widget.barStyle.iconSize,
                        ),
                  SizedBox(
                    width: 10.0,
                  ),
                  AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    vsync: this,
                    child: Text(
                      isSelected ? item.text : "",
                      style: TextStyle(
                          color: item.color,
                          fontWeight: widget.barStyle.fontWeight,
                          fontSize: widget.barStyle.fontSize),
                    ),
                  )
                ],
              ),
            ),
          ));
        } else {
          BarItem item = widget.barItems[i];
          bool isSelected = widget.selectedBarIndex == i;
          _barItems.add(InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                widget.selectedBarIndex = i;
                widget.onBarTap(widget.selectedBarIndex);
              });
            },
            child: AnimatedContainer(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * prefs.getDouble('width'),
                  vertical: 8.0 * prefs.getDouble('height')),
              duration: widget.animationDuration,
              decoration: BoxDecoration(
                  color: isSelected ? mainColor : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: <Widget>[
                  (widget.seenFlagClients == true || widget.newClient == true)
                      ? Stack(
                          children: <Widget>[
                            Icon(
                              item.iconData,
                              color: isSelected
                                  ? item.color
                                  : Color.fromARGB(150, 255, 255, 255),
                              size: widget.barStyle.iconSize,
                            ),
                            Positioned(
                              left: 14.0 * prefs.getDouble('width'),
                              child: Icon(
                                Icons.brightness_1,
                                color: isSelected == false
                                    ? mainColor
                                    : Colors.transparent,
                                size: 11.0 * prefs.getDouble('height'),
                              ),
                            )
                          ],
                        )
                      : Icon(
                          item.iconData,
                          color: isSelected
                              ? item.color
                              : Color.fromARGB(150, 255, 255, 255),
                          size: widget.barStyle.iconSize,
                        ),
                  SizedBox(
                    width: 10.0,
                  ),
                  AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    vsync: this,
                    child: Text(
                      isSelected ? item.text : "",
                      style: TextStyle(
                          color: item.color,
                          fontWeight: widget.barStyle.fontWeight,
                          fontSize: widget.barStyle.fontSize),
                    ),
                  )
                ],
              ),
            ),
          ));
        }
      }
    }
    return _barItems;
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fontSize = 18.0,
      this.iconSize = 32,
      this.fontWeight = FontWeight.w700});
}

class BarItem {
  String text;
  IconData iconData;
  Color color;
  BarItem({this.text, this.iconData, this.color});
}

class Vote extends PopupRoute<void> {
  Vote({this.clientUser});
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
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: CustomDialogVote(
          actualClient: clientUser,
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomDialogVote extends StatefulWidget {
  final ClientUser actualClient;

  CustomDialogVote({
    Key key,
    @required this.actualClient,
  }) : super(key: key);

  @override
  State createState() => CustomDialogVoteState(actualClient: actualClient);
}

class CustomDialogVoteState extends State<CustomDialogVote> {
  String hinttText = "Scrie";
  final ClientUser actualClient;
  bool flagSpecialCharacters = false;

  CustomDialogVoteState({
    this.actualClient,
  });
  String reviewText;
  int localAttribute1 = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: 24 * prefs.getDouble('width')),
            height: 486 * prefs.getDouble('height'),
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
                Center(
                  child: Text(
                    "Rate the collaboration with ${actualClient.firstName} ${actualClient.lastName}!",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17.0 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: Color.fromARGB(200, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 33.0 * prefs.getDouble('height'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Cooperation",
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
                                  fontSize: 12.0 * prefs.getDouble('height'),
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
                      borderRadius: BorderRadius.circular(90.0),
                      child: MaterialButton(
                        onPressed: () async {
                          QuerySnapshot query = await Firestore.instance
                              .collection('clientUsers')
                              .where('id', isEqualTo: actualClient.id)
                              .getDocuments();
                          ClientUser updatedClient =
                              ClientUser(query.documents[0]);
                          if (reviewText != null && reviewText != "") {
                            if (reviewText.contains("~") == true ||
                                reviewText.contains("*") == true ||
                                reviewText.contains("[") == true ||
                                reviewText.contains("]") == true ||
                                reviewText.contains("/")) {
                              flagSpecialCharacters = true;
                              Navigator.push(
                                  context, ReviewTextErrorClientPopUp());
                            } else {
                              if (updatedClient.reviewsMap.length < 4) {
                                flagSpecialCharacters = false;
                                Firestore.instance
                                    .collection('clientUsers')
                                    .document(updatedClient.id)
                                    .updateData(
                                  {
                                    'votesMap.${updatedClient.votesMap.length + 1}':
                                        localAttribute1,
                                    'reviewsMap.${updatedClient.reviewsMap.length + 1}':
                                        reviewText.contains(".") == true
                                            ? reviewText.replaceAll(
                                                ".", ")()()(")
                                            : reviewText,
                                  },
                                );
                              } else {
                                flagSpecialCharacters = false;
                                Firestore.instance
                                    .collection('clientUsers')
                                    .document(updatedClient.id)
                                    .updateData(
                                  {
                                    'votesMap.1':
                                        updatedClient.votesMap[1].vote,
                                    'reviewsMap.1':
                                        updatedClient.reviewsMap[1].review,
                                    'votesMap.2':
                                        updatedClient.votesMap[2].vote,
                                    'reviewsMap.2':
                                        updatedClient.reviewsMap[2].review,
                                    'votesMap.3':
                                        updatedClient.votesMap[3].vote,
                                    'reviewsMap.3':
                                        updatedClient.reviewsMap[3].review,
                                    'votesMap.4': localAttribute1,
                                    'reviewsMap.4': reviewText.contains(".") ==
                                            true
                                        ? reviewText.replaceAll(".", ")()()(")
                                        : reviewText,
                                  },
                                );
                              }
                            }
                          } else {
                            if (updatedClient.reviewsMap.length <= 4) {
                              flagSpecialCharacters = false;
                              Firestore.instance
                                  .collection('clientUsers')
                                  .document(updatedClient.id)
                                  .updateData(
                                {
                                  'votesMap.${updatedClient.votesMap.length + 1}':
                                      localAttribute1,
                                  'reviewsMap.${updatedClient.reviewsMap.length + 1}':
                                      null
                                },
                              );
                            } else {
                              flagSpecialCharacters = false;
                              Firestore.instance
                                  .collection('clientUsers')
                                  .document(updatedClient.id)
                                  .updateData(
                                {
                                  'votesMap.1': updatedClient.votesMap[2].vote,
                                  'reviewsMap.1':
                                      updatedClient.reviewsMap[2].review,
                                  'votesMap.2': updatedClient.votesMap[3].vote,
                                  'reviewsMap.2':
                                      updatedClient.reviewsMap[3].review,
                                  'votesMap.3': updatedClient.votesMap[4].vote,
                                  'reviewsMap.3':
                                      updatedClient.reviewsMap[4].review,
                                  'votesMap.4': localAttribute1,
                                  'reviewsMap.4': null,
                                },
                              );
                            }
                          }
                          if (flagSpecialCharacters != true) {
                            Firestore.instance
                                .collection('clientUsers')
                                .document(prefs.getString('id'))
                                .updateData(
                              {'dailyVote': true},
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Vote',
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
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30 * prefs.getDouble('height'),
                    child: Center(
                      child: Text(
                        "Close",
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
    );
  }
}

class ExtraTrainerPage extends StatefulWidget {
  ExtraTrainerPage({this.parent});
  final MainTrainerState parent;
  @override
  _ExtraTrainerPageState createState() => _ExtraTrainerPageState();
}

class _ExtraTrainerPageState extends State<ExtraTrainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.parent._pageOptions[widget.parent._selectedPage],
      backgroundColor: backgroundColor,
      bottomNavigationBar: SizedBox(
        height: 86 * prefs.getDouble('height'),
        child: BottomNavigationBar(
          selectedItemColor: mainColor,
          unselectedItemColor: Color.fromARGB(150, 255, 255, 255),
          backgroundColor: secondaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.parent._selectedPage,
          onTap: (int index) {
            setState(
              () {
                widget.parent._selectedPage = index;
              },
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Center(
                child: Container(
                    width: 35 * prefs.getDouble('width'),
                    child: ((widget.parent.imTrainer.newFriendRequest == null &&
                            widget.parent.imTrainer.newBusinessRequest == null)
                        ? Icon(
                            Icons.local_library,
                            size: 24 * prefs.getDouble('height'),
                          )
                        : Column(
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
                                Icons.local_library,
                                size: 24.0 * prefs.getDouble('height'),
                              ),
                            ],
                          ))),
              ),
              title: Text(
                'Requests',
                style: TextStyle(
                    fontSize: 10 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
            ),
            BottomNavigationBarItem(
              icon: Center(
                child: Container(
                  width: 35 * prefs.getDouble('width'),
                  child: Icon(Icons.perm_identity,
                      size: 24 * prefs.getDouble('height')),
                ),
              ),
              title: Text(
                'My profile',
                style: TextStyle(
                    fontSize: 10 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
            ),
            BottomNavigationBarItem(
              icon: Center(
                child: Container(
                  width: 35 * prefs.getDouble('width'),
                  child: (widget.parent.seenFlag == true ||
                          widget.parent.imTrainer.acceptedFriendship == true ||
                          widget.parent.imTrainer.newFriend == true ||
                          widget.parent.imTrainer.newClient == true)
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
                'People',
                style: TextStyle(
                    fontSize: 10 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
            ),
            BottomNavigationBarItem(
              icon: widget.parent.imTrainer.newMemberJoined == true
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
                          Icons.fitness_center,
                          size: 24.0 * prefs.getDouble('height'),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        width: 35 * prefs.getDouble('width'),
                        child: Icon(Icons.fitness_center,
                            size: 24 * prefs.getDouble('height')),
                      ),
                    ),
              title: Text(
                'Classes',
                style: TextStyle(
                    fontSize: 10 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
            ),
            BottomNavigationBarItem(
              icon: Center(
                child: Container(
                  width: 35 * prefs.getDouble('width'),
                  child: Icon(
                    Icons.assessment,
                    size: 24.0 * prefs.getDouble('height'),
                  ),
                ),
              ),
              title: Text(
                'Marketing',
                style: TextStyle(
                    fontSize: 10 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Rating extends StatefulWidget {
  final int initialRating;
  final void Function(int) onRated;
  final double size;
  final Color color = Color(0xffAC70F1);

  Rating({
    this.initialRating,
    this.onRated,
    this.size,
  });

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int _rating = 0;
  GlobalKey _starOneKey = GlobalKey();
  GlobalKey _starTwoKey = GlobalKey();
  GlobalKey _starThreeKey = GlobalKey();
  GlobalKey _starFourKey = GlobalKey();
  GlobalKey _starFiveKey = GlobalKey();
  bool _isDragging = false;

  _updateRating(int newRating) {
    if (_rating == 1 && newRating == 1 && _isDragging != true) {
      setState(
        () {
          _rating = 0;
          widget.onRated(0);
        },
      );
    } else {
      setState(
        () {
          _rating = newRating;
          widget.onRated(newRating);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        _isDragging = true;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        RenderBox star1 = _starOneKey.currentContext.findRenderObject();
        final positionStar1 = star1.localToGlobal(Offset.zero);
        final sizeStar1 = star1.size;

        RenderBox star2 = _starTwoKey.currentContext.findRenderObject();
        final positionStar2 = star2.localToGlobal(Offset.zero);
        final sizeStar2 = star2.size;

        RenderBox star3 = _starThreeKey.currentContext.findRenderObject();
        final positionStar3 = star3.localToGlobal(Offset.zero);
        final sizeStar3 = star3.size;

        RenderBox star4 = _starFourKey.currentContext.findRenderObject();
        final positionStar4 = star4.localToGlobal(Offset.zero);
        final sizeStar4 = star4.size;

        RenderBox star5 = _starFiveKey.currentContext.findRenderObject();
        final positionStar5 = star5.localToGlobal(Offset.zero);
        final sizeStar5 = star5.size;

        if (details.globalPosition.dx > positionStar1.dx &&
            details.globalPosition.dx < (positionStar1.dx + sizeStar1.width)) {
          _updateRating(1);
        } else if (details.globalPosition.dx > positionStar2.dx &&
            details.globalPosition.dx < (positionStar2.dx + sizeStar2.width)) {
          _updateRating(2);
        } else if (details.globalPosition.dx > positionStar3.dx &&
            details.globalPosition.dx < (positionStar3.dx + sizeStar3.width)) {
          _updateRating(3);
        } else if (details.globalPosition.dx > positionStar4.dx &&
            details.globalPosition.dx < (positionStar4.dx + sizeStar4.width)) {
          _updateRating(4);
        } else if (details.globalPosition.dx > positionStar5.dx &&
            details.globalPosition.dx < (positionStar5.dx + sizeStar5.width)) {
          _updateRating(5);
        } else if (details.globalPosition.dx >
            (positionStar1.dx + sizeStar1.width)) {
          _updateRating(5);
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _isDragging = false;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            key: _starOneKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.0 * prefs.getDouble('width')),
              child: Icon(
                _rating >= 1 ? Icons.star : Icons.star_border,
                color: widget.color,
                size: 24 * prefs.getDouble('height'),
              ),
            ),
          ),
          GestureDetector(
            key: _starTwoKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.0 * prefs.getDouble('width')),
              child: Icon(
                _rating >= 2 ? Icons.star : Icons.star_border,
                color: widget.color,
                size: 24 * prefs.getDouble('height'),
              ),
            ),
            onTap: () => _updateRating(2),
          ),
          GestureDetector(
            key: _starThreeKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.0 * prefs.getDouble('width')),
              child: Icon(
                _rating >= 3 ? Icons.star : Icons.star_border,
                color: widget.color,
                size: 24 * prefs.getDouble('height'),
              ),
            ),
            onTap: () => _updateRating(3),
          ),
          GestureDetector(
            key: _starFourKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.0 * prefs.getDouble('width')),
              child: Icon(
                _rating >= 4 ? Icons.star : Icons.star_border,
                color: widget.color,
                size: 24 * prefs.getDouble('height'),
              ),
            ),
            onTap: () => _updateRating(4),
          ),
          GestureDetector(
            key: _starFiveKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.0 * prefs.getDouble('width')),
              child: Icon(
                _rating >= 5 ? Icons.star : Icons.star_border,
                color: widget.color,
                size: 24 * prefs.getDouble('height'),
              ),
            ),
            onTap: () => _updateRating(5),
          ),
        ],
      ),
    );
  }
}
