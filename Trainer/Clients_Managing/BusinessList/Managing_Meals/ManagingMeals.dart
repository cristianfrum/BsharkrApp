import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day1.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day10.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day11.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day12.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day13.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day14.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day2.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day3.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day4.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day5.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day6.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day7.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day8.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/day9.dart';
import 'package:Bsharkr/models/clientUser.dart';

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

class MyPopupRouteMeals extends PopupRoute<void> {
  MyPopupRouteMeals({this.clientUser, this.currentCard});
  
  final int currentCard;
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
      ManagingMeals(
        clientUser: clientUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ManagingMeals extends StatefulWidget {
  final ClientUser clientUser;

  ManagingMeals({Key key, @required this.clientUser}) : super(key: key);

  @override
  State createState() => ManagingMealsState(clientUser: clientUser);
}

class ManagingMealsState extends State<ManagingMeals> {
  final ClientUser clientUser;
  ManagingMealsState({Key key, @required this.clientUser});

  Future _getData;

  var db = Firestore.instance;
  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: clientUser.id,
        )
        .getDocuments();
  }

  bool restart = false;

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
    "Ianuarie",
    "Februarie",
    "Martie",
    "Aprilie",
    "Mai",
    "Iunie",
    "Iulie",
    "August",
    "Septembrie",
    "Octombrie",
    "Noiembrie",
    "Decembrie"
  ];

  int currentPage = 0;
  var batch;
  @override
  void initState() {
   
    super.initState();
    _getData = getData();

    batch = db.batch();
  }

  bool mealPlanChanged = false;
  ClientUser cclientUser;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _getData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(prefix0.mainColor),
                ),
              ),
              color: prefix0.backgroundColor,
            );
          }
          if (restart == false) {
            cclientUser = ClientUser(snapshot.data.documents[0]);
          }
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
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  SecondPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  ThirdPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  FourthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  FifthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  SixthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  SeventhPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  EithPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  NinethPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  TenthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  EleventhPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  TwelfthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  TirteenthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                  FourteenthPage(
                    clientUser: cclientUser,
                    parent: this,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 95.0 * prefs.getDouble('height')),
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
              ),
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100 * prefs.getDouble('height'),
                    color: Colors.transparent,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    if (mealPlanChanged == true) {
                      batch.commit();
                      Firestore.instance
                          .collection('mealPlanUpdated')
                          .document(clientUser.id)
                          .setData(
                        {
                          'idFrom': prefs.getString('id'),
                          'idTo': clientUser.id,
                          'pushToken': clientUser.pushToken
                        },
                      );
                      Firestore.instance
                          .collection('clientUsers')
                          .document(clientUser.id)
                          .updateData(
                        {
                          'mealPlanUpdated': true,
                        },
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: double.infinity,
                      height: 80 * prefs.getDouble('height'),
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
                           mealPlanChanged != true ?   "Close" : "Save changes & notify your client",
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
        });
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
