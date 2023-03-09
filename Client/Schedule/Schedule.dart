import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/models/clientUser.dart';

import 'package:Bsharkr/colors.dart' as prefix0;

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
  "October",
  "November",
  "December"
];

class MySchedule extends StatefulWidget {
  final ClientUser client;
  MySchedule({this.client});
  @override
  State createState() => MyScheduleState();
}

class MyScheduleState extends State<MySchedule> {
  List<bool> isSelected = [true, false];

  String hinttText = "Scrie";
  Image image;
  var selected;
  String hintName, hintStreet, hintSector;

  int currentPage = 0;

  Future _getMyData;

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.client.scheduleUpdated == true) {
      Firestore.instance
          .collection('clientUsers')
          .document(widget.client.id)
          .updateData(
        {
          'scheduleUpdated': FieldValue.delete(),
        },
      );
    }

    return Container(
      child: Stack(
        overflow: Overflow.visible,
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
              ),
              SecondPage(
                client: widget.client,
              ),
              ThirdPage(
                client: widget.client,
              ),
              FourthPage(
                client: widget.client,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8 * prefs.getDouble('height')),
                          child: Container(
                height: 10 * prefs.getDouble('height'),
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
                      width: 42 * prefs.getDouble('width'),
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
                      width: 42 * prefs.getDouble('width'),
                    ),

                    SizedBox(
                      width: 10 * prefs.getDouble('width'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: currentPage == 2
                              ? prefix0.mainColor
                              : prefix0.secondaryColor),
                      height: 8 * prefs.getDouble('height'),
                      width: 42 * prefs.getDouble('width'),
                    ),
                    SizedBox(
                      width: 10 * prefs.getDouble('width'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: currentPage == 3
                              ? prefix0.mainColor
                              : prefix0.secondaryColor),
                      height: 8 * prefs.getDouble('height'),
                      width: 42 * prefs.getDouble('width'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  ClientUser client;
  FirstPage({@required this.client});
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  var selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 346 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff3E3E45)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.client.checkFirstSchedule.day1 == 'true'
                    ? Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    daysOfTheWeek[widget
                                                .client.scheduleFirstWeek.day1
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
                                        widget.client.scheduleFirstWeek.day1
                                            .toDate()
                                            .day
                                            .toString() +
                                        " " +
                                        monthsOfTheYear[widget
                                                .client.scheduleFirstWeek.day1
                                                .toDate()
                                                .month
                                                .toInt() -
                                            1],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget
                                                    .client.scheduleFirstWeek.day1 ==
                                                null
                                            ? "hh:mm"
                                            : ((widget
                                                            .client.scheduleFirstWeek.day1
                                                            .toDate()
                                                            .hour <
                                                        10
                                                    ? ("0" +
                                                        widget.client
                                                            .scheduleFirstWeek.day1
                                                            .toDate()
                                                            .hour
                                                            .toString())
                                                    : widget
                                                        .client.scheduleFirstWeek.day1
                                                        .toDate()
                                                        .hour
                                                        .toString()) +
                                                ":" +
                                                (widget.client.scheduleFirstWeek
                                                            .day1
                                                            .toDate()
                                                            .minute <
                                                        10
                                                    ? ("0" +
                                                        widget
                                                            .client
                                                            .scheduleFirstWeek
                                                            .day1
                                                            .toDate()
                                                            .minute
                                                            .toString())
                                                    : widget.client
                                                        .scheduleFirstWeek.day1
                                                        .toDate()
                                                        .minute
                                                        .toString())),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                13 * prefs.getDouble('height'),
                                            letterSpacing: -0.078,
                                            fontFamily: 'Roboto'),
                                      ),
                                      TextSpan(
                                          text: " - ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.066,
                                              fontFamily: 'Roboto')),
                                      TextSpan(
                                          text: widget.client.scheduleFirstEndWeek.day1 == null
                                              ? "hh:mm"
                                              : ((widget.client.scheduleFirstEndWeek.day1.toDate().hour < 10
                                                      ? ("0" +
                                                          widget.client.scheduleFirstEndWeek.day1
                                                              .toDate()
                                                              .hour
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleFirstEndWeek
                                                          .day1
                                                          .toDate()
                                                          .hour
                                                          .toString()) +
                                                  ":" +
                                                  (widget.client.scheduleFirstEndWeek.day1.toDate().minute < 10
                                                      ? ("0" +
                                                          widget.client.scheduleFirstEndWeek.day1
                                                              .toDate()
                                                              .minute
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleFirstEndWeek
                                                          .day1
                                                          .toDate()
                                                          .minute
                                                          .toString())),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 * prefs.getDouble('height'),
                                              letterSpacing: -0.078,
                                              fontFamily: 'Roboto')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4 * prefs.getDouble('height')),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Workout with ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        "${widget.client.trainingSessionTrainerName.day1}",
                                    style: TextStyle(
                                        color: prefix0.mainColor,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        ", ${widget.client.trainingSessionLocationName.day1} - at ${widget.client.trainingSessionLocationStreet.day1}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day1
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
                                  widget.client.scheduleFirstWeek.day1
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,),
                                  
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
                widget.client.checkFirstSchedule.day2 == 'true' ? 
                Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day2
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
                                  widget.client.scheduleFirstWeek.day2
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day2
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleFirstWeek.day2 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleFirstWeek
                                                      .day2
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day2
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day2
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleFirstWeek
                                                      .day2
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day2
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day2
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleFirstEndWeek.day2 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleFirstEndWeek.day2.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day1
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleFirstEndWeek.day2
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleFirstEndWeek.day2.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day2
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleFirstEndWeek.day2
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day2}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day2} - at ${widget.client.trainingSessionLocationStreet.day2}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day2
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
                                  widget.client.scheduleFirstWeek.day2
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day2
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
               widget.client.checkFirstSchedule.day3 == 'true' ? Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day3
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
                                  widget.client.scheduleFirstWeek.day3
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day3
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleFirstWeek.day3 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleFirstWeek
                                                      .day3
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day3
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day3
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleFirstWeek
                                                      .day3
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day3
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day3
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleFirstEndWeek.day3 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleFirstEndWeek.day3.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day3
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleFirstEndWeek.day3
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleFirstEndWeek.day3.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day3
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleFirstEndWeek.day3
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day3}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day3} - at ${widget.client.trainingSessionLocationStreet.day3}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day3
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
                                  widget.client.scheduleFirstWeek.day3
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day3
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
               widget.client.checkFirstSchedule.day4 == 'true' ? Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day4
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
                                  widget.client.scheduleFirstWeek.day4
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day4
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleFirstWeek.day4 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleFirstWeek
                                                      .day4
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day4
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day4
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleFirstWeek
                                                      .day4
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day4
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day4
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleFirstEndWeek.day4 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleFirstEndWeek.day4.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day4
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleFirstEndWeek.day4
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleFirstEndWeek.day4.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day4
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleFirstEndWeek.day4
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day4}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day4} - at ${widget.client.trainingSessionLocationStreet.day4}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day4
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
                                  widget.client.scheduleFirstWeek.day4
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day4
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SecondPage extends StatefulWidget {
  ClientUser client;
  SecondPage({@required this.client});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 346 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff3E3E45)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.client.checkFirstSchedule.day5 == 'true'
                    ? Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    daysOfTheWeek[widget
                                                .client.scheduleFirstWeek.day5
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
                                        widget.client.scheduleFirstWeek.day5
                                            .toDate()
                                            .day
                                            .toString() +
                                        " " +
                                        monthsOfTheYear[widget
                                                .client.scheduleFirstWeek.day5
                                                .toDate()
                                                .month
                                                .toInt() -
                                            1],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget
                                                    .client.scheduleFirstWeek.day5 ==
                                                null
                                            ? "hh:mm"
                                            : ((widget
                                                            .client.scheduleFirstWeek.day5
                                                            .toDate()
                                                            .hour <
                                                        10
                                                    ? ("0" +
                                                        widget.client
                                                            .scheduleFirstWeek.day5
                                                            .toDate()
                                                            .hour
                                                            .toString())
                                                    : widget
                                                        .client.scheduleFirstWeek.day5
                                                        .toDate()
                                                        .hour
                                                        .toString()) +
                                                ":" +
                                                (widget.client.scheduleFirstWeek
                                                            .day5
                                                            .toDate()
                                                            .minute <
                                                        10
                                                    ? ("0" +
                                                        widget
                                                            .client
                                                            .scheduleFirstWeek
                                                            .day5
                                                            .toDate()
                                                            .minute
                                                            .toString())
                                                    : widget.client
                                                        .scheduleFirstWeek.day5
                                                        .toDate()
                                                        .minute
                                                        .toString())),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                13 * prefs.getDouble('height'),
                                            letterSpacing: -0.078,
                                            fontFamily: 'Roboto'),
                                      ),
                                      TextSpan(
                                          text: " - ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.066,
                                              fontFamily: 'Roboto')),
                                      TextSpan(
                                          text: widget.client.scheduleFirstEndWeek.day5 == null
                                              ? "hh:mm"
                                              : ((widget.client.scheduleFirstEndWeek.day5.toDate().hour < 10
                                                      ? ("0" +
                                                          widget.client.scheduleFirstEndWeek.day5
                                                              .toDate()
                                                              .hour
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleFirstEndWeek
                                                          .day5
                                                          .toDate()
                                                          .hour
                                                          .toString()) +
                                                  ":" +
                                                  (widget.client.scheduleFirstEndWeek.day5.toDate().minute < 10
                                                      ? ("0" +
                                                          widget.client.scheduleFirstEndWeek.day5
                                                              .toDate()
                                                              .minute
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleFirstEndWeek
                                                          .day5
                                                          .toDate()
                                                          .minute
                                                          .toString())),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 * prefs.getDouble('height'),
                                              letterSpacing: -0.078,
                                              fontFamily: 'Roboto')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4 * prefs.getDouble('height')),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Workout with ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        "${widget.client.trainingSessionTrainerName.day5}",
                                    style: TextStyle(
                                        color: prefix0.mainColor,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        ", ${widget.client.trainingSessionLocationName.day5} - at ${widget.client.trainingSessionLocationStreet.day5}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day5
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
                                  widget.client.scheduleFirstWeek.day5
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day5
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
                widget.client.checkFirstSchedule.day6 == 'true' ? 
                Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day6
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
                                  widget.client.scheduleFirstWeek.day6
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day6
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleFirstWeek.day6 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleFirstWeek
                                                      .day6
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day6
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day6
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleFirstWeek
                                                      .day6
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day6
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day6
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleFirstEndWeek.day6 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleFirstEndWeek.day6.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day6
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleFirstEndWeek.day6
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleFirstEndWeek.day6.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day6
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleFirstEndWeek.day6
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day6}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day6} - at ${widget.client.trainingSessionLocationStreet.day6}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day6
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
                                  widget.client.scheduleFirstWeek.day6
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day6
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
               widget.client.checkFirstSchedule.day7 == 'true' ? Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day7
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
                                  widget.client.scheduleFirstWeek.day7
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleFirstWeek.day7 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleFirstWeek
                                                      .day7
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day7
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day7
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleFirstWeek
                                                      .day7
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleFirstWeek.day7
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleFirstWeek.day7
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleFirstEndWeek.day7 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleFirstEndWeek.day7.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day7
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleFirstEndWeek.day7
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleFirstEndWeek.day7.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleFirstEndWeek
                                                        .day7
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleFirstEndWeek.day7
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day7}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day7} - at ${widget.client.trainingSessionLocationStreet.day7}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleFirstWeek.day7
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
                                  widget.client.scheduleFirstWeek.day7
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleFirstWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
               widget.client.checkSecondSchedule.day1 == 'true' ? Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day1
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
                                  widget.client.scheduleSecondWeek.day1
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleSecondWeek.day1 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleSecondWeek
                                                      .day4
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day1
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day1
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleSecondWeek
                                                      .day1
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day1
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day1
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleSecondEndWeek.day1 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleSecondEndWeek.day1.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day1
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleSecondEndWeek.day1
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleSecondEndWeek.day1.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day1
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleSecondEndWeek.day1
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day8}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day8} - at ${widget.client.trainingSessionLocationStreet.day8}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day1
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
                                  widget.client.scheduleSecondWeek.day1
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day1
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class ThirdPage extends StatefulWidget {
  ClientUser client;
  ThirdPage({@required this.client});
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 346 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff3E3E45)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.client.checkSecondSchedule.day2 == 'true'
                    ? Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    daysOfTheWeek[widget
                                                .client.scheduleSecondWeek.day2
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
                                        widget.client.scheduleSecondWeek.day2
                                            .toDate()
                                            .day
                                            .toString() +
                                        " " +
                                        monthsOfTheYear[widget
                                                .client.scheduleSecondWeek.day2
                                                .toDate()
                                                .month
                                                .toInt() -
                                            1],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget
                                                    .client.scheduleSecondWeek.day2 ==
                                                null
                                            ? "hh:mm"
                                            : ((widget
                                                            .client.scheduleSecondWeek.day2
                                                            .toDate()
                                                            .hour <
                                                        10
                                                    ? ("0" +
                                                        widget.client
                                                            .scheduleSecondWeek.day2
                                                            .toDate()
                                                            .hour
                                                            .toString())
                                                    : widget
                                                        .client.scheduleSecondWeek.day2
                                                        .toDate()
                                                        .hour
                                                        .toString()) +
                                                ":" +
                                                (widget.client.scheduleSecondWeek
                                                            .day2
                                                            .toDate()
                                                            .minute <
                                                        10
                                                    ? ("0" +
                                                        widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day2
                                                            .toDate()
                                                            .minute
                                                            .toString())
                                                    : widget.client
                                                        .scheduleSecondWeek.day2
                                                        .toDate()
                                                        .minute
                                                        .toString())),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                13 * prefs.getDouble('height'),
                                            letterSpacing: -0.078,
                                            fontFamily: 'Roboto'),
                                      ),
                                      TextSpan(
                                          text: " - ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.066,
                                              fontFamily: 'Roboto')),
                                      TextSpan(
                                          text: widget.client.scheduleSecondEndWeek.day2 == null
                                              ? "hh:mm"
                                              : ((widget.client.scheduleSecondEndWeek.day2.toDate().hour < 10
                                                      ? ("0" +
                                                          widget.client.scheduleSecondEndWeek.day2
                                                              .toDate()
                                                              .hour
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleSecondEndWeek
                                                          .day2
                                                          .toDate()
                                                          .hour
                                                          .toString()) +
                                                  ":" +
                                                  (widget.client.scheduleSecondEndWeek.day2.toDate().minute < 10
                                                      ? ("0" +
                                                          widget.client.scheduleSecondEndWeek.day2
                                                              .toDate()
                                                              .minute
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleSecondEndWeek
                                                          .day2
                                                          .toDate()
                                                          .minute
                                                          .toString())),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 * prefs.getDouble('height'),
                                              letterSpacing: -0.078,
                                              fontFamily: 'Roboto')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4 * prefs.getDouble('height')),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Workout with ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        "${widget.client.trainingSessionTrainerName.day9}",
                                    style: TextStyle(
                                        color: prefix0.mainColor,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        ", ${widget.client.trainingSessionLocationName.day9} - at ${widget.client.trainingSessionLocationStreet.day9}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day2
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
                                  widget.client.scheduleSecondWeek.day2
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day2
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
                widget.client.checkSecondSchedule.day3 == 'true' ? 
                Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day3
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
                                  widget.client.scheduleSecondWeek.day3
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day3
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleSecondWeek.day3 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleSecondWeek
                                                      .day3
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day3
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day3
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleSecondWeek
                                                      .day3
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day3
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day3
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleSecondEndWeek.day3 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleSecondEndWeek.day3.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day3
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleSecondEndWeek.day3
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleSecondEndWeek.day3.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day3
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleSecondEndWeek.day3
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day10}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day10} - at ${widget.client.trainingSessionLocationStreet.day10}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day3
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
                                  widget.client.scheduleSecondWeek.day3
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day3
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
               widget.client.checkSecondSchedule.day4 == 'true' ? Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day4
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
                                  widget.client.scheduleSecondWeek.day4
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day4
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleSecondWeek.day4 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleSecondWeek
                                                      .day4
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day4
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day4
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleSecondWeek
                                                      .day4
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day4
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day4
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleSecondEndWeek.day4 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleSecondEndWeek.day4.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day4
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleSecondEndWeek.day4
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleSecondEndWeek.day4.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day4
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleSecondEndWeek.day4
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day11}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day11} - at ${widget.client.trainingSessionLocationStreet.day11}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day4
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
                                  widget.client.scheduleSecondWeek.day4
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day4
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
               widget.client.checkSecondSchedule.day5 == 'true' ? Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day5
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
                                  widget.client.scheduleSecondWeek.day5
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day5
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleSecondWeek.day5 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleSecondWeek
                                                      .day4
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day5
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day5
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleSecondWeek
                                                      .day5
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day5
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day5
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleSecondEndWeek.day5 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleSecondEndWeek.day5.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day5
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleSecondEndWeek.day5
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleSecondEndWeek.day5.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day5
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleSecondEndWeek.day5
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day12}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day12} - at ${widget.client.trainingSessionLocationStreet.day12}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day5
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
                                  widget.client.scheduleSecondWeek.day5
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day5
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class FourthPage extends StatefulWidget {
  ClientUser client;
  FourthPage({@required this.client});
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 173 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff3E3E45)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.client.checkSecondSchedule.day6 == 'true'
                    ? Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    daysOfTheWeek[widget
                                                .client.scheduleSecondWeek.day6
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
                                        widget.client.scheduleSecondWeek.day6
                                            .toDate()
                                            .day
                                            .toString() +
                                        " " +
                                        monthsOfTheYear[widget
                                                .client.scheduleSecondWeek.day6
                                                .toDate()
                                                .month
                                                .toInt() -
                                            1],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: widget
                                                    .client.scheduleSecondWeek.day6 ==
                                                null
                                            ? "hh:mm"
                                            : ((widget
                                                            .client.scheduleSecondWeek.day6
                                                            .toDate()
                                                            .hour <
                                                        10
                                                    ? ("0" +
                                                        widget.client
                                                            .scheduleSecondWeek.day6
                                                            .toDate()
                                                            .hour
                                                            .toString())
                                                    : widget
                                                        .client.scheduleSecondWeek.day6
                                                        .toDate()
                                                        .hour
                                                        .toString()) +
                                                ":" +
                                                (widget.client.scheduleSecondWeek
                                                            .day6
                                                            .toDate()
                                                            .minute <
                                                        10
                                                    ? ("0" +
                                                        widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day6
                                                            .toDate()
                                                            .minute
                                                            .toString())
                                                    : widget.client
                                                        .scheduleSecondWeek.day6
                                                        .toDate()
                                                        .minute
                                                        .toString())),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                13 * prefs.getDouble('height'),
                                            letterSpacing: -0.078,
                                            fontFamily: 'Roboto'),
                                      ),
                                      TextSpan(
                                          text: " - ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.066,
                                              fontFamily: 'Roboto')),
                                      TextSpan(
                                          text: widget.client.scheduleSecondEndWeek.day6 == null
                                              ? "hh:mm"
                                              : ((widget.client.scheduleSecondEndWeek.day6.toDate().hour < 10
                                                      ? ("0" +
                                                          widget.client.scheduleSecondEndWeek.day6
                                                              .toDate()
                                                              .hour
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleSecondEndWeek
                                                          .day6
                                                          .toDate()
                                                          .hour
                                                          .toString()) +
                                                  ":" +
                                                  (widget.client.scheduleSecondEndWeek.day6.toDate().minute < 10
                                                      ? ("0" +
                                                          widget.client.scheduleSecondEndWeek.day6
                                                              .toDate()
                                                              .minute
                                                              .toString())
                                                      : widget
                                                          .client
                                                          .scheduleSecondEndWeek
                                                          .day6
                                                          .toDate()
                                                          .minute
                                                          .toString())),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13 * prefs.getDouble('height'),
                                              letterSpacing: -0.078,
                                              fontFamily: 'Roboto')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4 * prefs.getDouble('height')),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Workout with ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        "${widget.client.trainingSessionTrainerName.day13}",
                                    style: TextStyle(
                                        color: prefix0.mainColor,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                  TextSpan(
                                    text:
                                        ", ${widget.client.trainingSessionLocationName.day13} - at ${widget.client.trainingSessionLocationStreet.day13}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        letterSpacing: -0.078),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day6
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
                                  widget.client.scheduleSecondWeek.day6
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day6
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
                Container(
                  height: 1.0 * prefs.getDouble('height'),
                  color: Color(0xff57575E),
                ),
                widget.client.checkSecondSchedule.day7 == 'true' ? 
                Container(
                  height: 85 * prefs.getDouble('height'),
                  padding: EdgeInsets.fromLTRB(
                      16 * prefs.getDouble('width'),
                      16 * prefs.getDouble('height'),
                      16 * prefs.getDouble('width'),
                      16),
                  width: 294 * prefs.getDouble('width'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day7
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
                                  widget.client.scheduleSecondWeek.day7
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.client.scheduleSecondWeek.day7 ==
                                          null
                                      ? "hh:mm"
                                      : ((widget.client.scheduleSecondWeek
                                                      .day7
                                                      .toDate()
                                                      .hour <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day7
                                                      .toDate()
                                                      .hour
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day7
                                                  .toDate()
                                                  .hour
                                                  .toString()) +
                                          ":" +
                                          (widget.client.scheduleSecondWeek
                                                      .day7
                                                      .toDate()
                                                      .minute <
                                                  10
                                              ? ("0" +
                                                  widget.client
                                                      .scheduleSecondWeek.day7
                                                      .toDate()
                                                      .minute
                                                      .toString())
                                              : widget
                                                  .client.scheduleSecondWeek.day7
                                                  .toDate()
                                                  .minute
                                                  .toString())),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.078,
                                      fontFamily: 'Roboto'),
                                ),
                                TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontFamily: 'Roboto')),
                                TextSpan(
                                    text: widget.client.scheduleSecondEndWeek.day7 == null
                                        ? "hh:mm"
                                        : ((widget.client.scheduleSecondEndWeek.day7.toDate().hour < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day7
                                                        .toDate()
                                                        .hour
                                                        .toString())
                                                : widget.client.scheduleSecondEndWeek.day7
                                                    .toDate()
                                                    .hour
                                                    .toString()) +
                                            ":" +
                                            (widget.client.scheduleSecondEndWeek.day7.toDate().minute < 10
                                                ? ("0" +
                                                    widget
                                                        .client
                                                        .scheduleSecondEndWeek
                                                        .day7
                                                        .toDate()
                                                        .minute
                                                        .toString())
                                                : widget.client
                                                    .scheduleSecondEndWeek.day7
                                                    .toDate()
                                                    .minute
                                                    .toString())),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * prefs.getDouble('height')),
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
                                  "${widget.client.trainingSessionTrainerName.day14}",
                              style: TextStyle(
                                  color: prefix0.mainColor,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                            TextSpan(
                              text:
                                  ", ${widget.client.trainingSessionLocationName.day14} - at ${widget.client.trainingSessionLocationStreet.day14}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :Container(
                        height: 85 * prefs.getDouble('height'),
                        padding: EdgeInsets.fromLTRB(
                            16 * prefs.getDouble('width'),
                            16 * prefs.getDouble('height'),
                            16 * prefs.getDouble('width'),
                            16),
                        width: 294 * prefs.getDouble('width'),
                        child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              daysOfTheWeek[widget.client.scheduleSecondWeek.day7
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
                                  widget.client.scheduleSecondWeek.day7
                                      .toDate()
                                      .day
                                      .toString() +
                                  " " +
                                  monthsOfTheYear[widget
                                          .client.scheduleSecondWeek.day7
                                          .toDate()
                                          .month
                                          .toInt() -
                                      1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13 * prefs.getDouble('height'),
                                  letterSpacing: -0.078,
                                  fontFamily: 'Roboto')),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Rest day   ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 * prefs.getDouble('height'),
                                        letterSpacing: -0.078,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.hotel, color: prefix0.mainColor, size: 20 * prefs.getDouble('height'))],
                            )
                        ],
                      ),
                      SizedBox(height: 2 * prefs.getDouble('height')),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Contact your trainer to set up a training session, if you feel like!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11 * prefs.getDouble('height'),
                                  letterSpacing: -0.078),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
