import 'dart:ui';
import 'dart:async';
import 'package:Bsharkr/Client/Client_Profile/Profile/time.dart';
import 'package:Bsharkr/Trainer/Classes/EditProfilePageCards.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/models/clientUser.dart';

import 'package:Bsharkr/colors.dart' as prefix0;

import '../../../../colors.dart';

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
  ManagingSchedule({this.clientUser, this.imTrainer});
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
      ManagingS(
        client: clientUser,
        imTrainer: imTrainer,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ManagingS extends StatefulWidget {
  final ClientUser client;
  TrainerUser imTrainer;
  ManagingS({Key key, @required this.client, this.imTrainer}) : super(key: key);

  @override
  State createState() => ManagingSState(client: client, );
}

class ManagingSState extends State<ManagingS> {
  List<bool> isSelected = [true, false];

  String hinttText = "Scrie";
  Image image;
  final ClientUser client;
  var selected;
  String hintName, hintStreet, hintSector;
  TrainerUser imTrainer;
  ManagingSState({@required this.client, this.image});
  bool scheduleChanged = false;
  int currentPage = 0;
  bool modified = false;
  var db = Firestore.instance;
  var batch;
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
                client: client,
                scheduleChanged: scheduleChanged,
                parent: this,
                imTrainer: widget.imTrainer),
            SecondPage(
                client: client, scheduleChanged: scheduleChanged, parent: this)
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 125.0 * prefs.getDouble('height')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 0
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 50 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 10 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 1
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
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
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              height: 130 * prefs.getDouble('height'),
              width: double.infinity,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
              if (scheduleChanged == true) {
                batch.commit();
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
                Firestore.instance
                    .collection('clientUsers')
                    .document(client.id)
                    .updateData(
                  {
                    'scheduleUpdated': true,
                  },
                );
              }
              Navigator.of(context).pop();
            },
            child: Container(
                width: double.infinity,
                height: 110 * prefs.getDouble('height'),
                color: Colors.transparent,
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
                        "Close",
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
  bool scheduleChanged;
  FirstPage(
      {@required this.client,
      @required this.scheduleChanged,
      @required this.parent,
      this.imTrainer});
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  bool scheduleChanged = false;
  String locationName;
  String locationDistrict;
  String locationWebsite;
  String locationStreet;
  String gymWebsite;
  var selected;
  @override
  Widget build(BuildContext context) {
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
              height: 497 * prefs.getDouble('height'),
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
                        15 * prefs.getDouble('width'),
                        0),
                    width: 300 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          monthsOfTheYear[widget.client.scheduleFirstWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1] ==
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1]
                              ? monthsOfTheYear[widget
                                      .client.scheduleFirstWeek.day1
                                      .toDate()
                                      .month
                                      .toInt() -
                                  1]
                              : monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1] +
                                  " - " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(200, 255, 255, 255),
                          ),
                        ),
                        SizedBox(
                          height: 10 * prefs.getDouble('height'),
                        ),
                        Container(
                          height: 274 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 270 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 50 * prefs.getDouble('height'),
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
                                                      ? prefix0.mainColor
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
                                                    Navigator.push(
                                                        context,
                                                        DetailsPopUp2(
                                                          index:1,
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
                                                                (widget.client.scheduleFirstWeek
                                                                            .day1
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
                                     
                                      height: 50 * prefs.getDouble('height'),
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
                                                      ? prefix0.mainColor
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
                                                    Navigator.push(
                                                        context,
                                                        DetailsPopUp2(
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
                                                                (widget.client.scheduleFirstWeek
                                                                            .day2
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
                                      height: 50 * prefs.getDouble('height'),
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
                                                      ? prefix0.mainColor
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
                                                    Navigator.push(
                                                        context,
                                                        DetailsPopUp2(
                                                          index:3,
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
                                                                (widget.client.scheduleFirstWeek
                                                                            .day3
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
                                      height: 50 * prefs.getDouble('height'),
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
                                                      ? prefix0.mainColor
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
                                                    Navigator.push(
                                                        context,
                                                        DetailsPopUp2(
                                                          index:4,
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
                                                                (widget.client.scheduleFirstWeek
                                                                            .day4
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
                                      height: 50 * prefs.getDouble('height'),
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
                                                      ? prefix0.mainColor
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
                                                    Navigator.push(
                                                        context,
                                                        DetailsPopUp2(
                                                          index:5,
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
                                                                (widget.client.scheduleFirstWeek
                                                                            .day5
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
  ManagingSState parent;
  bool scheduleChanged;
  final ClientUser client;
  SecondPage(
      {@required this.client,
      @required this.scheduleChanged,
      @required this.parent});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Icon showIcon(String x) {
    if (x == 'Icons.fitness_center') {
      return Icon(
        Icons.fitness_center,
        size: 17.0 * MediaQuery.of(context).size.height / 812,
        color: Colors.white,
        key: UniqueKey(),
      );
    }
    return Icon(
      Icons.hotel,
      size: 17.0 * MediaQuery.of(context).size.height / 812,
      color: Colors.white,
      key: UniqueKey(),
    );
  }

  bool toggleValue21 = false;
  bool toggleValue22 = false;
  bool toggleValue23 = false;
  bool toggleValue24 = false;
  bool toggleValue25 = false;
  bool toggleValue26 = false;
  bool toggleValue27 = false;
  bool modified21 = false;
  bool modified22 = false;
  bool modified23 = false;
  bool modified24 = false;
  bool modified25 = false;
  bool modified26 = false;
  bool modified27 = false;

  toggleButton21() {
    setState(() {
      toggleValue21 = !toggleValue21;
      modified21 = true;
      modified22 = false;
      modified23 = false;
      modified24 = false;
      modified25 = false;
      modified26 = false;
      modified27 = false;
    });
  }

  toggleButton22() {
    setState(() {
      toggleValue22 = !toggleValue22;
      modified21 = false;
      modified22 = true;
      modified23 = false;
      modified24 = false;
      modified25 = false;
      modified26 = false;
      modified27 = false;
    });
  }

  toggleButton23() {
    setState(() {
      modified21 = false;
      modified22 = false;
      modified23 = true;
      modified24 = false;
      modified25 = false;
      modified26 = false;
      modified27 = false;
      toggleValue23 = !toggleValue23;
    });
  }

  toggleButton24() {
    setState(() {
      modified21 = false;
      modified22 = false;
      modified23 = false;
      modified24 = true;
      modified25 = false;
      modified26 = false;
      modified27 = false;
      toggleValue24 = !toggleValue24;
    });
  }

  toggleButton25() {
    setState(() {
      modified21 = false;
      modified22 = false;
      modified23 = false;
      modified24 = false;
      modified25 = true;
      modified26 = false;
      modified27 = false;
      toggleValue25 = !toggleValue25;
    });
  }

  toggleButton26() {
    setState(() {
      modified21 = false;
      modified22 = false;
      modified23 = false;
      modified24 = false;
      modified25 = false;
      modified26 = true;
      modified27 = false;
      toggleValue26 = !toggleValue26;
    });
  }

  toggleButton27() {
    setState(() {
      modified21 = false;
      modified22 = false;
      modified23 = false;
      modified24 = false;
      modified25 = false;
      modified26 = false;
      modified27 = true;
      toggleValue27 = !toggleValue27;
    });
  }

  var selected;
   showSetHour(int index1, int index2) {
    if (index1 == 1 && index2 == 1) {
      if (widget.client.sessionsFirstWeek.day1.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day1 == 'true') {
          return widget.client.scheduleFirstWeek.day1.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day1.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 1 && index2 == 2) {
      if (widget.client.sessionsFirstWeek.day2.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day2 == 'true') {
          return widget.client.scheduleFirstWeek.day2.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day2.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 1 && index2 == 3) {
      if (widget.client.sessionsFirstWeek.day3.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day3 == 'true') {
          return widget.client.scheduleFirstWeek.day3.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day3.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 1 && index2 == 4) {
      if (widget.client.sessionsFirstWeek.day4.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day4 == 'true') {
          return widget.client.scheduleFirstWeek.day4.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day4.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 1 && index2 == 5) {
      if (widget.client.sessionsFirstWeek.day5.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day5 == 'true') {
          return widget.client.scheduleFirstWeek.day5.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day5.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 1 && index2 == 6) {
      if (widget.client.sessionsFirstWeek.day6.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day6 == 'true') {
          return widget.client.scheduleFirstWeek.day6.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day6.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 1 && index2 == 7) {
      if (widget.client.sessionsFirstWeek.day7.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkFirstSchedule.day7 == 'true') {
          return widget.client.scheduleFirstWeek.day7.toDate().hour.toString() +
              " : " +
              widget.client.scheduleFirstWeek.day7.toDate().minute.toString();
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 1) {
      if (widget.client.sessionsSecondWeek.day1.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day1 == 'true') {
          return (widget.client.scheduleSecondWeek.day1.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day1
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day1
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day1.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day1
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 2) {
      if (widget.client.sessionsSecondWeek.day2.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day2 == 'true') {
          return (widget.client.scheduleSecondWeek.day2.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day2
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day2
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day2.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day2
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 3) {
      if (widget.client.sessionsSecondWeek.day3.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day3 == 'true') {
          return (widget.client.scheduleSecondWeek.day3.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day3
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day3
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day3.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day3
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 4) {
      if (widget.client.sessionsSecondWeek.day4.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day4 == 'true') {
          return (widget.client.scheduleSecondWeek.day4.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day4
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day4
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day4.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day4
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 5) {
      if (widget.client.sessionsSecondWeek.day5.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day5 == 'true') {
          return (widget.client.scheduleSecondWeek.day5.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day5
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day5
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day5.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day5
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 6) {
      if (widget.client.sessionsSecondWeek.day6.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day6 == 'true') {
          return (widget.client.scheduleSecondWeek.day6.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day6
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day6
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day6.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day6
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }

    if (index1 == 2 && index2 == 7) {
      if (widget.client.sessionsSecondWeek.day7.toString() == "Icons.hotel")
        return "";
      else {
        if (widget.client.checkSecondSchedule.day7 == 'true') {
          return (widget.client.scheduleSecondWeek.day7.toDate().hour.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day7
                          .toDate()
                          .hour
                          .toString())
                  : widget.client.scheduleSecondWeek.day7
                      .toDate()
                      .hour
                      .toString()) +
              " : " +
              (widget.client.scheduleSecondWeek.day7.toDate().minute.toInt() <
                      10
                  ? ("0" +
                      widget.client.scheduleSecondWeek.day7
                          .toDate()
                          .minute
                          .toString())
                  : widget.client.scheduleSecondWeek.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "Hour";
        }
      }
    }
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.client.sessionsSecondWeek.day1 == 'Icons.fitness_center') {
      toggleValue21 = false;
    } else {
      toggleValue21 = true;
    }
    if (widget.client.sessionsSecondWeek.day2 == 'Icons.fitness_center') {
      toggleValue22 = false;
    } else {
      toggleValue22 = true;
    }
    if (widget.client.sessionsSecondWeek.day3 == 'Icons.fitness_center') {
      toggleValue23 = false;
    } else {
      toggleValue23 = true;
    }
    if (widget.client.sessionsSecondWeek.day4 == 'Icons.fitness_center') {
      toggleValue24 = false;
    } else {
      toggleValue24 = true;
    }
    if (widget.client.sessionsSecondWeek.day5 == 'Icons.fitness_center') {
      toggleValue25 = false;
    } else {
      toggleValue25 = true;
    }
    if (widget.client.sessionsSecondWeek.day6 == 'Icons.fitness_center') {
      toggleValue26 = false;
    } else {
      toggleValue26 = true;
    }
    if (widget.client.sessionsSecondWeek.day7 == 'Icons.fitness_center') {
      toggleValue27 = false;
    } else {
      toggleValue27 = true;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              height: 495.5 * prefs.getDouble('height'),
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
                      'assets/schedule2f1.svg',
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
                        Text(
                          monthsOfTheYear[widget.client.scheduleSecondWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1] ==
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1]
                              ? monthsOfTheYear[widget
                                      .client.scheduleSecondWeek.day1
                                      .toDate()
                                      .month
                                      .toInt() -
                                  1]
                              : monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1] +
                                  " - " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(200, 255, 255, 255),
                          ),
                        ),
                        SizedBox(
                          height: 10 * prefs.getDouble('height'),
                        ),
                        Container(
                          height: 274 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 270 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      (widget.client.scheduleSecondWeek.day1
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day1
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day1
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                    Text(
                                      (widget.client.scheduleSecondWeek.day2
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day2
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day2
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                    Text(
                                      (widget.client.scheduleSecondWeek.day3
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day3
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day3
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                    Text(
                                      (widget.client.scheduleSecondWeek.day4
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day4
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day4
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                    Text(
                                      (widget.client.scheduleSecondWeek.day5
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day5
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day5
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                    Text(
                                      (widget.client.scheduleSecondWeek.day6
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day6
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day6
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                    Text(
                                      (widget.client.scheduleSecondWeek.day7
                                                      .toDate()
                                                      .day
                                                      .toInt() <
                                                  10
                                              ? "0"
                                              : "") +
                                          widget.client.scheduleSecondWeek.day7
                                              .toDate()
                                              .day
                                              .toString() +
                                          " - " +
                                          daysOfTheWeek[widget.client
                                                  .scheduleSecondWeek.day7
                                                  .toDate()
                                                  .weekday -
                                              1],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 25 * prefs.getDouble('height')),
                                height: 270 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 1)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day1 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day1 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day1;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day1
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.1':
                                                    transitionFinal2,
                                                'scheduleBool2.1': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day1 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day1 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 2)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day2 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day2 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day2;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day2
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.2':
                                                    transitionFinal2,
                                                'scheduleBool2.2': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day2 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day2 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 3)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day3 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day3 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day3;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day3
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.3':
                                                    transitionFinal2,
                                                'scheduleBool2.3': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day3 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day3 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 4)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day4 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day4 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day4;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day4
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.4':
                                                    transitionFinal2,
                                                'scheduleBool2.4': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day4 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day4 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 5)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day5 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day5 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day5;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day5
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.5':
                                                    transitionFinal2,
                                                'scheduleBool2.5': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day5 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day5 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 6)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day6 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day6 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day6;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day6
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.6':
                                                    transitionFinal2,
                                                'scheduleBool2.6': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day6 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day6 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 25 * prefs.getDouble('height'),
                                      child: GestureDetector(
                                        child: Center(
                                          child: Text(
                                            "${showSetHour(2, 7)}",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () async {
                                          if (widget.client.sessionsSecondWeek
                                                  .day7 ==
                                              'Icons.fitness_center') {
                                            selected =
                                                await _selectTime(context);
                                            DateTime transition;
                                            if (widget.client.scheduleSecondWeek
                                                .day7 is Timestamp) {
                                              Timestamp transitionFINAL = widget
                                                  .client
                                                  .scheduleSecondWeek
                                                  .day7;
                                              transition =
                                                  transitionFINAL.toDate();
                                            } else {
                                              transition = widget.client
                                                  .scheduleSecondWeek.day7
                                                  .toDate();
                                            }
                                            var transitionFinal1 =
                                                transition.subtract(
                                              Duration(
                                                  hours: transition.hour,
                                                  minutes: transition.minute),
                                            );
                                            var transitionFinal2 =
                                                transitionFinal1.add(
                                              Duration(
                                                  hours: selected.hour,
                                                  minutes: selected.minute),
                                            );
                                            widget.parent.batch.updateData(
                                              widget.parent.db
                                                  .collection('clientUsers')
                                                  .document(widget.client.id),
                                              {
                                                'scheduleHour2.7':
                                                    transitionFinal2,
                                                'scheduleBool2.7': 'true'
                                              },
                                            );
                                            setState(
                                              () {
                                                widget.parent.setState(() {
                                                  widget.parent
                                                      .scheduleChanged = true;
                                                });
                                                widget.client.scheduleSecondWeek
                                                        .day7 =
                                                    Timestamp.fromDate(
                                                        transitionFinal2);
                                                widget
                                                    .client
                                                    .checkSecondSchedule
                                                    .day7 = 'true';
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 270 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        toggleButton21();
                                        if (widget.client.sessionsSecondWeek
                                                .day1 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.1': 'Icons.hotel',
                                              'scheduleBool2.1': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day1 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day1 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.1':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day1 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue21
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue21
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue21
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified21 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day1
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue21
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        toggleButton22();
                                        if (widget.client.sessionsSecondWeek
                                                .day2 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.2': 'Icons.hotel',
                                              'scheduleBool2.2': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day2 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day2 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.2':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day2 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue22
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue22
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue22
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified22 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day2
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue22
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        toggleButton23();
                                        if (widget.client.sessionsSecondWeek
                                                .day3 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.3': 'Icons.hotel',
                                              'scheduleBool2.3': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day3 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day3 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.3':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day3 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue23
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue23
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue23
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified23 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day3
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue23
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        toggleButton24();
                                        if (widget.client.sessionsSecondWeek
                                                .day4 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.4': 'Icons.hotel',
                                              'scheduleBool2.4': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day4 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day4 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.4':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day4 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue24
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue24
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue24
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified24 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day4
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue24
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        toggleButton25();
                                        if (widget.client.sessionsSecondWeek
                                                .day5 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.5': 'Icons.hotel',
                                              'scheduleBool2.5': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day5 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day5 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.5':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day5 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue25
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue25
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue25
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified25 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day5
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue25
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        toggleButton26();
                                        if (widget.client.sessionsSecondWeek
                                                .day6 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.6': 'Icons.hotel',
                                              'scheduleBool2.6': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day6 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day6 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.6':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day6 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue26
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue26
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue26
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified26 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day6
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue26
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        toggleButton27();
                                        if (widget.client.sessionsSecondWeek
                                                .day7 ==
                                            'Icons.fitness_center') {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.7': 'Icons.hotel',
                                              'scheduleBool2.7': 'false'
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                  .day7 = 'Icons.hotel';
                                              widget.client.checkSecondSchedule
                                                  .day7 = 'false';
                                            },
                                          );
                                        } else {
                                          widget.parent.batch.updateData(
                                            widget.parent.db
                                                .collection('clientUsers')
                                                .document(widget.client.id),
                                            {
                                              'schedule2.7':
                                                  'Icons.fitness_center',
                                            },
                                          );
                                          setState(
                                            () {
                                              widget.parent.setState(() {
                                                widget.parent.scheduleChanged =
                                                    true;
                                              });
                                              widget.client.sessionsSecondWeek
                                                      .day7 =
                                                  'Icons.fitness_center';
                                            },
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 400,
                                        ),
                                        height: 25 * prefs.getDouble('height'),
                                        width: 60 * prefs.getDouble('width'),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0 *
                                                  prefs.getDouble('height')),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: toggleValue27
                                              ? prefix0.backgroundColor
                                              : prefix0.mainColor,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                              top: 2,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.easeIn,
                                              left: toggleValue27
                                                  ? 25.0 *
                                                      prefs.getDouble('width')
                                                  : 0.0,
                                              right: toggleValue27
                                                  ? 0.0
                                                  : 30.0 *
                                                      prefs.getDouble('width'),
                                              child: AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 400),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return modified27 == false
                                                        ? showIcon(widget
                                                            .client
                                                            .sessionsSecondWeek
                                                            .day7
                                                            .toString())
                                                        : RotationTransition(
                                                            child: child,
                                                            turns: animation,
                                                          );
                                                  },
                                                  child: toggleValue27
                                                      ? Icon(
                                                          Icons.hotel,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )
                                                      : Icon(
                                                          Icons.fitness_center,
                                                          color: Colors.white,
                                                          size: 17 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          key: UniqueKey(),
                                                        )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
        ],
      ),
    );
  }
}

class DetailsPopUp2 extends PopupRoute<void> {
  DetailsPopUp2(
      {this.parent, this.trainerUser, this.day, this.client, this.index});
  final int index;
  final ClientUser client;
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
      DetailsPage2(
          trainer: trainerUser, parent: parent, day: day, client: client, index: index);

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
      this.index});
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
        index:index
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage3 extends StatefulWidget {
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
      this.client, @required this.index})
      : super(key: key);

  @override
  State createState() => DetailsPage3State(index: index);
}

class DetailsPage3State extends State<DetailsPage3> {
  String hinttText = "Scrie";
  Image image;
  final int index;
  String hintName, hintStreet, hintSector;
DetailsPage3State(
      {Key key,@required this.index});
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
                                text: (transitionFinal2 == null ||
                                        transitionFinal2 == "")
                                    ? "hh:mm"
                                    : ((transitionFinal2.hour < 10
                                            ? ("0" +
                                                transitionFinal2.hour
                                                    .toString())
                                            : transitionFinal2.hour
                                                .toString()) +
                                        ":" +
                                        (transitionFinal2.minute < 10
                                            ? ("0" +
                                                transitionFinal2.minute
                                                    .toString())
                                            : transitionFinal2.minute
                                                .toString())),
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
                                  text: (transitionFinal2End == null ||
                                          transitionFinal2End == "")
                                      ? "hh:mm"
                                      : ((transitionFinal2End.hour < 10
                                              ? ("0" +
                                                  transitionFinal2End.hour
                                                      .toString())
                                              : transitionFinal2End.hour
                                                  .toString()) +
                                          ":" +
                                          (transitionFinal2End.minute < 10
                                              ? ("0" +
                                                  transitionFinal2End.minute
                                                      .toString())
                                              : transitionFinal2End.minute
                                                  .toString())),
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
                                color: prefix0.mainColor,
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
                                      hours: selected.hour ,
                                      minutes: selected.minute),
                                );
                                setState(
                                  () {
                                    widget.parent.setState(() {
                                      widget.parent.scheduleChanged = true;
                                    });
                                    widget.client.checkFirstSchedule.day1 =
                                        'true';
                                  },
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
                                      hours: selected.hour ,
                                      minutes: selected.minute),
                                );

                                setState(
                                  () {
                                    widget.parent.setState(() {
                                      widget.parent.scheduleChanged = true;
                                    });
                                    widget.client.checkFirstSchedule.day1 =
                                        'true';
                                  },
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
                          await Firestore.instance
                              .collection('clientUsers')
                              .document(widget.client.id)
                              .updateData(
                            {
                              'scheduleHour1End.$index': transitionFinal2End,
                              'scheduleHour1.$index': transitionFinal2,
                              'scheduleBool1.$index': 'true',
                              'trainingSessionLocationName.$index':
                                  widget.locationName,
                              'trainingSessionLocationStreet.$index':
                                  widget.locationStreet,
                              'trainingSessionTrainerName.$index':
                                  "${widget.trainer.firstName} ${widget.trainer.lastName}",
                              'trainingSessionTrainerId.$index': widget.trainer.id,
                            },
                          );
                          Navigator.of(context).pop();
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
      this.client, this.index})
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
                  parent: widget.parent));
        });
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
                              setState(() {});
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
