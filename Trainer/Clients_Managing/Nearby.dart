import 'package:Bsharkr/Client/Trainer_Booking/Main/GeoLocation.dart/Geo.dart';
import 'package:Bsharkr/Trainer/Client_Requests/Client_Profile/ClientProfileFinal.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/models/clientUser.dart';
import 'package:flutter_svg/svg.dart';

class Nearby extends StatefulWidget {
  TrainerUser actualTrainer;
  Nearby({
    this.actualTrainer,
  });
  @override
  State createState() => NearbyState();

  void setState(Null Function() param0) {}
}

class NearbyState extends State<Nearby>
    with AutomaticKeepAliveClientMixin<Nearby> {
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
    ClientUser _clientUser = ClientUser(document);
    if (_clientUser.id == prefs.getString('id') ||
        checking.contains(_clientUser.id) == true ||
        _clientUser.acceptTrainerRequests != true ||
        widget.actualTrainer.locationGeopoint == null ||
        _clientUser.locationGeopoint == null) {
      return Container();
    } else {
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
                    _clientUser,
                    widget.actualTrainer,
                    this),
              ),
            );
          },
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
                                      height: (60 * prefs.getDouble('height')),
                                      width: (60 * prefs.getDouble('height')),
                                      child: Center(
                                          child: Text(
                                        _clientUser.firstName[0],
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize:
                                                35 * prefs.getDouble('height')),
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
                          width: 220 * prefs.getDouble('width'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 130 * prefs.getDouble('width'),
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
                                                  prefs.getDouble('width')),
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
                                            : Container(),
                                      ],
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          fontFamily: 'Roboto',
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: distanceInKilometers(
                                                    _clientUser
                                                        .locationGeopoint,
                                                    widget.actualTrainer
                                                        .locationGeopoint)
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: " KM",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    100, 255, 255, 255),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (widget.actualTrainer.nearbyFlag ==
                                      false) {
                                    await Firestore.instance
                                        .collection('clientUsers')
                                        .document(_clientUser.id)
                                        .updateData(
                                      {
                                        'nearby.${prefs.getString('id')}': true,
                                        'trainerRequestedClient': true
                                      },
                                    );

                                    await Firestore.instance
                                        .collection('clientUsers')
                                        .document(prefs.getString('id'))
                                        .updateData(
                                      {
                                        'nearby.${_clientUser.id}': true,
                                        'nearbyDate.${_clientUser.id}':
                                            DateTime.now(),
                                        'nearbyFlag': true,
                                      },
                                    );

                                    await Firestore.instance
                                        .collection('trainerRequestedClient')
                                        .document(_clientUser.id)
                                        .setData(
                                      {
                                        'idFrom': prefs.getString('id'),
                                        'idTo': _clientUser.id,
                                        'pushToken': _clientUser.pushToken,
                                      },
                                    );
                                    setState(() {
                                      actualList.removeWhere((element) =>
                                          ClientUser(element).id ==
                                          _clientUser.id);
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10 * prefs.getDouble('width')),
                                    width: 90 * prefs.getDouble('width'),
                                    height: 60 * prefs.getDouble('height'),
                                    child: Center(
                                      child: Icon(
                                        Icons.person_add,
                                        size: 24.0 * prefs.getDouble('height'),
                                        color: widget
                                                    .actualTrainer.nearbyFlag ==
                                                false
                                            ? Color.fromARGB(200, 255, 255, 255)
                                            : Color.fromARGB(80, 255, 255, 255),
                                      ),
                                    )),
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

  bool restart = false;

  List<String> checking = [];
  @override
  void initState() {
   
    super.initState();
    if (widget.actualTrainer.locationGeopoint != null) {
      getNearbyPeople();
    }
  }

  List<DocumentSnapshot> actualList = [];

  List<String> nearbyIds = [];

  GeoPoint sw, ne;
  getNearbyPeople() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot lastDocument;
    bool noMoreClients = false;
    GeoPoint center = GeoPoint(widget.actualTrainer.locationGeopoint.latitude,
        widget.actualTrainer.locationGeopoint.longitude);
    sw = GeoPoint(boundingBoxCoordinates(Area(center, 10)).swCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).swCorner.longitude);
    ne = GeoPoint(boundingBoxCoordinates(Area(center, 10)).neCorner.latitude,
        boundingBoxCoordinates(Area(center, 10)).neCorner.longitude);
    QuerySnapshot query = await Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'client')
        .where('location.geopoint', isGreaterThan: sw)
        .where('location.geopoint', isLessThan: ne)
        .limit(10)
        .getDocuments();
    if (query.documents.length != 0) {
      lastDocument = query.documents[query.documents.length - 1];

      for (int i = 0; i < query.documents.length; i++) {
        bool flagF = false;
        bool flagT = false;
        bool flagN = false;

        widget.actualTrainer.friends.forEach((element1) {
          if (ClientUser(query.documents[i]).id == element1.friendId) {
            flagF = true;
          }
        });
        widget.actualTrainer.clients.forEach((element2) {
          if (ClientUser(query.documents[i]).id == element2.clientId) {
            flagT = true;
          }
        });
        widget.actualTrainer.nearbyList.forEach((element3) {
          if (ClientUser(query.documents[i]).id == element3.id) {
            flagN = true;
          }
        });

        if (flagF == false && flagT == false && flagN == false) {
          actualList.add(query.documents[i]);
          nearbyIds.add(ClientUser(query.documents[i]).id);
        }
      }
    }

    if (query.documents.length == 0) {
      noMoreClients = true;
    }

    while (actualList.length < 10 && noMoreClients == false) {
      QuerySnapshot query1 = await Firestore.instance
          .collection('clientUsers')
          .where('role', isEqualTo: 'client')
          .where('location.geopoint', isGreaterThan: sw)
          .where('location.geopoint', isLessThan: ne)
          .orderBy('location.geopoint', descending: true)
          .startAfterDocument(lastDocument)
          .limit(1)
          .getDocuments();
      for (int i = 0; i < query1.documents.length; i++) {
        bool flagF = false;
        bool flagT = false;
        bool flagN = false;

        widget.actualTrainer.friends.forEach((element1) {
          if (ClientUser(query1.documents[i]).id == element1.friendId) {
            flagF = true;
          }
        });
        widget.actualTrainer.clients.forEach((element2) {
          if (ClientUser(query1.documents[i]).id == element2.clientId) {
            flagT = true;
          }
        });

        widget.actualTrainer.nearbyList.forEach((element3) {
          if (ClientUser(query1.documents[i]).id == element3.id) {
            flagN = true;
          }
        });

        if (flagF == false && flagT == false && flagN == false) {
          if (actualList
                  .where((element) =>
                      ClientUser(element).id ==
                      ClientUser(query1.documents[i]).id)
                  .toList() ==
              null) {
            actualList.add(query1.documents[i]);

            nearbyIds.add(ClientUser(query1.documents[i]).id);
          }
        }
      }
      if (query1.documents.length == 0) {
        noMoreClients = true;
      } else {
        lastDocument = query1.documents[query1.documents.length - 1];
      }
    }
    setState(() {
      actualList = actualList;
      isLoading = false;
    });
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: widget.actualTrainer.approved == true
          ? Stack(
              children: <Widget>[
                // List
                actualList.length != 0
                    ? Container(
                        padding:
                            EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                        child: ListView.builder(
                          itemBuilder: (context, index) => buildItem(
                            context,
                            actualList[index],
                          ),
                          itemCount: actualList.length,
                        ))
                    : Container(
                        color: backgroundColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/nearbyf1.svg',
                              width: 350.0 * prefs.getDouble('width'),
                              height: 200.0 * prefs.getDouble('height'),
                            ),
                            SizedBox(height: 32 * prefs.getDouble('height')),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 32 * prefs.getDouble('width')),
                              width: 375 * prefs.getDouble('width'),
                              child: Text(
                                "We could not find clients that accept friend requests in your local area. You can also bring your existing clients into the app.",
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
                      ),
                // Loading
                Positioned(
                  child: isLoading == true
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
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250.0 * prefs.getDouble('width'),
                  child: SvgPicture.asset(
                    'assets/waitf1.svg',
                    width: 250.0 * prefs.getDouble('width'),
                    height: 180.0 * prefs.getDouble('height'),
                  ),
                ),
                SizedBox(height: 32 * prefs.getDouble('height')),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 32 * prefs.getDouble('width')),
                  width: 375 * prefs.getDouble('width'),
                  child: Text(
                    "You will be able to reach out to new clients once your account will be approved.",
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
