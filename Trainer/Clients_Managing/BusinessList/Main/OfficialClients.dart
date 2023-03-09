import 'dart:async';
import 'dart:math';

import 'package:Bsharkr/Client/Client_Profile/Profile/time.dart';
import 'package:Bsharkr/Trainer/Client_Requests/Client_Profile/ClientProfileFinal.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/ManagingMeals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Chat/chatscreen.dart';
import 'package:Bsharkr/Trainer/IconSlide.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/models/clientUser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficialClients extends StatefulWidget {
  final int index;
  final TrainerUser actualTrainer;

  OfficialClients({Key key, this.actualTrainer, this.index}) : super(key: key);

  @override
  State createState() => OfficialClientsState();
}

class OfficialClientsState extends State<OfficialClients>
    with AutomaticKeepAliveClientMixin<OfficialClients> {
  List<int> listaGroupCounter = [];
  List<String> listaEdit = [];

  bool edit = false;
  int counter = 0;
  int numberNewMembers = 0;

  ClientUser initialClient;
  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();
  }
bool scheduleChanged = false;
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
                    null,),
              ),
            );
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
                      children: <Widget>[
                        SizedBox(
                          width: 30.0 * prefs.getDouble('width'),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: backgroundColor,
                          ),
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
                                      height: (60 * prefs.getDouble('height')),
                                      width: (60 * prefs.getDouble('height')),
                                      child: Center(
                                        child: Text(
                                          _clientUser.firstName[0],
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 35 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white),
                                        ),
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
                          width: 210 * prefs.getDouble('width'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 150 * prefs.getDouble('width'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  prefs.getDouble('height')),
                                        ),
                                        SizedBox(
                                          width: 4.0 * prefs.getDouble('width'),
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
                                                  prefs.getDouble('height')),
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
                                            fontSize:
                                                15 * prefs.getDouble('height'),
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
                                            fontSize:
                                                15 * prefs.getDouble('height'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0 * prefs.getDouble('width'),
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
                                          width: 5.0 * prefs.getDouble('width'),
                                        ),
                                        _clientUser.gender != 'none'
                                            ? Row(
                                                children: <Widget>[
                                                  Text(
                                                    _clientUser.gender == 'male'
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
                                                      prefs.getDouble('height'),
                                                  color: Color.fromARGB(
                                                      50, 255, 255, 255),
                                                ),
                                                Positioned(
                                                  top: 14.0 *
                                                      prefs.getDouble('height'),
                                                  left: 14.0 *
                                                      prefs.getDouble('width'),
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
                                                      prefs.getDouble('height'),
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255),
                                                ),
                                                Positioned(
                                                  top: 14.0 *
                                                      prefs.getDouble('height'),
                                                  left: 14.0 *
                                                      prefs.getDouble('width'),
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
        .where('trainersMap.${prefs.getString('id')}', isEqualTo: true);

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

  check() async {
    List<DocumentSnapshot> auxi = [];
    List<String> auuxx = [];
    int realNumber = 0;
    widget.actualTrainer.clients.forEach((element) {
      if (element.clientAccepted == true) {
        realNumber++;
      }
    });
    if (realNumber > verifyIds.length) {
      widget.actualTrainer.clients.forEach((element) async {
        bool flag = false;
        if (element.clientAccepted == true) {
          verifyIds.forEach((element1) {
            if (element1 == element.clientId) {
              flag = true;
            }
          });
          if (flag == false) {
            QuerySnapshot query = await Firestore.instance
                .collection('clientUsers')
                .where('id', isEqualTo: element.clientId)
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
                if (ClientUser(elementx).id == element.clientId) {
                  ultimulFlag = true;
                }
              });
              if (ultimulFlag == false) {
                if (mounted) {
                  setState(() {
                    _clients.insert(finalIndex, query.documents[0]);
                    verifyIds.add(element.clientId);
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
        widget.actualTrainer.clients.forEach((element) {
          if (element1 == element.clientId) {
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

  ClientUser actualClient;

  bool restart = false;

  @override
  void initState() {
   
    super.initState();
    _getClients();

    widget.actualTrainer.clients.forEach((element) {
      if (element.clientAccepted == true) {
        verifyIds.add(element.clientId);
      }
    });

    
  }

  @override
  Widget build(BuildContext context) {
    listaEdit = [];
    listaGroupCounter = [];
    numberNewMembers = 0;
    if (widget.actualTrainer.newClient == true && widget.index == 0) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {'newClient': false},
      );
    }
    check();
    return widget.actualTrainer.clients
                .where((element) => element.clientAccepted == true)
                .length !=
            0
        ? Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: <Widget>[
                // List
                ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Slidable(
                      actionExtentRatio: 0.20,
                      delegate: SlidableDrawerDelegate(),
                      child: buildItem(context, _clients[index]),
                      secondaryActions: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.all(10 * prefs.getDouble('height')),
                          child: IconSlideActionModifiedRight(
                            icon: Icons.local_dining,
                            color: mainColor,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MyPopupRouteMeals(
                                    clientUser: ClientUser(_clients[index]),
                                  ));
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.all(10 * prefs.getDouble('height')),
                          child: IconSlideActionModifiedRight(
                            icon: Icons.assignment,
                            color: mainColor,
                            onTap: () {
                              Navigator.push(
                                      context,
                                      ManagingSchedule(
                                          clientUser:
                                              ClientUser(_clients[index]),
                                          imTrainer: widget.actualTrainer,
                                          parent: this))
                                  .whenComplete(() => setState(() {}))
                                  .catchError((err) {
                                setState(() {});
                              });
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.all(10 * prefs.getDouble('height')),
                          child: IconSlideActionModifiedRight(
                            icon: Icons.cancel,
                            color: Colors.red,
                            onTap: () {
                              actualClient = ClientUser(_clients[index]);
                              setState(() {
                                Navigator.push(
                                    context,
                                    DeletePermissionPopup(
                                      clientUser: actualClient,
                                    ));
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: _clients.length,
                ),

                // Loading
                Positioned(
                  child: _loadingClients
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(mainColor),
                            ),
                          ),
                          color: backgroundColor,
                        )
                      : Container(),
                ),
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
                Text("No clients",
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
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

        if (details.globalPosition.dx < positionStar1.dx) {
          _updateRating(0);
        } else if (details.globalPosition.dx > positionStar1.dx &&
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
            onTap: () => _updateRating(1),
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
                  "Are you sure you want to stop your training partnership with ${clientUser.firstName} ${clientUser.lastName}? The friendship will be deleted as well.",
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
                        Firestore.instance
                            .collection('clientUsers')
                            .document(prefs.getString('id'))
                            .updateData(
                          {
                            'trainerMap.${clientUser.id}': FieldValue.delete(),
                            'friendsMap.${clientUser.id}': FieldValue.delete()
                          },
                        );

                        Firestore.instance
                            .collection('clientUsers')
                            .document(clientUser.id)
                            .updateData(
                          {
                            'trainersMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );

                        prefs.setInt('clientsCounter',
                            (prefs.getInt('clientsCounter') - 1));
                        List<String> aux = [];
                        prefs
                            .getStringList('previousClients')
                            .forEach((element) {
                          if (element != clientUser.id) {
                            aux.add(element);
                          }
                        });
                        prefs.setStringList('previousClients', aux);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          Vote(
                            clientUser: clientUser,
                          ),
                        );
                      },
                      child: Text(
                        'Stop training',
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

  CustomDialogVoteState({
    this.actualClient,
  });
  String reviewText;
  int localAttribute1 = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * prefs.getDouble('width')),
              height: 476 * prefs.getDouble('height'),
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
                      "Rate the collaboration with your client!",
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
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () async {
                            if (reviewText != null) {
                              if (actualClient.reviewsMap.length < 5) {
                                Firestore.instance
                                    .collection('clientUsers')
                                    .document(actualClient.id)
                                    .updateData(
                                  {
                                    'votesMap.${actualClient.votesMap.length + 1}':
                                        localAttribute1,
                                    'reviewsMap.${actualClient.reviewsMap.length + 1}':
                                        reviewText
                                  },
                                );
                              } else {
                                Firestore.instance
                                    .collection('clientUsers')
                                    .document(actualClient.id)
                                    .updateData(
                                  {
                                    'votesMap.1': actualClient.votesMap[1].vote,
                                    'reviewsMap.1':
                                        actualClient.reviewsMap[1].review,
                                    'votesMap.2': actualClient.votesMap[2].vote,
                                    'reviewsMap.2':
                                        actualClient.reviewsMap[2].review,
                                    'votesMap.3': actualClient.votesMap[3].vote,
                                    'reviewsMap.3':
                                        actualClient.reviewsMap[3].review,
                                    'votesMap.4': actualClient.votesMap[4].vote,
                                    'reviewsMap.4':
                                        actualClient.reviewsMap[4].review,
                                    'votesMap.5': localAttribute1,
                                    'reviewsMap.5': reviewText,
                                  },
                                );
                              }
                            } else {
                              if (actualClient.reviewsMap.length < 5) {
                                Firestore.instance
                                    .collection('clientUsers')
                                    .document(actualClient.id)
                                    .updateData(
                                  {
                                    'votesMap.${actualClient.votesMap.length + 1}':
                                        localAttribute1,
                                    'reviewsMap.${actualClient.reviewsMap.length + 1}':
                                        null
                                  },
                                );
                              } else {
                                Firestore.instance
                                    .collection('clientUsers')
                                    .document(actualClient.id)
                                    .updateData(
                                  {
                                    'votesMap.1': actualClient.votesMap[1].vote,
                                    'reviewsMap.1':
                                        actualClient.reviewsMap[1].review,
                                    'votesMap.2': actualClient.votesMap[2].vote,
                                    'reviewsMap.2':
                                        actualClient.reviewsMap[2].review,
                                    'votesMap.3': actualClient.votesMap[3].vote,
                                    'reviewsMap.3':
                                        actualClient.reviewsMap[3].review,
                                    'votesMap.4': actualClient.votesMap[4].vote,
                                    'reviewsMap.4':
                                        actualClient.reviewsMap[4].review,
                                    'votesMap.5': localAttribute1,
                                    'reviewsMap.5': null,
                                  },
                                );
                              }
                            }
                            Navigator.of(context).pop();
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
    );
  }
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

class ManagingSchedule extends PopupRoute<void> {
  ManagingSchedule({
    this.clientUser,
    this.imTrainer,
    this.parent,
  });
  OfficialClientsState parent;
  TrainerUser imTrainer;
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
      ManagingS(client: clientUser, imTrainer: imTrainer, parent: parent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ManagingS extends StatefulWidget {
  final ClientUser client;
  TrainerUser imTrainer;
  OfficialClientsState parent;
  ManagingS({Key key, @required this.client, this.imTrainer, this.parent})
      : super(key: key);

  @override
  State createState() => ManagingSState(
        client: client,
      );
}

class ManagingSState extends State<ManagingS> {
  List<bool> isSelected = [true, false];

  String hinttText = "Scrie";
  Image image;
  ClientUser client;
  var selected;
  String hintName, hintStreet, hintSector;
  TrainerUser imTrainer;
  ManagingSState({@required this.client, this.image});
  bool scheduleChanged = false;
  int currentPage = 0;
  bool modified = false;
  var db = Firestore.instance;
  var batch;
  bool saveChanges = false;

  @override
  void initState() {
   
    super.initState();
    batch = db.batch();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView(
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          children: <Widget>[
            FirstPage(
              client: widget.client,
              scheduleChanged: scheduleChanged,
              parent: this,
              imTrainer: widget.imTrainer,
              mainParent: widget.parent,
            ),
            SecondPage(
              client: widget.client,
              scheduleChanged: scheduleChanged,
              parent: this,
              imTrainer: widget.imTrainer,
              mainParent: widget.parent,
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 95.0 * prefs.getDouble('height')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 0 ? mainColor : secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 50 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 10 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 1 ? mainColor : secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 50 * prefs.getDouble('width'),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              widget.parent.setState(() {
                widget.parent.scheduleChanged = null;
          
              });
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              height: 140 * prefs.getDouble('height'),
              width: double.infinity,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
              if (scheduleChanged == true) {
                await Firestore.instance
                    .collection('clientUsers')
                    .document(widget.client.id)
                    .updateData(
                  {
                    'scheduleUpdated': true,
                  },
                );

                batch.commit();
                QuerySnapshot q = await Firestore.instance
                    .collection('clientUsers')
                    .where('id', isEqualTo: widget.client.id)
                    .getDocuments();
                Firestore.instance
                    .collection('updatedSchedule')
                    .document(client.id)
                    .setData(
                  {
                    'idFrom': prefs.getString('id'),
                    'idTo': client.id,
                    'pushToken': client.pushToken
                  },
                );

                widget.parent.setState(() {
                  int index = 0;
                  int finalIndex = -1;
                  widget.parent._clients.forEach((element) { 
                    if(ClientUser(element).id == ClientUser(q.documents[0]).id) {
                     finalIndex = index;
                    } index++;
                  });
                  if(finalIndex != -1) {
                    widget.parent._clients.removeWhere((element) => ClientUser(element).id == ClientUser(q.documents[0]).id);
                    widget.parent._clients.insert(finalIndex, q.documents[0]);
                  }
                });
              }
              Navigator.of(context).pop();
            },
            child: Container(
              
                width: double.infinity,
                height: 90 * prefs.getDouble('height'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10 * prefs.getDouble('height'),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        scheduleChanged == false
                            ? "Close"
                            : "Save changes & notify your client",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 17 * prefs.getDouble('height'),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        )
      ],
    );
  }
}

class FirstPage extends StatefulWidget {
  TrainerUser imTrainer;
  ManagingSState parent;
  ClientUser client;
  OfficialClientsState mainParent;
  bool scheduleChanged;
  FirstPage(
      {@required this.client,
      @required this.scheduleChanged,
      @required this.parent,
      this.imTrainer,
      this.mainParent});
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  ClientUser client;
  ClientUser clientChanged;
  bool scheduleChanged = false;
  String locationName;
  String locationDistrict;
  String locationWebsite;
  String locationStreet;
  String gymWebsite;
  var selected;

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (client != null) {
      widget.client = client;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 140 * prefs.getDouble('height'),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 530 * prefs.getDouble('height'),
              width: 310 * prefs.getDouble('width'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff3E3E45)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10 * prefs.getDouble('height'),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/schedule1f1.svg',
                      width: 250.0 * prefs.getDouble('width'),
                      height: 130.0 * prefs.getDouble('height'),
                    ),
                  ),
                  SizedBox(
                    height: 15 * prefs.getDouble('height'),
                  ),
                  Text(
                    widget.client.firstName + " " + widget.client.lastName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 14 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        15 * prefs.getDouble('width'),
                        15 * prefs.getDouble('height'),
                        5 * prefs.getDouble('width'),
                        0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 330 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 330 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day1
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day1
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day1
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day1
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day1 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day1 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day1 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day1 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day1 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 1,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day1
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day1
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day1 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day1 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day2
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day2
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day2
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day2
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day2 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day2 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day2 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day2 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day2 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 2,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day2
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day2
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day2 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day2 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day3
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day3
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day3
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day3
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day3 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day3 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day3 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day3 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day3 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 3,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day3
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day3
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day3 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day3 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day4
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day4
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day4
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day4
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day4 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day4 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day4 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day4 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day4 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 4,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day4
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day4
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day4 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day4 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day5
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day5
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day5
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day5
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day5 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day5 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day5 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day5 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day5 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 5,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day5
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day5
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day5 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day5 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day6
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day6
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day6
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day6
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day6 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day6 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day6 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day6 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day6 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 6,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day6
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day6
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day6 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day6 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day7
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day7
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day7
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day7
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day7 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day7 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day7 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day7 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day7 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 7,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day7
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day7
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day7 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day7 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  TrainerUser imTrainer;
  ManagingSState parent;
  ClientUser client;
  OfficialClientsState mainParent;
  bool scheduleChanged;
  SecondPage(
      {@required this.client,
      @required this.scheduleChanged,
      @required this.parent,
      this.imTrainer,
      this.mainParent});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with WidgetsBindingObserver {
  ClientUser client;
  bool scheduleChanged = false;
  String locationName;
  String locationDistrict;
  String locationWebsite;
  String locationStreet;
  String gymWebsite;
  var selected;
  @override
  Widget build(BuildContext context) {
    if (client != null) {
      widget.client = client;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 140 * prefs.getDouble('height'),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 530 * prefs.getDouble('height'),
              width: 310 * prefs.getDouble('width'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff3E3E45)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10 * prefs.getDouble('height'),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/scheduleSecondWeek.svg',
                      width: 250.0 * prefs.getDouble('width'),
                      height: 130.0 * prefs.getDouble('height'),
                    ),
                  ),
                  SizedBox(
                    height: 15 * prefs.getDouble('height'),
                  ),
                  Text(
                    widget.client.firstName + " " + widget.client.lastName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 14 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        15 * prefs.getDouble('width'),
                        15 * prefs.getDouble('height'),
                        15 * prefs.getDouble('width'),
                        0),
                    width: 300 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 330 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 330 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day1
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day1
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day1
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day1
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day1 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day8 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day1 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day1 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day8 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 8,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day1
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day1
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day8 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day1 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day2
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day2
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day2
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day2
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day2 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day9 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day2 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day2 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day9 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 9,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day2
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day2
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day9 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day2 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day3
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day3
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day3
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day3
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day3 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day10 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day3 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day3 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day10 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 10,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day3
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day3
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day10 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day3 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day4
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day4
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day4
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day4
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day4 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day11 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day4 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day4 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day11 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 11,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day4
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day4
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day11 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day4 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day5
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day5
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day5
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day5
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day5 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day12 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day5 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day5 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day12 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 12,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day5
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day5
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day12 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day5 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day6
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day6
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day6
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day6
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day6 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day13 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day6 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day6 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day13 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 13,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day6
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day6
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day13 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day6 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day7
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day7
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day7
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day7
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day7 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day14 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day7 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day7 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day14 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 14,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day7
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day7
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day14 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day7 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        ],
      ),
    );
  }
}

class DetailsPopUp2 extends PopupRoute<void> {
  DetailsPopUp2(
      {this.parent,
      this.trainerUser,
      this.day,
      this.client,
      this.index,
      this.mainParent,
      this.parent1});
  OfficialClientsState mainParent;
  final int index;
  final ClientUser client;
  final String day;
  final _FirstPageState parent;
  final _SecondPageState parent1;

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
      DetailsPage2(
          trainer: trainerUser,
          parent: parent,
          day: day,
          client: client,
          index: index,
          mainParent: mainParent,
          parent1: parent1);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPopUp3 extends PopupRoute<void> {
  DetailsPopUp3(
      {this.parent,
      this.trainerUser,
      this.day,
      this.locationName,
      this.locationStreet,
      this.client,
      this.index,
      this.mainParent,
      this.parent1});
  OfficialClientsState mainParent;
  final _SecondPageState parent1;
  final int index;
  final ClientUser client;
  final String locationName;
  final String locationStreet;
  final String day;
  final _FirstPageState parent;

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
      DetailsPage3(
          trainer: trainerUser,
          parent: parent,
          day: day,
          locationName: locationName,
          locationStreet: locationStreet,
          client: client,
          index: index,
          mainParent: mainParent,
          parent1: parent1);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage3 extends StatefulWidget {
  OfficialClientsState mainParent;
  final _SecondPageState parent1;
  final String locationName;
  final String locationStreet;
  final _FirstPageState parent;
  final TrainerUser trainer;
  final String day;
  final ClientUser client;
  final int index;
  DetailsPage3(
      {Key key,
      @required this.trainer,
      @required this.parent,
      this.day,
      this.locationName,
      this.locationStreet,
      this.client,
      @required this.index,
      this.mainParent,
      this.parent1})
      : super(key: key);

  @override
  State createState() => DetailsPage3State(index: index);
}

class DetailsPage3State extends State<DetailsPage3> {
  String hinttText = "Scrie";
  Image image;
  final int index;
  String hintName, hintStreet, hintSector;
  DetailsPage3State({Key key, @required this.index});
  @override
  void initState() {
   
    super.initState();
  }

  var selected;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    return showTimePicker1(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

  var transitionFinal2;
  var transitionFinal2End;

  @override
  Widget build(BuildContext context) {
    String hour1, hour2, minute1, minute2;

    if (transitionFinal2 != null) {
      if (transitionFinal2.hour < 10) {
        hour1 = "0" + transitionFinal2.hour.toString();
      } else {
        hour1 = transitionFinal2.hour.toString();
      }

      if (transitionFinal2.minute < 10) {
        minute1 = "0" + transitionFinal2.minute.toString();
      } else {
        minute1 = transitionFinal2.minute.toString();
      }
    }
    if (transitionFinal2End != null) {
      if (transitionFinal2End.hour < 10) {
        hour2 = "0" + transitionFinal2End.hour.toString();
      } else {
        hour2 = transitionFinal2End.hour.toString();
      }

      if (transitionFinal2End.minute < 10) {
        minute2 = "0" + transitionFinal2End.minute.toString();
      } else {
        minute2 = transitionFinal2End.minute.toString();
      }
    }

    if (hour1 == null && minute1 == null) {
      if (index == 1 && widget.client.checkFirstSchedule.day1 == 'true') {
        if (widget.client.scheduleFirstWeek.day1.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day1.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day1.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day1.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day1.toDate().minute.toString();
        }
      }

      if (index == 2 && widget.client.checkFirstSchedule.day2 == 'true') {
        if (widget.client.scheduleFirstWeek.day2.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day2.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day2.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day2.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day2.toDate().minute.toString();
        }
      }

      if (index == 3 && widget.client.checkFirstSchedule.day3 == 'true') {
        if (widget.client.scheduleFirstWeek.day3.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day3.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day3.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day3.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day3.toDate().minute.toString();
        }
      }

      if (index == 4 && widget.client.checkFirstSchedule.day4 == 'true') {
        if (widget.client.scheduleFirstWeek.day4.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day4.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day4.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day4.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day4.toDate().minute.toString();
        }
      }

      if (index == 5 && widget.client.checkFirstSchedule.day5 == 'true') {
        if (widget.client.scheduleFirstWeek.day5.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day5.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day5.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day5.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day5.toDate().minute.toString();
        }
      }

      if (index == 6 && widget.client.checkFirstSchedule.day6 == 'true') {
        if (widget.client.scheduleFirstWeek.day6.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day6.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day6.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day6.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day6.toDate().minute.toString();
        }
      }

      if (index == 7 && widget.client.checkFirstSchedule.day7 == 'true') {
        if (widget.client.scheduleFirstWeek.day7.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day7.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day7.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day7.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day7.toDate().minute.toString();
        }
      }

      if (index == 8 && widget.client.checkSecondSchedule.day1 == 'true') {
        if (widget.client.scheduleSecondWeek.day1.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day1.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day1.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day1.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day1.toDate().minute.toString();
        }
      }

      if (index == 9 && widget.client.checkSecondSchedule.day2 == 'true') {
        if (widget.client.scheduleSecondWeek.day2.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day2.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day2.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day2.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day2.toDate().minute.toString();
        }
      }

      if (index == 10 && widget.client.checkSecondSchedule.day3 == 'true') {
        if (widget.client.scheduleSecondWeek.day3.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day3.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day3.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day3.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day3.toDate().minute.toString();
        }
      }

      if (index == 11 && widget.client.checkSecondSchedule.day4 == 'true') {
        if (widget.client.scheduleSecondWeek.day4.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day4.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day4.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day4.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day4.toDate().minute.toString();
        }
      }

      if (index == 12 && widget.client.checkSecondSchedule.day5 == 'true') {
        if (widget.client.scheduleSecondWeek.day5.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day5.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day5.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day5.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day5.toDate().minute.toString();
        }
      }

      if (index == 13 && widget.client.checkSecondSchedule.day6 == 'true') {
        if (widget.client.scheduleSecondWeek.day6.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day6.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day6.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day6.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day6.toDate().minute.toString();
        }
      }

      if (index == 14 && widget.client.checkSecondSchedule.day7 == 'true') {
        if (widget.client.scheduleSecondWeek.day7.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day7.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day7.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day7.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day7.toDate().minute.toString();
        }
      }
    }
    if (hour2 == null && minute2 == null) {
      if (index == 1 && widget.client.checkFirstSchedule.day1 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day1.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day1.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day1.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day1
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day1
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 2 && widget.client.checkFirstSchedule.day2 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day2.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day2.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day2.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day2
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day2
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 3 && widget.client.checkFirstSchedule.day3 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day3.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day3.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day3.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day3
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day3
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 4 && widget.client.checkFirstSchedule.day4 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day4.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day4.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day4.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day4
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day4
              .toDate()
              .minute
              .toString();
        }
      }
      if (index == 5 && widget.client.checkFirstSchedule.day5 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day5.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day5.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day5.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day5
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day5
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 6 && widget.client.checkFirstSchedule.day6 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day6.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day6.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day6.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day6
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day6
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 7 && widget.client.checkFirstSchedule.day7 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day7.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day7.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day7.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day7
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day7
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 8 && widget.client.checkSecondSchedule.day1 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day1.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day1.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day1.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day1
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day1
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 9 && widget.client.checkSecondSchedule.day2 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day2.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day2.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day2.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day2
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day2
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 10 && widget.client.checkSecondSchedule.day3 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day3.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day3.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day3.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day3
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day3
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 11 && widget.client.checkSecondSchedule.day4 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day4.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day4.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day4.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day4
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day4
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 12 && widget.client.checkSecondSchedule.day5 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day5.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day5.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day5.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day5
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day5
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 13 && widget.client.checkSecondSchedule.day6 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day6.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day6.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day6.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day6
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day6
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 14 && widget.client.checkSecondSchedule.day7 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day7.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day7.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day7.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day7
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day7
              .toDate()
              .minute
              .toString();
        }
      }
    }
    return Center(
      child: Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: 0 * prefs.getDouble('width')),
          backgroundColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor,
              ),
              width: 310 * prefs.getDouble('width'),
              height: 210 * prefs.getDouble('height'),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16 * prefs.getDouble('height'),
                    horizontal: 12 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.day,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13 * prefs.getDouble('height'),
                                letterSpacing: -0.066,
                                fontFamily: 'Roboto')),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: (hour1 == null && minute1 == null)
                                    ? "hh:mm"
                                    : (hour1 + ":" + minute1),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13 * prefs.getDouble('height'),
                                    letterSpacing: -0.066,
                                    fontFamily: 'Roboto'),
                              ),
                              TextSpan(
                                  text: " - ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.066,
                                      fontFamily: 'Roboto')),
                              TextSpan(
                                  text: (hour2 == null && minute2 == null)
                                      ? "hh:mm"
                                      : (hour2 + ":" + minute2),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.066,
                                      fontFamily: 'Roboto')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Workout with ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.078),
                          ),
                          TextSpan(
                            text:
                                "${widget.trainer.firstName} ${widget.trainer.lastName}",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.078),
                          ),
                          TextSpan(
                            text:
                                " - at ${widget.locationName}, ${widget.locationStreet}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.078),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 130.0 * prefs.getDouble('width'),
                          height: 30.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                selected = await _selectTime(context);
                                DateTime transition;
                                if (widget.client.scheduleFirstWeek.day1
                                    is Timestamp) {
                                  Timestamp transitionFINAL =
                                      widget.client.scheduleFirstWeek.day1;
                                  transition = transitionFINAL.toDate();
                                } else {
                                  transition = widget
                                      .client.scheduleFirstWeek.day1
                                      .toDate();
                                }
                                var transitionFinal1 = transition.subtract(
                                  Duration(
                                      hours: transition.hour,
                                      minutes: transition.minute),
                                );
                                transitionFinal2 = transitionFinal1.add(
                                  Duration(
                                      days: index - 1,
                                      hours: selected.hour,
                                      minutes: selected.minute),
                                );
                                setState(
                                  () {},
                                );
                              },
                              child: Text(
                                'Set starting hour',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 12.0 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 130.0 * prefs.getDouble('width'),
                          height: 30.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                selected = await _selectTime(context);
                                DateTime transition;
                                if (widget.client.scheduleFirstEndWeek.day1
                                    is Timestamp) {
                                  Timestamp transitionFINAL =
                                      widget.client.scheduleFirstEndWeek.day1;
                                  transition = transitionFINAL.toDate();
                                } else {
                                  transition = widget
                                      .client.scheduleFirstEndWeek.day1
                                      .toDate();
                                }

                                var transitionFinal1 = transition.subtract(
                                  Duration(
                                      hours: transition.hour,
                                      minutes: transition.minute),
                                );
                                transitionFinal2End = transitionFinal1.add(
                                  Duration(
                                      days: index - 1,
                                      hours: selected.hour,
                                      minutes: selected.minute),
                                );

                                setState(
                                  () {},
                                );
                              },
                              child: Text(
                                'Set end hour',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 12.0 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Container(
                      height: 1.0 * prefs.getDouble('height'),
                      color: Color(0xff57575E),
                    ),
                    SizedBox(height: 8 * prefs.getDouble('height')),
                    InkWell(
                      onTap: () async {
                        if (transitionFinal2 != null &&
                            transitionFinal2End != null) {
                          bool friendsOrNot = false;
                          widget.trainer.clients.forEach((element) {
                            if (element.clientId == widget.client.id) {
                              friendsOrNot = true;
                            }
                          });
                          if (friendsOrNot == true) {
                            int miniIndex = 0;
                            if (widget.index > 7) {
                              miniIndex = widget.index - 7;

                              widget.parent1.widget.parent.batch.updateData(
                                widget.parent1.widget.parent.db
                                    .collection('clientUsers')
                                    .document(widget.client.id),
                                {
                                  'scheduleHour2End.$miniIndex':
                                      transitionFinal2End,
                                  'scheduleHour2.$miniIndex': transitionFinal2,
                                  'scheduleBool2.$miniIndex': 'true',
                                  'trainingSessionLocationName.$index':
                                      widget.locationName,
                                  'trainingSessionLocationStreet.$index':
                                      widget.locationStreet,
                                  'trainingSessionTrainerName.$index':
                                      "${widget.trainer.firstName} ${widget.trainer.lastName}",
                                  'trainingSessionTrainerId.$index':
                                      widget.trainer.id,
                                },
                              );

                              if (index == 8) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day1 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day8 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day8 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day8 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day8 = widget.trainer.id;
                              }

                              if (index == 9) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day2 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day9 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day9 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day9 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day9 = widget.trainer.id;
                              }

                              if (index == 10) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day3 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day10 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day10 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day10 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day10 = widget.trainer.id;
                              }

                              if (index == 11) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day4 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day11 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day11 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day11 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day11 = widget.trainer.id;
                              }

                              if (index == 12) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day5 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day12 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day12 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day12 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day12 = widget.trainer.id;
                              }

                               if (index == 13) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day6 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day13 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day13 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day13 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day13 = widget.trainer.id;
                              }

                              if (index == 14) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client.scheduleSecondEndWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day7 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day14 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day14 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day14 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day14 = widget.trainer.id;
                              }
                            } else {
                              widget.parent.widget.parent.batch.updateData(
                                widget.parent.widget.parent.db
                                    .collection('clientUsers')
                                    .document(widget.client.id),
                                {
                                  'scheduleHour1End.$index':
                                      transitionFinal2End,
                                  'scheduleHour1.$index': transitionFinal2,
                                  'scheduleBool1.$index': 'true',
                                  'trainingSessionLocationName.$index':
                                      widget.locationName,
                                  'trainingSessionLocationStreet.$index':
                                      widget.locationStreet,
                                  'trainingSessionTrainerName.$index':
                                      "${widget.trainer.firstName} ${widget.trainer.lastName}",
                                  'trainingSessionTrainerId.$index':
                                      widget.trainer.id,
                                },
                              );

                              if (index == 1) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent.widget.client.checkFirstSchedule
                                    .day1 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day1 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day1 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day1 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day1 = widget.trainer.id;
                              }

                              if (index == 2) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent.widget.client.checkFirstSchedule
                                    .day2 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day2 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day2 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day2 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day2 = widget.trainer.id;
                              }

                              if (index == 3) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent.widget.client.checkFirstSchedule
                                    .day3 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day3 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day3 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day3 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day3 = widget.trainer.id;
                              }

                              if (index == 4) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2End);
                                
                                widget.parent.widget.client.checkFirstSchedule
                                    .day4 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day4 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day4 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day4 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day4 = widget.trainer.id;
                              }

                              if (index == 5) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2End);
                              
                                widget.parent.widget.client.checkFirstSchedule
                                    .day5 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day5 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day5 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day5 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day5 = widget.trainer.id;
                              }

                              if (index == 6) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2End);
                               
                                widget.parent.widget.client.checkFirstSchedule
                                    .day6 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day6 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day6 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day6 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day6 = widget.trainer.id;
                              }

                              if (index == 7) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2End);
                               
                                widget.parent.widget.client.checkFirstSchedule
                                    .day7 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day7 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day7 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day7 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day7 = widget.trainer.id;
                              }
                            }

                            widget.mainParent.setState(() {
                              widget.mainParent.scheduleChanged = true;

                              if (widget.parent != null) {
                                widget.parent.widget.parent.setState(() {
                                  widget.parent.widget.parent.scheduleChanged =
                                      true;

                                  widget.parent.setState(() {});
                                });
                              }
                              if (widget.parent1 != null) {
                                widget.parent1.widget.parent.setState(() {
                                  widget.parent1.widget.parent.scheduleChanged =
                                      true;

                                  widget.parent1.setState(() {});
                                });
                              }
                            });

                            Navigator.of(context).pop();
                          }
                        } else {
                          Navigator.push(context, PopUpMissingRoute());
                        }
                      },
                      child: Container(
                        height: 32 * prefs.getDouble('height'),
                        child: Center(
                            child: Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        )),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}

class DetailsPage2 extends StatefulWidget {
  OfficialClientsState mainParent;
  final _SecondPageState parent1;
  final String day;
  final _FirstPageState parent;
  final TrainerUser trainer;
  final ClientUser client;
  final int index;
  DetailsPage2(
      {Key key,
      @required this.trainer,
      @required this.parent,
      this.day,
      this.client,
      this.index,
      this.mainParent,
      this.parent1})
      : super(key: key);

  @override
  State createState() => DetailsPage2State();
}

class DetailsPage2State extends State<DetailsPage2> {
  String hinttText = "Scrie";
  Image image;

  String hintName, hintStreet, hintSector;

  @override
  void initState() {
   
    super.initState();
  }

  Widget buildItem(index) {
    return InkWell(
      onTap: () {
        if (widget.parent != null) {
          widget.parent.setState(() {
            if (index == 0) {
              widget.parent.locationName = widget.trainer.gym1;
              widget.parent.locationDistrict = widget.trainer.gym1Sector;
              widget.parent.locationStreet = widget.trainer.gym1Street;
              widget.parent.gymWebsite = widget.trainer.gym1Website;
            }
            if (index == 1) {
              widget.parent.locationName = widget.trainer.gym2;
              widget.parent.locationDistrict = widget.trainer.gym2Sector;
              widget.parent.locationStreet = widget.trainer.gym2Street;

              widget.parent.gymWebsite = widget.trainer.gym2Website;
            }
            if (index == 2) {
              widget.parent.locationName = widget.trainer.gym3;
              widget.parent.locationDistrict = widget.trainer.gym3Sector;
              widget.parent.locationStreet = widget.trainer.gym3Street;
              widget.parent.gymWebsite = widget.trainer.gym3Website;
            }
            if (index == 3) {
              widget.parent.locationName = widget.trainer.gym4;
              widget.parent.locationDistrict = widget.trainer.gym4Sector;
              widget.parent.locationStreet = widget.trainer.gym4Street;
              widget.parent.gymWebsite = widget.trainer.gym4Website;
            }
            Navigator.of(context).pop();

            Navigator.push(
                context,
                DetailsPopUp3(
                    index: widget.index,
                    trainerUser: widget.trainer,
                    day: widget.day,
                    locationName: widget.parent.locationName,
                    locationStreet: widget.parent.locationStreet,
                    client: widget.client,
                    parent: widget.parent,
                    mainParent: widget.mainParent,
                    parent1: widget.parent1));
          });
        }
        if (widget.parent1 != null) {
          widget.parent1.setState(() {
            if (index == 0) {
              widget.parent1.locationName = widget.trainer.gym1;
              widget.parent1.locationDistrict = widget.trainer.gym1Sector;
              widget.parent1.locationStreet = widget.trainer.gym1Street;
              widget.parent1.gymWebsite = widget.trainer.gym1Website;
            }
            if (index == 1) {
              widget.parent1.locationName = widget.trainer.gym2;
              widget.parent1.locationDistrict = widget.trainer.gym2Sector;
              widget.parent1.locationStreet = widget.trainer.gym2Street;

              widget.parent1.gymWebsite = widget.trainer.gym2Website;
            }
            if (index == 2) {
              widget.parent1.locationName = widget.trainer.gym3;
              widget.parent1.locationDistrict = widget.trainer.gym3Sector;
              widget.parent1.locationStreet = widget.trainer.gym3Street;
              widget.parent1.gymWebsite = widget.trainer.gym3Website;
            }
            if (index == 3) {
              widget.parent1.locationName = widget.trainer.gym4;
              widget.parent1.locationDistrict = widget.trainer.gym4Sector;
              widget.parent1.locationStreet = widget.trainer.gym4Street;
              widget.parent1.gymWebsite = widget.trainer.gym4Website;
            }
            Navigator.of(context).pop();

            Navigator.push(
                context,
                DetailsPopUp3(
                    index: widget.index,
                    trainerUser: widget.trainer,
                    day: widget.day,
                    locationName: widget.parent1.locationName,
                    locationStreet: widget.parent1.locationStreet,
                    client: widget.client,
                    parent: widget.parent,
                    mainParent: widget.mainParent,
                    parent1: widget.parent1));
          });
        }
      },
      child: Container(
        height: 61 * prefs.getDouble('height'),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60 * prefs.getDouble('height'),
              child: Center(
                  child: Text(
                index == 0
                    ? widget.trainer.gym1
                    : index == 1
                        ? widget.trainer.gym2
                        : index == 2
                            ? widget.trainer.gym3
                            : widget.trainer.gym4,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13 * prefs.getDouble('height'),
                  color: Color.fromARGB(200, 255, 255, 255),
                  letterSpacing: -0.078,
                ),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              height: 1.0 * prefs.getDouble('height'),
              color: Color(0xff57575E),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int multiplier = 0;
    if (widget.trainer.gym1 != null && widget.trainer.gym1 != "") {
      multiplier += 1;
    }
    if (widget.trainer.gym2 != null && widget.trainer.gym2 != "") {
      multiplier += 1;
    }
    if (widget.trainer.gym3 != null && widget.trainer.gym3 != "") {
      multiplier += 1;
    }
    if (widget.trainer.gym4 != null && widget.trainer.gym4 != "") {
      multiplier += 1;
    }
    return Center(
      child: Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: 0 * prefs.getDouble('width')),
        backgroundColor: Colors.transparent,
        child: multiplier != 0
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff3E3E45)),
                width: 310 * prefs.getDouble('width'),
                height: ((multiplier * 61 + 156) * prefs.getDouble('height')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 82 * prefs.getDouble('height'),
                      child: Center(
                        child: Text(
                          "Select the gym",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 20 * prefs.getDouble('height'),
                              letterSpacing: 0.75,
                              color: Color.fromARGB(200, 255, 255, 255)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 1.0 * prefs.getDouble('height'),
                      color: Color(0xff57575E),
                    ),
                    (widget.trainer.gym1 != null && widget.trainer.gym1 != "")
                        ? buildItem(0)
                        : Container(),
                    (widget.trainer.gym2 != null && widget.trainer.gym2 != "")
                        ? buildItem(1)
                        : Container(),
                    (widget.trainer.gym3 != null && widget.trainer.gym3 != "")
                        ? buildItem(2)
                        : Container(),
                    (widget.trainer.gym4 != null && widget.trainer.gym4 != "")
                        ? buildItem(3)
                        : Container(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 72 * prefs.getDouble('height'),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                letterSpacing: -0.408,
                                fontWeight: FontWeight.w600,
                                fontSize: 17 * prefs.getDouble('height'),
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(200, 255, 255, 255)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff3E3E45)),
                width: 340 * prefs.getDouble('width'),
                height: 500 * prefs.getDouble('height'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    SvgPicture.asset(
                      'assets/editCardsf1.svg',
                      width: 180.0 * prefs.getDouble('width'),
                      height: 100.0 * prefs.getDouble('height'),
                    ),
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    Container(
                      width: 180 * prefs.getDouble('width'),
                      child: Center(
                        child: Text(
                          "Please edit your gym cards accordingly!",
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28 * prefs.getDouble('height'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 150 * prefs.getDouble('width'),
                        padding: EdgeInsets.only(
                          right: 15 * prefs.getDouble('width'),
                        ),
                        height: 30 * prefs.getDouble('width'),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff57575E),
                          child: MaterialButton(
                            onPressed: () {
                              if (prefs.getInt('currentCard') >= 0 &&
                                  prefs.getInt('currentCard') <= 3) {
                                Navigator.push(
                                    context,
                                    MyPopupRoute1(
                                        trainerUser: widget.trainer,
                                        currentCard:
                                            prefs.getInt('currentCard'),
                                        parent: this,
                                        parentParent: widget.parent));
                              }
                            },
                            child: Text(
                              "Edit card",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11 * prefs.getDouble('height')),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          top: 8.0 * prefs.getDouble('height'),
                        ),
                        child: Container(
                          width: 330 * prefs.getDouble('width'),
                          height: 230 * prefs.getDouble('height'),
                          child: CardSlider(
                            height: 0.0,
                            trainerUser: widget.trainer,
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
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
  List<ReviewMapDelay> revs = [];

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
                "Please set the time-interval!",
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
    positionY_line2 = positionY_line1 + 105 * prefs.getDouble('height');

    _middleAreaHeight = positionY_line2 - positionY_line1;
    _outsideCardInterval = 22.0 * prefs.getDouble('height');
    scrollOffsetY = 0;

    _cardInfoList = [
      CardInfo(
          leftColor: prefix0.mainColor,
          rightColor: prefix0.mainColor,
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 20 * prefs.getDouble('height'),
                            left: 20 * prefs.getDouble('width'),
                          ),
                          child: Text(
                            prefs.getString('gym4') != null && cardInfo == _cardInfoList[0]
                                ? prefs.getString('gym4')
                                : prefs.getString('gym3') != null && cardInfo == _cardInfoList[1]
                                    ? prefs.getString('gym3')
                                    : prefs.getString('gym2') != null &&
                                            cardInfo == _cardInfoList[2]
                                        ? prefs.getString('gym2')
                                        : prefs.getString('gym1') != null &&
                                                cardInfo == _cardInfoList[3]
                                            ? prefs.getString('gym1')
                                            : (cardInfo == _cardInfoList[3]
                                                        ? widget
                                                            .trainerUser.gym1
                                                        : cardInfo == _cardInfoList[2]
                                                            ? widget.trainerUser
                                                                .gym2
                                                            : cardInfo == _cardInfoList[1]
                                                                ? widget
                                                                    .trainerUser
                                                                    .gym3
                                                                : widget
                                                                    .trainerUser
                                                                    .gym4) ==
                                                    ""
                                                ? "Name"
                                                : (cardInfo == _cardInfoList[3]
                                                    ? widget.trainerUser.gym1
                                                    : cardInfo == _cardInfoList[2]
                                                        ? widget.trainerUser.gym2
                                                        : cardInfo == _cardInfoList[1] ? widget.trainerUser.gym3 : widget.trainerUser.gym4),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                color: Color.fromARGB(210, 255, 255, 255)
                                    .withOpacity(cardInfo == _cardInfoList[3]
                                        ? 1
                                        : cardInfo.opacity > 0.7 &&
                                                cardInfo == _cardInfoList[2]
                                            ? cardInfo.opacity
                                            : cardInfo.opacity > 0.7 &&
                                                    cardInfo == _cardInfoList[1]
                                                ? cardInfo.opacity
                                                : cardInfo.opacity > 0.7 &&
                                                        cardInfo ==
                                                            _cardInfoList[0]
                                                    ? cardInfo.opacity
                                                    : 0),
                                fontSize: 20 * prefs.getDouble('height'),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (cardInfo == _cardInfoList[1]) {
                              if (prefs.getString('gym3Website') != null) {
                                launch(prefs.getString('gym3Website'));
                              } else {
                                if (widget.trainerUser.gym3Website != null) {
                                  launch(widget.trainerUser.gym3Website);
                                }
                              }
                            }
                            if (cardInfo == _cardInfoList[0]) {
                              if (prefs.getString('gym4Website') != null) {
                                launch(prefs.getString('gym4Website'));
                              } else {
                                if (widget.trainerUser.gym4Website != null) {
                                  launch(widget.trainerUser.gym4Website);
                                }
                              }
                            }
                            if (cardInfo == _cardInfoList[2]) {
                              if (prefs.getString('gym2Website') != null) {
                                launch(prefs.getString('gym2Website'));
                              } else {
                                if (widget.trainerUser.gym2Website != null) {
                                  launch(widget.trainerUser.gym2Website);
                                }
                              }
                            }
                            if (cardInfo == _cardInfoList[3]) {
                              if (prefs.getString('gym1Website') != null) {
                                launch(prefs.getString('gym1Website'));
                              } else {
                                if (widget.trainerUser.gym1Website != null) {
                                  launch(widget.trainerUser.gym1Website);
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20 * prefs.getDouble('height'),
                              right: 20 * prefs.getDouble('width'),
                            ),
                            child: Icon(Icons.public,
                                size: 22 * prefs.getDouble('height'),
                                color: Colors.white),
                          ),
                        )
                      ]),
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
                          (prefs.getString('gym4Street') != null && cardInfo == _cardInfoList[0]
                              ? prefs.getString('gym4Street')
                              : prefs.getString('gym3Street') != null && cardInfo == _cardInfoList[1]
                                  ? prefs.getString('gym3Street')
                                  : prefs.getString('gym2Street') != null && cardInfo == _cardInfoList[2]
                                      ? prefs.getString('gym2Street')
                                      : prefs.getString('gym1Street') != null &&
                                              cardInfo == _cardInfoList[3]
                                          ? prefs.getString('gym1Street')
                                          : (cardInfo == _cardInfoList[3]
                                                      ? widget.trainerUser
                                                          .gym1Street
                                                      : cardInfo == _cardInfoList[2]
                                                          ? widget.trainerUser
                                                              .gym2Street
                                                          : cardInfo == _cardInfoList[1]
                                                              ? widget
                                                                  .trainerUser
                                                                  .gym3Street
                                                              : widget
                                                                  .trainerUser
                                                                  .gym4Street) ==
                                                  ""
                                              ? ""
                                              : (cardInfo == _cardInfoList[3]
                                                  ? widget
                                                      .trainerUser.gym1Street
                                                  : cardInfo == _cardInfoList[2]
                                                      ? widget.trainerUser.gym2Street
                                                      : cardInfo == _cardInfoList[1] ? widget.trainerUser.gym3Street : widget.trainerUser.gym4Street)),
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
                          (prefs.getString('gym4Sector') != null && cardInfo == _cardInfoList[0]
                              ? prefs.getString('gym4Sector')
                              : prefs.getString('gym3Sector') != null && cardInfo == _cardInfoList[1]
                                  ? prefs.getString('gym3Sector')
                                  : prefs.getString('gym2Sector') != null && cardInfo == _cardInfoList[2]
                                      ? prefs.getString('gym2Sector')
                                      : prefs.getString('gym1Sector') != null &&
                                              cardInfo == _cardInfoList[3]
                                          ? prefs.getString('gym1Sector')
                                          : (cardInfo == _cardInfoList[3]
                                                      ? widget.trainerUser
                                                          .gym1Sector
                                                      : cardInfo == _cardInfoList[2]
                                                          ? widget.trainerUser
                                                              .gym2Sector
                                                          : cardInfo == _cardInfoList[1]
                                                              ? widget
                                                                  .trainerUser
                                                                  .gym3Sector
                                                              : widget
                                                                  .trainerUser
                                                                  .gym4Sector) ==
                                                  ""
                                              ? ""
                                              : (cardInfo == _cardInfoList[3]
                                                  ? widget
                                                      .trainerUser.gym1Sector
                                                  : cardInfo == _cardInfoList[2]
                                                      ? widget.trainerUser.gym2Sector
                                                      : cardInfo == _cardInfoList[1] ? widget.trainerUser.gym3Sector : widget.trainerUser.gym4Sector)),
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
      prefs.setInt('currentCard', firstCardAtAreaIdx.toInt() + 3);
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
                      padding: EdgeInsets.only(bottom: 9.0),
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

class MyPopupRoute1 extends PopupRoute<void> {
  MyPopupRoute1({
    this.trainerUser,
    this.currentCard,
    this.parent,
    this.parentParent,
  });
  final _FirstPageState parentParent;
  final DetailsPage2State parent;
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
      EditGymCards(
          trainer: trainerUser,
          currentCard: currentCard,
          parent: parent,
          parentParent: parentParent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class EditGymCards extends StatefulWidget {
  final _FirstPageState parentParent;
  final DetailsPage2State parent;
  final TrainerUser trainer;
  final int currentCard;
  EditGymCards(
      {Key key,
      @required this.trainer,
      @required this.currentCard,
      @required this.parent,
      @required this.parentParent})
      : super(key: key);

  @override
  State createState() => EditGymCardsState(trainer: trainer);
}

class EditGymCardsState extends State<EditGymCards> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector, hintWebsite;

  EditGymCardsState({
    @required this.trainer,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff3E3E45)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30 * prefs.getDouble('height'),
                  ),
                  Text(
                    "Edit gym card",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 17 * prefs.getDouble('height'),
                        color: Color.fromARGB(200, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50 * prefs.getDouble('height'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    height: 73 * prefs.getDouble('width'),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLength: 20,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          height: 1.0 * prefs.getDouble('height'),
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.location_city,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: "Gym's name",
                      ),
                      onChanged: (String str) {
                        hintName = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 73 * prefs.getDouble('width'),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      maxLength: 25,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          height: 1 * prefs.getDouble('height'),
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: 'Street',
                      ),
                      onChanged: (String str) {
                        hintStreet = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 73 * prefs.getDouble('width'),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLength: 10,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.my_location,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: 'District',
                      ),
                      onChanged: (String str) {
                        hintSector = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 73 * prefs.getDouble('width'),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLength: 100,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.public,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: 'Website',
                      ),
                      onChanged: (String str) {
                        hintWebsite = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20 * prefs.getDouble('height'),
                  ),
                  Container(
                    width: 150.0 * prefs.getDouble('width'),
                    height: 50.0 * prefs.getDouble('height'),
                    child: Material(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(90.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (hintWebsite == null || hintWebsite == "") {
                            Navigator.push(context, PopUpMissingCardsRoute());
                          } else {
                            if (hintName == null || hintName == "") {
                              Navigator.push(context, PopUpMissingCardsRoute());
                            } else {
                              if (hintSector == null || hintSector == "") {
                                Navigator.push(
                                    context, PopUpMissingCardsRoute());
                              } else {
                                if (hintStreet == null || hintStreet == "") {
                                  Navigator.push(
                                      context, PopUpMissingCardsRoute());
                                } else {
                                  var db = Firestore.instance;
                                  var batch = db.batch();
                                  if (hintWebsite != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}Website':
                                            '$hintWebsite',
                                      },
                                    );
                                  }
                                  if (hintName != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}':
                                            '$hintName',
                                      },
                                    );
                                  }
                                  if (hintStreet != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}Street':
                                            '$hintStreet',
                                      },
                                    );
                                  }
                                  if (hintSector != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}Sector':
                                            '$hintSector',
                                      },
                                    );
                                  }

                                  batch.commit();
                                  if (4 - widget.currentCard == 1) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym1Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym1 =
                                          hintName;
                                      prefs.setString('gym1', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym1Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym1Sector', hintSector);
                                    }
                                  }
                                  if (4 - widget.currentCard == 2) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym2Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym2 =
                                          hintName;
                                      prefs.setString('gym2', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym2Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym2Sector', hintSector);
                                    }
                                  }
                                  if (4 - widget.currentCard == 3) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym3Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym3 =
                                          hintName;
                                      prefs.setString('gym3', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym3Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym3Sector', hintSector);
                                    }
                                  }
                                  if (4 - widget.currentCard == 4) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym4Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym4 =
                                          hintName;
                                      prefs.setString('gym4', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym4Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym4Sector', hintSector);
                                    }
                                  }
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          }
                        },
                        child: Text(
                          'Save changes',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 15.0 * prefs.getDouble('height'),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30 * prefs.getDouble('height'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopUpMissingCardsRoute extends PopupRoute<void> {
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      PopUpMissingCards();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpMissingCards extends StatefulWidget {
  @override
  State createState() => PopUpMissingCardsState();
}

class PopUpMissingCardsState extends State<PopUpMissingCards> {
  List<ReviewMapDelay> revs = [];

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
                'assets/completeallfieldsf1.svg',
                width: 180.0 * prefs.getDouble('width'),
                height: 100.0 * prefs.getDouble('height'),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Text(
                "Please complete all fields before submitting new changes!",
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
