import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/Trainer_Booking/Voting_Page/Voting.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Client/chatscreen.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix1;
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';

class CrudMethods {
  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();
  }
}

bool votingFlag;

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

class MyTrainer extends StatefulWidget {
  MyTrainer({
    this.bookedTrainerId,
    this.actualClient
  });
  final ClientUser actualClient;
  final String bookedTrainerId;
  @override
  _MyTrainerState createState() => new _MyTrainerState();
}

class _MyTrainerState extends State<MyTrainer>
    with SingleTickerProviderStateMixin {
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;

  Future _getData;

  CrudMethods crudObj;

  bool restart = false;
  bool flagBusinessAccepted;
  bool flagFriendshipAccepted;
  bool flagBusinessPending;
  bool flagFriendshipPending;
  Future _getDataTrainer;
  Future<QuerySnapshot> getDataTrainerr() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: widget.bookedTrainerId,
        )
        .getDocuments();
  }

  @override
  void initState() {
    super.initState();
    votingFlag = null;
    restart = false;
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
    crudObj = CrudMethods();
    _getData = crudObj.getData();
    _getDataTrainer = getDataTrainerr();
  }

  bool seenFlag;
  TrainerUser bookedTrainer;
  String trainersSpecializations = "";

  @override
  Widget build(BuildContext context) {
    controller.forward();
   
        return FutureBuilder(
            future: Firestore.instance
                .collection('clientUsers')
                .where(
                  'id',
                  isEqualTo: widget.bookedTrainerId,
                )
                .getDocuments(),
            builder: (context, snapshot1) {
              if (!snapshot1.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(prefix1.mainColor),
                  ),
                );
              }
              if (restart == false) {
                bookedTrainer = TrainerUser(snapshot1.data.documents[0]);

                bookedTrainer.clients.forEach((client) {
                  if (client.clientId == widget.actualClient.id &&
                      client.clientAccepted == true)
                    flagBusinessAccepted = true;
                });
                bookedTrainer.friends.forEach((friend) {
                  if (friend.friendId == widget.actualClient.id &&
                      friend.friendAccepted == true)
                    flagFriendshipAccepted = true;
                });
                bookedTrainer.friends.forEach((friend) {
                  if (friend.friendId == widget.actualClient.id &&
                      friend.friendAccepted == false)
                    flagFriendshipPending = true;
                });
                bookedTrainer.clients.forEach((client) {
                  if (client.clientId == widget.actualClient.id &&
                      client.clientAccepted == false)
                    flagBusinessPending = true;
                });
              }

              bookedTrainer.specializations.forEach((special) {
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
              votingFlag = false;
              DateTime timestamp = Timestamp.now().toDate();
              if (timestamp.isAfter(
                          widget.actualClient.scheduleFirstWeek.day1.toDate()) ==
                      true &&
                  timestamp.day ==
                      widget.actualClient.scheduleFirstWeek.day1.toDate().day &&
                  widget.actualClient.checkFirstSchedule.day1 == 'true' &&
                  widget.actualClient.dailyVote == false) {
                bookedTrainer.clients.forEach((element) {
                  if (element.clientId == prefs.getString('id')) {
                    votingFlag = true;
                  }
                });
              }
              seenFlag = false;
              widget.actualClient.unseenMessagesCounter.forEach((user) {
                if (user.userId == bookedTrainer.id) {
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
                              bookedTrainer.firstName +
                                  " " +
                                  bookedTrainer.lastName,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  letterSpacing:
                                      0.8 * prefs.getDouble('height'),
                                  wordSpacing: 7 * prefs.getDouble('height'),
                                  fontSize: 20.0 * prefs.getDouble('height'),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                        backgroundColor: backgroundColor,
                        body: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 5 * prefs.getDouble('height'),
                              ),
                              Container(
                                height: 80 * prefs.getDouble('height'),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 32 * prefs.getDouble('width')),
                                      child: bookedTrainer.photoUrl == null
                                          ? ClipOval(
                                              child: Container(
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255,
                                                    bookedTrainer.colorRed,
                                                    bookedTrainer.colorGreen,
                                                    bookedTrainer.colorBlue),
                                                shape: BoxShape.circle,
                                              ),
                                              height: (80 *
                                                  prefs.getDouble('height')),
                                              width: (80 *
                                                  prefs.getDouble('height')),
                                              child: Center(
                                                child: Text(
                                                  bookedTrainer.firstName[0],
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 50 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ))
                                          : InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    ProfilePhotoPopUp(
                                                      trainerUser:
                                                          bookedTrainer,
                                                    ));
                                              },
                                              child: Material(
                                                child: Container(
                                                  width: 80 *
                                                      prefs.getDouble('height'),
                                                  height: 80 *
                                                      prefs.getDouble('height'),
                                                  decoration: BoxDecoration(
                                                      color: backgroundColor,
                                                      shape: BoxShape.circle),
                                                  child: Image.network(
                                                    bookedTrainer.photoUrl,
                                                    fit: BoxFit.cover,
                                                    scale: 1.0,
                                                    loadingBuilder: (BuildContext
                                                            ctx,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    mainColor),
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
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 32 * prefs.getDouble('width')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width:
                                                220 * prefs.getDouble('width'),
                                            child: Text(
                                              trainersSpecializations,
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                letterSpacing: -0.408 *
                                                    prefs.getDouble('width'),
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0 *
                                                    prefs.getDouble('height'),
                                                color: Color.fromARGB(
                                                    80, 255, 255, 255),
                                              ),
                                              textAlign: TextAlign.end,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Text(
                                            (bookedTrainer.gender == 'male'
                                                    ? 'Male, '
                                                    : 'Female, ') +
                                                (bookedTrainer.age.toString() +
                                                    " years" +
                                                    " | ") +
                                                (bookedTrainer.clients.length
                                                        .toString() +
                                                    " clients"),
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              letterSpacing: -0.408 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0 *
                                                  prefs.getDouble('height'),
                                              color: Color.fromARGB(
                                                  80, 255, 255, 255),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            bookedTrainer.freeTraining == true
                                                ? "First session is free"
                                                : "",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              letterSpacing: -0.408 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0 *
                                                  prefs.getDouble('height'),
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32 * prefs.getDouble('width')),
                                child: flagBusinessAccepted == true
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: 150 *
                                                    prefs.getDouble('width'),
                                                height: 32 *
                                                    prefs.getDouble('height'),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: secondaryColor,
                                                  child: MaterialButton(
                                                      onPressed: () async {
                                                        Navigator.push(
                                                            context,
                                                            DeletePermissionPopup(
                                                                trainer:
                                                                    bookedTrainer,
                                                                parent: this));
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
                                                            Icons.cancel,
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
                                                    prefs.getDouble('width'),
                                                height: 32 *
                                                    prefs.getDouble('height'),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: seenFlag == true
                                                      ? mainColor
                                                      : secondaryColor,
                                                  child: MaterialButton(
                                                      onPressed: ()  {
                                                        Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                Chat(
                                                              peerId:
                                                                  bookedTrainer
                                                                      .id,
                                                            ),
                                                          ),
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
                                                            Icons.chat,
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
                                                  prefs.getDouble('height')),
                                          votingFlag == true
                                              ? Container(
                                                  child: Container(
                                                  width: 310 *
                                                      prefs.getDouble('width'),
                                                  height: 32 *
                                                      prefs.getDouble('height'),
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: secondaryColor,
                                                    child: MaterialButton(
                                                        onPressed: () async {
                                                          Navigator.push(
                                                            context,
                                                            Vote(
                                                                clientUser:
                                                                    widget.actualClient,
                                                                trainer:
                                                                    bookedTrainer,
                                                                parent: this),
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
                                                              Icons
                                                                  .fitness_center,
                                                              color:
                                                                  Colors.white,
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
                                                              "Rate the last training session",
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
                                                      prefs.getDouble('height'),
                                                )
                                        ],
                                      )
                                    : flagBusinessPending == true
                                        ? Container(
                                            width:
                                                310 * prefs.getDouble('width'),
                                            height:
                                                32 * prefs.getDouble('height'),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: secondaryColor,
                                              child: MaterialButton(
                                                  onPressed: ()  {
                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Chat(
                                                          peerId:
                                                              bookedTrainer.id,
                                                        ),
                                                      ),
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
                                                        Icons.message,
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
                                                        "Chat",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Colors.white,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          )
                                        : flagFriendshipAccepted == true
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 149 *
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
                                                          onPressed: ()  {
                                                            Navigator.push(
                                                              context,
                                                              new MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                            context) =>
                                                                        Chat(
                                                                  peerId:
                                                                      bookedTrainer
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
                                                                Icons.message,
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
                                                  ),
                                                  SizedBox(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
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
                                                      color: secondaryColor,
                                                      child: MaterialButton(
                                                          onPressed: () async {
                                                            QuerySnapshot query = await Firestore
                                                                .instance
                                                                .collection(
                                                                    'clientUsers')
                                                                .where('id',
                                                                    isEqualTo: prefs
                                                                        .getString(
                                                                            'id'))
                                                                .where(
                                                                    'trainersMap.${bookedTrainer.id}',
                                                                    isEqualTo:
                                                                        true)
                                                                .getDocuments();
                                                            if (query.documents
                                                                    .length ==
                                                                0) {
                                                              Firestore.instance
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      bookedTrainer
                                                                          .id)
                                                                  .updateData(
                                                                {
                                                                  'trainerMap.${prefs.getString('id')}':
                                                                      false,
                                                                },
                                                              );

                                                              QuerySnapshot query2 = await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      'pushNotifications')
                                                                  .where('id',
                                                                      isEqualTo:
                                                                          bookedTrainer
                                                                              .id)
                                                                  .getDocuments();
                                                              Firestore.instance
                                                                  .collection(
                                                                      'trainerRequests')
                                                                  .document(
                                                                      bookedTrainer
                                                                          .id)
                                                                  .setData(
                                                                {
                                                                  'idFrom': prefs
                                                                      .getString(
                                                                          'id'),
                                                                  'idTo':
                                                                      bookedTrainer
                                                                          .id,
                                                                  'pushToken':
                                                                      query2.documents[
                                                                              0]
                                                                          [
                                                                          'pushToken']
                                                                },
                                                              );
                                                            }
                                                            setState(
                                                              () {
                                                                var i = 0;
                                                                bookedTrainer
                                                                    .clients
                                                                    .forEach(
                                                                        (client) {
                                                                  if (client.clientId ==
                                                                          widget.actualClient
                                                                              .id &&
                                                                      client.clientAccepted ==
                                                                          false) {
                                                                    bookedTrainer
                                                                        .clients[
                                                                            i]
                                                                        .clientAccepted = false;
                                                                    flagBusinessPending =
                                                                        true;
                                                                  }
                                                                  i++;
                                                                });
                                                                restart = true;
                                                                flagBusinessPending =
                                                                    true;
                                                              },
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
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
                                                                "Colaborare",
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
                                              )
                                            : flagFriendshipPending == false
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
                                                                .circular(4),
                                                        color: secondaryColor,
                                                        child: MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              QuerySnapshot query = await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .where('id',
                                                                      isEqualTo:
                                                                          prefs.getString(
                                                                              'id'))
                                                                  .where(
                                                                      'friendsMap.${bookedTrainer.id}',
                                                                      isEqualTo:
                                                                          true)
                                                                  .getDocuments();
                                                              if (query
                                                                      .documents
                                                                      .length ==
                                                                  0) {
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        bookedTrainer
                                                                            .id)
                                                                    .updateData(
                                                                  {
                                                                    'friendsMap.${prefs.getString('id')}':
                                                                        false
                                                                  },
                                                                );
                                                              }
                                                              setState(
                                                                () {
                                                                  var i = 0;
                                                                  bookedTrainer
                                                                      .friends
                                                                      .forEach(
                                                                          (friend) {
                                                                    if (friend.friendId ==
                                                                            widget.actualClient
                                                                                .id &&
                                                                        friend.friendAccepted ==
                                                                            false) {
                                                                      bookedTrainer
                                                                          .friends[
                                                                              i]
                                                                          .friendAccepted = false;
                                                                      flagFriendshipPending =
                                                                          true;
                                                                    }
                                                                    i++;
                                                                  });
                                                                  restart =
                                                                      true;
                                                                  flagFriendshipPending =
                                                                      true;
                                                                },
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
                                                                  Icons
                                                                      .person_add,
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
                                                                  "Friend request",
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
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 70 *
                                                        prefs.getDouble(
                                                            'height'),
                                                  ),
                              ),
                              SizedBox(
                                height: 18.0 * prefs.getDouble('height'),
                              ),
                              Container(
                                width: double.infinity,
                                height: 20 * prefs.getDouble('height'),
                                padding: EdgeInsets.only(
                                    left: 32 * prefs.getDouble('width')),
                                child: Text(
                                  "Trainer rating: ${((bookedTrainer.attributeMap.attribute1 + bookedTrainer.attributeMap.attribute2) / 2).toStringAsFixed(2)}",
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
                              SizedBox(
                                height: 18.0 * prefs.getDouble('height'),
                              ),
                              RepaintBoundary(
                                child: Container(
                                  height: 135 * prefs.getDouble('height'),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          left: 32 * prefs.getDouble('width'),
                                        ),
                                        child: Text(
                                          "Communication: ${bookedTrainer.attributeMap.attribute1.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255),
                                              fontSize: 12.0 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.066,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            10.0 * prefs.getDouble('height'),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left:
                                                34 * prefs.getDouble('width')),
                                        height: 25 * prefs.getDouble('height'),
                                        child: CustomPaint(
                                          foregroundPainter: CustomGraphRight(
                                            attribute1: bookedTrainer
                                                .attributeMap.attribute1,
                                          ),
                                          child: Container(
                                            height:
                                                25 * prefs.getDouble('height'),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          left: 32 * prefs.getDouble('width'),
                                        ),
                                        child: Text(
                                          "Profesionalism: ${bookedTrainer.attributeMap.attribute2.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255),
                                              fontSize: 12.0 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.066,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            10.0 * prefs.getDouble('height'),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left:
                                                34 * prefs.getDouble('width')),
                                        height: 25 * prefs.getDouble('height'),
                                        child: CustomPaint(
                                          foregroundPainter: CustomGraphRight(
                                            attribute1: bookedTrainer
                                                .attributeMap.attribute2,
                                          ),
                                          child: Container(
                                            height:
                                                25 * prefs.getDouble('height'),
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
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        color:
                                            Color.fromARGB(120, 255, 255, 255)),
                                    textAlign: TextAlign.start,
                                  )),
                              Center(
                                child: Container(
                                  width: 330 * prefs.getDouble('width'),
                                  height: 250 * prefs.getDouble('height'),
                                  child: CardSlider(
                                    trainerUser: bookedTrainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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

class CustomDialogVote extends StatefulWidget {
  final _MyTrainerState parent;
  final TrainerUser trainer;
  final ClientUser actualClient;
  CustomDialogVote({Key key, @required this.trainer, @required this.parent, this.actualClient})
      : super(key: key);

  @override
  State createState() =>
      CustomDialogVoteState(trainer: trainer, parent: parent);
}

class CustomDialogVoteState extends State<CustomDialogVote> {
  String hinttText = "Scrie";
  Image image;
  final _MyTrainerState parent;
  final TrainerUser trainer;

  CustomDialogVoteState(
      {@required this.trainer, this.image, @required this.parent});
  String reviewText;
  int localAttribute1 = 1, localAttribute2 = 1;

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
                      color: prefix1.secondaryColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize:
                          MainAxisSize.min, // To make the card compact
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
                                        horizontal:
                                            16 * prefs.getDouble('width')),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: mainColor),
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
                                  DateTime timestamp = Timestamp.now().toDate();
                                  if (timestamp.isAfter(widget.actualClient
                                              .scheduleFirstWeek.day1
                                              .toDate()) ==
                                          true &&
                                      timestamp.day ==
                                          widget.actualClient.scheduleFirstWeek.day1
                                              .toDate()
                                              .day &&
                                      widget.actualClient.checkFirstSchedule.day1 ==
                                          'true' &&
                                      widget.actualClient.dailyVote == false) {
                                    trainer.clients.forEach((element) {
                                      if (element.clientId ==
                                          prefs.getString('id')) {
                                        if (reviewText != null) {
                                          Firestore.instance
                                              .collection('clientUsers')
                                              .document(trainer.id)
                                              .updateData(
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
                                              'month1.1': trainer
                                                      .month1.attribute1 +
                                                  (localAttribute1 == 5
                                                      ? 5
                                                      : localAttribute1 == 4
                                                          ? 0
                                                          : localAttribute1 == 3
                                                              ? -50
                                                              : localAttribute1 ==
                                                                      2
                                                                  ? -100
                                                                  : -200),
                                              'month1.2': trainer
                                                      .month1.attribute2 +
                                                  (localAttribute2 == 5
                                                      ? 5
                                                      : localAttribute2 == 4
                                                          ? 0
                                                          : localAttribute2 == 3
                                                              ? -50
                                                              : localAttribute2 ==
                                                                      2
                                                                  ? -100
                                                                  : -200),
                                              'reviewMap.$reviewText':
                                                  DateTime.now()
                                            },
                                          );
                                        } else {
                                          Firestore.instance
                                              .collection('clientUsers')
                                              .document(trainer.id)
                                              .updateData(
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
                                              'month1.1': trainer
                                                      .month1.attribute1 +
                                                  (localAttribute1 == 5
                                                      ? 5
                                                      : localAttribute1 == 4
                                                          ? 0
                                                          : localAttribute1 == 3
                                                              ? -50
                                                              : localAttribute1 ==
                                                                      2
                                                                  ? -100
                                                                  : -200),
                                              'month1.2': trainer
                                                      .month1.attribute2 +
                                                  (localAttribute2 == 5
                                                      ? 5
                                                      : localAttribute2 == 4
                                                          ? 0
                                                          : localAttribute2 == 3
                                                              ? -50
                                                              : localAttribute2 ==
                                                                      2
                                                                  ? -100
                                                                  : -200),
                                            },
                                          );
                                        }
                                        Firestore.instance
                                            .collection('clientUsers')
                                            .document(prefs.getString('id'))
                                            .updateData(
                                          {'dailyVote': true},
                                        );
                                        parent.setState(() {
                                          votingFlag = false;
                                        });
                                      }
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Rate',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize:
                                          17.0 * prefs.getDouble('height'),
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

class Vote extends PopupRoute<void> {
  Vote({this.clientUser, this.trainer, this.parent});
  final _MyTrainerState parent;
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
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: CustomDialogVote(
          trainer: trainer,
          parent: parent,
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermissionPopup extends PopupRoute<void> {
  DeletePermissionPopup({this.trainer, this.parent});
  final _MyTrainerState parent;
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
      DeletePermission(trainer: trainer, parent: parent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission extends StatefulWidget {
  final _MyTrainerState parent;
  final TrainerUser trainer;

  DeletePermission({Key key, @required this.trainer, @required this.parent})
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
                  "Are you sure you want to stop the training partnership with ${trainer.firstName} ${trainer.lastName}? The friendship will be deleted as well.",
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
                        Firestore.instance
                            .collection('clientUsers')
                            .document(prefs.getString('id'))
                            .updateData(
                          {
                            'trainersMap.${trainer.id}': FieldValue.delete(),
                            'friendsMap.${trainer.id}': FieldValue.delete()
                          },
                        );

                        Firestore.instance
                            .collection('clientUsers')
                            .document(trainer.id)
                            .updateData(
                          {
                            'trainerMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );
                        widget.parent.setState(() {
                          widget.parent.restart = true;
                          widget.parent.flagFriendshipAccepted = false;
                          widget.parent.flagFriendshipPending = false;
                          widget.parent.flagBusinessPending = false;
                          widget.parent.flagBusinessAccepted = false;
                        });
                        Navigator.of(context).pop();
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
