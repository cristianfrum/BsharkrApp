import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/ManagingMeals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/edit.dart';
import 'package:Bsharkr/models/clientUser.dart';

import 'package:Bsharkr/colors.dart' as prefix0;

class FourthPage extends StatefulWidget {
  final ManagingMealsState parent;
  final ClientUser clientUser;
  FourthPage({Key key, @required this.clientUser, @required this.parent})
      : super(key: key);
  @override
  _FourthPageState createState() =>
      _FourthPageState(clientUser: clientUser, parent: parent);
}

class _FourthPageState extends State<FourthPage> {
  final ManagingMealsState parent;
  final ClientUser clientUser;
  _FourthPageState({Key key, @required this.clientUser, @required this.parent});
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
      return clientUser.mealsDinner.day1.toString();
    }
    if (index == 2) {
      return clientUser.mealsDinner.day2.toString();
    }
    if (index == 3) {
      return clientUser.mealsDinner.day3.toString();
    }
    if (index == 4) {
      return clientUser.mealsDinner.day4.toString();
    }
    if (index == 5) {
      return clientUser.mealsDinner.day5.toString();
    }
    if (index == 6) {
      return clientUser.mealsDinner.day6.toString();
    }
    if (index == 7) {
      return clientUser.mealsDinner.day7.toString();
    }
    if (index == 8) {
      return clientUser.mealsDinner.day8.toString();
    }
    if (index == 9) {
      return clientUser.mealsDinner.day9.toString();
    }
    if (index == 10) {
      return clientUser.mealsDinner.day10.toString();
    }
    if (index == 11) {
      return clientUser.mealsDinner.day11.toString();
    }
    if (index == 12) {
      return clientUser.mealsDinner.day12.toString();
    }
    if (index == 13) {
      return clientUser.mealsDinner.day13.toString();
    }
    if (index == 14) {
      return clientUser.mealsDinner.day14.toString();
    }
    return "";
  }

  String lunchMeals(int index) {
    if (index == 1) {
      return clientUser.mealsLunch.day1.toString();
    }
    if (index == 2) {
      return clientUser.mealsLunch.day2.toString();
    }
    if (index == 3) {
      return clientUser.mealsLunch.day3.toString();
    }
    if (index == 4) {
      return clientUser.mealsLunch.day4.toString();
    }
    if (index == 5) {
      return clientUser.mealsLunch.day5.toString();
    }
    if (index == 6) {
      return clientUser.mealsLunch.day6.toString();
    }
    if (index == 7) {
      return clientUser.mealsLunch.day7.toString();
    }
    if (index == 8) {
      return clientUser.mealsLunch.day8.toString();
    }
    if (index == 9) {
      return clientUser.mealsLunch.day9.toString();
    }
    if (index == 10) {
      return clientUser.mealsLunch.day10.toString();
    }
    if (index == 11) {
      return clientUser.mealsLunch.day11.toString();
    }
    if (index == 12) {
      return clientUser.mealsLunch.day12.toString();
    }
    if (index == 13) {
      return clientUser.mealsLunch.day13.toString();
    }
    if (index == 14) {
      return clientUser.mealsLunch.day14.toString();
    }
    return "";
  }

  String breakfastMeals(int index) {
    if (index == 1) {
      return clientUser.mealsBreakfast.day1.toString();
    }
    if (index == 2) {
      return clientUser.mealsBreakfast.day2.toString();
    }
    if (index == 3) {
      return clientUser.mealsBreakfast.day3.toString();
    }
    if (index == 4) {
      return clientUser.mealsBreakfast.day4.toString();
    }
    if (index == 5) {
      return clientUser.mealsBreakfast.day5.toString();
    }
    if (index == 6) {
      return clientUser.mealsBreakfast.day6.toString();
    }
    if (index == 7) {
      return clientUser.mealsBreakfast.day7.toString();
    }
    if (index == 8) {
      return clientUser.mealsBreakfast.day8.toString();
    }
    if (index == 9) {
      return clientUser.mealsBreakfast.day9.toString();
    }
    if (index == 10) {
      return clientUser.mealsBreakfast.day10.toString();
    }
    if (index == 11) {
      return clientUser.mealsBreakfast.day11.toString();
    }
    if (index == 12) {
      return clientUser.mealsBreakfast.day12.toString();
    }
    if (index == 13) {
      return clientUser.mealsBreakfast.day13.toString();
    }
    if (index == 14) {
      return clientUser.mealsBreakfast.day14.toString();
    }
    return "";
  }

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
              height: 55 * prefs.getDouble('height'),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 607 * prefs.getDouble('height'),
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
                 
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16 * prefs.getDouble('width')),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            daysOfTheWeek[clientUser.scheduleFirstWeek.day4
                                        .toDate()
                                        .weekday -
                                    1] +
                                ", " +
                                clientUser.scheduleFirstWeek.day4
                                    .toDate()
                                    .day
                                    .toString() +
                                " " +
                                monthsOfTheYear[clientUser
                                        .scheduleFirstWeek.day4
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
                          Text(
                            clientUser.firstName,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20 * prefs.getDouble('height'),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(200, 255, 255, 255),
                                letterSpacing: 0.75),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 35 * prefs.getDouble('height'),
                  ),
                  Center(
                    child: SvgPicture.asset(
                      'assets/food4f1.svg',
                      width: 200.0 * prefs.getDouble('width'),
                      height: 110.0 * prefs.getDouble('height'),
                    ),
                  ),
                  SizedBox(
                    height: 46 * prefs.getDouble('height'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 15 * prefs.getDouble('height')),
                    height: 364 * prefs.getDouble('height'),
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
                                      height: 25 * prefs.getDouble('height'),
                                      width: 80 * prefs.getDouble('width'),
                                      child: Material(
                                        color: prefix0.mainColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Edit(
                                                  clientUser: clientUser,
                                                  index: 4,
                                                  meal: "Breakfast",
                                                  parent: parent,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                      fontFamily: 'Roboto',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
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
                                        vertical:
                                            3 * prefs.getDouble('height')),
                                    width: 310 * prefs.getDouble('width'),
                                    height: 72.5 * prefs.getDouble('height'),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        breakfastMeals(4) == "default"
                                            ? "Modify your client's meal plan"
                                            : breakfastMeals(4),
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
                                      height: 25 * prefs.getDouble('height'),
                                      width: 80 * prefs.getDouble('width'),
                                      child: Material(
                                        color: prefix0.mainColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Edit(
                                                  clientUser: clientUser,
                                                  index: 4,
                                                  meal: "Lunch",
                                                  parent: parent,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                      fontFamily: 'Roboto',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
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
                                        vertical:
                                            3 * prefs.getDouble('height')),
                                    width: 310 * prefs.getDouble('width'),
                                    height: 72.5 * prefs.getDouble('height'),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        lunchMeals(4) == "default"
                                            ? "Modify your client's meal plan"
                                            : lunchMeals(4),
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
                                      height: 25 * prefs.getDouble('height'),
                                      width: 80 * prefs.getDouble('width'),
                                      child: Material(
                                        color: prefix0.mainColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Edit(
                                                  clientUser: clientUser,
                                                  index: 4,
                                                  meal: "Dinner",
                                                  parent: parent,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                      fontFamily: 'Roboto',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
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
                                          dinnerMeals(4) == "default"
                                              ? "Modify your client's meal plan"
                                              : dinnerMeals(4),
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
      ),
    );
  }
}
