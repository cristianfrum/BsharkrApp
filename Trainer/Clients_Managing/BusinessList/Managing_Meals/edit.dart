import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/ManagingMeals.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/models/clientUser.dart';

class Edit extends StatefulWidget {
  final ManagingMealsState parent;
  final ClientUser clientUser;
  final int index;
  final String meal;
  Edit(
      {Key key,
      @required this.clientUser,
      @required this.index,
      @required this.meal,
      @required this.parent})
      : super(key: key);
  @override
  _EditState createState() => _EditState(
      clientUser: clientUser, index: index, meal: meal, parent: parent);
}

class _EditState extends State<Edit> {
  final ManagingMealsState parent;
  final int index;
  final String meal;
  final ClientUser clientUser;
  _EditState(
      {Key key,
      @required this.clientUser,
      @required this.index,
      @required this.meal,
      @required this.parent});

  String hinttText = "";

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
  void initState() {
   
    super.initState();
    prefs.setString("meal", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: prefix0.backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15 * prefs.getDouble('width')),
            child: IconButton(
              icon: Icon(
                Icons.check,
                size: 22 * prefs.getDouble('height'),
                color: Colors.white,
              ),
              onPressed: () {
                widget.parent.batch.updateData(
                  widget.parent.db
                      .collection('clientUsers')
                      .document(clientUser.id),
                  {"meals$meal.$index": "${prefs.getString("meal")}"},
                );
                Navigator.of(context).pop();
                widget.parent.setState(() {
                  if (prefs.getString('meal') != null) {
                    if (meal == "Dinner") {
                      if (index == 1) {
                        clientUser.mealsDinner.day1 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsDinner.day1 =
                            prefs.getString('meal');
                      }
                      if (index == 2) {
                        clientUser.mealsDinner.day2 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day2 =
                            prefs.getString('meal');
                      }
                      if (index == 3) {
                        clientUser.mealsDinner.day3 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day3 =
                            prefs.getString('meal');
                      }
                      if (index == 4) {
                        clientUser.mealsDinner.day4 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day4 =
                            prefs.getString('meal');
                      }
                      if (index == 5) {
                        clientUser.mealsDinner.day5 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day5 =
                            prefs.getString('meal');
                      }
                      if (index == 6) {
                        clientUser.mealsDinner.day6 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day6 =
                            prefs.getString('meal');
                      }
                      if (index == 7) {
                        clientUser.mealsDinner.day7 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day7 =
                            prefs.getString('meal');
                      }
                      if (index == 8) {
                        clientUser.mealsDinner.day8 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day8 =
                            prefs.getString('meal');
                      }
                      if (index == 9) {
                        clientUser.mealsDinner.day9 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day9 =
                            prefs.getString('meal');
                      }
                      if (index == 10) {
                        clientUser.mealsDinner.day10 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day10 =
                            prefs.getString('meal');
                      }
                      if (index == 11) {
                        clientUser.mealsDinner.day11 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day11 =
                            prefs.getString('meal');
                      }
                      if (index == 12) {
                        clientUser.mealsDinner.day12 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day12 =
                            prefs.getString('meal');
                      }
                      if (index == 13) {
                        clientUser.mealsDinner.day13 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day13 =
                            prefs.getString('meal');
                      }
                      if (index == 14) {
                        clientUser.mealsDinner.day14 = prefs.getString('meal');

                        widget.parent.cclientUser.mealsDinner.day14 =
                            prefs.getString('meal');
                      }
                    }

                    if (meal == "Lunch") {
                      if (index == 1) {
                        clientUser.mealsLunch.day1 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day1 =
                            prefs.getString('meal');
                      }
                      if (index == 2) {
                        clientUser.mealsLunch.day2 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day2 =
                            prefs.getString('meal');
                      }
                      if (index == 3) {
                        clientUser.mealsLunch.day3 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day3 =
                            prefs.getString('meal');
                      }
                      if (index == 4) {
                        clientUser.mealsLunch.day4 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day4 =
                            prefs.getString('meal');
                      }
                      if (index == 5) {
                        clientUser.mealsLunch.day5 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day5 =
                            prefs.getString('meal');
                      }
                      if (index == 6) {
                        clientUser.mealsLunch.day6 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day6 =
                            prefs.getString('meal');
                      }
                      if (index == 7) {
                        clientUser.mealsLunch.day7 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day7 =
                            prefs.getString('meal');
                      }
                      if (index == 8) {
                        clientUser.mealsLunch.day8 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day8 =
                            prefs.getString('meal');
                      }
                      if (index == 9) {
                        clientUser.mealsLunch.day9 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day9 =
                            prefs.getString('meal');
                      }
                      if (index == 10) {
                        clientUser.mealsLunch.day10 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day10 =
                            prefs.getString('meal');
                      }
                      if (index == 11) {
                        clientUser.mealsLunch.day11 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day11 =
                            prefs.getString('meal');
                      }
                      if (index == 12) {
                        clientUser.mealsLunch.day12 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day12 =
                            prefs.getString('meal');
                      }
                      if (index == 13) {
                        clientUser.mealsLunch.day13 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day13 =
                            prefs.getString('meal');
                      }
                      if (index == 14) {
                        clientUser.mealsLunch.day14 = prefs.getString('meal');
                        widget.parent.cclientUser.mealsLunch.day14 =
                            prefs.getString('meal');
                      }
                    }

                    if (meal == "Breakfast") {
                      if (index == 1) {
                        clientUser.mealsBreakfast.day1 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day1 =
                            prefs.getString('meal');
                      }
                      if (index == 2) {
                        clientUser.mealsBreakfast.day2 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day12 =
                            prefs.getString('meal');
                      }
                      if (index == 3) {
                        clientUser.mealsBreakfast.day3 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day3 =
                            prefs.getString('meal');
                      }
                      if (index == 4) {
                        clientUser.mealsBreakfast.day4 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day4 =
                            prefs.getString('meal');
                      }
                      if (index == 5) {
                        clientUser.mealsBreakfast.day5 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day5 =
                            prefs.getString('meal');
                      }
                      if (index == 6) {
                        clientUser.mealsBreakfast.day6 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day6 =
                            prefs.getString('meal');
                      }
                      if (index == 7) {
                        clientUser.mealsBreakfast.day7 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day7 =
                            prefs.getString('meal');
                      }
                      if (index == 8) {
                        clientUser.mealsBreakfast.day8 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day8 =
                            prefs.getString('meal');
                      }
                      if (index == 9) {
                        clientUser.mealsBreakfast.day9 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day9 =
                            prefs.getString('meal');
                      }
                      if (index == 10) {
                        clientUser.mealsBreakfast.day10 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day10 =
                            prefs.getString('meal');
                      }
                      if (index == 11) {
                        clientUser.mealsBreakfast.day11 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day11 =
                            prefs.getString('meal');
                      }
                      if (index == 12) {
                        clientUser.mealsBreakfast.day12 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day12 =
                            prefs.getString('meal');
                      }
                      if (index == 13) {
                        clientUser.mealsBreakfast.day13 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day13 =
                            prefs.getString('meal');
                      }
                      if (index == 14) {
                        clientUser.mealsBreakfast.day14 =
                            prefs.getString('meal');
                        widget.parent.cclientUser.mealsBreakfast.day14 =
                            prefs.getString('meal');
                      }
                    }
                  }
                  widget.parent.restart = true;
                  widget.parent.mealPlanChanged = true;
                });
              },
            ),
          )
        ],
        backgroundColor: prefix0.backgroundColor,
        elevation: 0.0,
        title: Text(
          "Modify " +
              (meal == "Breakfast"
                  ? "the breakfast"
                  : meal == "Lunch" ? "the lunch" : "the dinner"),
          style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 22 * prefs.getDouble('height'),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50 * prefs.getDouble('height'),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 20 * prefs.getDouble('width')),
            height: 200 * prefs.getDouble('height'),
            child: TextField(
              cursorColor: prefix0.mainColor,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.center,
              maxLines: 10,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 17.0 * prefs.getDouble('height'),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: prefix0.mainColor),
                ),
                alignLabelWithHint: true,
                labelStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 18 * prefs.getDouble('height'),
                  color: Colors.white,
                ),
                labelText: "Modify the meal plan",
              ),
              onChanged: (String str) {
                hinttText = str;
                prefs.setString("meal", hinttText);
              },
            ),
          ),
        ],
      ),
    );
  }
}
