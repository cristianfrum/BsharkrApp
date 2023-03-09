import 'dart:async';
import 'dart:math';

import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Classes/DateTimePicker.dart';

import 'package:Bsharkr/Trainer/Classes/EditProfilePageCards.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierChart.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierConfig.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierLine.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/TrainerProfileVisists.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddNewClass extends StatefulWidget {
  final TrainerUser imTrainer;
  AddNewClass({this.imTrainer});
  @override
  _AddNewClassState createState() => _AddNewClassState();
}

class _AddNewClassState extends State<AddNewClass> {
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

  bool toggleValue = false;
  String classLevel;
  String locationName;
  String locationStreet;
  String locationDistrict;
  String individualPrice;
  String gymWebsite;
  String memberPrice;
  int spots;
  String dateAndTime;
  bool dateTextFieldColor1 = false;
  String durationString;
  String type;
  DateTime duration;
  bool dateTextFieldColor = false;
  bool dateSessionType = false;
  DateTime dateAndTimeDateTime;

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: secondaryColor,
            title: Text(
              "Add Class",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22 * prefs.getDouble('height'),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Builder(
            builder: (context) => Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      height: 65 * prefs.getDouble('height'),
                      width: 343 * prefs.getDouble('width'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  DetailsPopUp1(
                                      trainerUser: widget.imTrainer,
                                      parent: this));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 88, 88, 94),
                                  borderRadius: BorderRadius.circular(90.0),
                                  border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 2 * prefs.getDouble('height'))),
                              height: 60 * prefs.getDouble('height'),
                              width: 171 * prefs.getDouble('width'),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 14 * prefs.getDouble('width')),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.event,
                                            color: Color.fromARGB(
                                                255, 152, 152, 157),
                                            size:
                                                26 * prefs.getDouble('height')),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 14 *
                                                  prefs.getDouble('width')),
                                          child: Text(
                                            classLevel == null
                                                ? "Class level"
                                                : "$classLevel",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 15.0 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  DetailsPopUp(
                                      trainerUser: widget.imTrainer,
                                      parent: this));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 88, 88, 94),
                                  borderRadius: BorderRadius.circular(90.0),
                                  border: Border.all(
                                      color: dateSessionType == false
                                          ? Colors.black
                                          : mainColor,
                                      style: BorderStyle.solid,
                                      width: 2 * prefs.getDouble('height'))),
                              height: 60 * prefs.getDouble('height'),
                              width: 171 * prefs.getDouble('width'),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 14 * prefs.getDouble('width')),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          type == null
                                              ? "Session type"
                                              : "$type",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 15.0 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white),
                                          textAlign: TextAlign.right,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 14 *
                                                  prefs.getDouble('width')),
                                          child: Icon(Icons.fitness_center,
                                              color: Color.fromARGB(
                                                  255, 152, 152, 157),
                                              size: 26 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            DetailsPopUp2(
                                trainerUser: widget.imTrainer, parent: this));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 88, 88, 94),
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        height: 60 * prefs.getDouble('height'),
                        width: 343 * prefs.getDouble('width'),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 14 * prefs.getDouble('width')),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.location_on,
                                      color: Color.fromARGB(255, 152, 152, 157),
                                      size: 26 * prefs.getDouble('height')),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 14 * prefs.getDouble('width')),
                                    child: Text(
                                      locationName == null
                                          ? "Location"
                                          : "$locationName",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              15.0 * prefs.getDouble('height'),
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      height: 65 * prefs.getDouble('height'),
                      width: 343 * prefs.getDouble('width'),
                      child: TextField(
                        keyboardAppearance: Brightness.dark,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15.0 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        decoration: new InputDecoration(
                            hasFloatingPlaceholder: false,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0 * prefs.getDouble('height')),
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
                                  horizontal: 14 * prefs.getDouble('width')),
                              child: Icon(Icons.attach_money,
                                  color: Color.fromARGB(255, 152, 152, 157),
                                  size: 26 * prefs.getDouble('height')),
                            ),
                            hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            border: InputBorder.none,
                            labelText: 'Individual price(ex: 50 RON)'),
                        onChanged: (String str) {
                          setState(() {
                            // prefs.setString('email', str);
                            individualPrice = str;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      height: 65 * prefs.getDouble('height'),
                      width: 343 * prefs.getDouble('width'),
                      child: TextField(
                        keyboardAppearance: Brightness.dark,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15.0 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        decoration: new InputDecoration(
                            hasFloatingPlaceholder: false,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0 * prefs.getDouble('height')),
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
                                  horizontal: 14 * prefs.getDouble('width')),
                              child: Icon(Icons.attach_money,
                                  color: Color.fromARGB(255, 152, 152, 157),
                                  size: 26 * prefs.getDouble('height')),
                            ),
                            hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            border: InputBorder.none,
                            labelText: 'Member price(ex: 50 RON)'),
                        onChanged: (String str) {
                          setState(() {
                            // prefs.setString('email', str);
                            memberPrice = str;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      height: 65 * prefs.getDouble('height'),
                      width: 343 * prefs.getDouble('width'),
                      child: TextField(
                        keyboardAppearance: Brightness.dark,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15.0 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        decoration: new InputDecoration(
                            hasFloatingPlaceholder: false,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0 * prefs.getDouble('height')),
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
                                  horizontal: 14 * prefs.getDouble('width')),
                              child: Icon(Icons.people,
                                  color: Color.fromARGB(255, 152, 152, 157),
                                  size: 26 * prefs.getDouble('height')),
                            ),
                            hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            labelStyle: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            border: InputBorder.none,
                            labelText: 'Spots'),
                        onChanged: (String str) {
                          setState(() {
                            // prefs.setString('email', str);
                            spots = int.parse(str);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dateTextFieldColor = true;
                        });
                        DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(Duration(days: 6)),
                          onCancel: () {
                            setState(() {
                              dateTextFieldColor = false;
                            });
                          },
                          onChanged: (date) {},
                          onConfirm: (date) {
                            String hour = date.hour < 10
                                ? ("0" + date.hour.toString())
                                : date.hour.toString();
                            String minute = date.minute < 10
                                ? ("0" + date.minute.toString())
                                : date.minute.toString();

                            setState(() {
                              dateAndTimeDateTime = date;
                              dateAndTime = "${date.year}" +
                                  "-" +
                                  "${monthsOfTheYear[date.month - 1]}" +
                                  "-" +
                                  "${daysOfTheWeek[date.weekday - 1]}" +
                                  " " +
                                  hour +
                                  ":" +
                                  minute;
                              dateTextFieldColor = false;
                            });
                          },
                          currentTime: DateTime.now(),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 88, 88, 94),
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                                color: dateTextFieldColor == false
                                    ? Colors.black
                                    : mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        height: 55 * prefs.getDouble('height'),
                        width: 343 * prefs.getDouble('width'),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 14 * prefs.getDouble('width')),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.date_range,
                                      color: Color.fromARGB(255, 152, 152, 157),
                                      size: 26 * prefs.getDouble('height')),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 14 * prefs.getDouble('width')),
                                    child: Text(
                                      dateAndTime == null
                                          ? "Date and Time"
                                          : "$dateAndTime",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              15.0 * prefs.getDouble('height'),
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dateTextFieldColor1 = true;
                        });
                        DatePicker.showTimePicker(
                          context,
                          showTitleActions: true,
                          onCancel: () {
                            setState(() {
                              dateTextFieldColor1 = false;
                            });
                          },
                          onChanged: (date) {},
                          onConfirm: (date) {
                            String hour = date.hour < 10
                                ? ("0" + date.hour.toString())
                                : date.hour.toString();
                            String minute = date.minute < 10
                                ? ("0" + date.minute.toString())
                                : date.minute.toString();

                            setState(() {
                              duration = date;
                              durationString = hour + ":" + minute;
                              dateTextFieldColor1 = false;
                            });
                          },
                          currentTime:
                              DateTime.parse('1974-03-20 00:00:00.000'),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 88, 88, 94),
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                                color: dateTextFieldColor1 == false
                                    ? Colors.black
                                    : mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        height: 55 * prefs.getDouble('height'),
                        width: 343 * prefs.getDouble('width'),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 14 * prefs.getDouble('width')),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.access_alarm,
                                      color: Color.fromARGB(255, 152, 152, 157),
                                      size: 26 * prefs.getDouble('height')),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 14 * prefs.getDouble('width')),
                                    child: Text(
                                      duration == null
                                          ? "Duration"
                                          : "$durationString",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              15.0 * prefs.getDouble('height'),
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32 * prefs.getDouble('width')),
                      height: 43 * prefs.getDouble('height'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Make class public",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.0 * prefs.getDouble('height'),
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(210, 255, 255, 255)),
                          ),
                          InkWell(
                            onTap: () {
                              toggleButton();
                            },
                            child: AnimatedContainer(
                              duration: Duration(
                                milliseconds: 400,
                              ),
                              height: 25 * prefs.getDouble('height'),
                              width: 60 * prefs.getDouble('width'),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0 * prefs.getDouble('height')),
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    toggleValue ? mainColor : backgroundColor,
                              ),
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  AnimatedPositioned(
                                    top: 5.0 * prefs.getDouble('height'),
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn,
                                    left: toggleValue
                                        ? 25.0 * prefs.getDouble('width')
                                        : 5.0,
                                    right: toggleValue
                                        ? 5.0
                                        : 35.0 * prefs.getDouble('width'),
                                    child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 400),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return toggleValue == true
                                              ? Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              : RotationTransition(
                                                  child: child,
                                                  turns: animation,
                                                );
                                        },
                                        child: toggleValue
                                            ? Text("Yes",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 11.0 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w700,
                                                ))
                                            : Text("No",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 11.0 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w700,
                                                ))),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1.0 * prefs.getDouble('height'),
                      color: Color(0xff57575E),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0 * prefs.getDouble('height')),
                      child: Container(
                        width: 300.0 * prefs.getDouble('width'),
                        height: 50.0 * prefs.getDouble('height'),
                        child: Material(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(90.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (classLevel == null) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: const Text(
                                    'Class level is missing',
                                    textAlign: TextAlign.center,
                                  ),
                                ));
                              } else {
                                if (locationName == null ||
                                    locationDistrict == null ||
                                    locationStreet == null ||
                                    gymWebsite == null) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: const Text(
                                      'Location is missing',
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                                } else {
                                  if (individualPrice == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: const Text(
                                        'Individual price is missing',
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  } else {
                                    if (memberPrice == null) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                          'Member price is missing',
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
                                    } else {
                                      if (spots == null) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                            'Available spots are missing',
                                            textAlign: TextAlign.center,
                                          ),
                                        ));
                                      } else {
                                        if (type == null) {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                              'Session type is missing',
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                        } else {
                                          if (dateAndTime == null) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: const Text(
                                                'Date and time are missing',
                                                textAlign: TextAlign.center,
                                              ),
                                            ));
                                          } else {
                                            if (dateAndTimeDateTime == null) {
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: const Text(
                                                  'Date and time are missing',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ));
                                            } else {
                                              if (duration == null) {
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text(
                                                    'Class duration is missing',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ));
                                              } else {
                                                int aux = (widget.imTrainer
                                                        .counterClasses +
                                                    1);
                                                String auxType;
                                                int auxTypeCounter;
                                                if (type == 'Aerobic') {
                                                  auxType = 'aerobicCounter';
                                                  auxTypeCounter = widget
                                                          .imTrainer
                                                          .aerobicCounter +
                                                      1;
                                                } else {
                                                  if (type == 'Workout') {
                                                    auxTypeCounter = widget
                                                            .imTrainer
                                                            .workoutCounter +
                                                        1;
                                                    auxType = 'workoutCounter';
                                                  } else {
                                                    if (type == 'Trx') {
                                                      auxTypeCounter = widget
                                                              .imTrainer
                                                              .trxCounter +
                                                          1;
                                                      auxType = 'trxCounter';
                                                    } else {
                                                      if (type == 'Pilates') {
                                                        auxTypeCounter = widget
                                                                .imTrainer
                                                                .pilatesCounter +
                                                            1;
                                                        auxType =
                                                            'pilatesCounter';
                                                      } else {
                                                        if (type == 'Zumba') {
                                                          auxTypeCounter = widget
                                                                  .imTrainer
                                                                  .zumbaCounter +
                                                              1;
                                                          auxType =
                                                              'zumbaCounter';
                                                        } else {
                                                          if (type ==
                                                              'Kangoo Jumps') {
                                                            auxTypeCounter = widget
                                                                    .imTrainer
                                                                    .kangooJumpsCounter +
                                                                1;
                                                            auxType =
                                                                'kangooJumpsCounter';
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }

                                                bool overLap = false;
                                                if (widget.imTrainer
                                                        .counterClasses ==
                                                    0) {
                                                  overLap = true;
                                                } else {
                                                  var time1 = [];
                                                  var time2 = [];
                                                  widget.imTrainer.classes
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
                                                          widget.imTrainer
                                                                  .counterClasses -
                                                              1;
                                                      i++) {
                                                    for (int j = i + 1;
                                                        j <
                                                            widget.imTrainer
                                                                .counterClasses;
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
                                                          widget.imTrainer
                                                                  .counterClasses -
                                                              1;
                                                      i++) {
                                                    if (time2[i].isBefore(
                                                            dateAndTimeDateTime) &&
                                                        time1[i + 1].isAfter(
                                                            dateAndTimeDateTime
                                                                .add(Duration(
                                                                    hours:
                                                                        duration
                                                                            .hour,
                                                                    minutes:
                                                                        duration
                                                                            .minute)))) {
                                                      overLap = true;
                                                    }
                                                  }

                                                  if (time1[0].isAfter(
                                                      dateAndTimeDateTime.add(
                                                          Duration(
                                                              hours:
                                                                  duration.hour,
                                                              minutes: duration
                                                                  .minute)))) {
                                                    overLap = true;
                                                  }

                                                  if (time2[widget.imTrainer
                                                              .counterClasses -
                                                          1]
                                                      .isBefore(
                                                          dateAndTimeDateTime)) {
                                                    overLap = true;
                                                  }
                                                }
                                                if (overLap == true) {
                                                  if (toggleValue == true) {
                                                    Navigator.push(
                                                        context,
                                                        SubmitPopUp(
                                                            aux: aux,
                                                            imTrainer: widget
                                                                .imTrainer,
                                                            toggleValue:
                                                                toggleValue,
                                                            classLevel:
                                                                classLevel,
                                                            locationName:
                                                                locationName,
                                                            locationDistrict:
                                                                locationDistrict,
                                                            gymWebsite:
                                                                gymWebsite,
                                                            locationStreet:
                                                                locationStreet,
                                                            individualPrice:
                                                                individualPrice,
                                                            memberPrice:
                                                                memberPrice,
                                                            spots: spots,
                                                            type: type,
                                                            dateAndTime:
                                                                dateAndTime,
                                                            dateAndTimeDateTime:
                                                                dateAndTimeDateTime,
                                                            duration: duration,
                                                            auxType: auxType,
                                                            auxTypeCounter:
                                                                auxTypeCounter));
                                                  } else {
                                                    var db = Firestore.instance;
                                                    var batch = db.batch();
                                                    batch.updateData(
                                                      db
                                                          .collection(
                                                              'clientUsers')
                                                          .document(prefs
                                                              .getString('id')),
                                                      {
                                                        'class$aux': {},
                                                      },
                                                    );
                                                    batch.updateData(
                                                      db
                                                          .collection(
                                                              'clientUsers')
                                                          .document(prefs
                                                              .getString('id')),
                                                      {
                                                        'class$aux.views': 0,
                                                        'class$aux.public':
                                                            toggleValue,
                                                        'class$aux.classLevel':
                                                            classLevel,
                                                        'class$aux.locationName':
                                                            locationName,
                                                        'class$aux.gymWebsite':
                                                            gymWebsite,
                                                        'class$aux.locationDistrict':
                                                            locationDistrict,
                                                        'class$aux.individualPrice':
                                                            individualPrice,
                                                        'class$aux.memberPrice':
                                                            memberPrice,
                                                        'class$aux.spots':
                                                            spots,
                                                        'class$aux.type': type,
                                                        'class$aux.dateAndTime':
                                                            dateAndTime,
                                                        'counterClasses': aux,
                                                        'class$aux.dateAndTimeDateTime':
                                                            dateAndTimeDateTime,
                                                        'class$aux.duration':
                                                            duration,
                                                        'class$aux.occupiedSpots':
                                                            {},
                                                        'class$aux.locationStreet':
                                                            locationStreet,
                                                        'class$aux.number': aux,
                                                        '$auxType':
                                                            auxTypeCounter,
                                                        'class$aux.firstName':
                                                            widget.imTrainer
                                                                .firstName,
                                                        'class$aux.lastName':
                                                            widget.imTrainer
                                                                .lastName,
                                                        'class$aux.clientsFirstName':
                                                            {},
                                                        'class$aux.clientsLastName':
                                                            {},
                                                        'class$aux.clientsGender':
                                                            {},
                                                        'class$aux.clientsAge':
                                                            {},
                                                        'class$aux.clientsPhotoUrl':
                                                            {},
                                                        'class$aux.clientsColorRed':
                                                            {},
                                                        'class$aux.clientsColorGreen':
                                                            {},
                                                        'class$aux.clientsColorBlue':
                                                            {},
                                                        'class$aux.clientsRating':
                                                            {}
                                                      },
                                                    );
                                                    batch.commit();
                                                    if (toggleValue == false) {
                                                      List<String> tokenVector =
                                                          [];
                                                      List<String> ids = [];
                                                      QuerySnapshot query2 =
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  'clientUsers')
                                                              .where(
                                                                  'trainersMap.${prefs.getString('id')}',
                                                                  isEqualTo:
                                                                      true)
                                                              .getDocuments();
                                                      query2.documents
                                                          .forEach((element) {
                                                        tokenVector.add(
                                                            ClientUser(element)
                                                                .pushToken);
                                                        ids.add(
                                                            ClientUser(element)
                                                                .id);
                                                      });

                                                      if (query2.documents
                                                              .length !=
                                                          0) {
                                                        var db =
                                                            Firestore.instance;
                                                        var batch = db.batch();
                                                        query2.documents
                                                            .forEach((element) {
                                                          batch.updateData(
                                                            db
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    ClientUser(
                                                                            element)
                                                                        .id),
                                                            {
                                                              'newPrivateClass':
                                                                  true,
                                                            },
                                                          );
                                                        });
                                                        batch.setData(
                                                          db
                                                              .collection(
                                                                  'newClassForMembers')
                                                              .document(prefs
                                                                  .getString(
                                                                      'id')),
                                                          {
                                                            'idFrom':
                                                                prefs.getString(
                                                                    'id'),
                                                            'idTo': ids,
                                                            'pushToken':
                                                                tokenVector,
                                                            'firstName': widget
                                                                .imTrainer
                                                                .firstName,
                                                            'lastName': widget
                                                                .imTrainer
                                                                .lastName
                                                          },
                                                        );
                                                        batch.commit();
                                                      }
                                                    }
                                                    Navigator.of(context).pop();
                                                  }
                                                } else {
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                    "You already have a class schduled at that time.",
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
                                                  )));
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
                            },
                            child: Text(
                              'Add new class',
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
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class DetailsPopUp extends PopupRoute<void> {
  DetailsPopUp({this.parent, this.trainerUser});
  final _AddNewClassState parent;

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
      DetailsPage(
        trainer: trainerUser,
        parent: parent,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage extends StatefulWidget {
  final _AddNewClassState parent;
  final TrainerUser trainer;
  DetailsPage({Key key, @required this.trainer, @required this.parent})
      : super(key: key);

  @override
  State createState() => DetailsPageState(trainer: trainer);
}

class DetailsPageState extends State<DetailsPage> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector;

  DetailsPageState({
    @required this.trainer,
  });

  List<ReviewMapDelay> revs = [];

  @override
  void initState() {
    super.initState();
  }

  Widget buildItem(index) {
    return InkWell(
      onTap: () {
        widget.parent.setState(() {
          widget.parent.type = trainersSpecializations[index];
          Navigator.of(context).pop();
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
                trainersSpecializations[index],
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

  List<String> trainersSpecializations = [];
  int specializationsCounter = 0;
  @override
  Widget build(BuildContext context) {
    trainer.specializations.forEach((element) {
      if (element.certified == true) {
        specializationsCounter++;
      }
    });
    if (specializationsCounter != 0) {
      trainer.specializations.forEach((special) {
        if (special.certified == true) {
          if (special.specialization.toLowerCase() == 'kangoojumps') {
            trainersSpecializations.add("Kangoo Jumps");
          } else {
            trainersSpecializations.add(
                special.specialization[0].toUpperCase() +
                    special.specialization.substring(1));
          }
        }
      });
    }
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: specializationsCounter == 0
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff3E3E45)),
                width: 310 * prefs.getDouble('width'),
                height: 320 * prefs.getDouble('height'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    SvgPicture.asset(
                      'assets/specializationsf1.svg',
                      width: 180.0 * prefs.getDouble('width'),
                      height: 100.0 * prefs.getDouble('height'),
                    ),
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    Container(
                      width: 180 * prefs.getDouble('width'),
                      child: Center(
                        child: Text(
                          "Please choose the specializations you're certified for",
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 36.0 * prefs.getDouble('height')),
                      child: Container(
                        width: 150.0 * prefs.getDouble('width'),
                        height: 50.0 * prefs.getDouble('height'),
                        child: Material(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(90.0),
                          child: MaterialButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditeazaProfilul(
                                    parent: this,
                                  ),
                                ),
                              ).whenComplete(() => Navigator.of(context).pop());
                            },
                            child: Text(
                              'Edit profile',
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
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff3E3E45)),
                width: 310 * prefs.getDouble('width'),
                height: ((specializationsCounter * 61 + 156) *
                    prefs.getDouble('height')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 82 * prefs.getDouble('height'),
                      child: Center(
                        child: Text(
                          "Select class' type",
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
                    trainersSpecializations.length >= 1
                        ? buildItem(0)
                        : Container(),
                    trainersSpecializations.length >= 2
                        ? buildItem(1)
                        : Container(),
                    trainersSpecializations.length >= 3
                        ? buildItem(2)
                        : Container(),
                    trainersSpecializations.length >= 4
                        ? buildItem(3)
                        : Container(),
                    trainersSpecializations.length >= 5
                        ? buildItem(4)
                        : Container(),
                    trainersSpecializations.length >= 6
                        ? buildItem(5)
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
              ),
      ),
    );
  }
}

class DetailsPopUp1 extends PopupRoute<void> {
  DetailsPopUp1({this.parent, this.trainerUser});
  final _AddNewClassState parent;

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
      DetailsPage1(
        trainer: trainerUser,
        parent: parent,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage1 extends StatefulWidget {
  final _AddNewClassState parent;
  final TrainerUser trainer;
  DetailsPage1({Key key, @required this.trainer, @required this.parent})
      : super(key: key);

  @override
  State createState() => DetailsPage1State(trainer: trainer);
}

class DetailsPage1State extends State<DetailsPage1> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector;

  DetailsPage1State({
    @required this.trainer,
  });

  List<ReviewMapDelay> revs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Color(0xff3E3E45)),
          width: 310 * prefs.getDouble('width'),
          height: ((3 * 61 + 156) * prefs.getDouble('height')),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 82 * prefs.getDouble('height'),
                child: Center(
                  child: Text(
                    "Select class' level",
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
              InkWell(
                onTap: () {
                  widget.parent.setState(() {
                    widget.parent.classLevel = 'Advanced';
                    Navigator.of(context).pop();
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
                          "Advanced",
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
              ),
              InkWell(
                onTap: () {
                  widget.parent.setState(() {
                    widget.parent.classLevel = 'Intermediate';
                    Navigator.of(context).pop();
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
                          "Intermediate",
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
              ),
              InkWell(
                onTap: () {
                  widget.parent.setState(() {
                    widget.parent.classLevel = 'Beginner';
                    Navigator.of(context).pop();
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
                          "Beginner",
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
              ),
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
        ),
      ),
    );
  }
}

class DetailsPopUp2 extends PopupRoute<void> {
  DetailsPopUp2({this.parent, this.trainerUser});
  final _AddNewClassState parent;

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
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage2 extends StatefulWidget {
  final _AddNewClassState parent;
  final TrainerUser trainer;
  DetailsPage2({Key key, @required this.trainer, @required this.parent})
      : super(key: key);

  @override
  State createState() => DetailsPage2State();
}

class DetailsPage2State extends State<DetailsPage2> {
  String hinttText = "Scrie";
  Image image;

  String hintName, hintStreet, hintSector;
  List<ReviewMapDelay> revs = [];

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
                              if (prefs.getInt('currentCard') >= 0 &&
                                  prefs.getInt('currentCard') <= 3) {
                                Navigator.push(
                                    context,
                                    MyPopupRoute1(
                                        trainerUser: widget.trainer,
                                        currentCard:
                                            prefs.getInt('currentCard'),
                                        parent: this));
                              }
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

class EditProfilePageCards {}

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

class EditeazaProfilul extends StatefulWidget {
  EditeazaProfilul({this.parent, this.auth, this.status});
  final bool status;
  final DetailsPageState parent;
  final BaseAuth auth;
  @override
  _EditeazaProfilulState createState() => _EditeazaProfilulState();
}

class _EditeazaProfilulState extends State<EditeazaProfilul> {
  Future<void> sendPasswordResetEmail(String email) async {
    await widget.auth.resetPassword(email);
  }

  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center;

  Geoflutterfire geo = Geoflutterfire();
  Future _getData;

  bool toggleValue = false;

  bool workoutButton = false;
  bool zumbaButton = false;
  bool pilatesButton = false;
  bool trxButton = false;
  bool kangoojumpsButton = false;
  bool aerobicButton = false;
  bool restart = false;

  _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
    );
  }

  final fromDate = DateTime.now().subtract(Duration(days: 30));
  final toDate = DateTime.now();

  toggleButton() {
    setState(() {
      restart = true;
      toggleValue = !toggleValue;
    });
  }

  List<DataPoint<DateTime>> dateList = [];
  TrainerProfileVisits profileVisits;
  views() async {
    QuerySnapshot query = await Firestore.instance
        .collection('profileVisits')
        .where('id', isEqualTo: prefs.getString('id'))
        .getDocuments();
    profileVisits = TrainerProfileVisits(query.documents[0]);

    for (int i = 0; i < profileVisits.viewsList.length; i++) {
      if (profileVisits.dateList
                  .where((element) => int.parse(element.number) == (i + 1))
                  .toList()[0] !=
              null &&
          profileVisits.viewsList
                  .where((element) => int.parse(element.number) == (i + 1))
                  .toList()[0] !=
              null) {
        dateList.add(DataPoint<DateTime>(
            value: double.parse(profileVisits.viewsList
                .where((element) => int.parse(element.number) == (i + 1))
                .toList()[0]
                .views
                .toString()),
            xAxis: profileVisits.dateList
                .where((element) => int.parse(element.number) == (i + 1))
                .toList()[0]
                .time
                .toDate()));
      }
    }
  }

  int randomInt = Random().nextInt(1000000);
  var tempImage;
  Future _getImage() async {
    var aux = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tempImage = aux;
    });
  }

  TrainerUser _trainerUser;

  @override
  initState() {
    super.initState();
    views().then((result) {
      setState(() {});
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await rootBundle.loadString('assets/dark.json');

    controller.setMapStyle(value);
  }

  PanelController _pc = new PanelController();
  @override
  Widget build(BuildContext context) {
    if (profileVisits == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainColor),
          ),
        ),
        color: backgroundColor,
      );
    }

    if (restart == false) {
      _trainerUser = widget.parent.trainer;
      _trainerUser.specializations.forEach((specialization) {
        toggleValue = _trainerUser.freeTraining;
        if (specialization.specialization == 'workout' &&
            specialization.certified == true) {
          workoutButton = true;
        }
        if (specialization.specialization == 'zumba' &&
            specialization.certified == true) {
          zumbaButton = true;
        }
        if (specialization.specialization == 'kangooJumps' &&
            specialization.certified == true) {
          kangoojumpsButton = true;
        }
        if (specialization.specialization == 'aerobic' &&
            specialization.certified == true) {
          aerobicButton = true;
        }
        if (specialization.specialization == 'pilates' &&
            specialization.certified == true) {
          pilatesButton = true;
        }
        if (specialization.specialization == 'trx' &&
            specialization.certified == true) {
          trxButton = true;
        }
      });
    }

    if (_trainerUser.locationGeopoint != null) {
      _center = LatLng(_trainerUser.locationGeopoint.latitude,
          _trainerUser.locationGeopoint.longitude);
    } else {
      _center = LatLng(45.521563, -122.677433);
    }
    return MaterialApp(
         debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: new Icon(
                Icons.backspace,
                color: Colors.white,
                size: 24 * prefs.getDouble('height'),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 15 * prefs.getDouble('width')),
                child: IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 22 * prefs.getDouble('height'),
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    var db = Firestore.instance;
                    var batch = db.batch();
                    if (tempImage != null) {
                      final StorageReference firebaseStorageRef =
                          FirebaseStorage.instance
                              .ref()
                              .child('${_trainerUser.id}');
                      final StorageUploadTask task =
                          firebaseStorageRef.putFile(tempImage);
                      final StorageTaskSnapshot downloadUrl =
                          (await task.onComplete);
                      final String url =
                          (await downloadUrl.ref.getDownloadURL());
                      await prefs.setString('photoUrl', url);
                      batch.updateData(
                        db
                            .collection('clientUsers')
                            .document(prefs.getString('id')),
                        {
                          'photoUrl': url,
                        },
                      );
                    }
                    batch.updateData(
                      db
                          .collection('clientUsers')
                          .document(prefs.getString('id')),
                      {
                        'specialization.workout': workoutButton,
                        'specialization.zumba': zumbaButton,
                        'specialization.pilates': pilatesButton,
                        'specialization.trx': trxButton,
                        'specialization.kangooJumps': kangoojumpsButton,
                        'specialization.aerobic': aerobicButton,
                        'freeTraining': toggleValue
                      },
                    );
                    batch.commit();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            backgroundColor: backgroundColor,
            elevation: 0.0,
            title: Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontSize: 20 * prefs.getDouble('height'),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          body: Builder(
            builder: (context) => SlidingUpPanel(
              isDraggable: false,
              controller: _pc,
              maxHeight: 616 * prefs.getDouble('height'),
              minHeight: 120 * prefs.getDouble('height'),
              renderPanelSheet: false,
              panelBuilder: (ScrollController sc) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 24 * prefs.getDouble('height')),
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
                                height: 450 * prefs.getDouble('height'),
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(
                                    24.0 * prefs.getDouble('width'),
                                    42.0 * prefs.getDouble('height'),
                                    24.0 * prefs.getDouble('width'),
                                    42.0 * prefs.getDouble('height')),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: GoogleMap(
                                        rotateGesturesEnabled: false,
                                        myLocationButtonEnabled: widget.status,
                                        myLocationEnabled: true,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _setStyle(controller);
                                          _controller.complete(controller);
                                        },
                                        initialCameraPosition: CameraPosition(
                                            target: _center, zoom: 11.0),
                                        onCameraMove: _onCameraMove,
                                        mapType: MapType.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16 * prefs.getDouble('height'))
                            ],
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 450 * prefs.getDouble('height'),
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(
                              24.0 * prefs.getDouble('width'),
                              42.0 * prefs.getDouble('height'),
                              24.0 * prefs.getDouble('width'),
                              42.0 * prefs.getDouble('height')),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.place,
                                  color: Colors.white,
                                  size: 42 * prefs.getDouble('height'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: InkWell(
                            onTap: () {
                              _pc.close();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: mainColor,
                              ),
                              margin: EdgeInsets.only(
                                  top: 22 * prefs.getDouble('height')),
                              height: 40 * prefs.getDouble('height'),
                              width: 40 * prefs.getDouble('height'),
                              child: Center(
                                  child: Icon(
                                Icons.arrow_downward,
                                size: 22 * prefs.getDouble('height'),
                                color: Colors.white,
                              )),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            GeoFirePoint myLocation = geo.point(
                                latitude: _center.latitude,
                                longitude: _center.longitude);
                            await Firestore.instance
                                .collection('clientUsers')
                                .document(
                                  prefs.getString('id'),
                                )
                                .updateData(
                              {'location': myLocation.data},
                            );
                            _pc.close();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: mainColor,
                            ),
                            height: 40 * prefs.getDouble('height'),
                            margin: EdgeInsets.fromLTRB(
                                24.0 * prefs.getDouble('width'),
                                42.0 * prefs.getDouble('height'),
                                24.0 * prefs.getDouble('width'),
                                42.0 * prefs.getDouble('height')),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              collapsed: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                    ),
                    margin: EdgeInsets.fromLTRB(
                        24.0 * prefs.getDouble('width'),
                        56.0 * prefs.getDouble('height'),
                        24.0 * prefs.getDouble('width'),
                        0.0),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 8 * prefs.getDouble('height')),
                      child: Center(
                        child: Text(
                          "Location",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Colors.white,
                              letterSpacing: -0.078),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          _pc.open();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: mainColor,
                          ),
                          margin: EdgeInsets.only(
                              top: 38 * prefs.getDouble('height')),
                          height: 40 * prefs.getDouble('height'),
                          width: 40 * prefs.getDouble('height'),
                          child: Center(
                              child: Icon(
                            Icons.arrow_upward,
                            size: 22 * prefs.getDouble('height'),
                            color: Colors.white,
                          )),
                        ),
                      )),
                ],
              ),
              backdropEnabled: true,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 18 * prefs.getDouble('height')),
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      color: backgroundColor,
                      width: 120 * prefs.getDouble('width'),
                      height: 120 * prefs.getDouble('height'),
                      child: Center(
                        child: tempImage == null
                            ? (_trainerUser.photoUrl == null
                                ? Stack(
                                    children: <Widget>[
                                      ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255,
                                                _trainerUser.colorRed,
                                                _trainerUser.colorGreen,
                                                _trainerUser.colorBlue),
                                            shape: BoxShape.circle,
                                          ),
                                          height:
                                              (120 * prefs.getDouble('height')),
                                          width:
                                              (120 * prefs.getDouble('height')),
                                          child: Center(
                                            child: Text(
                                                _trainerUser.firstName[0],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 50 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 85.0 * prefs.getDouble('height'),
                                        left: 85.0 * prefs.getDouble('height'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: backgroundColor),
                                          padding: EdgeInsets.all(
                                              5.0 * prefs.getDouble('height')),
                                          child: Container(
                                            width:
                                                28 * prefs.getDouble('height'),
                                            height:
                                                28 * prefs.getDouble('height'),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainColor,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15.0 *
                                                  prefs.getDouble('height'),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(
                                    children: <Widget>[
                                      Material(
                                        child: Container(
                                          color: Colors.black,
                                          width:
                                              120 * prefs.getDouble('height'),
                                          height:
                                              120 * prefs.getDouble('height'),
                                          child: Image.network(
                                            _trainerUser.photoUrl,
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
                                          Radius.circular(90),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      Positioned(
                                        top: 85.0 * prefs.getDouble('height'),
                                        left: 85.0 * prefs.getDouble('height'),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: backgroundColor),
                                          padding: EdgeInsets.all(
                                              5.0 * prefs.getDouble('height')),
                                          child: Container(
                                            width:
                                                28 * prefs.getDouble('height'),
                                            height:
                                                28 * prefs.getDouble('height'),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainColor,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15.0 *
                                                  prefs.getDouble('height'),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                            : Stack(
                                children: <Widget>[
                                  Material(
                                    child: Image.file(
                                      tempImage,
                                      width: 120.0 * prefs.getDouble('height'),
                                      height: 120.0 * prefs.getDouble('height'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(90.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  Positioned(
                                    top: 85.0 * prefs.getDouble('height'),
                                    left: 85.0 * prefs.getDouble('height'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: backgroundColor),
                                      padding: EdgeInsets.all(
                                          5.0 * prefs.getDouble('height')),
                                      child: Container(
                                        width: 28 * prefs.getDouble('height'),
                                        height: 28 * prefs.getDouble('height'),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: mainColor,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size:
                                              15.0 * prefs.getDouble('height'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 26 * prefs.getDouble('height')),
                  Container(
                    height: 66 * prefs.getDouble('height'),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Specializations",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 17 * prefs.getDouble('height'),
                              letterSpacing: -0.41),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Select the training specializations according to your certificates",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(150, 255, 255, 255),
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              letterSpacing: -0.41),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 128 * prefs.getDouble('height'),
                    width: 310 * prefs.getDouble('width'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      restart = true;
                                      workoutButton = !workoutButton;
                                    });
                                  },
                                  child: workoutButton == false
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4.0 *
                                                      prefs.getDouble(
                                                          'height'))),
                                          height:
                                              32 * prefs.getDouble('height'),
                                          width: 150 * prefs.getDouble('width'),
                                          padding: EdgeInsets.all(
                                            8.0 * prefs.getDouble('height'),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Workout",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.check_box_outline_blank,
                                                size: 16 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(4.0 *
                                                      prefs.getDouble(
                                                          'height'))),
                                          height:
                                              32 * prefs.getDouble('height'),
                                          width: 150 * prefs.getDouble('width'),
                                          padding: EdgeInsets.all(
                                            8.0 * prefs.getDouble('height'),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Workout",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.cancel,
                                                size: 16 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        )),
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    restart = true;
                                    pilatesButton = !pilatesButton;
                                  });
                                },
                                child: pilatesButton == false
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Pilates",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.check_box_outline_blank,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Pilates",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.cancel,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    restart = true;
                                    kangoojumpsButton = !kangoojumpsButton;
                                  });
                                },
                                child: kangoojumpsButton == false
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Kangoo Jumps",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.check_box_outline_blank,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Kangoo Jumps",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.cancel,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    restart = true;
                                    zumbaButton = !zumbaButton;
                                  });
                                },
                                child: zumbaButton == false
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Zumba",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.check_box_outline_blank,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Zumba",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.cancel,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    restart = true;
                                    trxButton = !trxButton;
                                  });
                                },
                                child: trxButton == false
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "TRX",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.check_box_outline_blank,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "TRX",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.cancel,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    restart = true;
                                    aerobicButton = !aerobicButton;
                                  });
                                },
                                child: aerobicButton == false
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Aerobic",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.check_box_outline_blank,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
                                        height: 32 * prefs.getDouble('height'),
                                        width: 150 * prefs.getDouble('width'),
                                        padding: EdgeInsets.all(
                                          8.0 * prefs.getDouble('height'),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Aerobic",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12 *
                                                      prefs.getDouble('height'),
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.cancel,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 1.0 * prefs.getDouble('height'),
                    color: Color(0xff57575E),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    height: 43 * prefs.getDouble('height'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Offer the first training for free",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.0 * prefs.getDouble('height'),
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(210, 255, 255, 255)),
                        ),
                        InkWell(
                          onTap: () {
                            toggleButton();
                          },
                          child: AnimatedContainer(
                            duration: Duration(
                              milliseconds: 400,
                            ),
                            height: 25 * prefs.getDouble('height'),
                            width: 60 * prefs.getDouble('width'),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0 * prefs.getDouble('height')),
                              borderRadius: BorderRadius.circular(20),
                              color: toggleValue ? mainColor : backgroundColor,
                            ),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                AnimatedPositioned(
                                  top: 5.0 * prefs.getDouble('height'),
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                  left: toggleValue
                                      ? 25.0 * prefs.getDouble('width')
                                      : 5.0,
                                  right: toggleValue
                                      ? 5.0
                                      : 35.0 * prefs.getDouble('width'),
                                  child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 400),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return toggleValue == true
                                            ? Text(
                                                "Yes",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Colors.white,
                                                    fontSize: 11.0 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )
                                            : RotationTransition(
                                                child: child,
                                                turns: animation,
                                              );
                                      },
                                      child: toggleValue
                                          ? Text("Yes",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: 11.0 *
                                                    prefs.getDouble('height'),
                                                fontWeight: FontWeight.w700,
                                              ))
                                          : Text("No",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: 11.0 *
                                                    prefs.getDouble('height'),
                                                fontWeight: FontWeight.w700,
                                              ))),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1.0 * prefs.getDouble('height'),
                    color: Color(0xff57575E),
                  ),
                  SizedBox(
                    height: 8 * prefs.getDouble('height'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    height: 48 * prefs.getDouble('height'),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Profile views",
                                style: TextStyle(
                                    letterSpacing: -0.408,
                                    fontSize: 17 * prefs.getDouble('height'),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Last 30 days",
                                style: TextStyle(
                                    letterSpacing: -0.06,
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  "All time total:" +
                                      profileVisits.visits.toString(),
                                  style: TextStyle(
                                    fontSize: 11 * prefs.getDouble('height'),
                                    fontFamily: 'Roboto',
                                    color: Color.fromARGB(100, 255, 255, 255),
                                  )),
                              Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8 * prefs.getDouble('height'),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        height: 130 * prefs.getDouble('height'),
                        child: BezierChart(
                          fromDate: profileVisits.dateList
                              .where(
                                  (element) => element.number.toString() == '1')
                              .toList()[0]
                              .time
                              .toDate(),
                          bezierChartScale: BezierChartScale.WEEKLY,
                          toDate: profileVisits.dateList
                              .where((element) =>
                                  element.number.toString() == '30')
                              .toList()[0]
                              .time
                              .toDate(),
                          selectedDate: profileVisits.dateList
                              .where((element) =>
                                  element.number.toString() == '30')
                              .toList()[0]
                              .time
                              .toDate(),
                          series: [
                            BezierLine(
                              label: "Views",
                              data: dateList,
                            ),
                          ],
                          config: BezierChartConfig(
                              bubbleIndicatorColor: Colors.white,
                              contentWidth: 310 * prefs.getDouble('width'),
                              xAxisTextStyle:
                                  TextStyle(color: Colors.transparent),
                              showDataPoints: false,
                              snap: false,
                              verticalIndicatorStrokeWidth: 0.0,
                              backgroundColor: backgroundColor),
                        )),
                  ),
                  SizedBox(
                    height: 16 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 42 * prefs.getDouble('height'),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Account",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 17 * prefs.getDouble('height'),
                              letterSpacing: -0.41),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 5.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Be careful, these settings may be irreversible",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(150, 255, 255, 255),
                              fontStyle: FontStyle.normal,
                              fontSize: 13 * prefs.getDouble('height'),
                              letterSpacing: -0.41),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20 * prefs.getDouble('height')),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            sendPasswordResetEmail(_trainerUser.nickname);
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Resetting password email has been sent.",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.0 * prefs.getDouble('height'),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  color: mainColor),
                              textAlign: TextAlign.center,
                            )));
                          },
                          child: Text("Change password",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.0 * prefs.getDouble('height'),
                                  letterSpacing: -0.08,
                                  color: Color.fromARGB(220, 255, 255, 255),
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start),
                        ),
                        SizedBox(height: 18.0 * prefs.getDouble('height')),
                        Text(
                          "Delete account",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.0 * prefs.getDouble('height'),
                              letterSpacing: -0.08,
                              color: Color(0xffFF453A),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class SubmitPopUp extends PopupRoute<void> {
  final DateTime dateAndTimeDateTime, duration;
  final String classLevel,
      locationName,
      gymWebsite,
      locationDistrict,
      individualPrice,
      memberPrice,
      type,
      dateAndTime,
      locationStreet,
      auxType;
  final bool toggleValue;
  final int aux, spots, auxTypeCounter;
  final TrainerUser imTrainer;
  SubmitPopUp(
      {this.aux,
      this.imTrainer,
      this.toggleValue,
      this.classLevel,
      this.locationName,
      this.gymWebsite,
      this.locationDistrict,
      this.individualPrice,
      this.memberPrice,
      this.spots,
      this.type,
      this.dateAndTime,
      this.dateAndTimeDateTime,
      this.duration,
      this.locationStreet,
      this.auxType,
      this.auxTypeCounter});
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
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
          child: Submit(
              aux: aux,
              imTrainer: imTrainer,
              toggleValue: toggleValue,
              classLevel: classLevel,
              locationName: locationName,
              locationDistrict: locationDistrict,
              gymWebsite: gymWebsite,
              individualPrice: individualPrice,
              memberPrice: memberPrice,
              spots: spots,
              type: type,
              dateAndTime: dateAndTime,
              dateAndTimeDateTime: dateAndTimeDateTime,
              duration: duration,
              locationStreet: locationStreet,
              auxType: auxType,
              auxTypeCounter: auxTypeCounter));

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class Submit extends StatefulWidget {
  final DateTime dateAndTimeDateTime, duration;
  final String classLevel,
      locationName,
      gymWebsite,
      locationDistrict,
      individualPrice,
      memberPrice,
      type,
      dateAndTime,
      locationStreet,
      auxType;
  final bool toggleValue;
  final int aux, spots, auxTypeCounter;
  final TrainerUser imTrainer;
  Submit(
      {this.aux,
      this.imTrainer,
      this.toggleValue,
      this.classLevel,
      this.locationDistrict,
      this.gymWebsite,
      this.locationName,
      this.individualPrice,
      this.memberPrice,
      this.spots,
      this.type,
      this.dateAndTime,
      this.dateAndTimeDateTime,
      this.duration,
      this.locationStreet,
      this.auxType,
      this.auxTypeCounter});
  @override
  State createState() => SubmitState();
}

class SubmitState extends State<Submit> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * prefs.getDouble('width')),
              height: 379 * prefs.getDouble('height'),
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
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Container(
                      width: 200.0 * prefs.getDouble('width'),
                      height: 120 * prefs.getDouble('height'),
                      child: SvgPicture.asset(
                        'assets/win.svg',
                        width: 230.0 * prefs.getDouble('width'),
                        height: 150 * prefs.getDouble('height'),
                      )),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Text(
                    "Create a public class",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 20 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8 * prefs.getDouble('height'),
                  ),
                  Text(
                    "This will cost 5 trophies. Do you want to continue?",
                    maxLines: 2,
                    style: TextStyle(
                        letterSpacing: -0.408,
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(150, 255, 255, 255),
                        fontSize: 17 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8 * prefs.getDouble('height'),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 32.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 150.0 * prefs.getDouble('width'),
                      height: 50.0 * prefs.getDouble('height'),
                      child: Material(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(90.0),
                        child: MaterialButton(
                          onPressed: () {
                            Future.delayed(Duration.zero, () async {
                              QuerySnapshot query = await Firestore.instance
                                  .collection('clientUsers')
                                  .where('id', isEqualTo: widget.imTrainer.id)
                                  .getDocuments();
                              if (query.documents.length != 0) {
                                TrainerUser updatedTrainer =
                                    TrainerUser(query.documents[0]);
                                    print(updatedTrainer.trophies);
                                    print(updatedTrainer.trophies > 5);
                                if (updatedTrainer.trophies < 5) {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    PopUpMissingRoute(),
                                  );
                                } else {
                                  var db = Firestore.instance;
                                  var batch = db.batch();
                                  batch.updateData(
                                    db
                                        .collection('clientUsers')
                                        .document(prefs.getString('id')),
                                    {
                                      'class${widget.aux}': {},
                                    },
                                  );
                                  batch.updateData(
                                    db
                                        .collection('clientUsers')
                                        .document(prefs.getString('id')),
                                    {
                                      'trophies': updatedTrainer.trophies - 5,
                                      'class${widget.aux}.views': 0,
                                      'class${widget.aux}.public':
                                          widget.toggleValue,
                                      'class${widget.aux}.classLevel':
                                          widget.classLevel,
                                      'class${widget.aux}.locationName':
                                          widget.locationName,
                                      'class${widget.aux}.gymWebsite':
                                          widget.gymWebsite,
                                      'class${widget.aux}.locationDistrict':
                                          widget.locationDistrict,
                                      'class${widget.aux}.individualPrice':
                                          widget.individualPrice,
                                      'class${widget.aux}.memberPrice':
                                          widget.memberPrice,
                                      'class${widget.aux}.spots': widget.spots,
                                      'class${widget.aux}.type': widget.type,
                                      'class${widget.aux}.dateAndTime':
                                          widget.dateAndTime,
                                      'counterClasses': widget.aux,
                                      'class${widget.aux}.dateAndTimeDateTime':
                                          widget.dateAndTimeDateTime,
                                      'class${widget.aux}.duration':
                                          widget.duration,
                                      'class${widget.aux}.occupiedSpots': {},
                                      'class${widget.aux}.locationStreet':
                                          widget.locationStreet,
                                      'class${widget.aux}.number': widget.aux,
                                      '${widget.auxType}':
                                          widget.auxTypeCounter,
                                      'class${widget.aux}.firstName':
                                          updatedTrainer.firstName,
                                      'class${widget.aux}.lastName':
                                          updatedTrainer.lastName,
                                      'class${widget.aux}.clientsFirstName': {},
                                      'class${widget.aux}.clientsLastName': {},
                                      'class${widget.aux}.clientsGender': {},
                                      'class${widget.aux}.clientsAge': {},
                                      'class${widget.aux}.clientsPhotoUrl': {},
                                      'class${widget.aux}.clientsColorRed': {},
                                      'class${widget.aux}.clientsColorGreen':
                                          {},
                                      'class${widget.aux}.clientsColorBlue': {},
                                      'class${widget.aux}.clientsRating': {}
                                    },
                                  );
                                  batch.commit();
                                  if (widget.toggleValue == false) {
                                    List<String> tokenVector = [];
                                    List<String> ids = [];
                                    QuerySnapshot query2 = await Firestore
                                        .instance
                                        .collection('clientUsers')
                                        .where(
                                            'trainersMap.${prefs.getString('id')}',
                                            isEqualTo: true)
                                        .getDocuments();
                                    query2.documents.forEach((element) {
                                      tokenVector
                                          .add(ClientUser(element).pushToken);
                                      ids.add(ClientUser(element).id);
                                    });

                                    if (query2.documents.length != 0) {
                                      var db = Firestore.instance;
                                      var batch = db.batch();
                                      query2.documents.forEach((element) {
                                        batch.updateData(
                                          db
                                              .collection('clientUsers')
                                              .document(ClientUser(element).id),
                                          {
                                            'newPrivateClass': true,
                                          },
                                        );
                                      });
                                      batch.setData(
                                        db
                                            .collection('newClassForMembers')
                                            .document(prefs.getString('id')),
                                        {
                                          'idFrom': prefs.getString('id'),
                                          'idTo': ids,
                                          'pushToken': tokenVector,
                                          'firstName': updatedTrainer.firstName,
                                          'lastName': updatedTrainer.lastName
                                        },
                                      );
                                      batch.commit();
                                    }
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              }
                            });
                          },
                          child: Text(
                            'Continue',
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
                ],
              ),
            ),
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
                'assets/pay.svg',
                width: 200.0 * prefs.getDouble('width'),
                height: 130.0 * prefs.getDouble('height'),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Text(
                "You have ran out of trophies",
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
