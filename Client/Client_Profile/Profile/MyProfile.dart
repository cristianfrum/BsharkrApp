import 'dart:async';
import 'dart:io';
import 'package:Bsharkr/Client/Client_Profile/Profile/time.dart';
import 'package:Bsharkr/Trainer/My_Profile/Instabug.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instabug_flutter/FeatureRequests.dart';
import 'package:location/location.dart';
import '../../../DeleteAccount.dart';
import '../../../colors.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../helpAndInfo.dart';

class ClientMainProfile extends StatefulWidget {
  ClientMainProfile(
      {@required this.clientUser,
      @required this.auth,
      @required this.onSignedOut,
      @required this.snapshot})
      : super();
  final DocumentSnapshot snapshot;
  final ClientUser clientUser;
  final BaseAuth auth;
  final Function onSignedOut;

  @override
  _ClientMainProfileState createState() => _ClientMainProfileState(
      clientUser: clientUser, auth: auth, onSignedOut: onSignedOut);
}

class _ClientMainProfileState extends State<ClientMainProfile>
    with SingleTickerProviderStateMixin {
  _ClientMainProfileState(
      {@required this.clientUser,
      @required this.auth,
      @required this.onSignedOut})
      : super();
  var selected;
  final ClientUser clientUser;
  final BaseAuth auth;
  final Function onSignedOut;
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;
  bool flagBusinessAccepted = false;
  bool flagFriendshipAccepted = false;
  bool flagFriendshipPending = false;
  bool flagBusinessPending = false;
  bool availability = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final now = DateTime.now();
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

  String translate(String element) {
    if (element == 'dynamic') return 'Dynamic';
    if (element == 'nutritionist') return 'Nutritionist';
    if (element == 'disciplined') return 'Disciplined';
    if (element == 'motivating') return 'Motivating';
    if (element == 'sociable') return 'Sociable';
    if (element == 'goodListener') return 'Good listener';
    if (element == 'anatomyKnowledge') return 'Anatomy knowledge';
  }

  var batch1;
  var db1;
  ClientUser aux;
  @override
  void initState() {
   
    super.initState();if (Platform.isIOS) {
      Instabug.start('f255fe86747f44bcf79b2a6bcc4d1688', [InvocationEvent.shake]);
    }
    aux = ClientUser(widget.snapshot);

    db1 = Firestore.instance;
    batch1 = db1.batch();
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
void showFeatureRequests() {
    FeatureRequests.show();
  }
  void setPrimaryColor() {
    Instabug.setPrimaryColor(mainColor);
  }

   void setColorTheme(ColorTheme colorTheme) {
    Instabug.setColorTheme(colorTheme);
  }

  bool _loading = false;
  bool loading = false;
  Future _signOut(BuildContext context) async {
    try {
      await prefs.setString('logOut', 'true');
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
    } catch (e) {
      print(e);
    }

      if(mounted){
        Phoenix.rebirth(context);
      }
  }

  String showSetHour1(int index) {
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
    return "";
  }

  String showSetHour2(int index) {
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
    return "";
  }

  List<String> preferencesList = [];

  int specializationCounter = 0;

  @override
  Widget build(BuildContext context) {
    specializationCounter = 0;
    clientUser.preferencesList.forEach((preference) {
      if (preference.wanted == true) {
        preferencesList.add(preference.preference);
        specializationCounter++;
      }
    });
    bool flag = false;
    if (aux.hour1Availability.day1 != clientUser.hour1Availability.day1) {
      flag = true;
    }
    if (aux.hour1Availability.day2 != clientUser.hour1Availability.day2) {
      flag = true;
    }
    if (aux.hour1Availability.day3 != clientUser.hour1Availability.day3) {
      flag = true;
    }
    if (aux.hour1Availability.day4 != clientUser.hour1Availability.day4) {
      flag = true;
    }
    if (aux.hour1Availability.day5 != clientUser.hour1Availability.day5) {
      flag = true;
    }
    if (aux.hour1Availability.day6 != clientUser.hour1Availability.day6) {
      flag = true;
    }
    if (aux.hour1Availability.day7 != clientUser.hour1Availability.day7) {
      flag = true;
    }
    if (aux.hour1Availability.day8 != clientUser.hour1Availability.day8) {
      flag = true;
    }
    if (aux.hour1Availability.day9 != clientUser.hour1Availability.day9) {
      flag = true;
    }
    if (aux.hour1Availability.day10 != clientUser.hour1Availability.day10) {
      flag = true;
    }
    if (aux.hour1Availability.day11 != clientUser.hour1Availability.day11) {
      flag = true;
    }
    if (aux.hour1Availability.day12 != clientUser.hour1Availability.day12) {
      flag = true;
    }
    if (aux.hour1Availability.day13 != clientUser.hour1Availability.day13) {
      flag = true;
    }
    if (aux.hour1Availability.day14 != clientUser.hour1Availability.day14) {
      flag = true;
    }
    if (aux.hour1Availability.day15 != clientUser.hour1Availability.day15) {
      flag = true;
    }
    if (aux.hour1Availability.day16 != clientUser.hour1Availability.day16) {
      flag = true;
    }
    if (aux.hour1Availability.day17 != clientUser.hour1Availability.day17) {
      flag = true;
    }
    if (aux.hour1Availability.day18 != clientUser.hour1Availability.day18) {
      flag = true;
    }
    if (aux.hour1Availability.day19 != clientUser.hour1Availability.day19) {
      flag = true;
    }
    if (aux.hour1Availability.day20 != clientUser.hour1Availability.day20) {
      flag = true;
    }
    if (aux.hour1Availability.day21 != clientUser.hour1Availability.day21) {
      flag = true;
    }

    if (aux.hour2Availability.day1 != clientUser.hour2Availability.day1) {
      flag = true;
    }
    if (aux.hour2Availability.day2 != clientUser.hour2Availability.day2) {
      flag = true;
    }
    if (aux.hour2Availability.day3 != clientUser.hour2Availability.day3) {
      flag = true;
    }
    if (aux.hour2Availability.day4 != clientUser.hour2Availability.day4) {
      flag = true;
    }
    if (aux.hour2Availability.day5 != clientUser.hour2Availability.day5) {
      flag = true;
    }
    if (aux.hour2Availability.day6 != clientUser.hour2Availability.day6) {
      flag = true;
    }
    if (aux.hour2Availability.day7 != clientUser.hour2Availability.day7) {
      flag = true;
    }
    if (aux.hour2Availability.day8 != clientUser.hour2Availability.day8) {
      flag = true;
    }
    if (aux.hour2Availability.day9 != clientUser.hour2Availability.day9) {
      flag = true;
    }
    if (aux.hour2Availability.day10 != clientUser.hour2Availability.day10) {
      flag = true;
    }
    if (aux.hour2Availability.day11 != clientUser.hour2Availability.day11) {
      flag = true;
    }
    if (aux.hour2Availability.day12 != clientUser.hour2Availability.day12) {
      flag = true;
    }
    if (aux.hour2Availability.day13 != clientUser.hour2Availability.day13) {
      flag = true;
    }
    if (aux.hour2Availability.day14 != clientUser.hour2Availability.day14) {
      flag = true;
    }
    if (aux.hour2Availability.day15 != clientUser.hour2Availability.day15) {
      flag = true;
    }
    if (aux.hour2Availability.day16 != clientUser.hour2Availability.day16) {
      flag = true;
    }
    if (aux.hour2Availability.day17 != clientUser.hour2Availability.day17) {
      flag = true;
    }
    if (aux.hour2Availability.day18 != clientUser.hour2Availability.day18) {
      flag = true;
    }
    if (aux.hour2Availability.day19 != clientUser.hour2Availability.day19) {
      flag = true;
    }
    if (aux.hour2Availability.day20 != clientUser.hour2Availability.day20) {
      flag = true;
    }
    if (aux.hour2Availability.day21 != clientUser.hour2Availability.day21) {
      flag = true;
    }

    if (aux.availability.mondayMorning !=
        clientUser.availability.mondayMorning) {
      flag = true;
    }
    if (aux.availability.mondayMidday != clientUser.availability.mondayMidday) {
      flag = true;
    }
    if (aux.availability.mondayEvening !=
        clientUser.availability.mondayEvening) {
      flag = true;
    }
    if (aux.availability.tuesdayMorning !=
        clientUser.availability.tuesdayMorning) {
      flag = true;
    }
    if (aux.availability.tuesdayMidday !=
        clientUser.availability.tuesdayMidday) {
      flag = true;
    }
    if (aux.availability.tuesdayEvening !=
        clientUser.availability.tuesdayEvening) {
      flag = true;
    }
    if (aux.availability.wednesdayMorning !=
        clientUser.availability.wednesdayMorning) {
      flag = true;
    }
    if (aux.availability.wednesdayMidday !=
        clientUser.availability.wednesdayMidday) {
      flag = true;
    }
    if (aux.availability.wednesdayEvening !=
        clientUser.availability.wednesdayEvening) {
      flag = true;
    }
    if (aux.availability.thursdayMorning !=
        clientUser.availability.thursdayMorning) {
      flag = true;
    }
    if (aux.availability.thursdayMidday !=
        clientUser.availability.thursdayMidday) {
      flag = true;
    }
    if (aux.availability.thursdayEvening !=
        clientUser.availability.thursdayEvening) {
      flag = true;
    }
    if (aux.availability.fridayMorning !=
        clientUser.availability.fridayMorning) {
      flag = true;
    }
    if (aux.availability.fridayMidday != clientUser.availability.fridayMidday) {
      flag = true;
    }
    if (aux.availability.fridayEvening !=
        clientUser.availability.fridayEvening) {
      flag = true;
    }
    if (aux.availability.saturdayMorning !=
        clientUser.availability.saturdayMorning) {
      flag = true;
    }
    if (aux.availability.saturdayMidday !=
        clientUser.availability.saturdayMidday) {
      flag = true;
    }
    if (aux.availability.saturdayEvening !=
        clientUser.availability.saturdayEvening) {
      flag = true;
    }
    if (aux.availability.sundayMorning !=
        clientUser.availability.sundayMorning) {
      flag = true;
    }
    if (aux.availability.sundayMidday != clientUser.availability.sundayMidday) {
      flag = true;
    }
    if (aux.availability.sundayEvening !=
        clientUser.availability.sundayEvening) {
      flag = true;
    }
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
                  _signOut(context);
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
          child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
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
                      padding:
                          EdgeInsets.only(left: 32 * prefs.getDouble('width')),
                      child: InkWell(
                        onTap: () {
                          if(clientUser.photoUrl != null) {
                            Navigator.push(
                              context,
                              ProfilePhotoPopUp(
                                client: clientUser,
                              ));
                          }
                        },
                        child: clientUser.photoUrl == null
                            ? ClipOval(
                                child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255,
                                      clientUser.colorRed,
                                      clientUser.colorGreen,
                                      clientUser.colorBlue),
                                  shape: BoxShape.circle,
                                ),
                                height: (80 * prefs.getDouble('height')),
                                width: (80 * prefs.getDouble('height')),
                                child: Center(
                                  child: Text(clientUser.firstName[0],
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize:
                                            50 * prefs.getDouble('height'),
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
                                    loadingBuilder: (BuildContext ctx,
                                        Widget child,
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
                                (clientUser.gender == 'male'
                                    ? 'Male'
                                    : 'Female'),
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
                              builder: (BuildContext context) =>
                                  EditeazaProfilul(
                                      parent: this,
                                      auth: widget.auth,
                                      clientUser: clientUser),
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

                      InkWell(
                        onTap: () {
                          setPrimaryColor();
                          setColorTheme(ColorTheme.dark);
                          Instabug.show();
                        },
                        child: Container(
                          height: 45 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.bug_report,
                                size: 24 * prefs.getDouble('height'),
                                color: mainColor,
                              ),
                              SizedBox(width: 8 * prefs.getDouble('width')),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "We value your feedback!",
                                      style: TextStyle(
                                          letterSpacing: 0.06,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              11 * prefs.getDouble('height'),
                                          color: Colors.white),
                                    ),
                                    TextSpan(
                                        text: " REPORT A BUG",
                                        style: TextStyle(
                                            letterSpacing: 0.06,
                                            color: mainColor,
                                            fontSize:
                                                11 * prefs.getDouble('height'),
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              SizedBox(
                height: 8 * prefs.getDouble('height'),
              ),
              Container(
                height: 22 * prefs.getDouble('height'),
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
                          availability = false;
                        });
                      },
                      child: Container(
                        height: 26 * prefs.getDouble('height'),
                        child: Text(
                          "Availability",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              color: availability == false
                                  ? prefix0.mainColor
                                  : Color.fromARGB(100, 255, 255, 255),
                              fontSize: 17 * prefs.getDouble('height')),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          availability = true;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 26 * prefs.getDouble('height'),
                        child: Text(
                          "Preferences",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              color: availability == true
                                  ? prefix0.mainColor
                                  : Color.fromARGB(100, 255, 255, 255),
                              fontSize: 17 * prefs.getDouble('height')),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4 * prefs.getDouble('height'),
              ),
              Container(
                  height: 232 * prefs.getDouble('height'),
                  child: availability == false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CarouselSlider(
                                height: 200 * prefs.getDouble('height'),
                                initialPage: 0,
                                onPageChanged: (index) {},
                                items: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Monday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Container(
                                            width: 310.1 *
                                                prefs.getDouble('width'),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 15.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      Text(
                                                        "Morning",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 14 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            color:
                                                                Color.fromARGB(
                                                                    200,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      SizedBox(
                                                        height: 22.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      Text(
                                                        "Midday",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 14 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            color:
                                                                Color.fromARGB(
                                                                    200,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      SizedBox(
                                                        height: 22.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      Text(
                                                        "Evening",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 14 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            color:
                                                                Color.fromARGB(
                                                                    200,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      SizedBox(
                                                        height: 7.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 40 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 15.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (clientUser
                                                                      .availability
                                                                      .mondayMorning ==
                                                                  'Available') {
                                                                selected =
                                                                    await _selectTime(
                                                                        context);
                                                                DateTime
                                                                    transition;
                                                                if (clientUser
                                                                        .hour1Availability
                                                                        .day1
                                                                    is Timestamp) {
                                                                  Timestamp
                                                                      transitionFINAL =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day1;
                                                                  transition =
                                                                      transitionFINAL
                                                                          .toDate();
                                                                } else {
                                                                  transition =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day1
                                                                          .toDate();
                                                                }

                                                                var transitionFinal1 =
                                                                    transition
                                                                        .subtract(
                                                                  Duration(
                                                                      hours: transition
                                                                          .hour,
                                                                      minutes:
                                                                          transition
                                                                              .minute),
                                                                );
                                                                var transitionFinal2 =
                                                                    transitionFinal1
                                                                        .add(
                                                                  Duration(
                                                                      hours: selected
                                                                          .hour,
                                                                      minutes:
                                                                          selected
                                                                              .minute),
                                                                );
                                                                ;
                                                                batch1
                                                                    .updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(
                                                                          clientUser
                                                                              .id),
                                                                  {
                                                                    'hour1Day.1':
                                                                        transitionFinal2,
                                                                    'checkDay.1':
                                                                        'true'
                                                                  },
                                                                );

                                                                setState(
                                                                  () {
                                                                    clientUser
                                                                            .hour1Availability
                                                                            .day1 =
                                                                        Timestamp.fromDate(
                                                                            transitionFinal2);
                                                                    clientUser
                                                                        .checkDailyAvailability
                                                                        .day1 = 'true';
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              showSetHour1(1),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 13 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 22.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (clientUser
                                                                      .availability
                                                                      .mondayMidday ==
                                                                  'Available') {
                                                                selected =
                                                                    await _selectTime(
                                                                        context);
                                                                DateTime
                                                                    transition;
                                                                if (clientUser
                                                                        .hour1Availability
                                                                        .day2
                                                                    is Timestamp) {
                                                                  Timestamp
                                                                      transitionFINAL =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day2;
                                                                  transition =
                                                                      transitionFINAL
                                                                          .toDate();
                                                                } else {
                                                                  transition =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day2
                                                                          .toDate();
                                                                }

                                                                var transitionFinal1 =
                                                                    transition
                                                                        .subtract(
                                                                  Duration(
                                                                      hours: transition
                                                                          .hour,
                                                                      minutes:
                                                                          transition
                                                                              .minute),
                                                                );
                                                                var transitionFinal2 =
                                                                    transitionFinal1
                                                                        .add(
                                                                  Duration(
                                                                      hours: selected
                                                                          .hour,
                                                                      minutes:
                                                                          selected
                                                                              .minute),
                                                                );
                                                                ;
                                                                batch1
                                                                    .updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(
                                                                          clientUser
                                                                              .id),
                                                                  {
                                                                    'hour1Day.2':
                                                                        transitionFinal2,
                                                                    'checkDay.2':
                                                                        'true'
                                                                  },
                                                                );
                                                                setState(
                                                                  () {
                                                                    clientUser
                                                                            .hour1Availability
                                                                            .day2 =
                                                                        Timestamp.fromDate(
                                                                            transitionFinal2);
                                                                    clientUser
                                                                        .checkDailyAvailability
                                                                        .day2 = 'true';
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              showSetHour1(2),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 13 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 22.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (clientUser
                                                                      .availability
                                                                      .mondayEvening ==
                                                                  'Available') {
                                                                selected =
                                                                    await _selectTime(
                                                                        context);
                                                                DateTime
                                                                    transition;
                                                                if (clientUser
                                                                        .hour1Availability
                                                                        .day1
                                                                    is Timestamp) {
                                                                  Timestamp
                                                                      transitionFINAL =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day3;
                                                                  transition =
                                                                      transitionFINAL
                                                                          .toDate();
                                                                } else {
                                                                  transition =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day3
                                                                          .toDate();
                                                                }

                                                                var transitionFinal1 =
                                                                    transition
                                                                        .subtract(
                                                                  Duration(
                                                                      hours: transition
                                                                          .hour,
                                                                      minutes:
                                                                          transition
                                                                              .minute),
                                                                );
                                                                var transitionFinal2 =
                                                                    transitionFinal1
                                                                        .add(
                                                                  Duration(
                                                                      hours: selected
                                                                          .hour,
                                                                      minutes:
                                                                          selected
                                                                              .minute),
                                                                );
                                                                ;
                                                                batch1
                                                                    .updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(
                                                                          clientUser
                                                                              .id),
                                                                  {
                                                                    'hour1Day.3':
                                                                        transitionFinal2,
                                                                    'checkDay.3':
                                                                        'true'
                                                                  },
                                                                );
                                                                setState(
                                                                  () {
                                                                    clientUser
                                                                            .hour1Availability
                                                                            .day3 =
                                                                        Timestamp.fromDate(
                                                                            transitionFinal2);

                                                                    clientUser
                                                                        .checkDailyAvailability
                                                                        .day3 = 'true';
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              showSetHour1(3),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 13 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 7.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 10 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 15.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          Text(
                                                            clientUser.availability
                                                                        .mondayMorning ==
                                                                    "Busy"
                                                                ? ""
                                                                : "-",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          SizedBox(
                                                            height: 22.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          Text(
                                                            clientUser.availability
                                                                        .mondayMidday ==
                                                                    "Busy"
                                                                ? ""
                                                                : "-",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          SizedBox(
                                                            height: 22.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          Text(
                                                            clientUser.availability
                                                                        .mondayEvening ==
                                                                    "Busy"
                                                                ? ""
                                                                : "-",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          SizedBox(
                                                            height: 7.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 40 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 15.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (clientUser
                                                                      .availability
                                                                      .mondayMorning ==
                                                                  'Available') {
                                                                selected =
                                                                    await _selectTime(
                                                                        context);
                                                                DateTime
                                                                    transition;
                                                                if (clientUser
                                                                        .hour2Availability
                                                                        .day1
                                                                    is Timestamp) {
                                                                  Timestamp
                                                                      transitionFINAL =
                                                                      clientUser
                                                                          .hour2Availability
                                                                          .day1;
                                                                  transition =
                                                                      transitionFINAL
                                                                          .toDate();
                                                                } else {
                                                                  transition =
                                                                      clientUser
                                                                          .hour2Availability
                                                                          .day1
                                                                          .toDate();
                                                                }

                                                                var transitionFinal1 =
                                                                    transition
                                                                        .subtract(
                                                                  Duration(
                                                                      hours: transition
                                                                          .hour,
                                                                      minutes:
                                                                          transition
                                                                              .minute),
                                                                );
                                                                var transitionFinal2 =
                                                                    transitionFinal1
                                                                        .add(
                                                                  Duration(
                                                                      hours: selected
                                                                          .hour,
                                                                      minutes:
                                                                          selected
                                                                              .minute),
                                                                );
                                                                ;
                                                                batch1
                                                                    .updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(
                                                                          clientUser
                                                                              .id),
                                                                  {
                                                                    'hour2Day.1':
                                                                        transitionFinal2,
                                                                    'checkDay2.1':
                                                                        'true'
                                                                  },
                                                                );

                                                                setState(
                                                                  () {
                                                                    clientUser
                                                                            .hour2Availability
                                                                            .day1 =
                                                                        Timestamp.fromDate(
                                                                            transitionFinal2);

                                                                    clientUser
                                                                        .checkDailyAvailabilityV2
                                                                        .day1 = 'true';
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              showSetHour2(1),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 13 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 22.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (clientUser
                                                                      .availability
                                                                      .mondayMidday ==
                                                                  'Available') {
                                                                selected =
                                                                    await _selectTime(
                                                                        context);
                                                                DateTime
                                                                    transition;
                                                                if (clientUser
                                                                        .hour1Availability
                                                                        .day2
                                                                    is Timestamp) {
                                                                  Timestamp
                                                                      transitionFINAL =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day2;
                                                                  transition =
                                                                      transitionFINAL
                                                                          .toDate();
                                                                } else {
                                                                  transition =
                                                                      clientUser
                                                                          .hour1Availability
                                                                          .day2
                                                                          .toDate();
                                                                }

                                                                var transitionFinal1 =
                                                                    transition
                                                                        .subtract(
                                                                  Duration(
                                                                      hours: transition
                                                                          .hour,
                                                                      minutes:
                                                                          transition
                                                                              .minute),
                                                                );
                                                                var transitionFinal2 =
                                                                    transitionFinal1
                                                                        .add(
                                                                  Duration(
                                                                      hours: selected
                                                                          .hour,
                                                                      minutes:
                                                                          selected
                                                                              .minute),
                                                                );
                                                                ;
                                                                batch1
                                                                    .updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(
                                                                          clientUser
                                                                              .id),
                                                                  {
                                                                    'hour2Day.2':
                                                                        transitionFinal2,
                                                                    'checkDay2.2':
                                                                        'true'
                                                                  },
                                                                );

                                                                setState(
                                                                  () {
                                                                    clientUser
                                                                            .hour2Availability
                                                                            .day2 =
                                                                        Timestamp.fromDate(
                                                                            transitionFinal2);

                                                                    clientUser
                                                                        .checkDailyAvailabilityV2
                                                                        .day2 = 'true';
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              showSetHour2(2),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 13 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 22.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              if (clientUser
                                                                      .availability
                                                                      .mondayEvening ==
                                                                  'Available') {
                                                                selected =
                                                                    await _selectTime(
                                                                        context);
                                                                DateTime
                                                                    transition;
                                                                if (clientUser
                                                                        .hour2Availability
                                                                        .day1
                                                                    is Timestamp) {
                                                                  Timestamp
                                                                      transitionFINAL =
                                                                      clientUser
                                                                          .hour2Availability
                                                                          .day3;
                                                                  transition =
                                                                      transitionFINAL
                                                                          .toDate();
                                                                } else {
                                                                  transition =
                                                                      clientUser
                                                                          .hour2Availability
                                                                          .day3
                                                                          .toDate();
                                                                }

                                                                var transitionFinal1 =
                                                                    transition
                                                                        .subtract(
                                                                  Duration(
                                                                      hours: transition
                                                                          .hour,
                                                                      minutes:
                                                                          transition
                                                                              .minute),
                                                                );
                                                                var transitionFinal2 =
                                                                    transitionFinal1
                                                                        .add(
                                                                  Duration(
                                                                      hours: selected
                                                                          .hour,
                                                                      minutes:
                                                                          selected
                                                                              .minute),
                                                                );
                                                               
                                                                batch1
                                                                    .updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(
                                                                          clientUser
                                                                              .id),
                                                                  {
                                                                    'hour2Day.3':
                                                                        transitionFinal2,
                                                                    'checkDay2.3':
                                                                        'true'
                                                                  },
                                                                );

                                                                setState(
                                                                  () {
                                                                    clientUser
                                                                            .hour2Availability
                                                                            .day3 =
                                                                        Timestamp.fromDate(
                                                                            transitionFinal2);

                                                                    clientUser
                                                                        .checkDailyAvailabilityV2
                                                                        .day3 = 'true';
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              showSetHour2(3),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize: 13 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          200,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 7.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: 70 *
                                                      prefs.getDouble('width'),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 10.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (clientUser
                                                                  .availability
                                                                  .mondayMorning ==
                                                              "Available") {
                                                         
                                                            batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      clientUser
                                                                          .id),
                                                              {
                                                                'day.1': "Busy",
                                                                'checkDay.1':
                                                                    'false',
                                                                'checkDay2.1':
                                                                    'false'
                                                              },
                                                            );

                                                            setState(() {
                                                              clientUser
                                                                      .availability
                                                                      .mondayMorning =
                                                                  "Busy";
                                                              clientUser
                                                                  .checkDailyAvailability
                                                                  .day1 = 'false';
                                                              clientUser
                                                                  .checkDailyAvailabilityV2
                                                                  .day1 = 'false';
                                                            });
                                                          } else {
                                                            
                                                            batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      clientUser
                                                                          .id),
                                                              {
                                                                'day.1':
                                                                    "Available"
                                                              },
                                                            );

                                                            setState(() {
                                                              clientUser
                                                                      .availability
                                                                      .mondayMorning =
                                                                  "Available";
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.fromLTRB(
                                                              8 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              3 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              8 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              3 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1 *
                                                                          prefs.getDouble(
                                                                              'height')),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    30,
                                                                  ),
                                                                  color: clientUser
                                                                              .availability
                                                                              .mondayMorning ==
                                                                          "Available"
                                                                      ? prefix0
                                                                          .mainColor
                                                                      : Color(
                                                                          0xff57575E)),
                                                          child: Text(
                                                            clientUser
                                                                .availability
                                                                .mondayMorning,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.5 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (clientUser
                                                                  .availability
                                                                  .mondayMidday ==
                                                              "Available") {
                                                            batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      clientUser
                                                                          .id),
                                                              {
                                                                'day.2': "Busy",
                                                                'checkDay.2':
                                                                    'false',
                                                                'checkDay2.2':
                                                                    'false'
                                                              },
                                                            );
                                                            setState(() {
                                                              clientUser
                                                                      .availability
                                                                      .mondayMidday =
                                                                  "Busy";

                                                              clientUser
                                                                  .checkDailyAvailability
                                                                  .day2 = 'false';
                                                              clientUser
                                                                  .checkDailyAvailabilityV2
                                                                  .day2 = 'false';
                                                            });
                                                          } else {
                                                            
                                                            batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      clientUser
                                                                          .id),
                                                              {
                                                                'day.2':
                                                                    "Available"
                                                              },
                                                            );
                                                            setState(() {
                                                              clientUser
                                                                      .availability
                                                                      .mondayMidday =
                                                                  "Available";
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.fromLTRB(
                                                              8 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              3 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              8 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              3 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1 *
                                                                          prefs.getDouble(
                                                                              'height')),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    30,
                                                                  ),
                                                                  color: clientUser
                                                                              .availability
                                                                              .mondayMidday ==
                                                                          "Available"
                                                                      ? prefix0
                                                                          .mainColor
                                                                      : Color(
                                                                          0xff57575E)),
                                                          child: Text(
                                                            clientUser
                                                                .availability
                                                                .mondayMidday,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.5 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (clientUser
                                                                  .availability
                                                                  .mondayEvening ==
                                                              "Available") {
                                                            ;
                                                            batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      clientUser
                                                                          .id),
                                                              {
                                                                'day.3': "Busy",
                                                                'checkDay.3':
                                                                    'false',
                                                                'checkDay2.3':
                                                                    'false'
                                                              },
                                                            );
                                                            setState(() {
                                                              clientUser
                                                                      .availability
                                                                      .mondayEvening =
                                                                  "Busy";

                                                              clientUser
                                                                  .checkDailyAvailability
                                                                  .day3 = 'false';
                                                              clientUser
                                                                  .checkDailyAvailabilityV2
                                                                  .day3 = 'false';
                                                            });
                                                          } else {
                                                           
                                                            batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(
                                                                      clientUser
                                                                          .id),
                                                              {
                                                                'day.3':
                                                                    "Available"
                                                              },
                                                            );
                                                            setState(() {
                                                              clientUser
                                                                      .availability
                                                                      .mondayEvening =
                                                                  "Available";
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.fromLTRB(
                                                              8 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              3 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              8 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              3 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1 *
                                                                          prefs.getDouble(
                                                                              'height')),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    30,
                                                                  ),
                                                                  color: clientUser
                                                                              .availability
                                                                              .mondayEvening ==
                                                                          "Available"
                                                                      ? prefix0
                                                                          .mainColor
                                                                      : Color(
                                                                          0xff57575E)),
                                                          child: Text(
                                                            clientUser
                                                                .availability
                                                                .mondayEvening,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Tuesday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Morning",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Midday",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Evening",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 7.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30 *
                                                    prefs.getDouble('height'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .tuesdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day4
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day4;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day4
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                              
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.4':
                                                                      transitionFinal2,
                                                                  'checkDay.4':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day4 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day4 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(4),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .tuesdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day5
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day5;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day5
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                          
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.5':
                                                                      transitionFinal2,
                                                                  'checkDay.5':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day5 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day5 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(5),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .tuesdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day6
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day6;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day6
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                             
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.6':
                                                                      transitionFinal2,
                                                                  'checkDay.6':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day6 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day6 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(6),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .tuesdayMorning ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .tuesdayMidday ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .tuesdayEvening ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .tuesdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day4
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day4;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day4
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                              
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.4':
                                                                      transitionFinal2,
                                                                  'checkDay2.4':
                                                                      'true',
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day4 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day4 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(4),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .tuesdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day5
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day5;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day5
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                              
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.5':
                                                                      transitionFinal2,
                                                                  'checkDay2.5':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day5 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day5 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(5),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .tuesdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day6
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day6;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day6
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                              
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.6':
                                                                      transitionFinal2,
                                                                  'checkDay2.6':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day6 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day6 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(6),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 70 *
                                                    prefs.getDouble('width'),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .tuesdayMorning ==
                                                            "Available") {
                                                          
                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.4': "Busy",
                                                              'checkDay.4':
                                                                  'false',
                                                              'checkDay2.4':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .tuesdayMorning =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day4 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day4 = 'false';
                                                          });
                                                        } else {
                                                          
                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.4':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .tuesdayMorning =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .tuesdayMorning ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .tuesdayMorning,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .tuesdayMidday ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.5': "Busy",
                                                              'checkDay.5':
                                                                  'false',
                                                              'checkDay2.5':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .tuesdayMidday =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day5 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day5 = 'false';
                                                          });
                                                        } else {
                                                          
                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.5':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .tuesdayMidday =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .tuesdayMidday ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .tuesdayMidday,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .tuesdayEvening ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.6': "Busy",
                                                              'checkDay.6':
                                                                  'false',
                                                              'checkDay2.6':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .tuesdayEvening =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day6 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day6 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.6':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .tuesdayEvening =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .tuesdayEvening ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .tuesdayEvening,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Wednesday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Morning",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Midday",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Evening",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 7.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30 *
                                                    prefs.getDouble('height'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .wednesdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day7
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day7;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day7
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.7':
                                                                      transitionFinal2,
                                                                  'checkDay.7':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day7 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day7 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(7),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .wednesdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day8
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day8;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day8
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );
                                                              
                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.8':
                                                                      transitionFinal2,
                                                                  'checkDay.8':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day8 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day8 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(8),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .wednesdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day9
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day9;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day9
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.9':
                                                                      transitionFinal2,
                                                                  'checkDay.9':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day9 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day9 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(9),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .wednesdayMorning ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .wednesdayMidday ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .wednesdayEvening ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .wednesdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day7
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day7;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day7
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.7':
                                                                      transitionFinal2,
                                                                  'checkDay2.7':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day7 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day7 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(7),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .wednesdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day8
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day8;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day8
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.8':
                                                                      transitionFinal2,
                                                                  'checkDay2.8':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day8 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day8 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(8),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .wednesdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day9
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day9;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day9
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.9':
                                                                      transitionFinal2,
                                                                  'checkDay2.9':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day9 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day9 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(9),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 70 *
                                                    prefs.getDouble('width'),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .wednesdayMorning ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.7': "Busy",
                                                              'checkDay2.7':
                                                                  "false",
                                                              'checkDay.7':
                                                                  "false"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .wednesdayMorning =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day7 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day7 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.7':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .wednesdayMorning =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .wednesdayMorning ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .wednesdayMorning,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .wednesdayMidday ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.8': "Busy",
                                                              'checkDay.8':
                                                                  'false',
                                                              'checkDay2.8':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .wednesdayMidday =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day8 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day8 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.8':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .wednesdayMidday =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .wednesdayMidday ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .wednesdayMidday,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .wednesdayEvening ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.9': "Busy",
                                                              'checkDay.9':
                                                                  'false',
                                                              'checkDay2.9':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .wednesdayEvening =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day9 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day9 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.9':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .wednesdayEvening =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .wednesdayEvening ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .wednesdayEvening,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Thursday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Morning",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Midday",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Evening",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 7.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .thursdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day10
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day10;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day10
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.10':
                                                                      transitionFinal2,
                                                                  'checkDay.10':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day10 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day10 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(10),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .thursdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day11
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day11;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day11
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.11':
                                                                      transitionFinal2,
                                                                  'checkDay.11':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day11 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day11 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(11),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .thursdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day12
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day12;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day12
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour1Day.12':
                                                                      transitionFinal2,
                                                                  'checkDay.12':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day12 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day12 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(12),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .thursdayMorning ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .thursdayMidday ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .thursdayEvening ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .thursdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day10
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day10;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day10
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.10':
                                                                      transitionFinal2,
                                                                  'checkDay2.10':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day10 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day10 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(10),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .thursdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day11
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day11;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day11
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.11':
                                                                      transitionFinal2,
                                                                  'checkDay2.11':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day11 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day11 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(11),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .thursdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day12
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day12;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day12
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                db1
                                                                    .collection(
                                                                        'clientUsers')
                                                                    .document(
                                                                        clientUser
                                                                            .id),
                                                                {
                                                                  'hour2Day.12':
                                                                      transitionFinal2,
                                                                  'checkDay2.12':
                                                                      'true'
                                                                },
                                                              );
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day12 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);
                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day12 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(12),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 70 *
                                                    prefs.getDouble('width'),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .thursdayMorning ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.10': "Busy",
                                                              'checkDay.10':
                                                                  'false',
                                                              'checkDay2.10':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .thursdayMorning =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day10 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day10 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.10':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .thursdayMorning =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .thursdayMorning ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .thursdayMorning,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .thursdayMidday ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.11': "Busy",
                                                              'checkDay.11':
                                                                  'false',
                                                              'checkDay2.11':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .thursdayMidday =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day11 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day11 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.11':
                                                                  "Available"
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .thursdayMidday =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .thursdayMidday ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .thursdayMidday,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .thursdayEvening ==
                                                            "Available") {

                                                          batch1.updateData(
                                                            db1
                                                                .collection(
                                                                    'clientUsers')
                                                                .document(
                                                                    clientUser
                                                                        .id),
                                                            {
                                                              'day.12': "Busy",
                                                              'checkDay.12':
                                                                  'false',
                                                              'checkDay2.12':
                                                                  'false'
                                                            },
                                                          );
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .thursdayEvening =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day12 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day12 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.12':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .thursdayEvening =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .thursdayEvening ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .thursdayEvening,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Friday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Morning",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Midday",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Evening",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 7.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .fridayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day13
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day13;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day13
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.13':
                                                                        transitionFinal2,
                                                                    'checkDay.13':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day13 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day13 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(13),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .fridayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day14
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day14;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day14
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.14':
                                                                        transitionFinal2,
                                                                    'checkDay.14':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day14 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day14 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(14),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .fridayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day15
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day15;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day15
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.15':
                                                                        transitionFinal2,
                                                                    'checkDay.15':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day15 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day15 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(15),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .fridayMorning ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .fridayMidday ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .fridayEvening ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .fridayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day13
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day13;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day13
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.13':
                                                                        transitionFinal2,
                                                                    'checkDay2.13':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day13 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day13 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(13),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .fridayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day14
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day14;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day14
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.14':
                                                                        transitionFinal2,
                                                                    'checkDay2.14':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day14 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day14 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(14),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .fridayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day15
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day15;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day15
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.15':
                                                                        transitionFinal2,
                                                                    'checkDay2.15':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day15 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day15 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(15),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 70 *
                                                    prefs.getDouble('width'),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .fridayMorning ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.13':
                                                                    "Busy",
                                                                'checkDay.13':
                                                                    'false',
                                                                'checkDay2.13':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .fridayMorning =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day13 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day13 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.13':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .fridayMorning =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .fridayMorning ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .fridayMorning,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'width'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .fridayMidday ==
                                                            "Available") {
                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.14':
                                                                    "Busy",
                                                                'checkDay.14':
                                                                    'false',
                                                                'checkDay2.14':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .fridayMidday =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day14 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day14 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.14':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .fridayMidday =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .fridayMidday ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .fridayMidday,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .fridayEvening ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.15':
                                                                    "Busy",
                                                                'checkDay.15':
                                                                    'false',
                                                                'checkDay2.15':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .fridayEvening =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day15 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day15 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.15':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .fridayEvening =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .fridayEvening ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .fridayEvening,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Saturday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Morning",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Midday",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Evening",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 7.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .saturdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day16
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day16;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day16
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.16':
                                                                        transitionFinal2,
                                                                    'checkDay.16':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day16 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day16 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(16),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .saturdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day17
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day17;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day17
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.17':
                                                                        transitionFinal2,
                                                                    'checkDay.17':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day17 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day17 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(17),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .saturdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day18
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day18;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day18
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.18':
                                                                        transitionFinal2,
                                                                    'checkDay.18':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day18 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day18 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(18),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .saturdayMorning ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .saturdayMidday ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .saturdayEvening ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .saturdayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day16
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day16;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day16
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.16':
                                                                        transitionFinal2,
                                                                    'checkDay2.16':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day16 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day16 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(16),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .saturdayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day17
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day17;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day17
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.17':
                                                                        transitionFinal2,
                                                                    'checkDay2.17':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day17 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day17 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(17),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .saturdayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day18
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day18;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day18
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.18':
                                                                        transitionFinal2,
                                                                    'checkDay2.18':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day18 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day18 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(18),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 70 *
                                                    prefs.getDouble('width'),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .saturdayMorning ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.16':
                                                                    "Busy",
                                                                'checkDay.16':
                                                                    'false',
                                                                'checkDay2.16':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .saturdayMorning =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day16 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day16 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.16':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .saturdayMorning =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .saturdayMorning ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .saturdayMorning,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .saturdayMidday ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.17':
                                                                    "Busy",
                                                                'checkDay.17':
                                                                    'false',
                                                                'checkDay2.17':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .saturdayMidday =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day17 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day17 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.17':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .saturdayMidday =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .saturdayMidday ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .saturdayMidday,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .saturdayEvening ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.18':
                                                                    "Busy",
                                                                'checkDay.18':
                                                                    'false',
                                                                'checkDay2.18':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .saturdayEvening =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day18 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day18 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.18':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .saturdayEvening =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .saturdayEvening ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .saturdayEvening,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height'),
                                        10 * prefs.getDouble('width'),
                                        15 * prefs.getDouble('height')),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.0 * prefs.getDouble('height')),
                                      color: prefix0.secondaryColor,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height'),
                                          15 * prefs.getDouble('width'),
                                          10 * prefs.getDouble('height')),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5 *
                                                    prefs.getDouble('height')),
                                            child: Text(
                                              "Sunday",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20 *
                                                      prefs.getDouble('height'),
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      200, 255, 255, 255)),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Morning",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Midday",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 22.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Text(
                                                      "Evening",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          color: Color.fromARGB(
                                                              200,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 7.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30 *
                                                    prefs.getDouble('width'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .sundayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day19
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day19;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day19
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.19':
                                                                        transitionFinal2,
                                                                    'checkDay.19':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day19 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day19 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(19),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .sundayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day20
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day20;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day20
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.20':
                                                                        transitionFinal2,
                                                                    'checkDay.20':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day20 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day20 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(20),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .sundayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour1Availability
                                                                      .day21
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day21;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour1Availability
                                                                        .day21
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour1Day.21':
                                                                        transitionFinal2,
                                                                    'checkDay.21':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour1Availability
                                                                          .day21 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailability
                                                                      .day21 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour1(21),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .sundayMorning ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .sundayMidday ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Text(
                                                          clientUser.availability
                                                                      .sundayEvening ==
                                                                  "Busy"
                                                              ? ""
                                                              : "-",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 13 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              color: Color
                                                                  .fromARGB(
                                                                      200,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40 *
                                                        prefs
                                                            .getDouble('width'),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 15.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .sundayMorning ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day19
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day19;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day19
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.19':
                                                                        transitionFinal2,
                                                                    'checkDay2.19':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day19 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day19 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(19),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .sundayMidday ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day20
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day20;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day20
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.20':
                                                                        transitionFinal2,
                                                                    'checkDay2.20':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day20 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day20 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(20),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 22.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (clientUser
                                                                    .availability
                                                                    .sundayEvening ==
                                                                'Available') {
                                                              selected =
                                                                  await _selectTime(
                                                                      context);
                                                              DateTime
                                                                  transition;
                                                              if (clientUser
                                                                      .hour2Availability
                                                                      .day21
                                                                  is Timestamp) {
                                                                Timestamp
                                                                    transitionFINAL =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day21;
                                                                transition =
                                                                    transitionFINAL
                                                                        .toDate();
                                                              } else {
                                                                transition =
                                                                    clientUser
                                                                        .hour2Availability
                                                                        .day21
                                                                        .toDate();
                                                              }

                                                              var transitionFinal1 =
                                                                  transition
                                                                      .subtract(
                                                                Duration(
                                                                    hours:
                                                                        transition
                                                                            .hour,
                                                                    minutes:
                                                                        transition
                                                                            .minute),
                                                              );
                                                              var transitionFinal2 =
                                                                  transitionFinal1
                                                                      .add(
                                                                Duration(
                                                                    hours:
                                                                        selected
                                                                            .hour,
                                                                    minutes:
                                                                        selected
                                                                            .minute),
                                                              );

                                                              batch1.updateData(
                                                                  db1
                                                                      .collection(
                                                                          'clientUsers')
                                                                      .document(clientUser.id),
                                                                  {
                                                                    'hour2Day.21':
                                                                        transitionFinal2,
                                                                    'checkDay2.21':
                                                                        'true'
                                                                  });
                                                              setState(
                                                                () {
                                                                  clientUser
                                                                          .hour2Availability
                                                                          .day21 =
                                                                      Timestamp
                                                                          .fromDate(
                                                                              transitionFinal2);

                                                                  clientUser
                                                                      .checkDailyAvailabilityV2
                                                                      .day21 = 'true';
                                                                },
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            showSetHour2(21),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                color: Color
                                                                    .fromARGB(
                                                                        200,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 70 *
                                                    prefs.getDouble('width'),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .sundayMorning ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.19':
                                                                    "Busy",
                                                                'checkDay.19':
                                                                    'false',
                                                                'checkDay2.19':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .sundayMorning =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day19 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day19 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.19':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .sundayMorning =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .sundayMorning ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .sundayMorning,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .sundayMidday ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.20':
                                                                    "Busy",
                                                                'checkDay.20':
                                                                    'false',
                                                                'checkDay2.20':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .sundayMidday =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day20 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day20 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.20':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .sundayMidday =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .sundayMidday ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .sundayMidday,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.5 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (clientUser
                                                                .availability
                                                                .sundayEvening ==
                                                            "Available") {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.21':
                                                                    "Busy",
                                                                'checkDay.21':
                                                                    'false',
                                                                'checkDay2.21':
                                                                    'false'
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .sundayEvening =
                                                                "Busy";

                                                            clientUser
                                                                .checkDailyAvailability
                                                                .day21 = 'false';
                                                            clientUser
                                                                .checkDailyAvailabilityV2
                                                                .day21 = 'false';
                                                          });
                                                        } else {

                                                          batch1.updateData(
                                                              db1
                                                                  .collection(
                                                                      'clientUsers')
                                                                  .document(clientUser.id),
                                                              {
                                                                'day.21':
                                                                    "Available"
                                                              });
                                                          setState(() {
                                                            clientUser
                                                                    .availability
                                                                    .sundayEvening =
                                                                "Available";
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.fromLTRB(
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            8 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                            3 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  30,
                                                                ),
                                                                color: clientUser
                                                                            .availability
                                                                            .sundayEvening ==
                                                                        "Available"
                                                                    ? prefix0
                                                                        .mainColor
                                                                    : Color(
                                                                        0xff57575E)),
                                                        child: Text(
                                                          clientUser
                                                              .availability
                                                              .sundayEvening,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            flag == true
                                ? Center(
                                    child: Container(
                                      width: 310 * prefs.getDouble('width'),
                                      height: 32 * prefs.getDouble('height'),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(4),
                                        color: prefix0.mainColor,
                                        child: MaterialButton(
                                            onPressed: () async {
                                              setState(() {
                                                batch1.commit();
                                                batch1 = db1.batch();
                                                aux.hour1Availability.day1 =
                                                    clientUser
                                                        .hour1Availability.day1;
                                                aux.hour1Availability.day2 =
                                                    clientUser
                                                        .hour1Availability.day2;
                                                aux.hour1Availability.day3 =
                                                    clientUser
                                                        .hour1Availability.day3;
                                                aux.hour1Availability.day4 =
                                                    clientUser
                                                        .hour1Availability.day4;
                                                aux.hour1Availability.day5 =
                                                    clientUser
                                                        .hour1Availability.day5;
                                                aux.hour1Availability.day6 =
                                                    clientUser
                                                        .hour1Availability.day6;
                                                aux.hour1Availability.day7 =
                                                    clientUser
                                                        .hour1Availability.day7;
                                                aux.hour1Availability.day8 =
                                                    clientUser
                                                        .hour1Availability.day8;
                                                aux.hour1Availability.day9 =
                                                    clientUser
                                                        .hour1Availability.day9;
                                                aux.hour1Availability.day10 =
                                                    clientUser.hour1Availability
                                                        .day10;
                                                aux.hour1Availability.day11 =
                                                    clientUser.hour1Availability
                                                        .day11;
                                                aux.hour1Availability.day12 =
                                                    clientUser.hour1Availability
                                                        .day12;
                                                aux.hour1Availability.day13 =
                                                    clientUser.hour1Availability
                                                        .day13;
                                                aux.hour1Availability.day14 =
                                                    clientUser.hour1Availability
                                                        .day14;
                                                aux.hour1Availability.day15 =
                                                    clientUser.hour1Availability
                                                        .day15;
                                                aux.hour1Availability.day16 =
                                                    clientUser.hour1Availability
                                                        .day16;
                                                aux.hour1Availability.day17 =
                                                    clientUser.hour1Availability
                                                        .day17;
                                                aux.hour1Availability.day18 =
                                                    clientUser.hour1Availability
                                                        .day18;
                                                aux.hour1Availability.day19 =
                                                    clientUser.hour1Availability
                                                        .day19;
                                                aux.hour1Availability.day20 =
                                                    clientUser.hour1Availability
                                                        .day20;
                                                aux.hour1Availability.day21 =
                                                    clientUser.hour1Availability
                                                        .day21;

                                                aux.hour2Availability.day1 =
                                                    clientUser
                                                        .hour2Availability.day1;
                                                aux.hour2Availability.day2 =
                                                    clientUser
                                                        .hour2Availability.day2;
                                                aux.hour2Availability.day3 =
                                                    clientUser
                                                        .hour2Availability.day3;
                                                aux.hour2Availability.day4 =
                                                    clientUser
                                                        .hour2Availability.day4;
                                                aux.hour2Availability.day5 =
                                                    clientUser
                                                        .hour2Availability.day5;
                                                aux.hour2Availability.day6 =
                                                    clientUser
                                                        .hour2Availability.day6;
                                                aux.hour2Availability.day7 =
                                                    clientUser
                                                        .hour2Availability.day7;
                                                aux.hour2Availability.day8 =
                                                    clientUser
                                                        .hour2Availability.day8;
                                                aux.hour2Availability.day9 =
                                                    clientUser
                                                        .hour2Availability.day9;
                                                aux.hour2Availability.day10 =
                                                    clientUser.hour2Availability
                                                        .day10;
                                                aux.hour2Availability.day11 =
                                                    clientUser.hour2Availability
                                                        .day11;
                                                aux.hour2Availability.day12 =
                                                    clientUser.hour2Availability
                                                        .day12;
                                                aux.hour2Availability.day13 =
                                                    clientUser.hour2Availability
                                                        .day13;
                                                aux.hour2Availability.day14 =
                                                    clientUser.hour2Availability
                                                        .day14;
                                                aux.hour2Availability.day15 =
                                                    clientUser.hour2Availability
                                                        .day15;
                                                aux.hour2Availability.day16 =
                                                    clientUser.hour2Availability
                                                        .day16;
                                                aux.hour2Availability.day17 =
                                                    clientUser.hour2Availability
                                                        .day17;
                                                aux.hour2Availability.day18 =
                                                    clientUser.hour2Availability
                                                        .day18;
                                                aux.hour2Availability.day19 =
                                                    clientUser.hour2Availability
                                                        .day19;
                                                aux.hour2Availability.day20 =
                                                    clientUser.hour2Availability
                                                        .day20;
                                                aux.hour2Availability.day21 =
                                                    clientUser.hour2Availability
                                                        .day21;

                                                aux.availability.mondayMorning =
                                                    clientUser.availability
                                                        .mondayMorning;
                                                aux.availability.mondayMidday =
                                                    clientUser.availability
                                                        .mondayMidday;
                                                aux.availability.mondayEvening =
                                                    clientUser.availability
                                                        .mondayEvening;
                                                aux.availability
                                                        .tuesdayMorning =
                                                    clientUser.availability
                                                        .tuesdayMorning;
                                                aux.availability.tuesdayMidday =
                                                    clientUser.availability
                                                        .tuesdayMidday;
                                                aux.availability
                                                        .tuesdayEvening =
                                                    clientUser.availability
                                                        .tuesdayEvening;
                                                aux.availability
                                                        .wednesdayMorning =
                                                    clientUser.availability
                                                        .wednesdayMorning;
                                                aux.availability
                                                        .wednesdayMidday =
                                                    clientUser.availability
                                                        .wednesdayMidday;
                                                aux.availability
                                                        .wednesdayEvening =
                                                    clientUser.availability
                                                        .wednesdayEvening;
                                                aux.availability
                                                        .thursdayMorning =
                                                    clientUser.availability
                                                        .thursdayMorning;
                                                aux.availability
                                                        .thursdayMidday =
                                                    clientUser.availability
                                                        .thursdayMidday;
                                                aux.availability
                                                        .thursdayEvening =
                                                    clientUser.availability
                                                        .thursdayEvening;
                                                aux.availability.fridayMorning =
                                                    clientUser.availability
                                                        .fridayMorning;
                                                aux.availability.fridayMidday =
                                                    clientUser.availability
                                                        .fridayMidday;
                                                aux.availability.fridayEvening =
                                                    clientUser.availability
                                                        .fridayEvening;
                                                aux.availability
                                                        .saturdayMorning =
                                                    clientUser.availability
                                                        .saturdayMorning;
                                                aux.availability
                                                        .saturdayMidday =
                                                    clientUser.availability
                                                        .saturdayMidday;
                                                aux.availability
                                                        .saturdayEvening =
                                                    clientUser.availability
                                                        .saturdayEvening;
                                                aux.availability.sundayMorning =
                                                    clientUser.availability
                                                        .sundayMorning;
                                                aux.availability.sundayMidday =
                                                    clientUser.availability
                                                        .sundayMidday;
                                                aux.availability.sundayEvening =
                                                    clientUser.availability
                                                        .sundayEvening;
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 16 *
                                                      prefs.getDouble('height'),
                                                ),
                                                SizedBox(
                                                  width: 10.0 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Text(
                                                  "Save schedule",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12 *
                                                          prefs.getDouble(
                                                              'height')),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Align(
                          alignment: Alignment.topCenter,
                          child: specializationCounter == 1
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
                                  child: Center(
                                    child: Text(
                                      "${translate(preferencesList[0])}",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              12 * prefs.getDouble('height'),
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white),
                                    ),
                                  ))
                              : specializationCounter == 2
                                  ? Container(
                                      height: 32 * prefs.getDouble('height'),
                                      width: 310 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0 *
                                                              prefs.getDouble(
                                                                  'height'))),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              width: 150 *
                                                  prefs.getDouble('width'),
                                              padding: EdgeInsets.all(
                                                8.0 * prefs.getDouble('height'),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${translate(preferencesList[0])}",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 12 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.white),
                                                ),
                                              )),
                                          SizedBox(
                                            width:
                                                10 * prefs.getDouble('width'),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0 *
                                                              prefs.getDouble(
                                                                  'height'))),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              width: 150 *
                                                  prefs.getDouble('width'),
                                              padding: EdgeInsets.all(
                                                8.0 * prefs.getDouble('height'),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${translate(preferencesList[1])}",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 12 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.white),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  : specializationCounter == 3
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              width: 310 *
                                                  prefs.getDouble('width'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: prefix0
                                                              .secondaryColor,
                                                          borderRadius: BorderRadius
                                                              .circular(4.0 *
                                                                  prefs.getDouble(
                                                                      'height'))),
                                                      height: 32 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      width: 150 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      padding: EdgeInsets.all(
                                                        8.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${translate(preferencesList[0])}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10 *
                                                        prefs
                                                            .getDouble('width'),
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: prefix0
                                                              .secondaryColor,
                                                          borderRadius: BorderRadius
                                                              .circular(4.0 *
                                                                  prefs.getDouble(
                                                                      'height'))),
                                                      height: 32 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      width: 150 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      padding: EdgeInsets.all(
                                                        8.0 *
                                                            prefs.getDouble(
                                                                'height'),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${translate(preferencesList[1])}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 11.0 *
                                                  prefs.getDouble('height'),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        prefix0.secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0 *
                                                                prefs.getDouble(
                                                                    'height'))),
                                                height: 32 *
                                                    prefs.getDouble('height'),
                                                width: 310 *
                                                    prefs.getDouble('width'),
                                                padding: EdgeInsets.all(
                                                  8.0 *
                                                      prefs.getDouble('height'),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${translate(preferencesList[2])}",
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 12 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors.white),
                                                  ),
                                                ))
                                          ],
                                        )
                                      : specializationCounter == 4
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 32 *
                                                      prefs.getDouble('height'),
                                                  width: 310 *
                                                      prefs.getDouble('width'),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: prefix0
                                                                  .secondaryColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(4.0 *
                                                                      prefs.getDouble(
                                                                          'height'))),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 150 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          padding:
                                                              EdgeInsets.all(
                                                            8.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${translate(preferencesList[0])}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10 *
                                                            prefs.getDouble(
                                                                'width'),
                                                      ),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: prefix0
                                                                  .secondaryColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(4.0 *
                                                                      prefs.getDouble(
                                                                          'height'))),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 150 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          padding:
                                                              EdgeInsets.all(
                                                            8.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${translate(preferencesList[1])}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11.0 *
                                                      prefs.getDouble('height'),
                                                ),
                                                Container(
                                                  height: 32 *
                                                      prefs.getDouble('height'),
                                                  width: 310 *
                                                      prefs.getDouble('width'),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: prefix0
                                                                  .secondaryColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(4.0 *
                                                                      prefs.getDouble(
                                                                          'height'))),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 150 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          padding:
                                                              EdgeInsets.all(
                                                            8.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${translate(preferencesList[2])}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10 *
                                                            prefs.getDouble(
                                                                'width'),
                                                      ),
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              color: prefix0
                                                                  .secondaryColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(4.0 *
                                                                      prefs.getDouble(
                                                                          'height'))),
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 150 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          padding:
                                                              EdgeInsets.all(
                                                            8.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${translate(preferencesList[3])}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          : specializationCounter == 5
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 32 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      width: 310 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color: prefix0
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 150 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                8.0 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${translate(preferencesList[0])}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize: 12 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: 10 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                          ),
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color: prefix0
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 150 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                8.0 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${translate(preferencesList[1])}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize: 12 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Container(
                                                      height: 32 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      width: 310 *
                                                          prefs.getDouble(
                                                              'width'),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color: prefix0
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 150 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                8.0 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${translate(preferencesList[2])}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize: 12 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: 10 *
                                                                prefs.getDouble(
                                                                    'width'),
                                                          ),
                                                          Container(
                                                              decoration: BoxDecoration(
                                                                  color: prefix0
                                                                      .secondaryColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 150 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                8.0 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "${translate(preferencesList[3])}",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize: 12 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: prefix0
                                                                .secondaryColor,
                                                            borderRadius: BorderRadius
                                                                .circular(4.0 *
                                                                    prefs.getDouble(
                                                                        'height'))),
                                                        height: 32 *
                                                            prefs.getDouble(
                                                                'height'),
                                                        width: 310 *
                                                            prefs.getDouble(
                                                                'width'),
                                                        padding: EdgeInsets.all(
                                                          8.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${translate(preferencesList[4])}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 12 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              : specializationCounter == 6
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 310 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                    8.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${translate(preferencesList[0])}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 12 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 10 *
                                                                    prefs.getDouble(
                                                                        'width'),
                                                              ),
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                    8.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${translate(preferencesList[1])}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 12 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 11.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Container(
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 310 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                    8.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${translate(preferencesList[2])}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 12 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 10 *
                                                                    prefs.getDouble(
                                                                        'width'),
                                                              ),
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                    8.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${translate(preferencesList[3])}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 12 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 11.0 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        Container(
                                                          height: 32 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          width: 310 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                    8.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${translate(preferencesList[5])}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 12 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )),
                                                              SizedBox(
                                                                width: 10 *
                                                                    prefs.getDouble(
                                                                        'width'),
                                                              ),
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
                                                                          prefs.getDouble(
                                                                              'height'))),
                                                                  height: 32 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                  width: 150 *
                                                                      prefs.getDouble(
                                                                          'width'),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                    8.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "${translate(preferencesList[6])}",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 12 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : specializationCounter == 7
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 310 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: prefix0
                                                                              .secondaryColor,
                                                                          borderRadius: BorderRadius.circular(4.0 *
                                                                              prefs.getDouble(
                                                                                  'height'))),
                                                                      height: 32 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                        8.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${translate(preferencesList[0])}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 12 * prefs.getDouble('height'),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        prefs.getDouble(
                                                                            'width'),
                                                                  ),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: prefix0
                                                                              .secondaryColor,
                                                                          borderRadius: BorderRadius.circular(4.0 *
                                                                              prefs.getDouble(
                                                                                  'height'))),
                                                                      height: 32 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                        8.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${translate(preferencesList[1])}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 12 * prefs.getDouble('height'),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 11.0 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                            ),
                                                            Container(
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 310 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: prefix0
                                                                              .secondaryColor,
                                                                          borderRadius: BorderRadius.circular(4.0 *
                                                                              prefs.getDouble(
                                                                                  'height'))),
                                                                      height: 32 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                        8.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${translate(preferencesList[2])}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 12 * prefs.getDouble('height'),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        prefs.getDouble(
                                                                            'width'),
                                                                  ),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: prefix0
                                                                              .secondaryColor,
                                                                          borderRadius: BorderRadius.circular(4.0 *
                                                                              prefs.getDouble(
                                                                                  'height'))),
                                                                      height: 32 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                        8.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${translate(preferencesList[3])}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 12 * prefs.getDouble('height'),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 11.0 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                            ),
                                                            Container(
                                                              height: 32 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                              width: 310 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: prefix0
                                                                              .secondaryColor,
                                                                          borderRadius: BorderRadius.circular(4.0 *
                                                                              prefs.getDouble(
                                                                                  'height'))),
                                                                      height: 32 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                        8.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${translate(preferencesList[4])}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 12 * prefs.getDouble('height'),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        prefs.getDouble(
                                                                            'width'),
                                                                  ),
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          color: prefix0
                                                                              .secondaryColor,
                                                                          borderRadius: BorderRadius.circular(4.0 *
                                                                              prefs.getDouble(
                                                                                  'height'))),
                                                                      height: 32 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      width: 150 *
                                                                          prefs.getDouble(
                                                                              'width'),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                        8.0 *
                                                                            prefs.getDouble('height'),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${translate(preferencesList[5])}",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 12 * prefs.getDouble('height'),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontStyle: FontStyle.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10 *
                                                                    prefs.getDouble(
                                                                        'height')),
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: prefix0
                                                                        .secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(4.0 *
                                                                            prefs.getDouble(
                                                                                'height'))),
                                                                height: 32 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                                width: 310 *
                                                                    prefs.getDouble(
                                                                        'width'),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                  8.0 *
                                                                      prefs.getDouble(
                                                                          'height'),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "${translate(preferencesList[6])}",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize: 12 *
                                                                            prefs.getDouble(
                                                                                'height'),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ))
                                                          ],
                                                        )
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              color: prefix0
                                                                  .secondaryColor),
                                                          width: 310 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                          height: 180 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text("No preferences set",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize: 17.0 *
                                                                            prefs.getDouble(
                                                                                'height'),
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        letterSpacing:
                                                                            -0.408),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                SizedBox(
                                                                    height: 8 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          36.0 *
                                                                              prefs.getDouble('width')),
                                                                  child: Text(
                                                                      "Setting your preferences will help trainers meet your requirements.",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize:
                                                                            13.0 *
                                                                                prefs.getDouble('height'),
                                                                        color: Color.fromARGB(
                                                                            100,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                ),
                                                                SizedBox(
                                                                    height: 8 *
                                                                        prefs.getDouble(
                                                                            'height')),
                                                                InkWell(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        new MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              EditeazaProfilul(
                                                                            parent:
                                                                                this,
                                                                            auth:
                                                                                widget.auth,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                        height: 32 * prefs.getDouble('height'),
                                                                        width: 106 * prefs.getDouble('width'),
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              mainColor,
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(90),
                                                                          ),
                                                                        ),
                                                                        child: Center(
                                                                            child: Text(
                                                                          "Set preferences",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
                                                                            color:
                                                                                Colors.white,
                                                                            letterSpacing:
                                                                                -0.06,
                                                                          ),
                                                                        ))))
                                                              ]),
                                                        ))),
              Container(
                height: 190.0 * prefs.getDouble('height'),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 32 * prefs.getDouble('width')),
                        child: Text(
                          "Description & Expectations",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              color: Color.fromARGB(100, 255, 255, 255),
                              fontSize: 17.0 * prefs.getDouble('height'),
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.0 * prefs.getDouble('height'),
                    ),
                    Container(
                      width: double.infinity,
                      height: 136 * prefs.getDouble('height'),
                      child: SingleChildScrollView(
                          child: (clientUser.expectations != "" ||
                                  prefs.getString('expectations') != null)
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 32.0 * prefs.getDouble('width')),
                                  child: Container(
                                    child: Text(
                                      (prefs.getString("expectations") == null)
                                          ? clientUser.expectations
                                          : prefs.getString('expectations'),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          fontSize:
                                              15 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          32 * prefs.getDouble('width')),
                                  height: 136 * prefs.getDouble('height'),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("No description set",
                                          style: TextStyle(
                                              fontSize: 17 *
                                                  prefs.getDouble('height'),
                                              letterSpacing: -0.408,
                                              fontFamily: 'Roboto',
                                              color: Colors.white),
                                          textAlign: TextAlign.center),
                                      Text(
                                          "Setting your expectations will aid trainers in providing compatible services with your needs.",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Color.fromARGB(
                                                  100, 255, 255, 255),
                                              fontSize: 12 *
                                                  prefs.getDouble('height')),
                                          textAlign: TextAlign.center),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditeazaProfilul(
                                                parent: this,
                                                auth: widget.auth,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height:
                                              32 * prefs.getDouble('height'),
                                          width: 186 * prefs.getDouble('width'),
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(90),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Set description & expectations",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white,
                                                letterSpacing: -0.06,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                    )
                  ],
                ),
              ),
            ],
          ),
          loading == true
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0 * prefs.getDouble('height')),
                      color: prefix0.secondaryColor,
                    ),
                    height: 80 * prefs.getDouble('height'),
                    width: 80 * prefs.getDouble('width'),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      )),
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

class CarouselSlider extends StatefulWidget {
  CarouselSlider(
      {@required this.items,
      this.height,
      this.aspectRatio: 16 / 9,
      this.viewportFraction: 0.9,
      this.initialPage: 0,
      int realPage: 10000,
      this.enableInfiniteScroll: true,
      this.reverse: false,
      this.autoPlay: false,
      this.autoPlayInterval: const Duration(seconds: 4),
      this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
      this.autoPlayCurve: Curves.fastOutSlowIn,
      this.pauseAutoPlayOnTouch,
      this.enlargeCenterPage = false,
      this.onPageChanged,
      this.scrollPhysics,
      this.scrollDirection: Axis.horizontal})
      : this.realPage =
            enableInfiniteScroll ? realPage + initialPage : initialPage,
        this.pageController = PageController(
          viewportFraction: viewportFraction,
          initialPage:
              enableInfiniteScroll ? realPage + initialPage : initialPage,
        );

  /// The widgets to be shown in the carousel.
  final List<Widget> items;

  /// Set carousel height and overrides any existing [aspectRatio].
  final double height;

  /// Aspect ratio is used if no height have been declared.
  ///
  /// Defaults to 16:9 aspect ratio.
  final double aspectRatio;

  /// The fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 0.8, which means each page fills 80% of the carousel.
  final num viewportFraction;

  /// The initial page to show when first creating the [CarouselSlider].
  ///
  /// Defaults to 0.
  final num initialPage;

  /// The actual index of the [PageView].
  ///
  /// This value can be ignored unless you know the carousel will be scrolled
  /// backwards more then 10000 pages.
  /// Defaults to 10000 to simulate infinite backwards scrolling.
  final num realPage;

  ///Determines if carousel should loop infinitely or be limited to item length.
  ///
  ///Defaults to true, i.e. infinite loop.
  final bool enableInfiniteScroll;

  /// Reverse the order of items if set to true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// Enables auto play, sliding one page at a time.
  ///
  /// Use [autoPlayInterval] to determent the frequency of slides.
  /// Defaults to false.
  final bool autoPlay;

  /// Sets Duration to determent the frequency of slides when
  ///
  /// [autoPlay] is set to true.
  /// Defaults to 4 seconds.
  final Duration autoPlayInterval;

  /// The animation duration between two transitioning pages while in auto playback.
  ///
  /// Defaults to 800 ms.
  final Duration autoPlayAnimationDuration;

  /// Determines the animation curve physics.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve autoPlayCurve;

  /// Sets a timer on touch detected that pause the auto play with
  /// the given [Duration].
  ///
  /// Touch Detection is only active if [autoPlay] is true.
  final Duration pauseAutoPlayOnTouch;

  /// Determines if current page should be larger then the side images,
  /// creating a feeling of depth in the carousel.
  ///
  /// Defaults to false.
  final bool enlargeCenterPage;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Called whenever the page in the center of the viewport changes.
  final Function(int index) onPageChanged;

  /// How the carousel should respond to user input.
  ///
  /// For example, determines how the items continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics scrollPhysics;

  /// [pageController] is created using the properties passed to the constructor
  /// and can be used to control the [PageView] it is passed to.
  final PageController pageController;

  /// Animates the controlled [CarouselSlider] to the next page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> nextPage({Duration duration, Curve curve}) {
    return pageController.nextPage(duration: duration, curve: curve);
  }

  /// Animates the controlled [CarouselSlider] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> previousPage({Duration duration, Curve curve}) {
    return pageController.previousPage(duration: duration, curve: curve);
  }

  /// Changes which page is displayed in the controlled [CarouselSlider].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToPage(int page) {
    final index =
        _getRealIndex(pageController.page.toInt(), realPage, items.length);
    return pageController
        .jumpToPage(pageController.page.toInt() + page - index);
  }

  /// Animates the controlled [CarouselSlider] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> animateToPage(int page, {Duration duration, Curve curve}) {
    final index =
        _getRealIndex(pageController.page.toInt(), realPage, items.length);
    return pageController.animateToPage(
        pageController.page.toInt() + page - index,
        duration: duration,
        curve: curve);
  }

  @override
  _CarouselSliderState createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider>
    with TickerProviderStateMixin {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = getTimer();
  }

  Timer getTimer() {
    return Timer.periodic(widget.autoPlayInterval, (_) {
      if (widget.autoPlay) {
        widget.pageController.nextPage(
            duration: widget.autoPlayAnimationDuration,
            curve: widget.autoPlayCurve);
      }
    });
  }

  void pauseOnTouch() {
    timer.cancel();
    timer = Timer(widget.pauseAutoPlayOnTouch, () {
      timer = getTimer();
    });
  }

  Widget getWrapper(Widget child) {
    if (widget.height != null) {
      final Widget wrapper = Container(height: widget.height, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    } else {
      final Widget wrapper =
          AspectRatio(aspectRatio: widget.aspectRatio, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    }
  }

  Widget addGestureDetection(Widget child) =>
      GestureDetector(onPanDown: (_) => pauseOnTouch(), child: child);

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return getWrapper(PageView.builder(
      physics: widget.scrollPhysics,
      scrollDirection: widget.scrollDirection,
      controller: widget.pageController,
      reverse: widget.reverse,
      itemCount: widget.enableInfiniteScroll ? null : widget.items.length,
      onPageChanged: (int index) {
        int currentPage = _getRealIndex(
            index + widget.initialPage, widget.realPage, widget.items.length);
        if (widget.onPageChanged != null) {
          widget.onPageChanged(currentPage);
        }
      },
      itemBuilder: (BuildContext context, int i) {
        final int index = _getRealIndex(
            i + widget.initialPage, widget.realPage, widget.items.length);

        return AnimatedBuilder(
          animation: widget.pageController,
          child: widget.items[index],
          builder: (BuildContext context, child) {
            // on the first render, the pageController.page is null,
            // this is a dirty hack
            if (widget.pageController.position.minScrollExtent == null ||
                widget.pageController.position.maxScrollExtent == null) {
              Future.delayed(Duration(microseconds: 1), () {
                setState(() {});
              });
              return Container();
            }
            double value = widget.pageController.page - i;
            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);

            final double height = widget.height ??
                MediaQuery.of(context).size.width * (1 / widget.aspectRatio);
            final double distortionValue = widget.enlargeCenterPage
                ? Curves.easeOut.transform(value)
                : 1.0;

            if (widget.scrollDirection == Axis.horizontal) {
              return Center(
                  child:
                      SizedBox(height: distortionValue * height, child: child));
            } else {
              return Center(
                  child: SizedBox(
                      width:
                          distortionValue * MediaQuery.of(context).size.width,
                      child: child));
            }
          },
        );
      },
    ));
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
  final _ClientMainProfileState parent;
  final ClientUser clientUser;
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
        permissionGranted = 'true';
        if (permissionGranted == 'true') {
          GeoFirePoint myLocation = geo.point(
              latitude: onValue.latitude, longitude: onValue.longitude);
          await Firestore.instance
              .collection('clientUsers')
              .document(prefs.getString('id'))
              .updateData({'location': myLocation.data});
        }
        setState(() {
          x = onValue.latitude;
          y = onValue.longitude;

          permissionGranted = 'true';
        });
      });
    } catch (e) {
      if (e == 'PERMISSION_DENIED') {
        setState(() {
          permissionGranted = 'false';
        });
      }
      if (e == 'PERMISSION_DENIED_NEVER_ASK') {
        setState(() {
          permissionGranted = 'never ask';
        });
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
      setState(() async {
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
      });
    }
  }

  bool toggleValue;

  bool restart = false;
  bool loading = false;
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
        resizeToAvoidBottomInset: false,
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
                  if(mounted){
                    setState(() {
                    loading = true;
                  });
                  }
                  var db = Firestore.instance;
                  var batch = db.batch();

                  if (tempImage != null) {
                    final StorageReference firebaseStorageRef = FirebaseStorage
                        .instance
                        .ref()
                        .child('${widget.clientUser.id}');
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
                  if(mounted){
                    setState(() {
                    loading = false;
                  });
                  }
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
          builder: (context) => IgnorePointer(ignoring: loading,
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
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
                                                widget
                                                    .parent.clientUser.colorRed,
                                                widget.parent.clientUser
                                                    .colorGreen,
                                                widget.parent.clientUser
                                                    .colorBlue),
                                            shape: BoxShape.circle,
                                          ),
                                          height:
                                              (120 * prefs.getDouble('height')),
                                          width:
                                              (120 * prefs.getDouble('height')),
                                          child: Center(
                                            child: Text(
                                                widget.parent.clientUser
                                                    .firstName[0],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 50 *
                                                        prefs.getDouble(
                                                            'height'),
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
                                            width:
                                                28 * prefs.getDouble('height'),
                                            height:
                                                28 * prefs.getDouble('height'),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: prefix0.mainColor,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15.0 *
                                                  prefs.getDouble('height'),
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
                                          width:
                                              120 * prefs.getDouble('height'),
                                          height:
                                              120 * prefs.getDouble('height'),
                                          child: Image.network(
                                            widget.parent.clientUser.photoUrl,
                                            fit: BoxFit.cover,
                                            scale: 1.0,
                                            loadingBuilder: (BuildContext ctx,
                                                Widget child,
                                                ImageChunkEvent
                                                    loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                            width:
                                                28 * prefs.getDouble('height'),
                                            height:
                                                28 * prefs.getDouble('height'),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: prefix0.mainColor,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15.0 *
                                                  prefs.getDouble('height'),
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
                                          size:
                                              15.0 * prefs.getDouble('height'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32 * prefs.getDouble('height')),
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
                                builder: (BuildContext context) =>
                                    EditExpectations(
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
                                (widget.parent.clientUser.expectations ==
                                            null ||
                                        widget.parent.clientUser.expectations ==
                                            "")
                                    ? "Tap to edit your description"
                                    : widget.parent.clientUser.expectations,
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
                                              borderRadius:
                                                  BorderRadius.circular(4.0 *
                                                      prefs.getDouble(
                                                          'height'))),
                                          height:
                                              32 * prefs.getDouble('height'),
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
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.check_box_outline_blank,
                                                size: 16 *
                                                    prefs.getDouble('height'),
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: prefix0.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(4.0 *
                                                      prefs.getDouble(
                                                          'height'))),
                                          height:
                                              32 * prefs.getDouble('height'),
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
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                              Icon(
                                                Icons.cancel,
                                                size: 16 *
                                                    prefs.getDouble('height'),
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
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: prefix0.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
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
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: prefix0.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
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
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: prefix0.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
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
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: prefix0.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
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
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: prefix0.mainColor,
                                            borderRadius: BorderRadius.circular(
                                                4.0 *
                                                    prefs.getDouble('height'))),
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
                                              size: 16 *
                                                  prefs.getDouble('height'),
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
                                        fontSize:
                                            12 * prefs.getDouble('height'),
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
                                        fontSize:
                                            12 * prefs.getDouble('height'),
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
                                                        prefs.getDouble(
                                                            'height'),
                                                    fontWeight:
                                                        FontWeight.w700),
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
                            sendPasswordResetEmail(widget.clientUser.nickname);
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
                        InkWell(
                          onTap: (){
                             Navigator.push(
                                          context,
                                          DeleteAccountPopup(role: 'client', id: widget.clientUser.id, auth: widget.auth),
                                        );
                          },
                                                  child: Text(
                            "Delete account",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.0 * prefs.getDouble('height'),
                                letterSpacing: -0.08,
                                color: Color(0xffFF453A),
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ),SizedBox(
                                  height: 18.0 * prefs.getDouble('height')),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HelpAndInfo(),
                                    ),
                                  );
                                },
                                child: Text("Help & Info",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize:
                                            14.0 * prefs.getDouble('height'),
                                        letterSpacing: -0.08,
                                        color:
                                            Color.fromARGB(220, 255, 255, 255),
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.start),
                              ),
                              Container(height: 80 * prefs.getDouble('height'))
                      ],
                    ),
                  )
                ],
              ),
              loading == true
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    )
                  : Container()
            ],
          ),
          ],),
          ),)
        ),);
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
        resizeToAvoidBottomInset: false,
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
      body: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
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
                child: TextField(autofocus: false,
                focusNode: FocusNode(),
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
                   widget. client.photoUrl,
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
