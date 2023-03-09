import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Classes/AddNewClass.dart';
import 'package:Bsharkr/Trainer/Classes/clientsThatJoined.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Classes extends StatefulWidget {
  final TrainerUser imTrainer;
  Classes({
    this.imTrainer,
  });
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
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

  Widget item(int index) {
    if (widget.imTrainer.classes[index] != null) {
      String hour = widget.imTrainer.classes[index].dateAndTimeDateTime.hour <
              10
          ? ("0" +
              widget.imTrainer.classes[index].dateAndTimeDateTime.hour
                  .toString())
          : widget.imTrainer.classes[index].dateAndTimeDateTime.hour.toString();
      String minute =
          widget.imTrainer.classes[index].dateAndTimeDateTime.minute < 10
              ? ("0" +
                  widget.imTrainer.classes[index].dateAndTimeDateTime.minute
                      .toString())
              : widget.imTrainer.classes[index].dateAndTimeDateTime.minute
                  .toString();
      String duration;
      if (widget.imTrainer.classes[index].duration.toDate().hour < 1) {
        if (widget.imTrainer.classes[index].duration.toDate().minute >= 0 &&
            widget.imTrainer.classes[index].duration.toDate().minute < 10) {
          duration =
              "0${widget.imTrainer.classes[index].duration.toDate().minute}m";
        }
        if (widget.imTrainer.classes[index].duration.toDate().minute > 9 &&
            widget.imTrainer.classes[index].duration.toDate().minute < 60) {
          duration =
              "${widget.imTrainer.classes[index].duration.toDate().minute}m";
        }
      } else {
        if (widget.imTrainer.classes[index].duration.toDate().hour > 0 &&
            widget.imTrainer.classes[index].duration.toDate().hour < 10) {
          duration =
              "0${widget.imTrainer.classes[index].duration.toDate().hour}h";
        }
        if (widget.imTrainer.classes[index].duration.toDate().hour > 9 &&
            widget.imTrainer.classes[index].duration.toDate().hour < 60) {
          duration =
              "${widget.imTrainer.classes[index].duration.toDate().hour}h";
        }

        if (widget.imTrainer.classes[index].duration.toDate().minute >= 0 &&
            widget.imTrainer.classes[index].duration.toDate().minute < 10) {
          duration = duration +
              " " +
              "0${widget.imTrainer.classes[index].duration.toDate().minute}m";
        }
        if (widget.imTrainer.classes[index].duration.toDate().minute > 9 &&
            widget.imTrainer.classes[index].duration.toDate().minute < 60) {
          duration = duration +
              " " +
              "${widget.imTrainer.classes[index].duration.toDate().minute}m";
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 343 * prefs.getDouble('width'),
            height: 306 * prefs.getDouble('height'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: secondaryColor,
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16 * prefs.getDouble('width'),
                    vertical: 16 * prefs.getDouble('height')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 56 * prefs.getDouble('height'),
                          width: 216 * prefs.getDouble('width'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "${widget.imTrainer.classes[index].dateAndTimeDateTime.year}" +
                                      "-" +
                                      "${monthsOfTheYear[widget.imTrainer.classes[index].dateAndTimeDateTime.month - 1]}" +
                                      "-" +
                                      "${widget.imTrainer.classes[index].dateAndTimeDateTime.day}" +
                                      "-" +
                                      "${daysOfTheWeek[widget.imTrainer.classes[index].dateAndTimeDateTime.weekday - 1]}" +
                                      " " +
                                      hour +
                                      ":" +
                                      minute,
                                  style: TextStyle(
                                      letterSpacing: 0.066,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Roboto',
                                      color: mainColor)),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 15 * prefs.getDouble('height'),
                                      fontFamily: 'Roboto',
                                      letterSpacing: -0.24),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.imTrainer.classes[index]
                                              .classLevel +
                                          " " +
                                          widget.imTrainer.classes[index].type +
                                          " Class with " +
                                          widget.imTrainer.firstName +
                                          " " +
                                          widget.imTrainer.lastName,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              17 * prefs.getDouble('height'),
                                          letterSpacing: -0.408,
                                          color: Colors.white),
                                    ),
                                    TextSpan(
                                        text: widget.imTrainer.classes[index]
                                                    .public ==
                                                true
                                            ? " - PUBLIC"
                                            : " - PRIVATE",
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize:
                                                12 * prefs.getDouble('height'),
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25 * prefs.getDouble('height'),
                          width: 94 * prefs.getDouble('width'),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(duration,
                                    style: TextStyle(
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        letterSpacing: -0.24,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(200, 255, 255, 255),
                                        fontFamily: 'Roboto')),
                                SizedBox(width: 8.0 * prefs.getDouble('width')),
                                Icon(Icons.alarm,
                                    color: mainColor,
                                    size: 24 * prefs.getDouble('height'))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[],
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.imTrainer.classes[index].gymWebsite !=
                            null) {
                          launch(widget.imTrainer.classes[index].gymWebsite);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 24 * prefs.getDouble('height'),
                            color: mainColor,
                          ),
                          SizedBox(width: 8 * prefs.getDouble('width')),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 15 * prefs.getDouble('height'),
                                      fontFamily: 'Roboto',
                                      letterSpacing: -0.24),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "At ",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.imTrainer.classes[index]
                                          .locationName,
                                      style: TextStyle(color: mainColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.imTrainer.classes[index].locationStreet +
                                    ", " +
                                    widget.imTrainer.classes[index]
                                        .locationDistrict,
                                style: TextStyle(
                                    fontSize: 15 * prefs.getDouble('height'),
                                    fontFamily: 'Roboto',
                                    letterSpacing: -0.24,
                                    color: Color.fromARGB(150, 255, 255, 255)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          size: 24 * prefs.getDouble('height'),
                          color: mainColor,
                        ),
                        SizedBox(width: 8 * prefs.getDouble('width')),
                        Text(
                          widget.imTrainer.classes[index].occupiedSpots.length
                                  .toString() +
                              "/" +
                              widget.imTrainer.classes[index].spots.toString() +
                              " occupied spots in this class",
                          style: TextStyle(
                              fontSize: 15 * prefs.getDouble('height'),
                              fontFamily: 'Roboto',
                              letterSpacing: -0.24,
                              color: Color.fromARGB(150, 255, 255, 255)),
                        )
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 24 * prefs.getDouble('height'),
                          color: mainColor,
                        ),
                        SizedBox(width: 8 * prefs.getDouble('width')),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget.imTrainer.classes[index]
                                        .individualPrice,
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 22 * prefs.getDouble('height'),
                                    ),
                                  ),
                                  TextSpan(
                                    text: " individual price",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        letterSpacing: -0.24),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "or " +
                                  widget.imTrainer.classes[index].memberPrice +
                                  " member price",
                              style: TextStyle(
                                  fontSize: 15 * prefs.getDouble('height'),
                                  fontFamily: 'Roboto',
                                  letterSpacing: -0.24,
                                  color: Color.fromARGB(150, 255, 255, 255)),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.0 * prefs.getDouble('height')),
                          child: Container(
                            width: 150.0 * prefs.getDouble('width'),
                            height: 42.0 * prefs.getDouble('height'),
                            child: Material(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(90.0),
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ClientsThatJoined(
                                              imTrainer: widget.imTrainer,
                                              title: widget
                                                      .imTrainer
                                                      .classes[index]
                                                      .classLevel +
                                                  " " +
                                                  widget.imTrainer
                                                      .classes[index].type +
                                                  " Class",
                                              index: index,
                                            )),
                                  ).catchError((Object response){
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text(
                                  'Manage students',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize:
                                          12.0 * prefs.getDouble('height'),
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.06),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.0 * prefs.getDouble('height')),
                          child: Container(
                            width: 150.0 * prefs.getDouble('width'),
                            height: 42.0 * prefs.getDouble('height'),
                            child: Material(
                              color: Color(0xff57575E),
                              borderRadius: BorderRadius.circular(90.0),
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    RemovePopUp1(
                                        imTrainer: widget.imTrainer,
                                        index: index),
                                  );
                                },
                                child: Text(
                                  'Remove class',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize:
                                          12.0 * prefs.getDouble('height'),
                                      letterSpacing: 0.06,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(height: 8.0 * prefs.getDouble('height'))
        ],
      );
    }
  }


  List<int> indexes = [];
  @override
  Widget build(BuildContext context) {
    indexes.clear();
    List<DateTime> dateTimeList = [];
    for (int i = 0; i < widget.imTrainer.classes.length; i++) {
      dateTimeList.add(widget.imTrainer.classes[i].dateAndTimeDateTime);
    }
    for (int i = 0; i < dateTimeList.length - 1; i++) {
      for (int j = i + 1; j < dateTimeList.length; j++) {
        if (dateTimeList[i].isAfter(dateTimeList[j])) {
          DateTime aux = dateTimeList[i];
          dateTimeList[i] = dateTimeList[j];
          dateTimeList[j] = aux;
        }
      }
    }
    for (int i = 0; i < dateTimeList.length; i++) {
      for (int j = 0; j < widget.imTrainer.classes.length; j++) {
        if (dateTimeList[i] ==
            widget.imTrainer.classes[j].dateAndTimeDateTime) {
          indexes.add(j);
        }
      }
    }
    if (widget.imTrainer.newMemberJoined == true) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {
          'newMemberJoined': FieldValue.delete(),
        },
      );
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          "Classes",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22 * prefs.getDouble('height'),
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AddNewClass(imTrainer: widget.imTrainer)),
              );
            },
            child: Padding(
                padding: EdgeInsets.only(right: 16 * prefs.getDouble('width')),
                child: Icon(
                  Icons.note_add,
                  size: 28 * prefs.getDouble('height'),
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: indexes.length != 0
          ? Padding(
              padding: EdgeInsets.only(
                  top: 16 * prefs.getDouble('width'),
                  left: 16 * prefs.getDouble('width'),
                  right: 16 * prefs.getDouble('width')),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: indexes.length,
                itemBuilder: (_, int index) => item(indexes[index]),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SvgPicture.asset(
                    'assets/trainerClassPlaceholderf1.svg',
                    width: 200.0 * prefs.getDouble('width'),
                    height: 150.0 * prefs.getDouble('height'),
                  ),
                ),
                SizedBox(height: 32 * prefs.getDouble('height')),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 48 * prefs.getDouble('width')),
                  child: Text(
                    "No classes'",
                    style: TextStyle(
                      letterSpacing: 0.75,
                      color: Colors.white,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8 * prefs.getDouble('height')),
                Container(
                  width: 200 * prefs.getDouble('width'),
                  child: Text(
                    "Start creating classes to train more students at once!",
                    style: TextStyle(
                        color: Color.fromARGB(200, 255, 255, 255),
                        letterSpacing: -0.078,
                        fontSize: 13 * prefs.getDouble('height'),
                        fontFamily: 'Roboto'),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 32 * prefs.getDouble('height')),
                Container(
                  width: 225.0 * prefs.getDouble('width'),
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
                                  AddNewClass(imTrainer: widget.imTrainer)),
                        );
                      },
                      child: Text(
                        'Create a class',
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
              ],
            ),
    );
  }
}

class RemovePopUp1 extends PopupRoute<void> {
  RemovePopUp1({this.imTrainer, this.index});
  final int index;
  final TrainerUser imTrainer;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      RemovePage1(imTrainer: imTrainer, index: index);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class RemovePage1 extends StatefulWidget {
  final int index;
  final TrainerUser imTrainer;
  RemovePage1({Key key, this.imTrainer, this.index});

  @override
  State createState() => RemovePage1State();
}

class RemovePage1State extends State<RemovePage1> {
  String hinttText = "Scrie";
  Image image;

  String hintName, hintStreet, hintSector;

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
              width: 310 * prefs.getDouble('width'),
              height: 280 * prefs.getDouble('height'),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8.0 * prefs.getDouble('height')),
                  color: backgroundColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Warning",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 20 * prefs.getDouble('height')),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16 * prefs.getDouble('height'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    child: Text(
                      "Are you sure you want to cancel ${widget.imTrainer.classes[widget.index].classLevel} ${widget.imTrainer.classes[widget.index].type} class?",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 13 * prefs.getDouble('height'),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 150.0 * prefs.getDouble('width'),
                      height: 50.0 * prefs.getDouble('height'),
                      child: Material(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(90.0),
                        child: MaterialButton(
                          onPressed: () async {
                            var db = Firestore.instance;
                            var batch = db.batch();
                            String auxType;
                            int auxTypeCounter;
                            if (widget.imTrainer.classes[widget.index].type ==
                                'Aerobic') {
                              auxType = 'aerobicCounter';

                              auxTypeCounter = widget.imTrainer.aerobicCounter;
                            } else {
                              if (widget.imTrainer.classes[widget.index].type ==
                                  'Workout') {
                                auxType = 'workoutCounter';
                                auxTypeCounter =
                                    widget.imTrainer.workoutCounter;
                              } else {
                                if (widget
                                        .imTrainer.classes[widget.index].type ==
                                    'Trx') {
                                  auxTypeCounter = widget.imTrainer.trxCounter;
                                  auxType = 'trxCounter';
                                } else {
                                  if (widget.imTrainer.classes[widget.index]
                                          .type ==
                                      'Pilates') {
                                    auxTypeCounter =
                                        widget.imTrainer.pilatesCounter;
                                    auxType = 'pilatesCounter';
                                  } else {
                                    if (widget.imTrainer.classes[widget.index]
                                            .type ==
                                        'Zumba') {
                                      auxTypeCounter =
                                          widget.imTrainer.zumbaCounter;
                                      auxType = 'zumbaCounter';
                                    } else {
                                      if (widget.imTrainer.classes[widget.index]
                                              .type ==
                                          'Kangoo Jumps') {
                                        auxTypeCounter =
                                            widget.imTrainer.kangooJumpsCounter;
                                        auxType = 'kangooJumpsCounter';
                                      }
                                    }
                                  }
                                }
                              }
                            }
                            List<String> ids = [];
                            List<String> pushTokens = [];
                            for (int i = 0;
                                i <
                                    widget.imTrainer.classes[widget.index]
                                        .occupiedSpots.length;
                                i++) {
                              int classCounter;
                              QuerySnapshot query2 = await Firestore.instance
                                  .collection('clientUsers')
                                  .where('id',
                                      isEqualTo: widget
                                          .imTrainer
                                          .classes[widget.index]
                                          .occupiedSpots[i]
                                          .id)
                                  .getDocuments();
                              ClientUser actualClient =
                                  ClientUser(query2.documents[0]);
                              ids.add(ClientUser(query2.documents[0]).id);
                              pushTokens.add(
                                  ClientUser(query2.documents[0]).pushToken);
                              for (int j = 0;
                                  j < actualClient.counterClassesClient;
                                  j++) {
                                if (actualClient.classes[j].dateAndTime ==
                                        widget.imTrainer.classes[widget.index]
                                            .dateAndTime &&
                                    actualClient
                                            .classes[j].dateAndTimeDateTime ==
                                        widget.imTrainer.classes[widget.index]
                                            .dateAndTimeDateTime &&
                                    actualClient.classes[j].duration ==
                                        widget.imTrainer.classes[widget.index]
                                            .duration &&
                                    actualClient.classes[j].firstName ==
                                        widget.imTrainer.firstName &&
                                    actualClient.classes[j].lastName ==
                                        widget.imTrainer.lastName &&
                                    actualClient.classes[j].trainerId ==
                                        widget.imTrainer.id) {
                                  classCounter = j;
                                }
                              }
                              if (classCounter == 0 &&
                                  actualClient.counterClassesClient == 1) {
                                batch.updateData(
                                  db
                                      .collection('clientUsers')
                                      .document(actualClient.id),
                                  {
                                    'deletedClient': true,
                                    'class${classCounter + 1}':
                                        FieldValue.delete(),
                                    'counterClassesClient':
                                        actualClient.counterClassesClient - 1
                                  },
                                );
                              } else {
                                for (int k = classCounter + 1;
                                    k < actualClient.counterClassesClient;
                                    k++) {
                                  batch.updateData(
                                    db
                                        .collection('clientUsers')
                                        .document(actualClient.id),
                                    {
                                      'class$k.public':
                                          actualClient.classes[k].public,
                                      'class$k.classLevel':
                                          actualClient.classes[k].classLevel,
                                      'class$k.locationName':
                                          actualClient.classes[k].locationName,
                                      'class$k.locationDistrict': actualClient
                                          .classes[k].locationDistrict,
                                      'class$k.individualPrice': actualClient
                                          .classes[k].individualPrice,
                                      'class$k.memberPrice':
                                          actualClient.classes[k].memberPrice,
                                      'class$k.type':
                                          actualClient.classes[k].type,
                                      'class$k.dateAndTime':
                                          actualClient.classes[k].dateAndTime,
                                      'class$k.dateAndTimeDateTime':
                                          actualClient
                                              .classes[k].dateAndTimeDateTime,
                                      'class$k.duration':
                                          actualClient.classes[k].duration,
                                      'class$k.locationStreet': actualClient
                                          .classes[k].locationStreet,
                                      'class$k.number': i,
                                      'class$k.trainerFirstName':
                                          actualClient.classes[k].firstName,
                                      'class$k.trainerId':
                                          actualClient.classes[k].trainerId,
                                      'class$k.trainerLastName':
                                          actualClient.classes[k].lastName
                                    },
                                  );
                                }
                                batch.updateData(
                                  db
                                      .collection('clientUsers')
                                      .document(actualClient.id),
                                  {
                                    'deletedClient': true,
                                    'class${actualClient.counterClassesClient}':
                                        FieldValue.delete(),
                                    'counterClassesClient':
                                        actualClient.counterClassesClient - 1
                                  },
                                );
                              }
                            }

                            if (widget.index == 0 &&
                                widget.imTrainer.counterClasses == 1) {
                              batch.updateData(
                                db
                                    .collection('clientUsers')
                                    .document(widget.imTrainer.id),
                                {
                                  'class${widget.imTrainer.counterClasses}':
                                      FieldValue.delete(),
                                  'counterClasses':
                                      widget.imTrainer.counterClasses - 1,
                                  '$auxType': auxTypeCounter - 1
                                },
                              );
                            } else {
                              for (int i = widget.index;
                                  i < widget.imTrainer.counterClasses - 1;
                                  i++) {
                                batch.updateData(
                                  db
                                      .collection('clientUsers')
                                      .document(widget.imTrainer.id),
                                  {
                                    'class${i + 1}.views':
                                        widget.imTrainer.classes[i + 1].views,
                                    'class${i + 1}.public':
                                        widget.imTrainer.classes[i + 1].public,
                                    'class${i + 1}.classLevel': widget
                                        .imTrainer.classes[i + 1].classLevel,
                                    'class${i + 1}.locationName': widget
                                        .imTrainer.classes[i + 1].locationName,
                                    'class${i + 1}.locationDistrict': widget
                                        .imTrainer
                                        .classes[i + 1]
                                        .locationDistrict,
                                    'class${i + 1}.gymWebsite': widget
                                        .imTrainer.classes[i + 1].gymWebsite,
                                    'class${i + 1}.individualPrice': widget
                                        .imTrainer
                                        .classes[i + 1]
                                        .individualPrice,
                                    'class${i + 1}.memberPrice': widget
                                        .imTrainer.classes[i + 1].memberPrice,
                                    'class${i + 1}.spots':
                                        widget.imTrainer.classes[i + 1].spots,
                                    'class${i + 1}.type':
                                        widget.imTrainer.classes[i + 1].type,
                                    'class${i + 1}.dateAndTime': widget
                                        .imTrainer.classes[i + 1].dateAndTime,
                                    'class${i + 1}.dateAndTimeDateTime': widget
                                        .imTrainer
                                        .classes[i + 1]
                                        .dateAndTimeDateTime,
                                    'class${i + 1}.duration': widget
                                        .imTrainer.classes[i + 1].duration,
                                    'class${i + 1}.occupiedSpots': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].occupiedSpots)
                                        v.id: v.flag
                                    },
                                    'class${i + 1}.clientsFirstName': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsFirstName)
                                        v.id: v.firstName
                                    },
                                    'class${i + 1}.clientsLastName': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsLastName)
                                        v.id: v.lastName
                                    },
                                    'class${i + 1}.clientsAge': {
                                      for (var v in widget
                                          .imTrainer.classes[i + 1].clientsAge)
                                        v.id: v.age
                                    },
                                    'class${i + 1}.clientsPhotoUrl': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsPhotoUrl)
                                        v.id: v.photoUrl
                                    },
                                    'class${i + 1}.clientsColorRed': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsColorRed)
                                        v.id: v.colorRed
                                    },
                                    'class${i + 1}.clientsColorGreen': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsColorGreen)
                                        v.id: v.colorGreen
                                    },
                                    'class${i + 1}.clientsColorBlue': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsColorBlue)
                                        v.id: v.colorBlue
                                    },
                                    'class${i + 1}.clientsGender': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsGender)
                                        v.id: v.gender
                                    },
                                    'class${i + 1}.locationStreet': widget
                                        .imTrainer
                                        .classes[i + 1]
                                        .locationStreet,
                                    'class${i + 1}.number': i + 1,
                                    'class${i + 1}.clientsRating': {
                                      for (var v in widget.imTrainer
                                          .classes[i + 1].clientsRating)
                                        v.id: v.vote
                                    },
                                  },
                                );
                              }
                              batch.updateData(
                                db
                                    .collection('clientUsers')
                                    .document(widget.imTrainer.id),
                                {
                                  'class${widget.imTrainer.counterClasses}':
                                      FieldValue.delete(),
                                  'counterClasses':
                                      widget.imTrainer.counterClasses - 1,
                                  '$auxType': auxTypeCounter - 1
                                },
                              );
                            }
                            if (ids.length != 0 || ids.length != null) {
                              await Firestore.instance
                                  .collection('deletedClass')
                                  .document(prefs.getString('id'))
                                  .setData(
                                {
                                  'idFrom': prefs.getString('id'),
                                  'idTo': ids,
                                  'pushToken': pushTokens,
                                  'firstName': widget.imTrainer.firstName
                                },
                              );
                            }
                            batch.commit();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel class',
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
                  SizedBox(
                    height: 8 * prefs.getDouble('height'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 32 * prefs.getDouble('height'),
                      width: 150 * prefs.getDouble('width'),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17 * prefs.getDouble('height'),
                              letterSpacing: -0.408,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
