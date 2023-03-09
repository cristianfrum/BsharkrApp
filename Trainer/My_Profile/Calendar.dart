import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Main_Menu/MainTrainer.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Calendar extends StatefulWidget {
  TrainerUser imTrainer;
  final MainTrainerState parent;
  Calendar({this.imTrainer, this.parent});
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<String> daysOfTheWeekAbbreviation = [
    "Mo",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sa",
    "Su",
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

  List<DocumentSnapshot> _clients = [];

  _getClients() async {
    if (mounted) {
      setState(() {
      });
    }
    Query q = Firestore.instance
        .collection('clientUsers')
        .where('role', isEqualTo: 'client')
        .where('trainersMap.${prefs.getString('id')}', isEqualTo: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    if (querySnapshot.documents.length != 0) {
      _clients = querySnapshot.documents;
    }
    if (mounted) {
      setState(() {
      });
    }
  }

  DateTime now;

  @override
  void initState() {
   
    super.initState();
    _getClients();
  }

  Widget day1(int index) {
    List<DateTime> sessionDateTime = [];
    List<String> workoutOrClass = [];
    List<String> sessionType = [];
    List<String> sessionLevel = [];
    List<String> sessionLocationName = [];
    List<String> sessionLocationStreet = [];
    List<Timestamp> sessionDuration = [];
    List<DocumentSnapshot> auxList = [];
    List<String> firstName = [];
    List<String> lastName = [];
    List<String> privateOrNot = [];

    if (index == 1) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day1 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day1 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day1.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day1);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day1);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day1);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day) {
          firstName.add("");
          lastName.add("");
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
        }
      });
    }

    if (index == 2) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day2 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day2 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day2.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day2);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day2);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day2);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day + 1) {
          firstName.add("");
          lastName.add("");
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
        }
      });
    }

    if (index == 3) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day3 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day3 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day3.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day3);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day3);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day3);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day + 2) {
          firstName.add("");
          lastName.add("");
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
        }
      });
    }

    if (index == 4) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day4 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day4 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day4.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day4);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day4);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day4);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day + 3) {
          firstName.add("");
          lastName.add("");
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
        }
      });
    }

    if (index == 5) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day5 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day5 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day5.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day5);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day5);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day5);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day + 4) {
          firstName.add("");
          lastName.add("");
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
        }
      });
    }

    if (index == 6) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day6 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day6 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day6.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day6);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day6);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day6);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day + 5) {
          firstName.add("");
          lastName.add("");
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
        }
      });
    }

    if (index == 7) {
      _clients.forEach((element) {
        if (ClientUser(element).checkFirstSchedule.day7 == 'true' &&
            ClientUser(element).trainingSessionTrainerId.day7 ==
                prefs.getString('id')) {
          firstName.add(ClientUser(element).firstName);
          lastName.add(ClientUser(element).lastName);
          auxList.add(element);
          sessionDateTime
              .add(ClientUser(element).scheduleFirstWeek.day7.toDate());
          workoutOrClass.add('1:1 Workout');
          sessionDuration.add(ClientUser(element).scheduleFirstEndWeek.day7);
          sessionLocationName
              .add(ClientUser(element).trainingSessionLocationName.day7);
          sessionLocationStreet
              .add(ClientUser(element).trainingSessionLocationStreet.day7);
          sessionType.add(null);
          sessionLevel.add(null);
          privateOrNot.add(null);
        }
      });

      widget.imTrainer.classes.forEach((element) {
        if (element.dateAndTimeDateTime.day == now.day + 6) {
          firstName.add("");
          lastName.add("");
          if (element.public == true) {
            privateOrNot.add("Public");
          }
          if (element.public == false) {
            privateOrNot.add("Private");
          }
          sessionDateTime.add(element.dateAndTimeDateTime);
          sessionType.add(element.type);
          sessionLevel.add(element.classLevel);
          sessionLocationName.add(element.locationName);
          sessionLocationStreet.add(element.locationStreet);
          sessionDuration.add(element.duration);
          workoutOrClass.add('Class');
        }
      });
    }

    for (int i = 0; i < sessionDateTime.length - 1; i++) {
      for (int j = i + 1; j < sessionDateTime.length; j++) {
        if (sessionDateTime[i].isAfter(sessionDateTime[j])) {
          var aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9, aux10;
          aux1 = sessionDateTime[i];
          aux2 = sessionType[i];
          aux3 = sessionLevel[i];
          aux4 = sessionLocationName[i];
          aux5 = sessionLocationStreet[i];
          aux6 = sessionDuration[i];
          aux7 = workoutOrClass[i];
          aux8 = firstName[i];
          aux9 = lastName[i];
          aux10 = privateOrNot[i];

          sessionDateTime[i] = sessionDateTime[j];
          sessionType[i] = sessionType[j];
          sessionLevel[i] = sessionLevel[j];
          sessionLocationName[i] = sessionLocationName[j];
          sessionLocationStreet[i] = sessionLocationStreet[j];
          sessionDuration[i] = sessionDuration[j];
          workoutOrClass[i] = workoutOrClass[j];
          firstName[i] = firstName[j];
          lastName[i] = lastName[j];
          privateOrNot[i] = privateOrNot[j];

          sessionDateTime[j] = aux1;
          sessionType[j] = aux2;
          sessionLevel[j] = aux3;
          sessionLocationName[j] = aux4;
          sessionLocationStreet[j] = aux5;
          sessionDuration[j] = aux6;
          workoutOrClass[j] = aux7;
          firstName[j] = aux8;
          lastName[j] = aux9;
          privateOrNot[j] = aux10;
        }
      }
    }
    print(sessionDateTime.length == 0);
    return sessionDateTime.length != 0
        ? Padding(
            padding:
                EdgeInsets.symmetric(vertical: 8 * prefs.getDouble('height')),
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(
                        16 * prefs.getDouble('width'),
                        4 * prefs.getDouble('height'),
                        16 * prefs.getDouble('width'),
                        4 * prefs.getDouble('height')),
                    child: trainingCard(
                        sessionDateTime[index],
                        sessionType[index],
                        sessionLevel[index],
                        sessionLocationName[index],
                        sessionLocationStreet[index],
                        sessionDuration[index],
                        workoutOrClass[index],
                        firstName[index],
                        lastName[index],
                        privateOrNot[index]),
                  );
                },
                itemCount: sessionDateTime.length),
          )
        : Container(
            height: 500 * prefs.getDouble('height'),
            color: backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/noTrainerBookingf1.svg',
                    width: 350.0 * prefs.getDouble('width'),
                    height: 150.0 * prefs.getDouble('height'),
                  ),
                  SizedBox(height: 32 * prefs.getDouble('height')),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 64 * prefs.getDouble('width')),
                      child: Text("No appointments",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.75,
                              fontSize: 20 * prefs.getDouble('height'),
                              color: Colors.white),
                          textAlign: TextAlign.center)),
                  SizedBox(height: 32 * prefs.getDouble('height')),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    width: 375 * prefs.getDouble('width'),
                    child: Text(
                      "Check your clients' schedules to see if you can plan any training sessions.",
                      style: TextStyle(
                          letterSpacing: 0.75,
                          fontSize: 13 * prefs.getDouble('height'),
                          color: Color.fromARGB(200, 255, 255, 255),
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                      maxLines: 3,
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
                            widget.parent.setState(() {
                              widget.parent.browseClients = true;
                            });
                          },
                          child: Text(
                            'Clients',
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
          );
  }

  Widget trainingCard(
      DateTime dateTime,
      String type,
      String level,
      String locationName,
      String locationStreet,
      Timestamp duration,
      String workoutOrClass,
      String firstName,
      String lastName, String privateOrNot) {
    return workoutOrClass == '1:1 Workout'
        ? Container(
            padding: EdgeInsets.all(16 * prefs.getDouble('height')),
            height: 86 * prefs.getDouble('height'),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: secondaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ((dateTime.hour < 10
                                  ? ("0" + dateTime.hour.toString())
                                  : dateTime.hour.toString()) +
                              ":" +
                              (dateTime.minute < 10
                                  ? ("0" + dateTime.minute.toString())
                                  : dateTime.minute.toString())),
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.078,
                              fontWeight: FontWeight.w600,
                              fontSize: 13 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.078,
                              fontWeight: FontWeight.w600,
                              fontSize: 13 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        ),
                        Text(
                          ((duration.toDate().hour < 10
                                  ? ("0" + duration.toDate().hour.toString())
                                  : duration.toDate().hour.toString()) +
                              ":" +
                              (duration.toDate().minute < 10
                                  ? ("0" + duration.toDate().minute.toString())
                                  : duration.toDate().minute.toString())),
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.078,
                              fontWeight: FontWeight.w600,
                              fontSize: 13 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        )
                      ],
                    ),
                    Text(
                      workoutOrClass,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: -0.078,
                          fontWeight: FontWeight.w600,
                          fontSize: 13 * prefs.getDouble('height'),
                          fontFamily: 'Roboto'),
                    )
                  ],
                ),
                SizedBox(
                  height: 13 * prefs.getDouble('height'),
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 15 * prefs.getDouble('height'),
                        fontFamily: 'Roboto',
                        letterSpacing: -0.24),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Workout with ",
                        style: TextStyle(
                            color: Color.fromARGB(150, 255, 255, 255),
                            letterSpacing: 0.066,
                            fontSize: 11 * prefs.getDouble('height'),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto'),
                      ),
                      TextSpan(
                        text: firstName + " " + lastName,
                        style: TextStyle(
                            color: mainColor,
                            letterSpacing: 0.066,
                            fontSize: 11 * prefs.getDouble('height'),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto'),
                      ),
                      TextSpan(
                        text: " - at $locationName, $locationStreet",
                        style: TextStyle(
                            color: Color.fromARGB(150, 255, 255, 255),
                            letterSpacing: 0.066,
                            fontSize: 11 * prefs.getDouble('height'),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(16 * prefs.getDouble('height')),
            height: 92 * prefs.getDouble('height'),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: workoutOrClass == "Class" ? mainColor : secondaryColor,
                width: 2 * prefs.getDouble('height'),
              ),
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: FractionalOffset(-1.0, -1.0),
                stops: [0.0, 0.85],
                colors: [
                  workoutOrClass == "Class"
                      ? mainColor.withOpacity(1.0)
                      : secondaryColor,
                  workoutOrClass == "Class"
                      ? mainColor.withOpacity(0.0)
                      : secondaryColor,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ((dateTime.hour < 10
                                  ? ("0" + dateTime.hour.toString())
                                  : dateTime.hour.toString()) +
                              ":" +
                              (dateTime.minute < 10
                                  ? ("0" + dateTime.minute.toString())
                                  : dateTime.minute.toString())),
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.078,
                              fontWeight: FontWeight.w600,
                              fontSize: 13 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.078,
                              fontWeight: FontWeight.w600,
                              fontSize: 13 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        ),
                        Text(
                          ((dateTime
                                          .add(Duration(
                                              hours: duration.toDate().hour,
                                              minutes:
                                                  duration.toDate().minute))
                                          .hour <
                                      10
                                  ? ("0" +
                                      dateTime
                                          .add(Duration(
                                              hours: duration.toDate().hour,
                                              minutes:
                                                  duration.toDate().minute))
                                          .hour
                                          .toString())
                                  : dateTime
                                      .add(Duration(
                                          hours: duration.toDate().hour,
                                          minutes: duration.toDate().minute))
                                      .hour
                                      .toString()) +
                              ":" +
                              (dateTime
                                          .add(Duration(
                                              hours: duration.toDate().hour,
                                              minutes:
                                                  duration.toDate().minute))
                                          .minute <
                                      10
                                  ? ("0" +
                                      dateTime
                                          .add(Duration(
                                              hours: duration.toDate().hour,
                                              minutes:
                                                  duration.toDate().minute))
                                          .minute
                                          .toString())
                                  : dateTime
                                      .add(Duration(
                                          hours: duration.toDate().hour,
                                          minutes: duration.toDate().minute))
                                      .minute
                                      .toString())),
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: -0.078,
                              fontWeight: FontWeight.w600,
                              fontSize: 13 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                    Text(
                  privateOrNot + " " + workoutOrClass[0].toLowerCase() + workoutOrClass.substring(1),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: -0.078,
                          fontWeight: FontWeight.w600,
                          fontSize: 13 * prefs.getDouble('height'),
                          fontFamily: 'Roboto'),
                    )
                  ],
                ),
                SizedBox(
                  height: 13 * prefs.getDouble('height'),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15 * prefs.getDouble('height'),
                      fontFamily: 'Roboto',
                      letterSpacing: -0.24,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "${level[0].toUpperCase()}${level.substring(1)} ${type[0].toUpperCase()}${type.substring(1)}",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.066,
                            fontSize: 11 * prefs.getDouble('height'),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto'),
                      ),
                      TextSpan(
                        text: " - at $locationName, $locationStreet",
                        style: TextStyle(
                            color: Color.fromARGB(150, 255, 255, 255),
                            letterSpacing: 0.066,
                            fontSize: 11 * prefs.getDouble('height'),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    now = DateTime.now();
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(106 * prefs.getDouble('height')),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 106 * prefs.getDouble('height'),
                    color: secondaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 22 * prefs.getDouble('height'),
                        ),
                        Container(
                          height: 84 * prefs.getDouble('height'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                monthsOfTheYear[now.month - 1] +
                                    " " +
                                    (now.day.toInt() < 10 ? "0" : "") +
                                    now.day.toString() +
                                    " - " +
                                    (now.day.toInt() + 6 < 10 ? "0" : "") +
                                    (now.day.toInt() + 6).toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(200, 255, 255, 255),
                                    letterSpacing: -0.078,
                                    fontSize: 13 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto'),
                              ),
                              SizedBox(height: 8 * prefs.getDouble('height')),
                              TabBar(
                                indicatorColor: mainColor,
                                tabs: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day + 1}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday + 1 - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday +
                                                                      1 -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day + 2}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday + 2 - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday +
                                                                      2 -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day + 3}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday + 3 - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday +
                                                                      3 -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day + 4}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday + 4 - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday +
                                                                      4 -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day + 5}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday + 5 - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday +
                                                                      5 -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          "${now.day + 6}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 255, 255, 255),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize: 11 *
                                                  prefs.getDouble('height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              6 * prefs.getDouble('height')),
                                      Container(
                                        height:
                                            16.8 * prefs.getDouble('height'),
                                        child: Text(
                                          daysOfTheWeekAbbreviation[
                                              (now.weekday + 6 - 1) % 7],
                                          style: TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Roboto',
                                              letterSpacing: 0.06,
                                              fontSize:
                                                  daysOfTheWeekAbbreviation[
                                                              (now.weekday +
                                                                      6 -
                                                                      1) %
                                                                  7] ==
                                                          "Mo"
                                                      ? 16 *
                                                          prefs.getDouble(
                                                              'height')
                                                      : 17 *
                                                          prefs.getDouble(
                                                              'height')),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              12 * prefs.getDouble('height')),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: secondaryColor,
          title: Text(
            "Calendar",
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.8,
                fontSize: 22 * prefs.getDouble('height'),
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            day1(1),
            day1(2),
            day1(3),
            day1(4),
            day1(5),
            day1(6),
            day1(7),
          ],
        ),
      ),
    );
  }
}
