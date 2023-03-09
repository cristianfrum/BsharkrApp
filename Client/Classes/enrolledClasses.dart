import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../globals.dart';

class EnrolledClasses extends StatefulWidget {
  final MyAppState parent;
  EnrolledClasses({this.imClient, this.parent});
  final ClientUser imClient;
  @override
  _EnrolledClassesState createState() => _EnrolledClassesState();
}

class _EnrolledClassesState extends State<EnrolledClasses> {
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
    String hour = widget.imClient.classes[index].dateAndTimeDateTime.hour < 10
        ? ("0" +
            widget.imClient.classes[index].dateAndTimeDateTime.hour.toString())
        : widget.imClient.classes[index].dateAndTimeDateTime.hour.toString();
    String minute = widget.imClient.classes[index].dateAndTimeDateTime.minute <
            10
        ? ("0" +
            widget.imClient.classes[index].dateAndTimeDateTime.minute
                .toString())
        : widget.imClient.classes[index].dateAndTimeDateTime.minute.toString();
    String duration;
    if (widget.imClient.classes[index].duration.toDate().hour < 1) {
      if (widget.imClient.classes[index].duration.toDate().minute >= 0 &&
          widget.imClient.classes[index].duration.toDate().minute < 10) {
        duration =
            "0${widget.imClient.classes[index].duration.toDate().minute}m";
      }
      if (widget.imClient.classes[index].duration.toDate().minute > 9 &&
          widget.imClient.classes[index].duration.toDate().minute < 60) {
        duration =
            "${widget.imClient.classes[index].duration.toDate().minute}m";
      }
    } else {
      if (widget.imClient.classes[index].duration.toDate().hour > 0 &&
          widget.imClient.classes[index].duration.toDate().hour < 10) {
        duration = "0${widget.imClient.classes[index].duration.toDate().hour}h";
      }
      if (widget.imClient.classes[index].duration.toDate().hour > 9 &&
          widget.imClient.classes[index].duration.toDate().hour < 60) {
        duration = "${widget.imClient.classes[index].duration.toDate().hour}h";
      }

      if (widget.imClient.classes[index].duration.toDate().minute >= 0 &&
          widget.imClient.classes[index].duration.toDate().minute < 10) {
        duration = duration +
            " " +
            "0${widget.imClient.classes[index].duration.toDate().minute}m";
      }
      if (widget.imClient.classes[index].duration.toDate().minute > 9 &&
          widget.imClient.classes[index].duration.toDate().minute < 60) {
        duration = duration +
            " " +
            "${widget.imClient.classes[index].duration.toDate().minute}m";
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 343 * prefs.getDouble('width'),
          height: 226 * prefs.getDouble('height'),
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
                        height: 76 * prefs.getDouble('height'),
                        width: 216 * prefs.getDouble('width'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${widget.imClient.classes[index].dateAndTimeDateTime.year}" +
                                    "-" +
                                    "${monthsOfTheYear[widget.imClient.classes[index].dateAndTimeDateTime.month - 1]}" +
                                    "-" +
                                    "${widget.imClient.classes[index].dateAndTimeDateTime.day}" +
                                    "-" +
                                    "${daysOfTheWeek[widget.imClient.classes[index].dateAndTimeDateTime.weekday - 1]}" +
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
                                    text: widget.imClient.classes[index]
                                            .classLevel +
                                        " " +
                                        widget.imClient.classes[index].type +
                                        " Class with " +
                                        widget.imClient.classes[index].firstName +
                                        " " +
                                        widget.imClient.classes[index].lastName,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            17 * prefs.getDouble('height'),
                                        letterSpacing: -0.408,
                                        color: Colors.white),
                                  ),
                                  TextSpan(
                                      text: widget.imClient.classes[index]
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
                                      fontSize: 15 * prefs.getDouble('height'),
                                      letterSpacing: -0.24,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(200, 255, 255, 255),
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
                      if (widget.imClient.classes[index].gymWebsite != null) {
                        launch(widget.imClient.classes[index].gymWebsite);
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
                                      color: Color.fromARGB(150, 255, 255, 255),
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget
                                        .imClient.classes[index].locationName,
                                    style: TextStyle(color: mainColor),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.imClient.classes[index].locationStreet +
                                  ", " +
                                  widget
                                      .imClient.classes[index].locationDistrict,
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
                  Padding(
                    padding:
                        EdgeInsets.only(top: 24.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 310.0 * prefs.getDouble('width'),
                      height: 41.0 * prefs.getDouble('height'),
                      child: Material(
                        color: Color(0xff57575E),
                        borderRadius: BorderRadius.circular(90.0),
                        child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            var db = Firestore.instance;
                            var batch = db.batch();
                            if (index == 0 &&
                                widget.imClient.counterClassesClient == 1) {
                            } else {
                              for (int i = index + 1;
                                  i < widget.imClient.counterClassesClient;
                                  i++) {
                                batch.updateData(
                                  db
                                      .collection('clientUsers')
                                      .document(widget.imClient.id),
                                  {
                                    'class$i.gymWebsite':
                                        widget.imClient.classes[i].gymWebsite,
                                    'class$i.public':
                                        widget.imClient.classes[i].public,
                                    'class$i.classLevel':
                                        widget.imClient.classes[i].classLevel,
                                    'class$i.locationName':
                                        widget.imClient.classes[i].locationName,
                                    'class$i.locationDistrict': widget
                                        .imClient.classes[i].locationDistrict,
                                    'class$i.individualPrice': widget
                                        .imClient.classes[i].individualPrice,
                                    'class$i.memberPrice':
                                        widget.imClient.classes[i].memberPrice,
                                    'class$i.spots':
                                        widget.imClient.classes[i].spots,
                                    'class$i.type':
                                        widget.imClient.classes[i].type,
                                    'class$i.dateAndTime':
                                        widget.imClient.classes[i].dateAndTime,
                                    'class$i.dateAndTimeDateTime': widget
                                        .imClient
                                        .classes[i]
                                        .dateAndTimeDateTime,
                                    'class$i.duration':
                                        widget.imClient.classes[i].duration,
                                    'class$i.occupiedSpots': widget
                                        .imClient.classes[i].occupiedSpots,
                                    'class$i.locationStreet': widget
                                        .imClient.classes[i].locationStreet,
                                    'class$i.number': i,
                                    'class$i.trainerFirstName':
                                        widget.imClient.classes[i].firstName,
                                    'class$i.trainerId':
                                        widget.imClient.classes[i].trainerId,
                                    'class$i.trainerLastName':
                                        widget.imClient.classes[i].lastName
                                  },
                                );
                              }
                            }
                            QuerySnapshot query = await Firestore.instance
                                .collection('clientUsers')
                                .where('id',
                                    isEqualTo: widget
                                        .imClient.classes[index].trainerId)
                                .getDocuments();
                            TrainerUser myTrainer =
                                TrainerUser(query.documents[0]);
                            int counter = 1;
                            myTrainer.classes.forEach((actualClass) {
                              if (actualClass.classLevel ==
                                      widget
                                          .imClient.classes[index].classLevel &&
                                  actualClass.dateAndTime ==
                                      widget.imClient.classes[index]
                                          .dateAndTime &&
                                  actualClass.dateAndTimeDateTime ==
                                      widget.imClient.classes[index]
                                          .dateAndTimeDateTime &&
                                  actualClass.duration ==
                                      widget.imClient.classes[index].duration &&
                                  actualClass.individualPrice ==
                                      widget.imClient.classes[index]
                                          .individualPrice &&
                                  actualClass.locationDistrict ==
                                      widget.imClient.classes[index]
                                          .locationDistrict &&
                                  actualClass.locationName ==
                                      widget.imClient.classes[index]
                                          .locationName &&
                                  actualClass.locationStreet ==
                                      widget.imClient.classes[index]
                                          .locationStreet &&
                                  actualClass.memberPrice ==
                                      widget.imClient.classes[index]
                                          .memberPrice &&
                                  myTrainer.id ==
                                      widget
                                          .imClient.classes[index].trainerId) {
                                batch.updateData(
                                  db.collection('clientUsers').document(
                                      widget.imClient.classes[index].trainerId),
                                  {
                                    'class$counter.occupiedSpots.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsAge.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsGender.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsFirstName.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsLastName.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsPhotoUrl.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsColorRed.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsColorGreen.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsColorBlue.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                    'class$counter.clientsRating.${prefs.getString('id')}':
                                        FieldValue.delete(),
                                  },
                                );
                              }
                              counter++;
                            });

                            batch.updateData(
                              db
                                  .collection('clientUsers')
                                  .document(widget.imClient.id),
                              {
                                'class${widget.imClient.counterClassesClient}':
                                    FieldValue.delete(),
                                'counterClassesClient':
                                    widget.imClient.counterClassesClient - 1
                              },
                            );
                            setState(() {
                              loading = false;
                            });
                            batch.commit();
                          },
                          child: Text(
                            'Cancel enrollment',
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
  }

  List<int> indexes = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    List<DateTime> dateTimeList = [];
    indexes.clear();
    for (int i = 0; i < widget.imClient.classes.length; i++) {
      dateTimeList.add(widget.imClient.classes[i].dateAndTimeDateTime);
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
      for (int j = 0; j < widget.imClient.classes.length; j++) {
        if (dateTimeList[i] == widget.imClient.classes[j].dateAndTimeDateTime &&
            indexes.where((element) => element == j).toList().length == 0) {
          indexes.add(j);
        }
      }
    }
    if (widget.imClient.deletedClient == true) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {'deletedClient': FieldValue.delete()},
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16 * prefs.getDouble('height')),
      child: widget.imClient.counterClassesClient != 0
          ? IgnorePointer(
              ignoring: loading,
              child: loading == false
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.imClient.counterClassesClient,
                      itemBuilder: (_, int index) => item(indexes[index]),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                        ),
                      ),
                    ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 32 * prefs.getDouble('height')),
                SvgPicture.asset(
                  'assets/groupClassesf1.svg',
                  width: 250.0 * prefs.getDouble('width'),
                  height: 200.0 * prefs.getDouble('height'),
                ),
                SizedBox(height: 48 * prefs.getDouble('height')),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 48 * prefs.getDouble('width')),
                  child: Text(
                    "You did not sign up for a group class.'",
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
                      vertical: 34.0 * prefs.getDouble('height')),
                  child: Container(
                    width: 240.0 * prefs.getDouble('width'),
                    height: 60.0 * prefs.getDouble('height'),
                    child: Material(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(90.0),
                      child: MaterialButton(
                        onPressed: () async {
                          widget.parent.setState(() {
                            widget.parent.browsingTrainersAndClasses = true;
                          });
                        },
                        child: Text(
                          'Browse trainers and classes',
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
    );
  }
}
