import 'package:Bsharkr/Client/Congrats.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/main.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AvailablePrivateClasses extends StatefulWidget {
  final MyAppState parent;
  AvailablePrivateClasses({this.imClient, this.parent});
  final ClientUser imClient;
  @override
  _AvailablePrivateClassesState createState() =>
      _AvailablePrivateClassesState();
}

class _AvailablePrivateClassesState extends State<AvailablePrivateClasses>
    with AutomaticKeepAliveClientMixin<AvailablePrivateClasses> {
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

  Widget item(TrainerUser trainer, int index) {
    bool alreadyEnrolled = false;

    trainer.classes[index].occupiedSpots.forEach((element) {
      if (element.id == widget.imClient.id) {
        alreadyEnrolled = true;
      }
    });

    if (trainer.classes[index] != null &&
        alreadyEnrolled == false &&
        trainer.classes[index].occupiedSpots.length <
            trainer.classes[index].spots &&
        trainer.classes[index].public == false) {
      String hour = trainer.classes[index].dateAndTimeDateTime.hour < 10
          ? ("0" + trainer.classes[index].dateAndTimeDateTime.hour.toString())
          : trainer.classes[index].dateAndTimeDateTime.hour.toString();
      String minute = trainer.classes[index].dateAndTimeDateTime.minute < 10
          ? ("0" + trainer.classes[index].dateAndTimeDateTime.minute.toString())
          : trainer.classes[index].dateAndTimeDateTime.minute.toString();
      String duration;
      if (trainer.classes[index].duration.toDate().hour < 1) {
        if (trainer.classes[index].duration.toDate().minute >= 0 &&
            trainer.classes[index].duration.toDate().minute < 10) {
          duration = "0${trainer.classes[index].duration.toDate().minute}m";
        }
        if (trainer.classes[index].duration.toDate().minute > 9 &&
            trainer.classes[index].duration.toDate().minute < 60) {
          duration = "${trainer.classes[index].duration.toDate().minute}m";
        }
      } else {
        if (trainer.classes[index].duration.toDate().hour > 0 &&
            trainer.classes[index].duration.toDate().hour < 10) {
          duration = "0${trainer.classes[index].duration.toDate().hour}h";
        }
        if (trainer.classes[index].duration.toDate().hour > 9 &&
            trainer.classes[index].duration.toDate().hour < 60) {
          duration = "${trainer.classes[index].duration.toDate().hour}h";
        }

        if (trainer.classes[index].duration.toDate().minute >= 0 &&
            trainer.classes[index].duration.toDate().minute < 10) {
          duration = duration +
              " " +
              "0${trainer.classes[index].duration.toDate().minute}m";
        }
        if (trainer.classes[index].duration.toDate().minute > 9 &&
            trainer.classes[index].duration.toDate().minute < 60) {
          duration = duration +
              " " +
              "${trainer.classes[index].duration.toDate().minute}m";
        }
      }
      bool enrolledFlag = false;
      widget.imClient.classes.forEach((actualClass) {
        if (actualClass.duration == trainer.classes[index].duration &&
            actualClass.dateAndTimeDateTime ==
                trainer.classes[index].dateAndTimeDateTime &&
            actualClass.dateAndTime == trainer.classes[index].dateAndTime) {
          enrolledFlag = true;
        }
      });
      if (enrolledFlag == false) {
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
                                    "${trainer.classes[index].dateAndTimeDateTime.year}" +
                                        "-" +
                                        "${monthsOfTheYear[trainer.classes[index].dateAndTimeDateTime.month - 1]}" +
                                        "-" +
                                        "${trainer.classes[index].dateAndTimeDateTime.day}" +
                                        "-" +
                                        "${daysOfTheWeek[trainer.classes[index].dateAndTimeDateTime.weekday - 1]}" +
                                        " " +
                                        hour +
                                        ":" +
                                        minute,
                                    style: TextStyle(
                                        letterSpacing: 0.066,
                                        fontSize:
                                            13 * prefs.getDouble('height'),
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Roboto',
                                        color: mainColor)),
                                Text(
                                  trainer.classes[index].classLevel +
                                      " " +
                                      trainer.classes[index].type +
                                      " Class with " +
                                      trainer.firstName +
                                      " " +
                                      trainer.lastName,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17 * prefs.getDouble('height'),
                                      letterSpacing: -0.408,
                                      color: Colors.white),
                                  maxLines: 3,
                                )
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
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontFamily: 'Roboto')),
                                  SizedBox(
                                      width: 8.0 * prefs.getDouble('width')),
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
                          if (trainer.classes[index].gymWebsite != null) {
                            launch(trainer.classes[index].gymWebsite);
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
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                        fontFamily: 'Roboto',
                                        letterSpacing: -0.24),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "At ",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              150, 255, 255, 255),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            trainer.classes[index].locationName,
                                        style: TextStyle(color: mainColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  trainer.classes[index].locationStreet +
                                      ", " +
                                      trainer.classes[index].locationDistrict,
                                  style: TextStyle(
                                      fontSize: 15 * prefs.getDouble('height'),
                                      fontFamily: 'Roboto',
                                      letterSpacing: -0.24,
                                      color:
                                          Color.fromARGB(150, 255, 255, 255)),
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
                            trainer.classes[index].occupiedSpots.length
                                    .toString() +
                                "/" +
                                trainer.classes[index].spots.toString() +
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
                                      text: trainer
                                          .classes[index].individualPrice,
                                      style: TextStyle(
                                        color: mainColor,
                                        fontSize:
                                            22 * prefs.getDouble('height'),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " individual price",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              150, 255, 255, 255),
                                          fontSize:
                                              15 * prefs.getDouble('height'),
                                          letterSpacing: -0.24),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "or " +
                                    trainer.classes[index].memberPrice +
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: 24.0 * prefs.getDouble('height')),
                        child: Container(
                          width: 310.0 * prefs.getDouble('width'),
                          height: 41.0 * prefs.getDouble('height'),
                          child: Material(
                            color: enrolledFlag == false
                                ? mainColor
                                : Color(0xff57575E),
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (enrolledFlag == true) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "You have already signed up for this class",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              18.0 * prefs.getDouble('height'),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          color: mainColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                                } else {
                                  QuerySnapshot query = await Firestore.instance
                                      .collection('clientUsers')
                                      .where('id', isEqualTo: trainer.id)
                                      .getDocuments();

                                  TrainerUser updatedTrainer =
                                      TrainerUser(query.documents[0]);
                                  bool flagUpdated = false;
                                  int temporaryIndex = 0;
                                  updatedTrainer.classes
                                      .forEach((actualClass) async {
                                    if (actualClass.dateAndTime ==
                                            trainer
                                                .classes[index].dateAndTime &&
                                        actualClass.dateAndTimeDateTime ==
                                            trainer.classes[index]
                                                .dateAndTimeDateTime &&
                                        actualClass.duration ==
                                            trainer.classes[index].duration &&
                                        actualClass.firstName ==
                                            trainer.classes[index].firstName &&
                                        trainer.classes[index].lastName ==
                                            actualClass.lastName) {
                                      flagUpdated = true;
                                      index = temporaryIndex;
                                    }

                                    temporaryIndex++;
                                  });
                                  if (flagUpdated == true) {
                                    trainer = updatedTrainer;
                                    double rating = 0;
                                    int mediaAritmetica = 0;
                                    if (widget.imClient.votesMap.length != 0) {
                                      widget.imClient.votesMap
                                          .forEach((element) {
                                        mediaAritmetica++;
                                        rating += element.vote.toDouble();
                                      });
                                      rating /= mediaAritmetica;
                                    }
                                    bool overLap = false;
                                    if (widget.imClient.counterClassesClient >
                                        0) {
                                      var time1 = [];
                                      var time2 = [];
                                      widget.imClient.classes
                                          .forEach((actualClass) {
                                        time1.add(
                                            actualClass.dateAndTimeDateTime);
                                        time2.add(actualClass
                                            .dateAndTimeDateTime
                                            .add(Duration(
                                                hours: actualClass.duration
                                                    .toDate()
                                                    .hour,
                                                minutes: actualClass.duration
                                                    .toDate()
                                                    .minute)));
                                      });
                                      for (int i = 0;
                                          i <
                                              widget.imClient
                                                      .counterClassesClient -
                                                  1;
                                          i++) {
                                        for (int j = i + 1;
                                            j <
                                                widget.imClient
                                                    .counterClassesClient;
                                            j++) {
                                          if (time1[i].isAfter(time1[j])) {
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
                                              widget.imClient
                                                      .counterClassesClient -
                                                  1;
                                          i++) {
                                        if (time2[i].isBefore(trainer
                                                .classes[index]
                                                .dateAndTimeDateTime) &&
                                            time1[i + 1].isAfter(trainer
                                                .classes[index]
                                                .dateAndTimeDateTime
                                                .add(Duration(
                                                    hours: trainer
                                                        .classes[index].duration
                                                        .toDate()
                                                        .hour,
                                                    minutes: trainer
                                                        .classes[index].duration
                                                        .toDate()
                                                        .minute)))) {
                                          overLap = true;
                                        }
                                      }

                                      if (time1[0].isAfter(trainer
                                          .classes[index].dateAndTimeDateTime
                                          .add(Duration(
                                              hours: trainer
                                                  .classes[index].duration
                                                  .toDate()
                                                  .hour,
                                              minutes: trainer
                                                  .classes[index].duration
                                                  .toDate()
                                                  .minute)))) {
                                        overLap = true;
                                      }

                                      if (time2[widget.imClient
                                                  .counterClassesClient -
                                              1]
                                          .isBefore(trainer.classes[index]
                                              .dateAndTimeDateTime)) {
                                        overLap = true;
                                      }
                                    } else {
                                      overLap = true;
                                    }
                                    if (overLap == true) {
                                      if (updatedTrainer.classes[index]
                                              .occupiedSpots.length >=
                                          updatedTrainer.classes[index].spots) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "All spots in this class have been occupied. This page has been refreshed.",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18.0 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color: mainColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ));
                                        setState(() {
                                          _getTrainers();
                                        });
                                      } else {

                                        Navigator.push(
                                          context,
                                          CongratsPopup(),
                                        );
                                        await Firestore.instance
                                            .collection('clientUsers')
                                            .document(trainer.id)
                                            .updateData(
                                          {
                                            'newMemberJoined': true,
                                            'class${index + 1}.occupiedSpots.${widget.imClient.id}':
                                                true,
                                            'class${index + 1}.clientsFirstName.${prefs.getString('id')}':
                                                widget.imClient.firstName,
                                            'class${index + 1}.clientsAge.${prefs.getString('id')}':
                                                widget.imClient.age.toString(),
                                            'class${index + 1}.clientsGender.${prefs.getString('id')}':
                                                widget.imClient.gender,
                                            'class${index + 1}.clientsLastName.${prefs.getString('id')}':
                                                widget.imClient.lastName,
                                            'class${index + 1}.clientsPhotoUrl.${prefs.getString('id')}':
                                                widget.imClient.photoUrl,
                                            'class${index + 1}.clientsColorRed.${prefs.getString('id')}':
                                                widget.imClient.colorRed
                                                    .toString(),
                                            'class${index + 1}.clientsColorGreen.${prefs.getString('id')}':
                                                widget.imClient.colorGreen
                                                    .toString(),
                                            'class${index + 1}.clientsColorBlue.${prefs.getString('id')}':
                                                widget.imClient.colorBlue
                                                    .toString(),
                                            'class${index + 1}.clientsRating.${prefs.getString('id')}':
                                                rating.toString(),
                                          },
                                        );

                                        await Firestore.instance
                                            .collection('clientUsers')
                                            .document(prefs.getString('id'))
                                            .updateData(
                                          {
                                            'class${widget.imClient.counterClassesClient + 1}':
                                                {},
                                          },
                                        );
                                        await Firestore.instance
                                            .collection('clientUsers')
                                            .document(prefs.getString('id'))
                                            .updateData(
                                          {
                                            'deletedClient': true,
                                            'class${widget.imClient.counterClassesClient + 1}.public':
                                                trainer.classes[index].public,
                                            'class${widget.imClient.counterClassesClient + 1}.gymWebsite':
                                                trainer
                                                    .classes[index].gymWebsite,
                                            'class${widget.imClient.counterClassesClient + 1}.classLevel':
                                                trainer
                                                    .classes[index].classLevel,
                                            'class${widget.imClient.counterClassesClient + 1}.locationName':
                                                trainer.classes[index]
                                                    .locationName,
                                            'class${widget.imClient.counterClassesClient + 1}.locationDistrict':
                                                trainer.classes[index]
                                                    .locationDistrict,
                                            'class${widget.imClient.counterClassesClient + 1}.number':
                                                widget.imClient
                                                        .counterClassesClient +
                                                    1,
                                            'class${widget.imClient.counterClassesClient + 1}.individualPrice':
                                                trainer.classes[index]
                                                    .individualPrice,
                                            'class${widget.imClient.counterClassesClient + 1}.memberPrice':
                                                trainer
                                                    .classes[index].memberPrice,
                                            'class${widget.imClient.counterClassesClient + 1}.type':
                                                trainer.classes[index].type,
                                            'class${widget.imClient.counterClassesClient + 1}.dateAndTime':
                                                trainer
                                                    .classes[index].dateAndTime,
                                            'counterClassesClient': widget
                                                    .imClient
                                                    .counterClassesClient +
                                                1,
                                            'class${widget.imClient.counterClassesClient + 1}.dateAndTimeDateTime':
                                                trainer.classes[index]
                                                    .dateAndTimeDateTime,
                                            'class${widget.imClient.counterClassesClient + 1}.duration':
                                                trainer.classes[index].duration,
                                            'class${widget.imClient.counterClassesClient + 1}.locationStreet':
                                                trainer.classes[index]
                                                    .locationStreet,
                                            'class${widget.imClient.counterClassesClient + 1}.trainerId':
                                                trainer.id,
                                            'class${widget.imClient.counterClassesClient + 1}.trainerFirstName':
                                                trainer.firstName,
                                            'class${widget.imClient.counterClassesClient + 1}.trainerLastName':
                                                trainer.lastName,
                                          },
                                        );
                                        await Firestore.instance
                                            .collection('newMemberJoined')
                                            .document(trainer.id)
                                            .setData(
                                          {
                                            'idFrom': prefs.getString('id'),
                                            'idTo': trainer.id,
                                            'pushToken': trainer.pushToken,
                                            'firstName':
                                                widget.imClient.firstName
                                          },
                                        );
                                        setState(() {
                                          _getTrainers();
                                        });
                                      }
                                    } else {
                                      if (overLap == false) {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            "One of your classes overlaps this one",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18.0 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color: mainColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ));
                                        setState(() {
                                          _getTrainers();
                                        });
                                      } else {
                                        if (enrolledFlag == true) {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "You have already signed up for this class",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18.0 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w500,
                                                  color: mainColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                        }
                                      }
                                    }
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "This class has been canceled. The page has been refreshed.",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18.0 *
                                                prefs.getDouble('height'),
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            color: mainColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                    setState(() {
                                      _getTrainers();
                                    });
                                  }
                                  if (query.documents.length != 0) {}
                                }
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Text(
                                enrolledFlag == false
                                    ? 'Enroll in this class!'
                                    : 'Enrolled',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 12.0 * prefs.getDouble('height'),
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 0.06),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 8.0 * prefs.getDouble('height'))
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  bool loading = false;

  List<DocumentSnapshot> _trainers = [];
  List<int> indexxes = [];
  bool _loadingTrainers = false;
  _getTrainers() async {
    if (mounted) {
      setState(() {
        _loadingTrainers = true;
      });
    }
    _trainers = [];
    dateTimeList = [];
    orderedClasses = [];
    indexxes = [];
    Query q = Firestore.instance.collection('clientUsers').where(
          'trainerMap.${widget.imClient.id}',
          isEqualTo: true,
        );

    QuerySnapshot querySnapshot = await q.getDocuments();
    if (querySnapshot.documents.length != 0) {
      _trainers = querySnapshot.documents;

      bool placeholder = false;
      for (int i = 0; i < _trainers.length; i++) {
        if (TrainerUser(_trainers[i]).counterClasses > 0) {
          placeholder = true;
        }
      }

      if (loading == false) {
        for (int i = 0; i < _trainers.length; i++) {
          for (int j = 0; j < TrainerUser(_trainers[i]).classes.length; j++) {
            TrainerUser actualTrainer = TrainerUser(_trainers[i]);
            bool overlapFlag = false;

            var time1 = [];
            var time2 = [];
            widget.imClient.classes.forEach((actualClass) {
              time1.add(actualClass.dateAndTimeDateTime);
              time2.add(actualClass.dateAndTimeDateTime.add(Duration(
                  hours: actualClass.duration.toDate().hour,
                  minutes: actualClass.duration.toDate().minute)));
            });
            for (int i = 0; i < widget.imClient.counterClassesClient - 1; i++) {
              for (int j = i + 1;
                  j < widget.imClient.counterClassesClient;
                  j++) {
                if (time1[i].isAfter(time1[j])) {
                  var aux1 = time1[i];
                  time1[i] = time1[j];
                  time1[j] = aux1;

                  var aux2 = time2[i];
                  time2[i] = time2[j];
                  time2[j] = aux2;
                }
              }
            }
            for (int i = 0; i < widget.imClient.counterClassesClient - 1; i++) {
              if (time2[i]
                      .isBefore(actualTrainer.classes[j].dateAndTimeDateTime) &&
                  time1[i + 1].isAfter(
                      actualTrainer.classes[j].dateAndTimeDateTime.add(Duration(
                          hours:
                              actualTrainer.classes[j].duration.toDate().hour,
                          minutes: actualTrainer.classes[j].duration
                              .toDate()
                              .minute)))) {
                overlapFlag = true;
              }
            }
            if (time1.length != 0) {
              if (time1[0].isAfter(actualTrainer.classes[j].dateAndTimeDateTime
                  .add(Duration(
                      hours: actualTrainer.classes[j].duration.toDate().hour,
                      minutes: actualTrainer.classes[j].duration
                          .toDate()
                          .minute)))) {
                overlapFlag = true;
              }
            } else {
              overlapFlag = true;
            }
            if (time2.length != 0) {
              if (time2[widget.imClient.counterClassesClient - 1]
                  .isBefore(actualTrainer.classes[j].dateAndTimeDateTime)) {
                overlapFlag = true;
              }
            }
            if (overlapFlag == true &&
                actualTrainer.classes[j].occupiedSpots.length <
                    actualTrainer.classes[j].spots &&
                actualTrainer.classes[j].public == false) {
              dateTimeList.add(
                  TrainerUser(_trainers[i]).classes[j].dateAndTimeDateTime);
              orderedClasses.add(i);
            }
          }
        }
        for (int i = 0; i < dateTimeList.length - 1; i++) {
          for (int j = i + 1; j < dateTimeList.length; j++) {
            if (dateTimeList[i].isAfter(dateTimeList[j])) {
              DateTime aux = dateTimeList[i];
              dateTimeList[i] = dateTimeList[j];
              dateTimeList[j] = aux;
              int auxTrainer = orderedClasses[i];
              orderedClasses[i] = orderedClasses[j];
              orderedClasses[j] = auxTrainer;
            }
          }
        }

        for (int i = 0; i < dateTimeList.length; i++) {
          TrainerUser trainer = TrainerUser(_trainers[orderedClasses[i]]);
          for (int k = 0; k < trainer.counterClasses; k++) {
            if (dateTimeList[i] == trainer.classes[k].dateAndTimeDateTime) {
              indexxes.add(k);
              placeholder = false;
            }
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        _loadingTrainers = false;
      });
    }
  }

  @override
  void initState() {
   
    super.initState();
    _getTrainers();
  }

  bool placeholder = false;
  List<DateTime> dateTimeList = [];
  List<int> orderedClasses = [];
  @override
  Widget build(BuildContext context) {
    if (widget.imClient.newPrivateClass == true) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {'newPrivateClass': FieldValue.delete()},
      );
    }
    if (indexxes.length == 0) {
      placeholder = true;
    } else {
      placeholder = false;
    }
    return IgnorePointer(
        ignoring: _loadingTrainers || loading,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            _loadingTrainers != true
                ? Padding(
                    padding:
                        EdgeInsets.only(top: 8 * prefs.getDouble('height')),
                    child: placeholder == false
                        ? Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: indexxes.length,
                                itemBuilder: (_, int index1) => item(
                                    TrainerUser(
                                        _trainers[orderedClasses[index1]]),
                                    indexxes[index1]),
                              ),
                              loading == true
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              8.0 * prefs.getDouble('height')),
                                          color: Colors.transparent,
                                        ),
                                        height: 80 * prefs.getDouble('height'),
                                        width: 80 * prefs.getDouble('width'),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      mainColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 32 * prefs.getDouble('height')),
                              SvgPicture.asset(
                                'assets/noTrainersf1.svg',
                                width: 250.0 * prefs.getDouble('width'),
                                height: 200.0 * prefs.getDouble('height'),
                              ),
                              SizedBox(height: 48 * prefs.getDouble('height')),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 48 * prefs.getDouble('width')),
                                child: Text(
                                  "None of your trainers organize private classes right now.'",
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
                              SizedBox(height: 128 * prefs.getDouble('height')),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 36.0 * prefs.getDouble('height')),
                                child: Container(
                                  width: 240.0 * prefs.getDouble('width'),
                                  height: 60.0 * prefs.getDouble('height'),
                                  child: Material(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(90.0),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        widget.parent.setState(() {
                                          widget.parent
                                                  .browsingTrainersAndClasses =
                                              true;
                                        });
                                      },
                                      child: Text(
                                        'Browse trainers and classes',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 17.0 *
                                                prefs.getDouble('height'),
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
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            8.0 * prefs.getDouble('height')),
                        color: secondaryColor,
                      ),
                      height: 80 * prefs.getDouble('height'),
                      width: 80 * prefs.getDouble('width'),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
