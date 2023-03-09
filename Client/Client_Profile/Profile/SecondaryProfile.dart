import 'dart:async';
import 'dart:io';
import 'package:Bsharkr/Client/Client_Profile/Profile/time.dart';
import 'package:Bsharkr/Client/Meals/Meals.dart';
import 'package:Bsharkr/Client/Schedule/Schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../../../colors.dart';

import 'package:permission_handler/permission_handler.dart';

class ClientSecondaryProfile extends StatefulWidget {
  ClientSecondaryProfile(
      {@required this.auth, @required this.onSignedOut, this.imClient, this.notification})
      : super();

  final String notification;
  final ClientUser imClient;
  final BaseAuth auth;
  final Function onSignedOut;

  @override
  _ClientSecondaryProfileState createState() => _ClientSecondaryProfileState(
      auth: auth, onSignedOut: onSignedOut, clientUser: imClient);
}

class _ClientSecondaryProfileState extends State<ClientSecondaryProfile>
    with SingleTickerProviderStateMixin {
  _ClientSecondaryProfileState(
      {@required this.auth,
      @required this.onSignedOut,
      @required this.clientUser})
      : super();
  var selected;
  final BaseAuth auth;
  final Function onSignedOut;
  final ClientUser clientUser;
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;
  bool flagBusinessAccepted = false;
  bool flagFriendshipAccepted = false;
  bool flagFriendshipPending = false;
  bool flagBusinessPending = false;
  bool availability = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    return showTimePicker1(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

  bool preferences(String preference) {
    bool result = false;
    clientUser.preferencesList.forEach((clientPreference) {
      if (clientPreference.preference == preference)
        result = clientPreference.wanted;
    });
    return result;
  }

   translate(String element) {
    if (element == 'dynamic') return 'Dynamic';
    if (element == 'nutritionist') return 'Nutritionist';
    if (element == 'disciplined') return 'Disciplined';
    if (element == 'motivating') return 'Motivating';
    if (element == 'sociable') return 'Sociable';
    if (element == 'goodListener') return 'Good listener';
    if (element == 'anatomyKnowledge') return 'Anatomy knowledge';
  }

  @override
  void initState() {
    super.initState();
    if(widget.notification != null){
      if(widget.notification == 'meal'){
        availability = true;
      } else {
        availability = false;
      }
    }
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    cardAnimation = Tween(begin: 0.0, end: -0.025).animate(
      CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller),
    );

    delayedCardAnimation = Tween(begin: 0.0, end: -0.05).animate(
      CurvedAnimation(
          curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
          parent: controller),
    );

    fabButtonanim = Tween(begin: 1.0, end: -0.0008).animate(
      CurvedAnimation(
          curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn),
          parent: controller),
    );

    infoAnimation = Tween(begin: 0.0, end: 0.015).animate(
      CurvedAnimation(
          curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn),
          parent: controller),
    );
  }

  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();
  }

  Future _signOut() async {
    try {
      await prefs.setString('expectations', null);
      await prefs.setDouble('height', null);
      await prefs.setDouble('width', null);
      await prefs.setString('id', null);
      await prefs.setString('nickname', null);
      await prefs.setString('role', null);
      await prefs.setString('email', null);
      await prefs.setString('password1', null);
      await prefs.setString('password2', null);
      await prefs.setString('firstName', null);
      await prefs.setString('lastName', null);
      await prefs.setInt('age', null);
      await prefs.setString('gender', null);
      await prefs.setString('photoUrl', null);
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

   showSetHour1(int index) {
    if (index == 1) {
      if (clientUser.availability.mondayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day1 == 'true') {
          return (clientUser.hour1Availability.day1.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day1.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day1.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day1
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 2) {
      if (clientUser.availability.mondayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day2 == 'true') {
          return (clientUser.hour1Availability.day2.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day2.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day2.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day2
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 3) {
      if (clientUser.availability.mondayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day3 == 'true') {
          return (clientUser.hour1Availability.day3.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day3.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day3.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day3
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 4) {
      if (clientUser.availability.tuesdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day4 == 'true') {
          return (clientUser.hour1Availability.day4.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day4.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day4.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day4
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 5) {
      if (clientUser.availability.tuesdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day5 == 'true') {
          return (clientUser.hour1Availability.day5.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day5.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day5.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day5
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 6) {
      if (clientUser.availability.tuesdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day6 == 'true') {
          return (clientUser.hour1Availability.day6.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day6.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day6.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day6
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 7) {
      if (clientUser.availability.wednesdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day7 == 'true') {
          return (clientUser.hour1Availability.day7.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day7.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day7.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day7
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 8) {
      if (clientUser.availability.wednesdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day8 == 'true') {
          return (clientUser.hour1Availability.day8.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day8.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day8.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day8
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day8
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 9) {
      if (clientUser.availability.wednesdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day9 == 'true') {
          return (clientUser.hour1Availability.day9.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day9.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day9.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day9
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day9
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 10) {
      if (clientUser.availability.thursdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day10 == 'true') {
          return (clientUser.hour1Availability.day10.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day10.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day10.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day10
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day10
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 11) {
      if (clientUser.availability.thursdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day11 == 'true') {
          return (clientUser.hour1Availability.day11.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day11.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day11.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day11
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day11
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 12) {
      if (clientUser.availability.thursdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day12 == 'true') {
          return (clientUser.hour1Availability.day12.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day12.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day12.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day12
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day12
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 13) {
      if (clientUser.availability.fridayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day13 == 'true') {
          return (clientUser.hour1Availability.day13.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day13.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day13.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day13
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day13
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 14) {
      if (clientUser.availability.fridayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day14 == 'true') {
          return (clientUser.hour1Availability.day14.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day14.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day14.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day14
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day14
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 15) {
      if (clientUser.availability.fridayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day15 == 'true') {
          return (clientUser.hour1Availability.day15.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day15.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day15.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day15
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day15
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 16) {
      if (clientUser.availability.saturdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day16 == 'true') {
          return (clientUser.hour1Availability.day16.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day16.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day16.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day16
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day16
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 17) {
      if (clientUser.availability.saturdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day17 == 'true') {
          return (clientUser.hour1Availability.day17.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day17.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day17.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day17
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day17
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 18) {
      if (clientUser.availability.saturdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day18 == 'true') {
          return (clientUser.hour1Availability.day18.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day18.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day18.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day18
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day18
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 19) {
      if (clientUser.availability.sundayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day19 == 'true') {
          return (clientUser.hour1Availability.day19.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day19.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day19.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day19
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day19
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 20) {
      if (clientUser.availability.sundayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day20 == 'true') {
          return (clientUser.hour1Availability.day20.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day20.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day20.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day20
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day20
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 21) {
      if (clientUser.availability.sundayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailability.day21 == 'true') {
          return (clientUser.hour1Availability.day21.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour1Availability.day21.toDate().hour.toString() +
              " : " +
              (clientUser.hour1Availability.day21.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour1Availability.day21
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour1Availability.day21
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }
  }

   showSetHour2(int index) {
    if (index == 1) {
      if (clientUser.availability.mondayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day1 == 'true') {
          return (clientUser.hour2Availability.day1.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day1.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day1.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day1
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 2) {
      if (clientUser.availability.mondayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day2 == 'true') {
          return (clientUser.hour2Availability.day2.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day2.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day2.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day2
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 3) {
      if (clientUser.availability.mondayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day3 == 'true') {
          return (clientUser.hour2Availability.day3.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day3.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day3.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day3
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 4) {
      if (clientUser.availability.tuesdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day4 == 'true') {
          return (clientUser.hour2Availability.day4.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day4.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day4.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day4
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 5) {
      if (clientUser.availability.tuesdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day5 == 'true') {
          return (clientUser.hour2Availability.day5.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day5.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day5.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day5
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 6) {
      if (clientUser.availability.tuesdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day6 == 'true') {
          return (clientUser.hour2Availability.day6.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day6.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day6.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day6
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 7) {
      if (clientUser.availability.wednesdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day7 == 'true') {
          return (clientUser.hour2Availability.day7.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day7.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day7.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day7
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 8) {
      if (clientUser.availability.wednesdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day8 == 'true') {
          return (clientUser.hour2Availability.day8.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day8.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day8.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day8
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day8
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 9) {
      if (clientUser.availability.wednesdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day9 == 'true') {
          return (clientUser.hour2Availability.day9.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day9.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day9.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day9
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day9
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 10) {
      if (clientUser.availability.thursdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day10 == 'true') {
          return (clientUser.hour2Availability.day10.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day10.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day10.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day10
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day10
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 11) {
      if (clientUser.availability.thursdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day11 == 'true') {
          return (clientUser.hour2Availability.day11.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day11.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day11.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day11
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day11
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 12) {
      if (clientUser.availability.thursdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day12 == 'true') {
          return (clientUser.hour2Availability.day12.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day12.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day12.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day12
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day12
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 13) {
      if (clientUser.availability.fridayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day13 == 'true') {
          return (clientUser.hour2Availability.day13.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day13.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day13.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day13
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day13
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 14) {
      if (clientUser.availability.fridayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day14 == 'true') {
          return (clientUser.hour2Availability.day14.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day14.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day14.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day14
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day14
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 15) {
      if (clientUser.availability.fridayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day15 == 'true') {
          return (clientUser.hour2Availability.day15.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day15.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day15.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day15
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day15
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 16) {
      if (clientUser.availability.saturdayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day16 == 'true') {
          return (clientUser.hour2Availability.day16.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day16.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day16.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day16
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day16
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 17) {
      if (clientUser.availability.saturdayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day17 == 'true') {
          return (clientUser.hour2Availability.day17.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day17.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day17.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day17
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day17
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 18) {
      if (clientUser.availability.saturdayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day18 == 'true') {
          return (clientUser.hour2Availability.day18.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day18.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day18.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day18
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day18
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 19) {
      if (clientUser.availability.sundayMorning.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day19 == 'true') {
          return (clientUser.hour2Availability.day19.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day19.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day19.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day19
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day19
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 20) {
      if (clientUser.availability.sundayMidday.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day20 == 'true') {
          return (clientUser.hour2Availability.day20.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day20.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day20.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day20
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day20
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 21) {
      if (clientUser.availability.sundayEvening.toString() == "Busy")
        return "";
      else {
        if (clientUser.checkDailyAvailabilityV2.day21 == 'true') {
          return (clientUser.hour2Availability.day21.toDate().hour < 10
                  ? "0"
                  : "") +
              clientUser.hour2Availability.day21.toDate().hour.toString() +
              " : " +
              (clientUser.hour2Availability.day21.toDate().minute.toInt() < 10
                  ? ("0" +
                      clientUser.hour2Availability.day21
                          .toDate()
                          .minute
                          .toString())
                  : clientUser.hour2Availability.day21
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }
  }

  List<String> preferencesList = [];

  int specializationCounter = 0;
  bool restartState = false;
  @override
  Widget build(BuildContext context) {
    clientUser.preferencesList.forEach((preference) {
      if (preference.wanted == true) {
        preferencesList.add(preference.preference);
        specializationCounter++;
      }
    });
    return Scaffold(
      backgroundColor: prefix0.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            clientUser.lastName == null
                ? "nume"
                : clientUser.firstName + " " + clientUser.lastName,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22 * prefs.getDouble('height')),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 24 * prefs.getDouble('width')),
              child: GestureDetector(
                onTap: () {
                  _signOut();
                },
                child: Icon(Icons.exit_to_app,
                    color: Colors.white, size: 24 * prefs.getDouble('height')),
              ),
            )
          ],
          backgroundColor: prefix0.backgroundColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8 * prefs.getDouble('height'),
            ),
            Container(
              height: 80 * prefs.getDouble('height'),
                          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 32 * prefs.getDouble('width')),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            ProfilePhotoPopUp(
                              client: clientUser,
                            ));
                      },
                      child: clientUser.photoUrl == null
                          ? ClipOval(
                              child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, clientUser.colorRed,
                                    clientUser.colorGreen, clientUser.colorBlue),
                                shape: BoxShape.circle,
                              ),
                              height: (80 * prefs.getDouble('height')),
                              width: (80 * prefs.getDouble('height')),
                              child: Center(
                                child: Text(clientUser.firstName[0],
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 50 * prefs.getDouble('height'),
                                      color: Colors.white,
                                    )),
                              ),
                            ))
                          : Material(
                              child: Container(
                                width: 80 * prefs.getDouble('height'),
                                height: 80 * prefs.getDouble('height'),
                                decoration: BoxDecoration(
                                    color: prefix0.backgroundColor,
                                    shape: BoxShape.circle),
                                child: Image.network(
                                  clientUser.photoUrl,
                                  fit: BoxFit.cover,
                                  scale: 1.0,
                                  loadingBuilder: (BuildContext ctx, Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  prefix0.mainColor),
                                          backgroundColor:
                                              prefix0.backgroundColor,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(77.5),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: 32 * prefs.getDouble('width')),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Gender: " +
                              (clientUser.gender == 'male' ? 'Male' : 'Female'),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            letterSpacing: -0.408 * prefs.getDouble('width'),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0 * prefs.getDouble('height'),
                            color: Color.fromARGB(80, 255, 255, 255),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Age: " + clientUser.age.toString() + " years",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            letterSpacing: -0.408 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0 * prefs.getDouble('height'),
                            color: Color.fromARGB(80, 255, 255, 255),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        clientUser.acceptTrainerRequests == true
                            ? Text(
                                "Accept new requests",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  letterSpacing:
                                      -0.408 * prefs.getDouble('width'),
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0 * prefs.getDouble('height'),
                                  color: prefix0.mainColor,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15 * prefs.getDouble('height'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 32 * prefs.getDouble('width')),
              child: Container(
                width: 310 * prefs.getDouble('width'),
                height: 32 * prefs.getDouble('height'),
                child: Material(
                  borderRadius: BorderRadius.circular(4),
                  color: prefix0.secondaryColor,
                  child: MaterialButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => EditeazaProfilul(
                              parent: this,
                              auth: widget.auth,
                              clientUser: clientUser,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16 * prefs.getDouble('height'),
                          ),
                          SizedBox(
                            width: 10.0 * prefs.getDouble('width'),
                          ),
                          Text(
                            "Edit profile",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 12 * prefs.getDouble('height')),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 12.0000008 * prefs.getDouble('height'),
            ),
            Container(
              height: 18 * prefs.getDouble('height'),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 32 * prefs.getDouble('width'),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          restartState = true;
                          availability = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 26 * prefs.getDouble('height'),
                            child: Center(
                              child: Text(
                                "Workout plan",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    color: availability == false
                                        ? prefix0.mainColor
                                        : Color.fromARGB(100, 255, 255, 255),
                                    fontSize: 17 * prefs.getDouble('height')),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 8 * prefs.getDouble('width')),
                          widget.imClient.scheduleUpdated == true
                              ? Icon(
                                  Icons.brightness_1,
                                  size: 18 * prefs.getDouble('height'),
                                  color: prefix0.mainColor,
                                )
                              : Container(),
                        ],
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          restartState = true;
                          availability = true;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          widget.imClient.mealPlanUpdated == true
                              ? Icon(
                                  Icons.brightness_1,
                                  size: 18 * prefs.getDouble('height'),
                                  color: prefix0.mainColor,
                                )
                              : Container(),
                          SizedBox(width: 8 * prefs.getDouble('width')),
                          Container(
                            height: 26 * prefs.getDouble('height'),
                            child: Center(
                              child: Text(
                                "Meal plan",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    color: availability == true
                                        ? prefix0.mainColor
                                        : Color.fromARGB(100, 255, 255, 255),
                                    fontSize: 17 * prefs.getDouble('height')),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 0.1349939 * prefs.getDouble('height'),
            ),
            Container(
              height: 444 * prefs.getDouble('height'),
              child: availability == false
                  ? Container(
                      height: 419.1 * prefs.getDouble('height'),
                      child: MySchedule(
                        client: widget.imClient,
                      ),
                    )
                  : Container(
                      height: 444 * prefs.getDouble('height'),
                      child: MyMeals(clientUser: widget.imClient)),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    paint.color = Colors.black;
    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.4);
    ovalPath.quadraticBezierTo(width * 0.5, height * 0.7, width, height * 0.4);
    canvas.drawPath(ovalPath, paint);
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height * 0.4 + 1), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// Converts an index of a set size to the corresponding index of a collection of another size
/// as if they were circular.
///
/// Takes a [position] from collection Foo, a [base] from where Foo's index originated
/// and the [length] of a second collection Baa, for which the correlating index is sought.
///
/// For example; We have a Carousel of 10000(simulating infinity) but only 6 images.
/// We need to repeat the images to give the illusion of a never ending stream.
/// By calling _getRealIndex with position and base we get an offset.
/// This offset modulo our length, 6, will return a number between 0 and 5, which represent the image
/// to be placed in the given position.
int _getRealIndex(int position, int base, int length) {
  final int offset = position - base;
  return _remainder(offset, length);
}

/// Returns the remainder of the modulo operation [input] % [source], and adjust it for
/// negative values.
int _remainder(int input, int source) {
  final int result = input % source;
  return result < 0 ? source + result : result;
}

class EditeazaProfilul extends StatefulWidget {
  EditeazaProfilul({this.parent, this.auth, this.clientUser});
  final ClientUser clientUser;
  final _ClientSecondaryProfileState parent;
  final BaseAuth auth;
  @override
  _EditeazaProfilulState createState() => _EditeazaProfilulState();
}

class _EditeazaProfilulState extends State<EditeazaProfilul> {
  Future<void> sendPasswordResetEmail(String email) async {
    await widget.auth.resetPassword(email);
  }

  var tempImage;
  Future _getImage() async {
    var aux = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tempImage = aux;
    });
  }

  bool seenFlagFriends;
  bool seenFlagTrainers;
  Map<PermissionGroup, PermissionStatus> permissions;
  ServiceStatus serviceStatus;
  String permissionGranted;
  double x;
  double y;
  _getLocation() async {
    var location = new Location();
    try {
      await location.getLocation().then((onValue) async {
        if (permissionGranted == 'true') {
          GeoFirePoint myLocation = geo.point(latitude: x, longitude: y);
          await Firestore.instance
              .collection('clientUsers')
              .document(prefs.getString('id'))
              .updateData({'location': myLocation.data});
        }
        x = onValue.latitude;
        y = onValue.longitude;

        permissionGranted = 'true';
      });
    } catch (e) {
      if (e == 'PERMISSION_DENIED') {
        permissionGranted = 'false';
      }
      if (e == 'PERMISSION_DENIED_NEVER_ASK') {
        permissionGranted = 'never ask';
      }
    }
  }

  Geoflutterfire geo = Geoflutterfire();
  getPermission() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    if (permissions.containsValue(PermissionStatus.denied)) {
      setState(() {
        permissionGranted = 'never ask';
      });
    }
    if (permissions.containsValue(PermissionStatus.granted)) {
      var location = new Location();
      var auxx, auxy;
      await location.getLocation().then((onValue) {
        auxx = onValue.latitude;
        auxy = onValue.longitude;
      });

      x = auxx;
      y = auxy;

      permissionGranted = 'true';
      if (permissionGranted == 'true') {
        GeoFirePoint myLocation = geo.point(latitude: x, longitude: y);
        await Firestore.instance
            .collection('clientUsers')
            .document(prefs.getString('id'))
            .updateData({'location': myLocation.data});
      }
    }
  }

  bool toggleValue;

  bool restart = false;

  bool sociableButton = false;
  bool nutritionistButton = false;
  bool anatomyKnowledgeButton = false;
  bool motivatingButton = false;
  bool disciplinedButton = false;
  bool goodListenerButton = false;
  bool dynamicButton = false;

  toggleButton() {
    setState(() {
      restart = true;
      toggleValue = !toggleValue;
    });
  }

  ClientUser clientUser;

  @override
  void initState() {
    super.initState();
    if (widget.parent.clientUser.acceptTrainerRequests == null) {
      toggleValue = false;
    } else {
      toggleValue = widget.parent.clientUser.acceptTrainerRequests;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (restart == false) {
      widget.parent.clientUser.preferencesList.forEach((preference) {
        if (preference.preference == 'sociable' && preference.wanted == true) {
          sociableButton = true;
        }
        if (preference.preference == 'nutritionist' &&
            preference.wanted == true) {
          nutritionistButton = true;
        }
        if (preference.preference == 'anatomyKnowledge' &&
            preference.wanted == true) {
          anatomyKnowledgeButton = true;
        }
        if (preference.preference == 'motivating' &&
            preference.wanted == true) {
          motivatingButton = true;
        }
        if (preference.preference == 'disciplined' &&
            preference.wanted == true) {
          disciplinedButton = true;
        }
        if (preference.preference == 'goodListener' &&
            preference.wanted == true) {
          goodListenerButton = true;
        }
        if (preference.preference == 'dynamic' && preference.wanted == true) {
          dynamicButton = true;
        }
      });
    }

    return Scaffold(
        backgroundColor: prefix0.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(
              Icons.backspace,
              color: Colors.white,
              size: 24 * prefs.getDouble('height'),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15 * prefs.getDouble('width')),
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  size: 22 * prefs.getDouble('height'),
                  color: Colors.white,
                ),
                onPressed: () async {
                  var db = Firestore.instance;
                  var batch = db.batch();

                  if (tempImage != null) {
                    final StorageReference firebaseStorageRef = FirebaseStorage
                        .instance
                        .ref()
                        .child('${clientUser.id}');
                    final StorageUploadTask task =
                        firebaseStorageRef.putFile(tempImage);
                    final StorageTaskSnapshot downloadUrl =
                        (await task.onComplete);
                    final String url = (await downloadUrl.ref.getDownloadURL());
                    await prefs.setString('photoUrl', url);
                    batch.updateData(
                      db
                          .collection('clientUsers')
                          .document(prefs.getString('id')),
                      {
                        'photoUrl': url,
                      },
                    );
                    widget.parent.setState(() {
                      widget.parent.clientUser.photoUrl = url;
                      restart = true;
                    });
                  }
                  if (toggleValue) {
                    if (Platform.isAndroid) {
                      _getLocation();
                    }
                    if (Platform.isIOS) {
                      getPermission();
                    }
                  }
                  batch.updateData(
                    db
                        .collection('clientUsers')
                        .document(prefs.getString('id')),
                    {
                      'preferencesList.sociable': sociableButton,
                      'preferencesList.nutritionist': nutritionistButton,
                      'preferencesList.anatomyKnowledge':
                          anatomyKnowledgeButton,
                      'preferencesList.motivating': motivatingButton,
                      'preferencesList.disciplined': disciplinedButton,
                      'preferencesList.goodListener': goodListenerButton,
                      'preferencesList.dynamic': dynamicButton,
                      'acceptTrainerRequests': toggleValue,
                    },
                  );
                  batch.commit();
                  List<String> localPreferencesList = [];
                  int localSpecializationCounter = 0;
                  widget.parent.setState(() {
                    widget.parent.clientUser.preferencesList
                        .forEach((preference) {
                      widget.parent.clientUser.acceptTrainerRequests =
                          toggleValue;
                      if (preference.preference == 'sociable') {
                        preference.wanted = sociableButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }

                      if (preference.preference == 'nutritionist') {
                        preference.wanted = nutritionistButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }

                      if (preference.preference == 'anatomyKnowledge') {
                        preference.wanted = anatomyKnowledgeButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }

                      if (preference.preference == 'motivating') {
                        preference.wanted = motivatingButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }

                      if (preference.preference == 'disciplined') {
                        preference.wanted = disciplinedButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }

                      if (preference.preference == 'goodListener') {
                        preference.wanted = goodListenerButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }

                      if (preference.preference == 'dynamic') {
                        preference.wanted = dynamicButton;
                        if (preference.wanted == true) {
                          localPreferencesList.add(preference.preference);
                          localSpecializationCounter++;
                        }
                      }
                    });
                    widget.parent.specializationCounter =
                        localSpecializationCounter;
                    widget.parent.preferencesList = localPreferencesList;
                  });
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
          backgroundColor: prefix0.backgroundColor,
          elevation: 0.0,
          title: Text(
            "Edit profile",
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 20 * prefs.getDouble('height'),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 18 * prefs.getDouble('height')),
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  color: prefix0.backgroundColor,
                  width: 120 * prefs.getDouble('width'),
                  height: 120 * prefs.getDouble('height'),
                  child: Center(
                    child: tempImage == null
                        ? (widget.parent.clientUser.photoUrl == null
                            ? Stack(
                                children: <Widget>[
                                  ClipOval(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(
                                            255,
                                            widget.parent.clientUser.colorRed,
                                            widget.parent.clientUser.colorGreen,
                                            widget.parent.clientUser.colorBlue),
                                        shape: BoxShape.circle,
                                      ),
                                      height: (120 * prefs.getDouble('height')),
                                      width: (120 * prefs.getDouble('height')),
                                      child: Center(
                                        child: Text(
                                            widget
                                                .parent.clientUser.firstName[0],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 50 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 85.0 * prefs.getDouble('height'),
                                    left: 85.0 * prefs.getDouble('height'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: prefix0.backgroundColor),
                                      padding: EdgeInsets.all(
                                          5.0 * prefs.getDouble('height')),
                                      child: Container(
                                        width: 28 * prefs.getDouble('height'),
                                        height: 28 * prefs.getDouble('height'),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: prefix0.mainColor,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size:
                                              15.0 * prefs.getDouble('height'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Stack(
                                children: <Widget>[
                                  Material(
                                    child: Container(
                                      color: Colors.black,
                                      width: 120 * prefs.getDouble('height'),
                                      height: 120 * prefs.getDouble('height'),
                                      child: Image.network(
                                        widget.parent.clientUser.photoUrl,
                                        fit: BoxFit.cover,
                                        scale: 1.0,
                                        loadingBuilder: (BuildContext ctx,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        prefix0.mainColor),
                                                backgroundColor:
                                                    prefix0.backgroundColor,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(90),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  Positioned(
                                    top: 85.0 * prefs.getDouble('height'),
                                    left: 85.0 * prefs.getDouble('height'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: prefix0.backgroundColor),
                                      padding: EdgeInsets.all(
                                          5.0 * prefs.getDouble('height')),
                                      child: Container(
                                        width: 28 * prefs.getDouble('height'),
                                        height: 28 * prefs.getDouble('height'),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: prefix0.mainColor,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size:
                                              15.0 * prefs.getDouble('height'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                        : Stack(
                            children: <Widget>[
                              Material(
                                child: Image.file(
                                  tempImage,
                                  width: 120.0 * prefs.getDouble('height'),
                                  height: 120.0 * prefs.getDouble('height'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(90.0),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                              Positioned(
                                top: 85.0 * prefs.getDouble('height'),
                                left: 85.0 * prefs.getDouble('height'),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: prefix0.backgroundColor),
                                  padding: EdgeInsets.all(
                                      5.0 * prefs.getDouble('height')),
                                  child: Container(
                                    width: 28 * prefs.getDouble('height'),
                                    height: 28 * prefs.getDouble('height'),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: prefix0.mainColor,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15.0 * prefs.getDouble('height'),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 52 * prefs.getDouble('height')),
              Container(
                height: 44 * prefs.getDouble('height'),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 32 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Trainer expectations",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 17 * prefs.getDouble('height'),
                          letterSpacing: -0.41),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 5.0 * prefs.getDouble('height'),
                    ),
                    Text(
                      "Describe what you expect from your trainer",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(150, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                          fontSize: 14 * prefs.getDouble('height'),
                          letterSpacing: -0.41),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0 * prefs.getDouble('height'),
              ),
              Container(
                height: 42 * prefs.getDouble('height'),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 32 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Description",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => EditExpectations(
                              clientUser: widget.clientUser,
                              parent: this,
                            ),
                          ),
                        );
                        restart = true;
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.parent.clientUser.expectations,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15.0 * prefs.getDouble('height'),
                                color: Color.fromARGB(170, 255, 255, 255),
                                letterSpacing: -0.24,
                                fontWeight: FontWeight.normal),
                            maxLines: 1,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1.0 * prefs.getDouble('height'),
                            color: Color.fromARGB(50, 255, 255, 255),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16.0 * prefs.getDouble('height'),
              ),
              Container(
                height: 128 * prefs.getDouble('height'),
                width: 310 * prefs.getDouble('width'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  restart = true;
                                  sociableButton = !sociableButton;
                                });
                              },
                              child: sociableButton == false
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: prefix0.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                              4.0 * prefs.getDouble('height'))),
                                      height: 32 * prefs.getDouble('height'),
                                      width: 150 * prefs.getDouble('width'),
                                      padding: EdgeInsets.all(
                                        8.0 * prefs.getDouble('height'),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Sociable",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 12 *
                                                    prefs.getDouble('height'),
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.check_box_outline_blank,
                                            size:
                                                16 * prefs.getDouble('height'),
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: prefix0.mainColor,
                                          borderRadius: BorderRadius.circular(
                                              4.0 * prefs.getDouble('height'))),
                                      height: 32 * prefs.getDouble('height'),
                                      width: 150 * prefs.getDouble('width'),
                                      padding: EdgeInsets.all(
                                        8.0 * prefs.getDouble('height'),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Sociable",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 12 *
                                                    prefs.getDouble('height'),
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.cancel,
                                            size:
                                                16 * prefs.getDouble('height'),
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    )),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restart = true;
                                nutritionistButton = !nutritionistButton;
                              });
                            },
                            child: nutritionistButton == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Nutritionist",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.check_box_outline_blank,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Nutritionist",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restart = true;
                                dynamicButton = !dynamicButton;
                              });
                            },
                            child: dynamicButton == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Dynamic",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.check_box_outline_blank,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Dynamic",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restart = true;
                                motivatingButton = !motivatingButton;
                              });
                            },
                            child: motivatingButton == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Motivating",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.check_box_outline_blank,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Motivating",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restart = true;
                                disciplinedButton = !disciplinedButton;
                              });
                            },
                            child: disciplinedButton == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Disciplined",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.check_box_outline_blank,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Disciplined",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                restart = true;
                                goodListenerButton = !goodListenerButton;
                              });
                            },
                            child: goodListenerButton == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Good listener",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.check_box_outline_blank,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: prefix0.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            4.0 * prefs.getDouble('height'))),
                                    height: 32 * prefs.getDouble('height'),
                                    width: 150 * prefs.getDouble('width'),
                                    padding: EdgeInsets.all(
                                      8.0 * prefs.getDouble('height'),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Good listener",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.cancel,
                                          size: 16 * prefs.getDouble('height'),
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 11.0 * prefs.getDouble('height'),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      restart = true;
                      anatomyKnowledgeButton = !anatomyKnowledgeButton;
                    });
                  },
                  child: anatomyKnowledgeButton == false
                      ? Container(
                          decoration: BoxDecoration(
                              color: prefix0.secondaryColor,
                              borderRadius: BorderRadius.circular(
                                  4.0 * prefs.getDouble('height'))),
                          height: 32 * prefs.getDouble('height'),
                          width: 310 * prefs.getDouble('width'),
                          padding: EdgeInsets.all(
                            8.0 * prefs.getDouble('height'),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Anatomy knowledge",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 8.0 * prefs.getDouble('width'),
                              ),
                              Icon(
                                Icons.check_box_outline_blank,
                                size: 16 * prefs.getDouble('height'),
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: prefix0.mainColor,
                              borderRadius: BorderRadius.circular(
                                  4.0 * prefs.getDouble('height'))),
                          height: 32 * prefs.getDouble('height'),
                          width: 310 * prefs.getDouble('width'),
                          padding: EdgeInsets.all(
                            8.0 * prefs.getDouble('height'),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Anatomy knowledge",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 8.0 * prefs.getDouble('width'),
                              ),
                              Icon(
                                Icons.cancel,
                                size: 16 * prefs.getDouble('height'),
                                color: Colors.white,
                              )
                            ],
                          ),
                        )),
              SizedBox(
                height: 30 * prefs.getDouble('height'),
              ),
              Container(
                height: 1.0 * prefs.getDouble('height'),
                color: Color(0xff3E3E45),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 32 * prefs.getDouble('width')),
                height: 43 * prefs.getDouble('height'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Accept friend requests from trainers",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(210, 255, 255, 255)),
                    ),
                    InkWell(
                      onTap: () {
                        toggleButton();
                      },
                      child: AnimatedContainer(
                        duration: Duration(
                          milliseconds: 400,
                        ),
                        height: 25 * prefs.getDouble('height'),
                        width: 60 * prefs.getDouble('width'),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0 * prefs.getDouble('height')),
                          borderRadius: BorderRadius.circular(20),
                          color: toggleValue
                              ? prefix0.mainColor
                              : prefix0.backgroundColor,
                        ),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            AnimatedPositioned(
                              top: 5.0 * prefs.getDouble('height'),
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                              left: toggleValue
                                  ? 25.0 * prefs.getDouble('width')
                                  : 5.0,
                              right: toggleValue
                                  ? 5.0
                                  : 35.0 * prefs.getDouble('width'),
                              child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 400),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return toggleValue == true
                                        ? Text(
                                            "Yes",
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: 11.0 *
                                                    prefs.getDouble('height'),
                                                fontWeight: FontWeight.w700),
                                          )
                                        : RotationTransition(
                                            child: child,
                                            turns: animation,
                                          );
                                  },
                                  child: toggleValue
                                      ? Text("Yes",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 11.0 *
                                                prefs.getDouble('height'),
                                            fontWeight: FontWeight.w700,
                                          ))
                                      : Text("No",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 11.0 *
                                                prefs.getDouble('height'),
                                            fontWeight: FontWeight.w700,
                                          ))),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1.0 * prefs.getDouble('height'),
                color: Color(0xff3E3E45),
              ),
              SizedBox(
                height: 30 * prefs.getDouble('height'),
              ),
              Container(
                height: 42 * prefs.getDouble('height'),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 32 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Account",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 17 * prefs.getDouble('height'),
                          letterSpacing: -0.41),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 5.0 * prefs.getDouble('height'),
                    ),
                    Text(
                      "Be careful, these settings may be irreversible",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(150, 255, 255, 255),
                          fontStyle: FontStyle.normal,
                          fontSize: 13 * prefs.getDouble('height'),
                          letterSpacing: -0.41),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20 * prefs.getDouble('height')),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 32 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        sendPasswordResetEmail(clientUser.nickname);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          "Reset password e-mail has been sent.",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18.0 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: mainColor),
                          textAlign: TextAlign.center,
                        )));
                      },
                      child: Text("Change password",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.0 * prefs.getDouble('height'),
                              letterSpacing: -0.08,
                              color: Color.fromARGB(220, 255, 255, 255),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start),
                    ),
                    SizedBox(height: 18.0 * prefs.getDouble('height')),
                    Text(
                      "Delete account",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.0 * prefs.getDouble('height'),
                          letterSpacing: -0.08,
                          color: Color(0xffFF453A),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class EditExpectations extends StatefulWidget {
  final _EditeazaProfilulState parent;
  final ClientUser clientUser;

  EditExpectations({Key key, @required this.clientUser, @required this.parent})
      : super(key: key);
  @override
  _EditExpectationsState createState() =>
      _EditExpectationsState(clientUser: clientUser, parent: parent);
}

class _EditExpectationsState extends State<EditExpectations> {
  final _EditeazaProfilulState parent;

  final ClientUser clientUser;
  _EditExpectationsState(
      {Key key, @required this.clientUser, @required this.parent});

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

  String verify;
  @override
  void initState() {
    super.initState();
    verify = prefs.getString("expectations");
    prefs.setString("expectations", null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: prefix0.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(
            Icons.backspace,
            color: Colors.white,
            size: 24 * prefs.getDouble('height'),
          ),
          onPressed: () async {
            prefs.setString('expectations', verify);
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15 * prefs.getDouble('width')),
            child: IconButton(
              icon: Icon(
                Icons.check,
                size: 22 * prefs.getDouble('height'),
                color: Colors.white,
              ),
              onPressed: () async {
                if (prefs.getString('expectations') != null) {
                  await Firestore.instance
                      .collection('clientUsers')
                      .document(
                        clientUser.id,
                      )
                      .updateData(
                    {"expectations": "${prefs.getString("expectations")}"},
                  );

                  this.parent.setState(() {
                    clientUser.expectations = prefs.getString("expectations");
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          )
        ],
        backgroundColor: prefix0.backgroundColor,
        elevation: 0.0,
        title: Center(
          child: Text(
            "Edit",
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 22 * prefs.getDouble('height'),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
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
              keyboardType: TextInputType.text,
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
                labelText: "Modify description & expectations",
              ),
              onChanged: (String str) {
                hinttText = str;
                prefs.setString("expectations", hinttText);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePhotoPopUp extends PopupRoute<void> {
  ProfilePhotoPopUp({this.client, this.currentCard});
  final int currentCard;
  final ClientUser client;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      ProfilePhoto(
        client: client,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ProfilePhoto extends StatefulWidget {
  final ClientUser client;
  ProfilePhoto({Key key, @required this.client}) : super(key: key);

  @override
  State createState() => ProfilePhotoState(client: client);
}

class ProfilePhotoState extends State<ProfilePhoto> {
  String hinttText = "Scrie";
  Image image;
  final ClientUser client;

  String hintName, hintStreet, hintSector;

  ProfilePhotoState({
    @required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent),
              child: Material(
                child: Container(
                  width: 250 * prefs.getDouble('width'),
                  height: 400 * prefs.getDouble('height'),
                  decoration: BoxDecoration(
                      color: Colors.transparent, shape: BoxShape.circle),
                  child: Image.network(
                    client.photoUrl,
                    fit: BoxFit.cover,
                    scale: 1.0,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor),
                            backgroundColor: backgroundColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
