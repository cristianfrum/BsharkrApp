import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/TrainerProfileVisists.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierChart.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierConfig.dart';
import 'package:Bsharkr/Trainer/My_Profile/BezierLine.dart';

class Trophies extends StatefulWidget {
  TrainerUser imTrainer;
  Trophies({this.imTrainer});
  @override
  _TrophiesState createState() => _TrophiesState();
}

class _TrophiesState extends State<Trophies>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
   
    super.initState();
    controller = TabController(
      initialIndex: 1,
      length: 2,
      vsync: this,
    );
    views().then((result) {
      setState(() {
        profileVisits = result;
      });
    });
  }

  List<DataPoint<DateTime>> dateList = [];
  TrainerProfileVisits profileVisits;
  views() async {
    setState(() {
      isLoading = true;
    });
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

    setState(() {
      isLoading = false;
    });
    return profileVisits;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
            ),
            color: backgroundColor,
          )
        : DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(106 * prefs.getDouble('height')),
                child: AppBar(
                  backgroundColor: secondaryColor,
                  title: Text(
                    "Marketing",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: -0.408,
                        fontSize: 17 * prefs.getDouble('height'),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto'),
                  ),
                  centerTitle: true,
                  bottom: TabBar(
                      indicatorColor: mainColor,
                      controller: controller,
                      tabs: <Widget>[
                        Tab(
                          text: "Analytics",
                        ),
                        Tab(
                          text: "Trophies",
                        )
                      ]),
                ),
              ),
              body: TabBarView(controller: controller, children: <Widget>[
                profileVisits != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.all(32 * prefs.getDouble('height')),
                            child: Container(
                              height: 48 * prefs.getDouble('height'),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                profileVisits.visits.toString(),
                                            style: TextStyle(
                                              fontSize: 11 *
                                                  prefs.getDouble('height'),
                                              fontFamily: 'Roboto',
                                              color: Color.fromARGB(
                                                  100, 255, 255, 255),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              ViewsInfo(),
                                            );
                                          },
                                          child: Icon(
                                            Icons.info,
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            size:
                                                18 * prefs.getDouble('height'),
                                          ),
                                        )
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
                                      xAxisTextStyle:
                                          TextStyle(color: Colors.transparent),
                                      showDataPoints: false,
                                      snap: false,
                                      verticalIndicatorStrokeWidth: 0.0,
                                      backgroundColor: backgroundColor),
                                )),
                          ),
                          SizedBox(
                            height: 42 * prefs.getDouble('height'),
                          ),
                          SvgPicture.asset(
                            'assets/analyticsf1.svg',
                            width: 450.0 * prefs.getDouble('width'),
                            height: 220.0 * prefs.getDouble('height'),
                          ),
                          SizedBox(
                            height: 16 * prefs.getDouble('height'),
                          ),
                        ],
                      )
                    : Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    Container(
                      child: SvgPicture.asset(
                        'assets/win.svg',
                        width: 200.0 * prefs.getDouble('width'),
                        height: 142.0 * prefs.getDouble('height'),
                      ),
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Container(
                      height: 41 * prefs.getDouble('height'),
                      child: Text(
                        widget.imTrainer.trophies.toString(),
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 34 * prefs.getDouble('height'),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 16 * prefs.getDouble('height'),
                      child: Center(
                        child: Text(
                          "Trophies remaining",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontSize: 12 * prefs.getDouble('height')),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32 * prefs.getDouble('height'),
                    ),
                    Container(
                      width: 343 * prefs.getDouble('width'),
                      height: 110 * prefs.getDouble('height'),
                      margin: EdgeInsets.symmetric(
                          horizontal: 16 * prefs.getDouble('width')),
                      padding: EdgeInsets.all(16 * prefs.getDouble('height')),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Small pack",
                            style: TextStyle(
                                color: Color.fromARGB(200, 255, 255, 255),
                                letterSpacing: -0.078,
                                fontSize: 13 * prefs.getDouble('height'),
                                fontFamily: 'Roboto'),
                          ),
                          SizedBox(height: 4 * prefs.getDouble('height')),
                          Container(
                            height: 29 * prefs.getDouble('height'),
                            width: 343 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "300 Trophies",
                                    style: TextStyle(
                                        letterSpacing: 0.75,
                                        color: mainColor,
                                        fontSize:
                                            20 * prefs.getDouble('height'),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    width: 99.0 * prefs.getDouble('width'),
                                    height: 29.0 * prefs.getDouble('height'),
                                    child: Material(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(90.0),
                                      child: MaterialButton(
                                        onPressed: () async {},
                                        child: Text(
                                          'Not available',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                              fontSize: 11.0 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: 0.06,
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
                          SizedBox(height: 8 * prefs.getDouble('height')),
                          Container(
                            height: 21 * prefs.getDouble('height'),
                            width: 150 * prefs.getDouble('width'),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  letterSpacing: -0.32,
                                  fontSize: 16 * prefs.getDouble('height'),
                                  fontFamily: 'Roboto'),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      width: 343 * prefs.getDouble('width'),
                      height: 110 * prefs.getDouble('height'),
                      margin: EdgeInsets.symmetric(
                          horizontal: 16 * prefs.getDouble('width')),
                      padding: EdgeInsets.all(16 * prefs.getDouble('height')),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Value pack",
                            style: TextStyle(
                                color: Color.fromARGB(200, 255, 255, 255),
                                letterSpacing: -0.078,
                                fontSize: 13 * prefs.getDouble('height'),
                                fontFamily: 'Roboto'),
                          ),
                          SizedBox(height: 4 * prefs.getDouble('height')),
                          Container(
                            height: 29 * prefs.getDouble('height'),
                            width: 343 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "700 Trophies",
                                    style: TextStyle(
                                        letterSpacing: 0.75,
                                        color: mainColor,
                                        fontSize:
                                            20 * prefs.getDouble('height'),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    width: 99.0 * prefs.getDouble('width'),
                                    height: 29.0 * prefs.getDouble('height'),
                                    child: Material(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(90.0),
                                      child: MaterialButton(
                                        onPressed: () async {},
                                        child: Text(
                                          'Not available',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                              fontSize: 11.0 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: 0.06,
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
                          SizedBox(height: 8 * prefs.getDouble('height')),
                          Container(
                            height: 21 * prefs.getDouble('height'),
                            width: 150 * prefs.getDouble('width'),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  letterSpacing: -0.32,
                                  fontSize: 16 * prefs.getDouble('height'),
                                  fontFamily: 'Roboto'),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16 * prefs.getDouble('height'),
                    ),
                    Container(
                      height: 32 * prefs.getDouble('height'),
                      width: 134 * prefs.getDouble('width'),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              TrophiesInfo(),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 15 * prefs.getDouble('height'),
                              ),
                              SizedBox(
                                width: 4.0 * prefs.getDouble('width'),
                              ),
                              Text(
                                "About trophies",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    letterSpacing: 0.06,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15 * prefs.getDouble('height')),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          );
  }
}

class ViewsInfo extends PopupRoute<void> {
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
        child: CustomDialogInfo(),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomDialogInfo extends StatefulWidget {
  @override
  State createState() => CustomDialogInfoState();
}

class CustomDialogInfoState extends State<CustomDialogInfo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                height: 324 * prefs.getDouble('height'),
                width: 310 * prefs.getDouble('width'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: secondaryColor,
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    16 * prefs.getDouble('height'),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 24 * prefs.getDouble('height'),
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(
                        height: 32 * prefs.getDouble('height'),
                      ),
                      Text(
                        "How profile views are calculated",
                        style: TextStyle(
                            fontSize: 28 * prefs.getDouble('height'),
                            color: Colors.white,
                            letterSpacing: 0.87,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Roboto'),
                      ),
                      SizedBox(
                        height: 84 * prefs.getDouble('height'),
                      ),
                      Text(
                        "Profile views represent the total number of times your profile was viewd directly combined with the number of times a client has seen you in his search results.",
                        style: TextStyle(
                            fontSize: 13 * prefs.getDouble('height'),
                            letterSpacing: -0.078,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto'),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class TrophiesInfo extends PopupRoute<void> {
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
        child: CustomDialogTrophies(),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomDialogTrophies extends StatefulWidget {
  @override
  State createState() => CustomDialogTrophiesState();
}

class CustomDialogTrophiesState extends State<CustomDialogTrophies> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                height: 364 * prefs.getDouble('height'),
                width: 310 * prefs.getDouble('width'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: secondaryColor,
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    16 * prefs.getDouble('height'),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 24 * prefs.getDouble('height'),
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(
                        height: 32 * prefs.getDouble('height'),
                      ),
                      Text(
                        "How trophies work for you",
                        style: TextStyle(
                            fontSize: 28 * prefs.getDouble('height'),
                            color: Colors.white,
                            letterSpacing: 0.87,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Roboto'),
                      ),
                      SizedBox(
                        height: 48 * prefs.getDouble('height'),
                      ),
                      Text(
                        "When you have trophies left, clients are allowed to rate their last training session. Each rating will consume 1 trophy from your ballance.",
                        style: TextStyle(
                            fontSize: 13 * prefs.getDouble('height'),
                            letterSpacing: -0.078,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto'),
                      ),
                      SizedBox(
                        height: 48 * prefs.getDouble('height'),
                      ),
                      Text(
                        "You can also spend trophies to create public classes, that clients outside your network can join. Creating a new public class costs 5 trophies. Private classes are completely free!",
                        style: TextStyle(
                            fontSize: 13 * prefs.getDouble('height'),
                            letterSpacing: -0.078,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
