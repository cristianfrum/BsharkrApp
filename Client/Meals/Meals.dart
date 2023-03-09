import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/Meals/day1.dart';
import 'package:Bsharkr/Client/Meals/day10.dart';
import 'package:Bsharkr/Client/Meals/day11.dart';
import 'package:Bsharkr/Client/Meals/day12.dart';
import 'package:Bsharkr/Client/Meals/day13.dart';
import 'package:Bsharkr/Client/Meals/day14.dart';
import 'package:Bsharkr/Client/Meals/day2.dart';
import 'package:Bsharkr/Client/Meals/day3.dart';
import 'package:Bsharkr/Client/Meals/day4.dart';
import 'package:Bsharkr/Client/Meals/day5.dart';
import 'package:Bsharkr/Client/Meals/day6.dart';
import 'package:Bsharkr/Client/Meals/day7.dart';
import 'package:Bsharkr/Client/Meals/day8.dart';
import 'package:Bsharkr/Client/Meals/day9.dart';
import 'package:Bsharkr/Client/globals.dart';

import 'package:Bsharkr/colors.dart' as prefix0;

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
List<String> daysOfTheWeek = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

class MyMeals extends StatefulWidget {
  final clientUser;
  MyMeals({this.clientUser});
  @override
  State createState() => MyMealsState();
}

class MyMealsState extends State<MyMeals> {
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
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clientUser.mealPlanUpdated == true) {
      Firestore.instance
          .collection('clientUsers')
          .document(widget.clientUser.id)
          .updateData(
        {
          'mealPlanUpdated': FieldValue.delete(),
        },
      );
    }
    return Container(
      height: 444 * prefs.getDouble('height'),
          child: Stack(
        children: <Widget>[
          
          Align(
            alignment: Alignment.topCenter,
                    child: PageView(
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      children: <Widget>[
                        FirstPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        SecondPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        ThirdPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        FourthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        FifthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        SixthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        SeventhPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        EithPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        NinethPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        TenthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        EleventhPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        TwelfthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        TirteenthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                        FourteenthPage(
                          clientUser: widget.clientUser,
                          parent: this,
                        ),
                      ],
                    ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
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
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 1
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 2
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 3
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 4
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 5
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 6
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 7
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 8
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 9
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 10
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 11
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 12
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 7 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 13
                          ? prefix0.mainColor
                          : prefix0.secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 8 * prefs.getDouble('width'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
