import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierChart.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierConfig.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierLine.dart';
import 'package:Bsharkr/models/TrainerProfileVisists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../colors.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  TrainerProfileVisits profileVisits;
  List<DataPoint<DateTime>> dateList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
                        stream: Firestore.instance
                            .collection('profileVisits')
                            .where('id', isEqualTo: prefs.getString('id'))
                            .snapshots(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(mainColor),
                                  backgroundColor: backgroundColor,
                                ),
                              ),
                              color: backgroundColor,
                            );
                          }
                          profileVisits = TrainerProfileVisits(snapshot.data.documents[0]);
                          for (int i = 0;
                              i < profileVisits.viewsList.length;
                              i++) {
                            if (profileVisits.dateList
                                        .where((element) =>
                                            int.parse(element.number) ==
                                            (i + 1))
                                        .toList()[0] !=
                                    null &&
                                profileVisits.viewsList
                                        .where((element) =>
                                            int.parse(element.number) ==
                                            (i + 1))
                                        .toList()[0] !=
                                    null) {
                              dateList.add(DataPoint<DateTime>(
                                  value: double.parse(profileVisits.viewsList
                                      .where((element) =>
                                          int.parse(element.number) == (i + 1))
                                      .toList()[0]
                                      .views
                                      .toString()),
                                  xAxis: profileVisits.dateList
                                      .where((element) =>
                                          int.parse(element.number) == (i + 1))
                                      .toList()[0]
                                      .time
                                      .toDate()));
                            }
                          }
                          return profileVisits == null ?  Container : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(
                                    32 * prefs.getDouble('height')),
                                child: Container(
                                  height: 48 * prefs.getDouble('height'),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Profile views",
                                              style: TextStyle(
                                                  letterSpacing: -0.408,
                                                  fontSize: 17 *
                                                      prefs.getDouble('height'),
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "Last 30 days",
                                              style: TextStyle(
                                                  letterSpacing: -0.06,
                                                  fontSize: 11 *
                                                      prefs.getDouble('height'),
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                                "All time total:" +
                                                    profileVisits.visits
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 11 *
                                                      prefs.getDouble('height'),
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromARGB(
                                                      100, 255, 255, 255),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                          .where((element) =>
                                              element.number.toString() == '1')
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
                                          contentWidth:
                                              310 * prefs.getDouble('width'),
                                          xAxisTextStyle: TextStyle(
                                              color: Colors.transparent),
                                          showDataPoints: false,
                                          snap: false,
                                          verticalIndicatorStrokeWidth: 0.0,
                                          backgroundColor: backgroundColor),
                                    )),
                              ),
                              SizedBox(
                                height: 16 * prefs.getDouble('height'),
                              ),
                              SvgPicture.asset(
                                'assets/analyticsf1.svg',
                                width: 250.0 * prefs.getDouble('width'),
                                height: 165.0 * prefs.getDouble('height'),
                              ),
                              SizedBox(
                                height: 16 * prefs.getDouble('height'),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 18 * prefs.getDouble('width')),
                                width: 375 * prefs.getDouble('width'),
                                child: Text(
                                  "We are currently working on providing more detailed analytics for your personal trainer career to grow.",
                                  style: TextStyle(
                                      letterSpacing: 0.75,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      color: Color.fromARGB(200, 255, 255, 255),
                                      fontFamily: 'Roboto'),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 18 * prefs.getDouble('width')),
                                width: 375 * prefs.getDouble('width'),
                                child: Text(
                                  "Coming soon",
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
                          );
                        },
                      );
  }
}