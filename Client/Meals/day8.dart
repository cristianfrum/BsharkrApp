import 'package:Bsharkr/models/clientUser.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/Meals/Meals.dart';
import 'package:Bsharkr/Client/globals.dart';

class EithPage extends StatefulWidget {
  final MyMealsState parent;
  final ClientUser clientUser;
  EithPage({Key key, @required this.clientUser, @required this.parent})
      : super(key: key);
  @override
  _EithPageState createState() =>
      _EithPageState(clientUser: clientUser, parent: parent);
}

class _EithPageState extends State<EithPage> {
  final MyMealsState parent;
  final ClientUser clientUser;
  _EithPageState({Key key, @required this.clientUser, @required this.parent});

  List<String> daysOfTheWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  String dinnerMeals(int index) {
    if (index == 1) {
      return widget.clientUser.mealsDinner.day1.toString();
    }
    if (index == 2) {
      return widget.clientUser.mealsDinner.day2.toString();
    }
    if (index == 3) {
      return widget.clientUser.mealsDinner.day3.toString();
    }
    if (index == 4) {
      return widget.clientUser.mealsDinner.day4.toString();
    }
    if (index == 5) {
      return widget.clientUser.mealsDinner.day5.toString();
    }
    if (index == 6) {
      return widget.clientUser.mealsDinner.day6.toString();
    }
    if (index == 7) {
      return widget.clientUser.mealsDinner.day7.toString();
    }
    if (index == 8) {
      return widget.clientUser.mealsDinner.day8.toString();
    }
    if (index == 9) {
      return widget.clientUser.mealsDinner.day9.toString();
    }
    if (index == 10) {
      return widget.clientUser.mealsDinner.day10.toString();
    }
    if (index == 11) {
      return widget.clientUser.mealsDinner.day11.toString();
    }
    if (index == 12) {
      return widget.clientUser.mealsDinner.day12.toString();
    }
    if (index == 13) {
      return widget.clientUser.mealsDinner.day13.toString();
    }
    if (index == 14) {
      return widget.clientUser.mealsDinner.day14.toString();
    }
    return "";
  }

  String lunchMeals(int index) {
    if (index == 1) {
      return widget.clientUser.mealsLunch.day1.toString();
    }
    if (index == 2) {
      return widget.clientUser.mealsLunch.day2.toString();
    }
    if (index == 3) {
      return widget.clientUser.mealsLunch.day3.toString();
    }
    if (index == 4) {
      return widget.clientUser.mealsLunch.day4.toString();
    }
    if (index == 5) {
      return widget.clientUser.mealsLunch.day5.toString();
    }
    if (index == 6) {
      return widget.clientUser.mealsLunch.day6.toString();
    }
    if (index == 7) {
      return widget.clientUser.mealsLunch.day7.toString();
    }
    if (index == 8) {
      return widget.clientUser.mealsLunch.day8.toString();
    }
    if (index == 9) {
      return widget.clientUser.mealsLunch.day9.toString();
    }
    if (index == 10) {
      return widget.clientUser.mealsLunch.day10.toString();
    }
    if (index == 11) {
      return widget.clientUser.mealsLunch.day11.toString();
    }
    if (index == 12) {
      return widget.clientUser.mealsLunch.day12.toString();
    }
    if (index == 13) {
      return widget.clientUser.mealsLunch.day13.toString();
    }
    if (index == 14) {
      return widget.clientUser.mealsLunch.day14.toString();
    }
    return "";
  }

  String breakfastMeals(int index) {
    if (index == 1) {
      return widget.clientUser.mealsBreakfast.day1.toString();
    }
    if (index == 2) {
      return widget.clientUser.mealsBreakfast.day2.toString();
    }
    if (index == 3) {
      return widget.clientUser.mealsBreakfast.day3.toString();
    }
    if (index == 4) {
      return widget.clientUser.mealsBreakfast.day4.toString();
    }
    if (index == 5) {
      return widget.clientUser.mealsBreakfast.day5.toString();
    }
    if (index == 6) {
      return widget.clientUser.mealsBreakfast.day6.toString();
    }
    if (index == 7) {
      return widget.clientUser.mealsBreakfast.day7.toString();
    }
    if (index == 8) {
      return widget.clientUser.mealsBreakfast.day8.toString();
    }
    if (index == 9) {
      return widget.clientUser.mealsBreakfast.day9.toString();
    }
    if (index == 10) {
      return widget.clientUser.mealsBreakfast.day10.toString();
    }
    if (index == 11) {
      return widget.clientUser.mealsBreakfast.day11.toString();
    }
    if (index == 12) {
      return widget.clientUser.mealsBreakfast.day12.toString();
    }
    if (index == 13) {
      return widget.clientUser.mealsBreakfast.day13.toString();
    }
    if (index == 14) {
      return widget.clientUser.mealsBreakfast.day14.toString();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 370 * prefs.getDouble('height'),
            width: 310 * prefs.getDouble('width'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff3E3E45)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15 * prefs.getDouble('height'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(),
                    Container(
                      padding:
                          EdgeInsets.only(right: 15 * prefs.getDouble('width')),
                      child: Text(
                        daysOfTheWeek[widget.clientUser.scheduleSecondWeek.day1
                                    .toDate()
                                    .weekday -
                                1] +
                            ", " +
                            widget.clientUser.scheduleSecondWeek.day1
                                .toDate()
                                .day
                                .toString() +
                            " " +
                            monthsOfTheYear[widget
                                    .clientUser.scheduleSecondWeek.day1
                                    .toDate()
                                    .month -
                                1],
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20 * prefs.getDouble('height'),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(200, 255, 255, 255),
                            letterSpacing: 0.75),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 27 * prefs.getDouble('height'),
                ),
                Container(
                  height: 304 * prefs.getDouble('height'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15 * prefs.getDouble('width')),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "Breakfast",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              17 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                  ),
                                  Container(
                                    height: 16 * prefs.getDouble('height'),
                                    width: 80 * prefs.getDouble('width'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3 * prefs.getDouble('height')),
                              width: 310 * prefs.getDouble('width'),
                              height: 80 * prefs.getDouble('height'),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 0.0 * prefs.getDouble('height'),
                                  bottom: 5.0 * prefs.getDouble('height'),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3 * prefs.getDouble('height')),
                                  width: 310 * prefs.getDouble('width'),
                                  height: 72.5 * prefs.getDouble('height'),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      breakfastMeals(8) == "default"
                                          ? ""
                                          : breakfastMeals(8),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          letterSpacing: -0.078,
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13.0 * prefs.getDouble('height'),
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15 * prefs.getDouble('width')),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "Lunch",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              17 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                  ),
                                  Container(
                                    height: 16 * prefs.getDouble('height'),
                                    width: 80 * prefs.getDouble('width'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3 * prefs.getDouble('height')),
                              width: 310 * prefs.getDouble('width'),
                              height: 80 * prefs.getDouble('height'),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 0.0 * prefs.getDouble('height'),
                                  bottom: 5.0 * prefs.getDouble('height'),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3 * prefs.getDouble('height')),
                                  width: 310 * prefs.getDouble('width'),
                                  height: 72.5 * prefs.getDouble('height'),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      lunchMeals(8) == "default"
                                          ? ""
                                          : lunchMeals(8),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          letterSpacing: -0.078,
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13.0 * prefs.getDouble('height'),
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15 * prefs.getDouble('width')),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "Dinner",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              17 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                  ),
                                  Container(
                                    height: 16 * prefs.getDouble('height'),
                                    width: 80 * prefs.getDouble('width'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3 * prefs.getDouble('height')),
                                width: 310 * prefs.getDouble('width'),
                                height: 80 * prefs.getDouble('height'),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 0.0 * prefs.getDouble('height'),
                                    bottom: 5.0 * prefs.getDouble('height'),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            3 * prefs.getDouble('height')),
                                    width: 310 * prefs.getDouble('width'),
                                    height: 72.5 * prefs.getDouble('height'),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        dinnerMeals(8) == "default"
                                            ? ""
                                            : dinnerMeals(8),
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            letterSpacing: -0.078,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13.0 *
                                                prefs.getDouble('height'),
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                200, 255, 255, 255)),
                                        textAlign: TextAlign.start,
                                      ),
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
