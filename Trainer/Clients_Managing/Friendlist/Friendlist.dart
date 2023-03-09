import 'package:Bsharkr/Trainer/Client_Requests/Client_Profile/ClientProfileFinal.dart';
import 'package:Bsharkr/Trainer/IconSlide.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Chat/chatscreen.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/models/clientUser.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

class FriendList extends StatefulWidget {
  final int index;
  final TrainerUser actualTrainer;
  FriendList({this.actualTrainer, this.index});
  @override
  State createState() => FriendListState();
}

class FriendListState extends State<FriendList>
    with AutomaticKeepAliveClientMixin<FriendList> {
  List<int> listGroupCounter = [];
  List<String> listEdit = [];

  bool edit = false;
  int counter = 0;
  int counter2 = 0;

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    bool seenFlag = false;
    ClientUser _clientUser = ClientUser(document);
    widget.actualTrainer.unseenMessagesCounter.forEach((user) {
      if (user.userId == _clientUser.id) {
        seenFlag = true;
      }
    });
    if (_clientUser.id == prefs.getString('id')) {
      return Container();
    } else {
      double votFinal = 0;
      _clientUser.votesMap.forEach((element) {
        votFinal = votFinal + element.vote;
      });

      if (votFinal != 0) {
        votFinal = (votFinal / _clientUser.votesMap.length);
      }
      return Container(
        padding: EdgeInsets.fromLTRB(
            10.0 * prefs.getDouble('width'),
            5.0 * prefs.getDouble('height'),
            10.0 * prefs.getDouble('width'),
            5.0 * prefs.getDouble('height')),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => ClientProfileFinalSetState(
                    _clientUser.id,
                    prefs.getString('id'),
                    ClientUser(document),
                    widget.actualTrainer,
                    null),
              ),
            );
          },
          child: Slidable(
            actionExtentRatio: 0.20,
            delegate: SlidableDrawerDelegate(),
            secondaryActions: <Widget>[
              Container(
                padding: EdgeInsets.all(10 * prefs.getDouble('height')),
                child: IconSlideActionModifiedRight(
                  icon: Icons.cancel,
                  color: Colors.red,
                  onTap: () {
                    ClientUser actualClient = ClientUser(document);
                    Navigator.push(
                        context,
                        DeletePermissionPopup(
                          clientUser: actualClient,
                        ));
                  },
                ),
              ),
            ],
            child: Container(
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
                        children: <Widget>[
                          SizedBox(
                            width: 30.0 * prefs.getDouble('width'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: prefix0.backgroundColor,
                                shape: BoxShape.circle),
                            padding:
                                EdgeInsets.all(2.0 * prefs.getDouble('height')),
                            child: _clientUser.photoUrl == null
                                ? ClipOval(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255,
                                              _clientUser.colorRed,
                                              _clientUser.colorGreen,
                                              _clientUser.colorBlue),
                                          shape: BoxShape.circle,
                                        ),
                                        height:
                                            (60 * prefs.getDouble('height')),
                                        width: (60 * prefs.getDouble('height')),
                                        child: Center(
                                            child: Text(
                                          _clientUser.firstName[0],
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                              fontSize: 35 *
                                                  prefs.getDouble('height')),
                                        ))),
                                  )
                                : Material(
                                    child: Container(
                                      width: 60 * prefs.getDouble('height'),
                                      height: 60 * prefs.getDouble('height'),
                                      decoration: BoxDecoration(
                                          color: prefix0.backgroundColor,
                                          shape: BoxShape.circle),
                                      child: Image.network(
                                        _clientUser.photoUrl,
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
                                                    AlwaysStoppedAnimation<
                                                            Color>(
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
                            width: 210 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 150 * prefs.getDouble('width'),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            _clientUser.firstName,
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255),
                                                fontSize: 17 *
                                                    prefs.getDouble('width')),
                                          ),
                                          SizedBox(
                                            width:
                                                4.0 * prefs.getDouble('width'),
                                          ),
                                          Text(
                                            _clientUser.lastName,
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255),
                                                fontSize: 17 *
                                                    prefs.getDouble('width')),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.0 * prefs.getDouble('height'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Age: ",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromARGB(
                                                  100, 255, 255, 255),
                                              fontSize: 15 *
                                                  prefs.getDouble('height'),
                                            ),
                                          ),
                                          Text(
                                            _clientUser.age.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.normal,
                                              color: Color.fromARGB(
                                                  100, 255, 255, 255),
                                              fontSize: 15 *
                                                  prefs.getDouble('height'),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                5.0 * prefs.getDouble('width'),
                                          ),
                                          Text(
                                            "|",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 15.0 *
                                                    prefs.getDouble('height'),
                                                color: Color.fromARGB(
                                                    100, 255, 255, 255)),
                                          ),
                                          SizedBox(
                                            width:
                                                5.0 * prefs.getDouble('width'),
                                          ),
                                          _clientUser.gender != 'none'
                                              ? Row(
                                                  children: <Widget>[
                                                    Text(
                                                      _clientUser.gender ==
                                                              'male'
                                                          ? "Male"
                                                          : "Female",
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromARGB(
                                                            100, 255, 255, 255),
                                                        fontSize: 15 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      ),
                                      votFinal.toStringAsFixed(2) == "0.00"
                                          ? Container(
                                              height: 22 *
                                                  prefs.getDouble('height'),
                                              width: 150 *
                                                  prefs.getDouble('width'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    "No rating yet",
                                                    style: TextStyle(
                                                        fontSize: 12.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white
                                                            .withOpacity(0.3)),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0 *
                                                        prefs
                                                            .getDouble('width'),
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 12.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: 22 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  70 * prefs.getDouble('width'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "${votFinal.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontSize: 17.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            prefix0.mainColor),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0 *
                                                        prefs
                                                            .getDouble('width'),
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 19.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: prefix0.mainColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) => Chat(
                                          peerId: _clientUser.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 30 * prefs.getDouble('width')),
                                    width: 60 * prefs.getDouble('width'),
                                    height: 60 * prefs.getDouble('height'),
                                    child: Center(
                                      child: seenFlag == false
                                          ? Container(
                                              width:
                                                  30 * prefs.getDouble('width'),
                                              child: Stack(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.message,
                                                    size: 24.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Color.fromARGB(
                                                        50, 255, 255, 255),
                                                  ),
                                                  Positioned(
                                                    top: 14.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    left: 14.0 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Icon(
                                                      Icons.brightness_1,
                                                      color: Colors.transparent,
                                                      size: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              width:
                                                  30 * prefs.getDouble('width'),
                                              child: Stack(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.message,
                                                    size: 24.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Color.fromARGB(
                                                        200, 255, 255, 255),
                                                  ),
                                                  Positioned(
                                                    top: 14.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    left: 14.0 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Icon(
                                                      Icons.brightness_1,
                                                      color: prefix0.mainColor,
                                                      size: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  List<DocumentSnapshot> _clients = [];
  bool _loadingClients = false;
  ScrollController _scrollController = ScrollController();
  List<String> newFriends = [];
  List<String> verifyIds = [];

  _getClients() async {
    if (mounted) {
      setState(() {
        _loadingClients = true;
      });
    }
    Query q = Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'client')
        .where('friendsMap.${prefs.getString('id')}', isEqualTo: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    if (querySnapshot.documents.length != 0) {
      _clients = querySnapshot.documents;
    }
    if (mounted) {
      setState(() {
        _loadingClients = false;
      });
    }
  }

  @override
  void initState() {
   
    super.initState();
    _getClients();
    widget.actualTrainer.friends.forEach((element) {
      if (element.friendAccepted == true) {
        verifyIds.add(element.friendId);
      }
    });
  }

  check() async {
    List<DocumentSnapshot> auxi = [];
    List<String> auuxx = [];
    int realNumber = 0;
    widget.actualTrainer.friends.forEach((element) {
      if (element.friendAccepted == true) {
        realNumber++;
      }
    });
    if (realNumber > verifyIds.length) {
      widget.actualTrainer.friends.forEach((element) async {
        bool flag = false;
        if (element.friendAccepted == true) {
          verifyIds.forEach((element1) {
            if (element1 == element.friendId) {
              flag = true;
            }
          });
          if (flag == false) {
            QuerySnapshot query = await Firestore.instance
                .collection('clientUsers')
                .where('id', isEqualTo: element.friendId)
                .getDocuments();
            bool flaggy = false;
            int index = 0;
            int finalIndex = -1;
            _clients.forEach((element2) {
              if (ClientUser(query.documents[0])
                          .firstName
                          .compareTo(ClientUser(element2).firstName) <
                      0 &&
                  flaggy == false) {
                flaggy = true;
                finalIndex = index;
              }
              index++;
            });
            if (flaggy == false && _clients.length < 7) {
              finalIndex = index;
            }
            if (finalIndex != -1) {
              bool ultimulFlag = false;
              _clients.forEach((elementx) {
                if (ClientUser(elementx).id == element.friendId) {
                  ultimulFlag = true;
                }
              });
              if (ultimulFlag == false) {
                if (mounted) {
                  setState(() {
                    _clients.insert(finalIndex, query.documents[0]);
                    verifyIds.add(element.friendId);
                  });
                }
              }
            }
          }
        }
      });
    }
    if (realNumber < verifyIds.length) {
      verifyIds.forEach((element1) async {
        bool flag = false;
        widget.actualTrainer.friends.forEach((element) {
          if (element1 == element.friendId) {
            flag = true;
          }
        });
        if (flag == false) {
          if (_clients
                  .where((element) => ClientUser(element).id == element1)
                  .toList()[0] !=
              null) {
            auuxx.add(element1);
            auxi.add(_clients
                .where((element) => ClientUser(element).id == element1)
                .toList()[0]);
          }
        }
      });

      auuxx.forEach((element) {
        verifyIds.remove(element);
      });

      setState(() {
        for (int i = 0; i < auxi.length; i++) {
          _clients.remove(auxi[i]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    listEdit = [];
    listGroupCounter = [];
    counter2 = 0;
    if (widget.actualTrainer.acceptedFriendship == true) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {'acceptedFriendship': FieldValue.delete()},
      );
    }
    if (widget.actualTrainer.newFriend == true && widget.index == 1) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {'newFriend': false},
      );
    }
    check();
    return widget.actualTrainer.friends
                .where((element) => element.friendAccepted == true)
                .length !=
            0
        ? Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                // List
                Container(
                    padding:
                        EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) =>
                          buildItem(context, _clients[index]),
                      itemCount: _clients.length,
                    )),
                // Loading
                Align(
                  alignment: Alignment.center,
                  child: _loadingClients
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  prefix0.mainColor),
                            ),
                          ),
                          color: backgroundColor,
                        )
                      : Container(),
                )
              ],
            ),
          )
        : Container(
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/contactsf1.svg',
                  width: 350.0 * prefs.getDouble('width'),
                  height: 200.0 * prefs.getDouble('height'),
                ),
                SizedBox(height: 16 * prefs.getDouble('height')),
                Text("No friends",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.75,
                        fontSize: 20 * prefs.getDouble('height'),
                        color: Colors.white)),
                SizedBox(height: 8 * prefs.getDouble('height')),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 32 * prefs.getDouble('width')),
                  width: 375 * prefs.getDouble('width'),
                  child: Text(
                    "You have a free contact request each day. Use it to interact with potential clients. You can also bring your existing clients into the app.",
                    style: TextStyle(
                        letterSpacing: 0.75,
                        fontSize: 13 * prefs.getDouble('height'),
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontFamily: 'Roboto'),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                )
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class DeletePermissionPopup extends PopupRoute<void> {
  DeletePermissionPopup({this.clientUser});
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
      DeletePermission(
        clientUser: clientUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission extends StatefulWidget {
  final ClientUser clientUser;

  DeletePermission({Key key, @required this.clientUser}) : super(key: key);

  @override
  State createState() => DeletePermissionState(clientUser: clientUser);
}

class DeletePermissionState extends State<DeletePermission> {
  final ClientUser clientUser;
  DeletePermissionState({Key key, @required this.clientUser});

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
                  "Are you sure you want to delete your friendship with ${clientUser.firstName} ${clientUser.lastName}?",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(120, 255, 255, 255),
                    fontSize: 12 * prefs.getDouble('height'),
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
                    borderRadius: BorderRadius.circular(90.0),
                    child: MaterialButton(
                      onPressed: () async {
                        await Firestore.instance
                            .collection('clientUsers')
                            .document(prefs.getString('id'))
                            .updateData(
                          {
                            'trainerMap.${clientUser.id}': FieldValue.delete(),
                            'friendsMap.${clientUser.id}': FieldValue.delete()
                          },
                        );

                        await Firestore.instance
                            .collection('clientUsers')
                            .document(clientUser.id)
                            .updateData(
                          {
                            'trainerMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Delete',
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
