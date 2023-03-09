import 'dart:math';

import 'package:Bsharkr/Client/Client_Profile/Profile/time.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Nearby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/ManagingMeals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Chat/chatscreen.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'dart:async';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientProfileFinalSetState extends StatefulWidget {
  ClientProfileFinalSetState(this.clientId, this.trainerId, this.bookedClient,
      this.imTrainer, this.parent)
      : super();
  ClientUser bookedClient;
  TrainerUser imTrainer;
  final NearbyState parent;
  final String clientId;
  final String trainerId;

  @override
  _ClientProfileFinalSetStateState createState() =>
      _ClientProfileFinalSetStateState();
}

class _ClientProfileFinalSetStateState extends State<ClientProfileFinalSetState>
    with SingleTickerProviderStateMixin {
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;
  bool flagBusinessAccepted = false;
  bool flagFriendshipAccepted = false;
  bool flagFriendshipPending = false;
  bool flagBusinessPending = false;
  bool restart = false;
  int specializationCounter = 0;
  bool seenFlag;

  List<String> preferencesList = [];

   translate(String element) {
    if (element == 'dynamic') return 'Dynamic';
    if (element == 'nutritionist') return 'Nutritionist';
    if (element == 'disciplined') return 'Disciplined';
    if (element == 'motivating') return 'Motivating';
    if (element == 'sociable') return 'Sociable';
    if (element == 'goodListener') return 'Good listener';
    if (element == 'anatomyKnowledge') return 'Anatomy knowledge';
  }

  bool scheduleChanged = false;
  @override
  void initState() {
    super.initState();
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
    getDataClient();
  }

  ClientUser initialClient;
  void getDataClient() async {
    QuerySnapshot q;
    q = await Firestore.instance
        .collection('clientUsers')
        .where('id', isEqualTo: widget.bookedClient.id)
        .getDocuments();
    if (q != null) {
      initialClient = ClientUser(q.documents[0]);
      widget.bookedClient = ClientUser(q.documents[0]);
    }
  }

  bool availabilityFlag = false;

  bool preferences(String preference) {
    bool result = false;
    widget.bookedClient.preferencesList.forEach((clientPreference) {
      if (clientPreference.preference == preference)
        result = clientPreference.wanted;
    });
    return result;
  }

   showSetHour2(int index) {
    if (index == 1) {
      if (widget.bookedClient.availability.mondayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day1 == 'true') {
          return (widget.bookedClient.hour2Availability.day1.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day1
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day1
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day1
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return " hour";
        }
      }
    }

    if (index == 2) {
      if (widget.bookedClient.availability.mondayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day2 == 'true') {
          return (widget.bookedClient.hour2Availability.day2.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day2
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day2
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day2
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 3) {
      if (widget.bookedClient.availability.mondayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day3 == 'true') {
          return (widget.bookedClient.hour2Availability.day3.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day3
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day3
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day3
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 4) {
      if (widget.bookedClient.availability.tuesdayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day4 == 'true') {
          return (widget.bookedClient.hour2Availability.day4.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day4
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day4
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day4
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 5) {
      if (widget.bookedClient.availability.tuesdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day5 == 'true') {
          return (widget.bookedClient.hour2Availability.day5.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day5
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day5
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day5
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 6) {
      if (widget.bookedClient.availability.tuesdayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day6 == 'true') {
          return (widget.bookedClient.hour2Availability.day6.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day6
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day6
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day6
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 7) {
      if (widget.bookedClient.availability.wednesdayMorning.toString() ==
          "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day7 == 'true') {
          return (widget.bookedClient.hour2Availability.day7.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day7
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day7
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day7
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 8) {
      if (widget.bookedClient.availability.wednesdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day8 == 'true') {
          return (widget.bookedClient.hour2Availability.day8.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day8
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day8
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day8
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day8
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 9) {
      if (widget.bookedClient.availability.wednesdayEvening.toString() ==
          "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day9 == 'true') {
          return (widget.bookedClient.hour2Availability.day9.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day9
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour2Availability.day9
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day9
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day9
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 10) {
      if (widget.bookedClient.availability.thursdayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day10 == 'true') {
          return (widget.bookedClient.hour2Availability.day10.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day10
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day10
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day10
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day10
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 11) {
      if (widget.bookedClient.availability.thursdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day11 == 'true') {
          return (widget.bookedClient.hour2Availability.day11.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day11
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day11
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day11
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day11
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 12) {
      if (widget.bookedClient.availability.thursdayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day12 == 'true') {
          return (widget.bookedClient.hour2Availability.day12.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day12
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day12
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day12
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day12
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 13) {
      if (widget.bookedClient.availability.fridayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day13 == 'true') {
          return (widget.bookedClient.hour2Availability.day13.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day13
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day13
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day13
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day13
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 14) {
      if (widget.bookedClient.availability.fridayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day14 == 'true') {
          return (widget.bookedClient.hour2Availability.day14.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day14
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day14
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day14
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day14
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 15) {
      if (widget.bookedClient.availability.fridayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day15 == 'true') {
          return (widget.bookedClient.hour2Availability.day15.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day15
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day15
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day15
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day15
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 16) {
      if (widget.bookedClient.availability.saturdayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day16 == 'true') {
          return (widget.bookedClient.hour2Availability.day16.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day16
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day16
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day16
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day16
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 17) {
      if (widget.bookedClient.availability.saturdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day17 == 'true') {
          return (widget.bookedClient.hour2Availability.day17.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day17
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day17
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day17
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day17
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 18) {
      if (widget.bookedClient.availability.saturdayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day18 == 'true') {
          return (widget.bookedClient.hour2Availability.day18.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day18
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day18
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day18
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day18
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 19) {
      if (widget.bookedClient.availability.sundayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day19 == 'true') {
          return (widget.bookedClient.hour2Availability.day19.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day19
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day19
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day19
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day19
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 20) {
      if (widget.bookedClient.availability.sundayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day20 == 'true') {
          return (widget.bookedClient.hour2Availability.day20.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day20
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day20
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day20
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day20
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 21) {
      if (widget.bookedClient.availability.sundayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailabilityV2.day21 == 'true') {
          return (widget.bookedClient.hour2Availability.day21.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour2Availability.day21
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour2Availability.day21
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour2Availability.day21
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour2Availability.day21
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }
  }

   showSetHour1(int index) {
    if (index == 1) {
      if (widget.bookedClient.availability.mondayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day1 == 'true') {
          return (widget.bookedClient.hour1Availability.day1.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day1
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day1
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day1
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour ";
        }
      }
    }

    if (index == 2) {
      if (widget.bookedClient.availability.mondayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day2 == 'true') {
          return (widget.bookedClient.hour1Availability.day2.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day2
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day2
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day2
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 3) {
      if (widget.bookedClient.availability.mondayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day3 == 'true') {
          return (widget.bookedClient.hour1Availability.day3.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day3
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day3
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day3
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 4) {
      if (widget.bookedClient.availability.tuesdayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day4 == 'true') {
          return (widget.bookedClient.hour1Availability.day4.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day4
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day4
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day4
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 5) {
      if (widget.bookedClient.availability.tuesdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day5 == 'true') {
          return (widget.bookedClient.hour1Availability.day5.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day5
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day5
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day5
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 6) {
      if (widget.bookedClient.availability.tuesdayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day6 == 'true') {
          return (widget.bookedClient.hour1Availability.day6.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day6
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day6
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day6
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 7) {
      if (widget.bookedClient.availability.wednesdayMorning.toString() ==
          "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day7 == 'true') {
          return (widget.bookedClient.hour1Availability.day7.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day7
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day7
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day7
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 8) {
      if (widget.bookedClient.availability.wednesdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day8 == 'true') {
          return (widget.bookedClient.hour1Availability.day8.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day8
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day8
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day8
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day8
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 9) {
      if (widget.bookedClient.availability.wednesdayEvening.toString() ==
          "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day9 == 'true') {
          return (widget.bookedClient.hour1Availability.day9.toDate().hour < 10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day9
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget.bookedClient.hour1Availability.day9
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day9
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day9
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 10) {
      if (widget.bookedClient.availability.thursdayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day10 == 'true') {
          return (widget.bookedClient.hour1Availability.day10.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day10
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day10
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day10
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day10
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 11) {
      if (widget.bookedClient.availability.thursdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day11 == 'true') {
          return (widget.bookedClient.hour1Availability.day11.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day11
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day11
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day11
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day11
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 12) {
      if (widget.bookedClient.availability.thursdayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day12 == 'true') {
          return (widget.bookedClient.hour1Availability.day12.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day12
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day12
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day12
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day12
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 13) {
      if (widget.bookedClient.availability.fridayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day13 == 'true') {
          return (widget.bookedClient.hour1Availability.day13.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day13
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day13
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day13
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day13
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 14) {
      if (widget.bookedClient.availability.fridayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day14 == 'true') {
          return (widget.bookedClient.hour1Availability.day14.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day14
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day14
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day14
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day14
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 15) {
      if (widget.bookedClient.availability.fridayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day15 == 'true') {
          return (widget.bookedClient.hour1Availability.day15.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day15
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day15
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day15
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day15
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 16) {
      if (widget.bookedClient.availability.saturdayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day16 == 'true') {
          return (widget.bookedClient.hour1Availability.day16.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day16
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day16
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day16
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day16
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 17) {
      if (widget.bookedClient.availability.saturdayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day17 == 'true') {
          return (widget.bookedClient.hour1Availability.day17.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day17
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day17
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day17
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day17
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 18) {
      if (widget.bookedClient.availability.saturdayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day18 == 'true') {
          return (widget.bookedClient.hour1Availability.day18.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day18
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day18
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day18
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day18
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 19) {
      if (widget.bookedClient.availability.sundayMorning.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day19 == 'true') {
          return (widget.bookedClient.hour1Availability.day19.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day19
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day19
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day19
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day19
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 20) {
      if (widget.bookedClient.availability.sundayMidday.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day20 == 'true') {
          return (widget.bookedClient.hour1Availability.day20.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day20
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day20
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day20
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day20
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 21) {
      if (widget.bookedClient.availability.sundayEvening.toString() == "Busy")
        return "";
      else {
        if (widget.bookedClient.checkDailyAvailability.day21 == 'true') {
          return (widget.bookedClient.hour1Availability.day21.toDate().hour <
                      10
                  ? "0"
                  : "") +
              widget.bookedClient.hour1Availability.day21
                  .toDate()
                  .hour
                  .toString() +
              " : " +
              (widget
                          .bookedClient.hour1Availability.day21
                          .toDate()
                          .minute
                          .toInt() <
                      10
                  ? ("0" +
                      widget.bookedClient.hour1Availability.day21
                          .toDate()
                          .minute
                          .toString())
                  : widget.bookedClient.hour1Availability.day21
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    specializationCounter = 0;
    widget.bookedClient.preferencesList.forEach((preference) {
      if (preference.wanted == true) {
        preferencesList.add(preference.preference);
        specializationCounter++;
      }
    });
    flagBusinessAccepted = false;
    flagFriendshipAccepted = false;

    flagFriendshipPending = false;
    flagBusinessPending = false;
    widget.imTrainer.clients.forEach((client) {
      if (client.clientId == widget.bookedClient.id &&
          client.clientAccepted == true) {
        flagBusinessAccepted = true;
      }
    });
    widget.imTrainer.friends.forEach((friend) {
      if (friend.friendId == widget.bookedClient.id &&
          friend.friendAccepted == true) flagFriendshipAccepted = true;
    });
    widget.imTrainer.friends.forEach((friend) {
      if (friend.friendId == widget.bookedClient.id &&
          friend.friendAccepted == false) flagFriendshipPending = true;
    });
    widget.imTrainer.clients.forEach((friend) {
      if (friend.clientId == widget.bookedClient.id &&
          friend.clientAccepted == false) flagBusinessPending = true;
    });

    bool flagF = false;
    bool flagT = false;
    bool flagN = false;
    bool flagNearby = false;

    widget.imTrainer.friends.forEach((element1) {
      if (widget.bookedClient.id == element1.friendId) {
        flagF = true;
      }
    });
    widget.imTrainer.clients.forEach((element2) {
      if (widget.bookedClient.id == element2.clientId) {
        flagT = true;
      }
    });
    widget.imTrainer.nearbyList.forEach((element3) {
      if (widget.bookedClient.id == element3.id) {
        flagN = true;
      }
    });

    if (flagN == false &&
        flagT == false &&
        flagF == false &&
        widget.imTrainer.nearbyFlag == false) {
      flagNearby = true;
    }

    List week = [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Monday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('width'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(1),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .mondayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(1),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(2),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .mondayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(2),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(3),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .mondayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(3),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .mondayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.mondayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color:
                                widget.bookedClient.availability.mondayMidday ==
                                        'Available'
                                    ? prefix0.mainColor
                                    : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.mondayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .mondayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.mondayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Tuesday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('height'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(4),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .tuesdayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(4),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(5),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .tuesdayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(5),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(6),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .tuesdayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(6),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .tuesdayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.tuesdayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .tuesdayMidday ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.tuesdayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .tuesdayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.tuesdayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Wednesday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('height'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(7),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .wednesdayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(7),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(8),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .wednesdayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(8),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(9),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .wednesdayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(9),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .wednesdayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.wednesdayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .wednesdayMidday ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.wednesdayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .wednesdayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.wednesdayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Thursday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('width'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(10),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .thursdayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(10),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(11),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .thursdayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(11),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(12),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .thursdayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(12),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .thursdayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.thursdayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .thursdayMidday ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.thursdayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .thursdayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.thursdayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Friday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('width'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(13),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .fridayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(13),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(14),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .fridayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(14),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(15),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .fridayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(15),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .fridayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.fridayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('width'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color:
                                widget.bookedClient.availability.fridayMidday ==
                                        'Available'
                                    ? prefix0.mainColor
                                    : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.fridayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .fridayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.fridayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Saturday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('width'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(16),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .saturdayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(16),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(17),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .saturdayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(17),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(18),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .saturdayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(18),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .saturdayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.saturdayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .saturdayMidday ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.saturdayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .saturdayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.saturdayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5 * prefs.getDouble('height')),
                child: Text(
                  "Sunday",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * prefs.getDouble('height'),
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Morning",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Midday",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Evening",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontSize: 14 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15 * prefs.getDouble('width'),
                  ),
                  Container(
                    width: 100 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(19),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .sundayMorning ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(19),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(20),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .sundayMidday ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(20),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 22.0 * prefs.getDouble('height'),
                        ),
                        Container(
                            height: 15 * prefs.getDouble('height'),
                            width: 98 * prefs.getDouble('width'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour1(21),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 12 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      widget.bookedClient.availability
                                                  .sundayEvening ==
                                              'Available'
                                          ? " - "
                                          : "",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15 * prefs.getDouble('height'),
                                  width: 43 * prefs.getDouble('width'),
                                  child: Center(
                                    child: Text(
                                      showSetHour2(21),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontSize:
                                              13 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 7.0 * prefs.getDouble('height'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .sundayMorning ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.sundayMorning ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color:
                                widget.bookedClient.availability.sundayMidday ==
                                        'Available'
                                    ? prefix0.mainColor
                                    : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.sundayMidday ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 15.5 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height'),
                            8 * prefs.getDouble('width'),
                            3 * prefs.getDouble('height')),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1 * prefs.getDouble('height')),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            color: widget.bookedClient.availability
                                        .sundayEvening ==
                                    'Available'
                                ? prefix0.mainColor
                                : Color(0xff57575E)),
                        child: Text(
                          widget.bookedClient.availability.sundayEvening ==
                                  'Available'
                              ? "Available"
                              : "Busy",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 12 * prefs.getDouble('height'),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 2.0 * prefs.getDouble('height'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ];
    int votFinal = 0;
    widget.bookedClient.votesMap.forEach((element) {
      votFinal = votFinal + element.vote;
    });

    if (votFinal != 0) {
      votFinal = (votFinal / widget.bookedClient.votesMap.length).round();
    }
    seenFlag = false;
    widget.imTrainer.unseenMessagesCounter.forEach((user) {
      if (user.userId == widget.bookedClient.id) {
        seenFlag = true;
      }
    });
    return Scaffold(
      backgroundColor: prefix0.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24 * prefs.getDouble('height'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            widget.bookedClient.lastName == null
                ? "nume"
                : widget.bookedClient.firstName +
                    " " +
                    widget.bookedClient.lastName,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22 * prefs.getDouble('height')),
          ),
          backgroundColor: prefix0.backgroundColor,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20 * prefs.getDouble('height'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 32 * prefs.getDouble('width')),
                child: InkWell(
                  onTap: () {
                    if (widget.bookedClient.photoUrl != null) {
                      Navigator.push(
                          context,
                          ProfilePhotoPopUp(
                            client: widget.bookedClient,
                          ));
                    }
                  },
                  child: widget.bookedClient.photoUrl == null
                      ? ClipOval(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255,
                                    widget.bookedClient.colorRed,
                                    widget.bookedClient.colorGreen,
                                    widget.bookedClient.colorBlue),
                                shape: BoxShape.circle,
                              ),
                              height: (80 * prefs.getDouble('height')),
                              width: (80 * prefs.getDouble('height')),
                              child: Center(
                                child: Text(
                                  widget.bookedClient.firstName[0],
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: 50 * prefs.getDouble('height')),
                                ),
                              )),
                        )
                      : Material(
                          child: Container(
                            width: 80 * prefs.getDouble('height'),
                            height: 80 * prefs.getDouble('height'),
                            decoration: BoxDecoration(
                                color: backgroundColor, shape: BoxShape.circle),
                            child: Image.network(
                              widget.bookedClient.photoUrl,
                              fit: BoxFit.cover,
                              scale: 1.0,
                              loadingBuilder: (BuildContext ctx, Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          prefix0.mainColor),
                                      backgroundColor: prefix0.backgroundColor,
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
                padding: EdgeInsets.only(right: 32 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Gender: " + widget.bookedClient.gender,
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
                      "Age: " + widget.bookedClient.age.toString() + " years",
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
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              DetailsPopUp(
                                client: widget.bookedClient,
                              ));
                        },
                        child: Rating(
                          initialRating: votFinal,
                        ))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15 * prefs.getDouble('height'),
          ),
          Container(
            height: 85 * prefs.getDouble('height'),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 32 * prefs.getDouble('width')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  flagNearby == true
                      ? Container(
                          width: 310 * prefs.getDouble('width'),
                          height: 32 * prefs.getDouble('height'),
                          child: Material(
                            borderRadius: BorderRadius.circular(4),
                            color: prefix0.mainColor,
                            child: MaterialButton(
                                onPressed: () async {
                                  var db = Firestore.instance;
                                  var batch = db.batch();

                                  batch.updateData(
                                    db
                                        .collection('clientUsers')
                                        .document(widget.bookedClient.id),
                                    {
                                      'nearby.${prefs.getString('id')}': true,
                                      'trainerRequestedClient': true
                                    },
                                  );

                                  batch.updateData(
                                    db
                                        .collection('clientUsers')
                                        .document(prefs.getString('id')),
                                    {
                                      'nearby.${widget.bookedClient.id}': true,
                                      'nearbyDate.${widget.bookedClient.id}':
                                          DateTime.now(),
                                      'nearbyFlag': true,
                                    },
                                  );
                                  batch.updateData(
                                    db
                                        .collection('clientUsers')
                                        .document(widget.bookedClient.id),
                                    {
                                      'idFrom': prefs.getString('id'),
                                      'idTo': widget.bookedClient.id,
                                      'pushToken':
                                          widget.bookedClient.pushToken,
                                    },
                                  );
                                  if (widget.parent != null) {
                                    widget.parent.setState(() {
                                      widget.parent.actualList.removeWhere(
                                          (element) =>
                                              ClientUser(element).id ==
                                              widget.bookedClient.id);
                                    });
                                  }
                                  batch.commit();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.people,
                                      color: Colors.white,
                                      size: 14 * prefs.getDouble('height'),
                                    ),
                                    SizedBox(
                                      width: 10.0 * prefs.getDouble('width'),
                                    ),
                                    Text(
                                      "Send friend request",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              11 * prefs.getDouble('height')),
                                    ),
                                  ],
                                )),
                          ),
                        )
                      : flagFriendshipPending == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 150 * prefs.getDouble('width'),
                                  height: 32 * prefs.getDouble('height'),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4),
                                    color: prefix0.secondaryColor,
                                    child: MaterialButton(
                                        onPressed: () {
                                          widget.imTrainer.friends
                                              .forEach((element) {
                                            if (element.friendId ==
                                                    widget.bookedClient.id &&
                                                element.friendAccepted ==
                                                    false) {
                                              Navigator.push(
                                                  context,
                                                  DeletePermissionPopup(
                                                    clientUser:
                                                        widget.bookedClient,
                                                  ));
                                            }
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
                                              Icons.cancel,
                                              color: Colors.white,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                            ),
                                            SizedBox(
                                              width: 10.0 *
                                                  prefs.getDouble('width'),
                                            ),
                                            Text(
                                              "Ignore friendship",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12 *
                                                      prefs
                                                          .getDouble('height')),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                SizedBox(width: 5 * prefs.getDouble('width')),
                                Container(
                                  width: 150 * prefs.getDouble('width'),
                                  height: 32 * prefs.getDouble('height'),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4),
                                    color: prefix0.mainColor,
                                    child: MaterialButton(
                                        onPressed: () async {
                                          var db = Firestore.instance;
                                          var batch = db.batch();

                                          batch.updateData(
                                            db
                                                .collection('clientUsers')
                                                .document(
                                                    prefs.getString('id')),
                                            {
                                              'friendsMap.${widget.bookedClient.id}':
                                                  true,
                                              'newFriend': true
                                            },
                                          );
                                          batch.updateData(
                                            db
                                                .collection('clientUsers')
                                                .document(
                                                    widget.bookedClient.id),
                                            {
                                              'friendsMap.${prefs.getString('id')}':
                                                  true,
                                              'newFriend': true
                                            },
                                          );

                                          batch.setData(
                                            db
                                                .collection(
                                                    'clientAcceptedFriendship')
                                                .document(
                                                    widget.bookedClient.id),
                                            {
                                              'idFrom': prefs.getString('id'),
                                              'idTo': widget.bookedClient.id,
                                              'pushToken':
                                                  widget.bookedClient.pushToken,
                                              'nickname':
                                                  widget.imTrainer.firstName
                                            },
                                          );
                                          batch.commit();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.account_box,
                                              color: Colors.white,
                                              size: 16 *
                                                  prefs.getDouble('height'),
                                            ),
                                            SizedBox(
                                              width: 10.0 *
                                                  prefs.getDouble('width'),
                                            ),
                                            Text(
                                              "Accept friendship",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12 *
                                                      prefs
                                                          .getDouble('height')),
                                            ),
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            )
                          : (flagFriendshipAccepted == true &&
                                  flagBusinessAccepted == false &&
                                  flagBusinessPending == false)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 150 * prefs.getDouble('width'),
                                      height: 32 * prefs.getDouble('height'),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(4),
                                        color: prefix0.secondaryColor,
                                        child: MaterialButton(
                                            onPressed: () {
                                              widget.imTrainer.friends
                                                  .forEach((element) {
                                                if (element.friendId ==
                                                        widget
                                                            .bookedClient.id &&
                                                    element.friendAccepted ==
                                                        true) {
                                                  Navigator.push(
                                                      context,
                                                      DeletePermissionPopup(
                                                        clientUser:
                                                            widget.bookedClient,
                                                      ));
                                                }
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
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                  size: 16 *
                                                      prefs.getDouble('height'),
                                                ),
                                                SizedBox(
                                                  width: 10.0 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Text(
                                                  "Ignore friendship",
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
                                    SizedBox(
                                        width: 10 * prefs.getDouble('width')),
                                    Container(
                                      width: 150 * prefs.getDouble('width'),
                                      height: 32 * prefs.getDouble('height'),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(4),
                                        color: seenFlag == false
                                            ? prefix0.secondaryColor
                                            : mainColor,
                                        child: MaterialButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Chat(
                                                    peerId:
                                                        widget.bookedClient.id,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.message,
                                                  color: Colors.white,
                                                  size: 16 *
                                                      prefs.getDouble('height'),
                                                ),
                                                SizedBox(
                                                  width: 10.0 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Text(
                                                  "Chat",
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
                                    )
                                  ],
                                )
                              : flagBusinessPending == true
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 150 *
                                                  prefs.getDouble('width'),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: prefix0.secondaryColor,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      widget.imTrainer.friends
                                                          .forEach((element) {
                                                        if (element.friendId ==
                                                                widget
                                                                    .bookedClient
                                                                    .id &&
                                                            element.friendAccepted ==
                                                                true) {
                                                          Navigator.push(
                                                              context,
                                                              DeletePermissionPopup(
                                                                clientUser: widget
                                                                    .bookedClient,
                                                              ));
                                                        }
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.cancel,
                                                          color: Colors.white,
                                                          size: 16 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                        ),
                                                        Text(
                                                          "Ignore friendship",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  10 * prefs.getDouble('width'),
                                            ),
                                            Container(
                                                child: Container(
                                              width: 150 *
                                                  prefs.getDouble('width'),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: seenFlag == false
                                                    ? prefix0.secondaryColor
                                                    : mainColor,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Chat(
                                                            peerId: widget
                                                                .bookedClient
                                                                .id,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.sms,
                                                          color: Colors.white,
                                                          size: 12 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                        ),
                                                        Text(
                                                          "Chat",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 11 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ))
                                          ],
                                        ),
                                        SizedBox(
                                            height: 5.0 *
                                                prefs.getDouble('height')),
                                        Container(
                                          width: 310 * prefs.getDouble('width'),
                                          height:
                                              32 * prefs.getDouble('height'),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: prefix0.mainColor,
                                            child: MaterialButton(
                                                onPressed: () async {
                                                  var db = Firestore.instance;
                                                  var batch = db.batch();

                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(prefs
                                                            .getString('id')),
                                                    {
                                                      'trainerMap.${widget.bookedClient.id}':
                                                          true,
                                                      'friendsMap.${widget.bookedClient.id}':
                                                          FieldValue.delete(),
                                                      'newClient': true,
                                                    },
                                                  );
                                                  batch.updateData(
                                                    db
                                                        .collection(
                                                            'clientUsers')
                                                        .document(widget
                                                            .bookedClient.id),
                                                    {
                                                      'trainersMap.${prefs.getString('id')}':
                                                          true,
                                                      'friendsMap.${prefs.getString('id')}':
                                                          FieldValue.delete(),
                                                      'newBusiness': true
                                                    },
                                                  );

                                                  batch.setData(
                                                    db
                                                        .collection(
                                                            'clientAcceptedCollaboration')
                                                        .document(widget
                                                            .bookedClient.id),
                                                    {
                                                      'idFrom':
                                                          prefs.getString('id'),
                                                      'idTo': widget
                                                          .bookedClient.id,
                                                      'pushToken': widget
                                                          .bookedClient
                                                          .pushToken
                                                    },
                                                  );

                                                  batch.commit();
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.assignment,
                                                      color: Colors.white,
                                                      size: 14 *
                                                          prefs.getDouble(
                                                              'height'),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0 *
                                                          prefs.getDouble(
                                                              'width'),
                                                    ),
                                                    Text(
                                                      "Accept collaboration",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: Colors.white,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11 *
                                                              prefs.getDouble(
                                                                  'height')),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  : flagBusinessAccepted == true
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    child: Container(
                                                  width: 96 *
                                                      prefs.getDouble('width'),
                                                  height: 32 *
                                                      prefs.getDouble('height'),
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color:
                                                        prefix0.secondaryColor,
                                                    child: MaterialButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MyPopupRouteMeals(
                                                              clientUser: widget
                                                                  .bookedClient,
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .local_dining,
                                                              color:
                                                                  Colors.white,
                                                              size: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                            ),
                                                            Text(
                                                              "Nutrition",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 11 *
                                                                      prefs.getDouble(
                                                                          'height')),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 10 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Container(
                                                    child: Container(
                                                  width: 96 *
                                                      prefs.getDouble('width'),
                                                  height: 32 *
                                                      prefs.getDouble('height'),
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color:
                                                        prefix0.secondaryColor,
                                                    child: MaterialButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              ManagingSchedule(
                                                                  clientUser: widget
                                                                      .bookedClient,
                                                                  imTrainer: widget
                                                                      .imTrainer,
                                                                  parent:
                                                                      this));
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.assignment,
                                                              color:
                                                                  Colors.white,
                                                              size: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                            ),
                                                            Text(
                                                              "Program",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 11 *
                                                                      prefs.getDouble(
                                                                          'height')),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                )),
                                                SizedBox(
                                                  width: 10 *
                                                      prefs.getDouble('width'),
                                                ),
                                                Container(
                                                    child: Container(
                                                  width: 96 *
                                                      prefs.getDouble('width'),
                                                  height: 32 *
                                                      prefs.getDouble('height'),
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: seenFlag == false
                                                        ? prefix0.secondaryColor
                                                        : mainColor,
                                                    child: MaterialButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            new MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Chat(
                                                                peerId: widget
                                                                    .bookedClient
                                                                    .id,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.sms,
                                                              color:
                                                                  Colors.white,
                                                              size: 12 *
                                                                  prefs.getDouble(
                                                                      'height'),
                                                            ),
                                                            SizedBox(
                                                              width: 10.0 *
                                                                  prefs.getDouble(
                                                                      'width'),
                                                            ),
                                                            Text(
                                                              "Chat",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 11 *
                                                                      prefs.getDouble(
                                                                          'height')),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ))
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  5 * prefs.getDouble('width'),
                                            ),
                                            Container(
                                              width: 310 *
                                                  prefs.getDouble('width'),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: prefix0.secondaryColor,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          DeletePermissionPopup1(
                                                            clientUser: widget
                                                                .bookedClient,
                                                          ));
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.cancel,
                                                          color: Colors.white,
                                                          size: 16 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        SizedBox(
                                                          width: 10.0 *
                                                              prefs.getDouble(
                                                                  'width'),
                                                        ),
                                                        Text(
                                                          "End the partnership",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.white,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(
                                          height:
                                              110 * prefs.getDouble('height'),
                                        )
                ],
              ),
            ),
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: 32 * prefs.getDouble('width')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        availabilityFlag = false;
                      });
                    },
                    child: Container(
                      height: 30 * prefs.getDouble('height'),
                      child: Text(
                        "Availability",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: availabilityFlag == true
                                ? Color.fromARGB(100, 255, 255, 255)
                                : prefix0.mainColor,
                            fontSize: 17 * prefs.getDouble('width')),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        availabilityFlag = true;
                      });
                    },
                    child: Container(
                      height: 30 * prefs.getDouble('height'),
                      child: Text(
                        "Preferences",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: availabilityFlag == false
                                ? Color.fromARGB(100, 255, 255, 255)
                                : prefix0.mainColor,
                            fontSize: 17 * prefs.getDouble('width')),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(
            height: 10 * prefs.getDouble('height'),
          ),
          Container(
              height: 200 * prefs.getDouble('height'),
              child: Center(
                child: availabilityFlag == false
                    ? CarouselSlider(
                        height: 200 * prefs.getDouble('height'),
                        initialPage: 0,
                        onPageChanged: (index) {
                          setState(() {});
                        },
                        items: week.map((a) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  margin: EdgeInsets.fromLTRB(
                                      10 * prefs.getDouble('width'),
                                      15 * prefs.getDouble('height'),
                                      10 * prefs.getDouble('width'),
                                      15 * prefs.getDouble('height')),
                                  child: a);
                            },
                          );
                        }).toList())
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
                                                    BorderRadius.circular(4.0 *
                                                        prefs.getDouble(
                                                            'height'))),
                                            height:
                                                32 * prefs.getDouble('height'),
                                            width:
                                                150 * prefs.getDouble('width'),
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
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white),
                                              ),
                                            )),
                                        SizedBox(
                                          width: 10 * prefs.getDouble('width'),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: prefix0.secondaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(4.0 *
                                                        prefs.getDouble(
                                                            'height'))),
                                            height:
                                                32 * prefs.getDouble('height'),
                                            width:
                                                150 * prefs.getDouble('width'),
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
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
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
                                            height:
                                                32 * prefs.getDouble('height'),
                                            width:
                                                310 * prefs.getDouble('width'),
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
                                                        prefs
                                                            .getDouble('width'),
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
                                                                FontWeight.w400,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10 *
                                                      prefs.getDouble('width'),
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
                                                        prefs
                                                            .getDouble('width'),
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
                                                                FontWeight.w400,
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
                                                prefs.getDouble('height'),
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
                                              width: 310 *
                                                  prefs.getDouble('width'),
                                              padding: EdgeInsets.all(
                                                8.0 * prefs.getDouble('height'),
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
                                                        padding: EdgeInsets.all(
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
                                                        prefs
                                                            .getDouble('width'),
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
                                                        prefs.getDouble(
                                                            'height'),
                                                  ),
                                                  Container(
                                                    height: 32 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    width: 310 *
                                                        prefs
                                                            .getDouble('width'),
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
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ))
                                                ],
                                              )
                                            : specializationCounter == 6
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
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
                                                                    "${translate(preferencesList[5])}",
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
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${translate(preferencesList[0])}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
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
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${translate(preferencesList[1])}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
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
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${translate(preferencesList[2])}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
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
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${translate(preferencesList[3])}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
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
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${translate(preferencesList[4])}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
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
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${translate(preferencesList[5])}",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
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
                                                            children: <Widget>[
                                                              Text(
                                                                  "No preferences set",
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
                                                                    horizontal: 36.0 *
                                                                        prefs.getDouble(
                                                                            'width')),
                                                                child: Text(
                                                                    "This person did not set up the preferences regarding the ideal trainer.",
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
                                                            ]),
                                                      ),
                      ),
              )),
          Container(
            height: 220.0 * prefs.getDouble('height'),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 25.0 * prefs.getDouble('height'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32 * prefs.getDouble('width')),
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
                SizedBox(
                  height: 10.0 * prefs.getDouble('height'),
                ),
                widget.bookedClient.expectations != ""
                    ? Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 32.0 * prefs.getDouble('width')),
                            child: Container(
                              child: Text(
                                widget.bookedClient.expectations == null
                                    ? "Introduce a brief description in order to help fitness trainers offer compatible services with your lifestyle. For a harmonious collaboration it is preferable that the expectations regarding your future trainer to be inserted."
                                    : widget.bookedClient.expectations,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15 * prefs.getDouble('height'),
                                    color: Color.fromARGB(200, 255, 255, 255)),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            left: 32 * prefs.getDouble('width'),
                            top: 16 * prefs.getDouble('height')),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/cardf1.svg',
                              width: 200.0 * prefs.getDouble('width'),
                              height: 100.0 * prefs.getDouble('height'),
                            ),
                            SizedBox(width: 16 * prefs.getDouble('width')),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 22 * prefs.getDouble('height'),
                                  child: Text("No expectations set",
                                      style: TextStyle(
                                          fontSize:
                                              17 * prefs.getDouble('height'),
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          letterSpacing: -0.408),
                                      textAlign: TextAlign.start,
                                      maxLines: 2),
                                ),
                                SizedBox(height: 8 * prefs.getDouble('height')),
                                Container(
                                  width: 120 * prefs.getDouble('width'),
                                  height: 70 * prefs.getDouble('height'),
                                  child: Text(
                                    "We highly recommend to try to get to know your client before starting to collaborate.",
                                    style: TextStyle(
                                        fontSize:
                                            12 * prefs.getDouble('height'),
                                        color:
                                            Color.fromARGB(200, 255, 255, 255),
                                        fontFamily: 'Roboto'),
                                    textAlign: TextAlign.start,
                                    maxLines: 5,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ],
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

class Rating extends StatefulWidget {
  final int initialRating;
  final void Function(int) onRated;
  final double size;
  final Color color = Color(0xffAC70F1);

  Rating({
    this.initialRating,
    this.onRated,
    this.size,
  });

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 3.0 * prefs.getDouble('width')),
          child: Icon(
            _rating >= 1 ? Icons.star : Icons.star_border,
            color: widget.color,
            size: 24 * prefs.getDouble('height'),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 3.0 * prefs.getDouble('width')),
          child: Icon(
            _rating >= 2 ? Icons.star : Icons.star_border,
            color: widget.color,
            size: 24 * prefs.getDouble('height'),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 3.0 * prefs.getDouble('width')),
          child: Icon(
            _rating >= 3 ? Icons.star : Icons.star_border,
            color: widget.color,
            size: 24 * prefs.getDouble('height'),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 3.0 * prefs.getDouble('width')),
          child: Icon(
            _rating >= 4 ? Icons.star : Icons.star_border,
            color: widget.color,
            size: 24 * prefs.getDouble('height'),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 3.0 * prefs.getDouble('width')),
          child: Icon(
            _rating >= 5 ? Icons.star : Icons.star_border,
            color: widget.color,
            size: 24 * prefs.getDouble('height'),
          ),
        ),
      ],
    );
  }
}

class DetailsPopUp extends PopupRoute<void> {
  DetailsPopUp({this.client});
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
      DetailsPage(
        client: client,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage extends StatefulWidget {
  final ClientUser client;
  DetailsPage({Key key, this.client});

  @override
  State createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  String hinttText = "Scrie";
  Image image;

  String hintName, hintStreet, hintSector;
  List<ReviewMapDelay> revs = [];

  Widget buildItem(
    List<Votes> reviews,
    int index,
    List<Reviews> revv,
  ) {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            index != (reviews.length - 1)
                ? Container(
                    width: double.infinity,
                    height: 1 * prefs.getDouble('height'),
                    color: Color.fromARGB(150, 255, 255, 255))
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                top: 8 * prefs.getDouble('height'),
                bottom: 8 * prefs.getDouble('height'),
                left: 16 * prefs.getDouble('width'),
                right: 16 * prefs.getDouble('width'),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 90 * prefs.getDouble('height'),
                    width: 310 * prefs.getDouble('width'),
                    child: Padding(
                      padding: EdgeInsets.all(
                        10 * prefs.getDouble('height'),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          revv[index].review != null ? revv[index].review.contains(")()()(") == true ? revv[index].review.replaceAll(")()()(", ".") : revv[index].review : "",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13 * prefs.getDouble('height'),
                              letterSpacing: -0.078,
                              color: Color.fromARGB(200, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Rating(
                        initialRating: reviews[index].vote,
                      )
                    ],
                  )
                ],
              ),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Dialog(
            backgroundColor: Colors.transparent,
            child: widget.client.reviewsMap.length == 0
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff3E3E45)),
                    width: 310 * prefs.getDouble('width'),
                    height: 250 * prefs.getDouble('height'),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/reviewf1.svg',
                            width: 180.0 * prefs.getDouble('width'),
                            height: 100.0 * prefs.getDouble('height'),
                          ),
                          SizedBox(height: 24 * prefs.getDouble('height')),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 56 * prefs.getDouble('height')),
                              child: Text(
                                "This person did not receive reviews yet.",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14 * prefs.getDouble('height'),
                                    color: Color.fromARGB(200, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff3E3E45)),
                    height: (144 *
                                (widget.client.reviewsMap.length < 5
                                    ? widget.client.reviewsMap.length
                                    : 5) +
                            50)
                        .toDouble(),
                    child: Container(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0 * prefs.getDouble('height')),
                        itemBuilder: (context, index) => buildItem(
                            widget.client.votesMap,
                            index,
                            widget.client.reviewsMap),
                        itemCount: widget.client.reviewsMap.length,
                        reverse: true,
                      ),
                    ),
                  )));
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

class DeletePermissionPopup extends PopupRoute<void> {
  DeletePermissionPopup({
    this.clientUser,
  });
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
      DeletePermission(
        clientUser: clientUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission extends StatefulWidget {
  final ClientUser clientUser;

  DeletePermission({
    Key key,
    @required this.clientUser,
  }) : super(key: key);

  @override
  State createState() => DeletePermissionState(clientUser: clientUser);
}

class DeletePermissionState extends State<DeletePermission> {
  final ClientUser clientUser;
  DeletePermissionState({Key key, @required this.clientUser});

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    horizontal: 16 * prefs.getDouble('width')),
                child: Text(
                  "Are you sure you want to delete your friendship with ${clientUser.firstName} ${clientUser.lastName}?",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(120, 255, 255, 255),
                    fontSize: 12 * prefs.getDouble('height'),
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
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () async {
                        var db = Firestore.instance;
                        var batch = db.batch();

                        batch.updateData(
                          db
                              .collection('clientUsers')
                              .document(prefs.getString('id')),
                          {
                            'trainerMap.${clientUser.id}': FieldValue.delete(),
                            'friendsMap.${clientUser.id}': FieldValue.delete()
                          },
                        );
                        batch.updateData(
                          db.collection('clientUsers').document(clientUser.id),
                          {
                            'trainersMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );

                        batch.commit();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Refuse',
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
        ));
  }
}

class DeletePermissionPopup1 extends PopupRoute<void> {
  DeletePermissionPopup1({this.clientUser});
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
      DeletePermission1(
        clientUser: clientUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission1 extends StatefulWidget {
  final ClientUser clientUser;

  DeletePermission1({Key key, @required this.clientUser}) : super(key: key);

  @override
  State createState() => DeletePermission1State(clientUser: clientUser);
}

class DeletePermission1State extends State<DeletePermission1> {
  final ClientUser clientUser;
  DeletePermission1State({Key key, @required this.clientUser});

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    horizontal: 16 * prefs.getDouble('width')),
                child: Text(
                  "Are you sure you want to stop your training partnership with ${clientUser.firstName} ${clientUser.lastName}? The friendship will be deleted as well.",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(120, 255, 255, 255),
                    fontSize: 12 * prefs.getDouble('height'),
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

                        batch.updateData(
                          db
                              .collection('clientUsers')
                              .document(prefs.getString('id')),
                          {
                            'trainerMap.${clientUser.id}': FieldValue.delete(),
                            'friendsMap.${clientUser.id}': FieldValue.delete()
                          },
                        );
                        batch.updateData(
                          db.collection('clientUsers').document(clientUser.id),
                          {
                            'trainersMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );

                        batch.commit();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Stop training',
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
        ));
  }
}

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

class ManagingSchedule extends PopupRoute<void> {
  ManagingSchedule({
    this.clientUser,
    this.imTrainer,
    this.parent,
  });
  _ClientProfileFinalSetStateState parent;
  TrainerUser imTrainer;
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
      ManagingS(client: clientUser, imTrainer: imTrainer, parent: parent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ManagingS extends StatefulWidget {
  final ClientUser client;
  TrainerUser imTrainer;
  _ClientProfileFinalSetStateState parent;
  ManagingS({Key key, @required this.client, this.imTrainer, this.parent})
      : super(key: key);

  @override
  State createState() => ManagingSState(
        client: client,
      );
}

class ManagingSState extends State<ManagingS> {
  List<bool> isSelected = [true, false];

  String hinttText = "Scrie";
  Image image;
  ClientUser client;
  var selected;
  String hintName, hintStreet, hintSector;
  TrainerUser imTrainer;
  ManagingSState({@required this.client, this.image});
  bool scheduleChanged = false;
  int currentPage = 0;
  bool modified = false;
  var db = Firestore.instance;
  var batch;
  bool saveChanges = false;

  @override
  void initState() {
    super.initState();
    batch = db.batch();
  }

  @override
  Widget build(BuildContext context) {
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
              client: widget.client,
              scheduleChanged: scheduleChanged,
              parent: this,
              imTrainer: widget.imTrainer,
              mainParent: widget.parent,
            ),
            SecondPage(
              client: widget.client,
              scheduleChanged: scheduleChanged,
              parent: this,
              imTrainer: widget.imTrainer,
              mainParent: widget.parent,
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 95.0 * prefs.getDouble('height')),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 0 ? mainColor : secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 50 * prefs.getDouble('width'),
                ),
                SizedBox(
                  width: 10 * prefs.getDouble('width'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: currentPage == 1 ? mainColor : secondaryColor),
                  height: 8 * prefs.getDouble('height'),
                  width: 50 * prefs.getDouble('width'),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              widget.parent.setState(() {
                widget.parent.scheduleChanged = null;

                widget.parent.widget.bookedClient = widget.parent.initialClient;
              });
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              height: 140 * prefs.getDouble('height'),
              width: double.infinity,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
              if (scheduleChanged == true) {
                await Firestore.instance
                    .collection('clientUsers')
                    .document(widget.client.id)
                    .updateData(
                  {
                    'scheduleUpdated': true,
                  },
                );

                batch.commit();
                QuerySnapshot q = await Firestore.instance
                    .collection('clientUsers')
                    .where('id', isEqualTo: widget.client.id)
                    .getDocuments();
                Firestore.instance
                    .collection('updatedSchedule')
                    .document(client.id)
                    .setData(
                  {
                    'idFrom': prefs.getString('id'),
                    'idTo': client.id,
                    'pushToken': client.pushToken
                  },
                );

                widget.parent.setState(() {
                  widget.parent.widget.bookedClient =
                      ClientUser(q.documents[0]);
                });
              }
              Navigator.of(context).pop();
            },
            child: Container(
                width: double.infinity,
                height: 90 * prefs.getDouble('height'),
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
                        scheduleChanged == false
                            ? "Close"
                            : "Save changes & notify your client",
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
  }
}

class FirstPage extends StatefulWidget {
  TrainerUser imTrainer;
  ManagingSState parent;
  ClientUser client;
  _ClientProfileFinalSetStateState mainParent;
  bool scheduleChanged;
  FirstPage(
      {@required this.client,
      @required this.scheduleChanged,
      @required this.parent,
      this.imTrainer,
      this.mainParent});
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with WidgetsBindingObserver {
  ClientUser client;
  ClientUser clientChanged;
  bool scheduleChanged = false;
  String locationName;
  String locationDistrict;
  String locationWebsite;
  String locationStreet;
  String gymWebsite;
  var selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (client != null) {
      widget.client = client;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 140 * prefs.getDouble('height'),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 530 * prefs.getDouble('height'),
              width: 310 * prefs.getDouble('width'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff3E3E45)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10 * prefs.getDouble('height'),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/schedule1f1.svg',
                      width: 250.0 * prefs.getDouble('width'),
                      height: 130.0 * prefs.getDouble('height'),
                    ),
                  ),
                  SizedBox(
                    height: 15 * prefs.getDouble('height'),
                  ),
                  Text(
                    widget.client.firstName + " " + widget.client.lastName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 14 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        15 * prefs.getDouble('width'),
                        15 * prefs.getDouble('height'),
                        5 * prefs.getDouble('width'),
                        0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 330 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 330 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day1
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day1
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day1
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day1
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day1 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day1 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day1 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day1 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day1 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 1,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day1
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day1
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day1 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day1 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day2
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day2
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day2
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day2
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day2 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day2 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day2 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day2 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day2 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 2,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day2
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day2
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day2 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day2 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day3
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day3
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day3
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day3
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day3 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day3 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day3 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day3 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day3 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 3,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day3
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day3
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day3 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day3 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day4
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day4
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day4
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day4
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day4 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day4 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day4 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day4 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day4 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 4,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day4
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day4
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day4 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day4 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day5
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day5
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day5
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day5
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day5 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day5 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day5 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day5 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day5 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 5,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day5
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day5
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day5 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day5 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day6
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day6
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day6
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day6
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day6 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day6 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day6 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day6 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day6 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 6,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day6
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day6
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day6 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day6 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleFirstWeek.day7
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget.client
                                                            .scheduleFirstWeek.day7
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleFirstWeek
                                                    .day7
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleFirstWeek.day7
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day7 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day7 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day7 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkFirstSchedule
                                                              .day7 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day7 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 7,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleFirstWeek.day7
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleFirstWeek
                                                                      .day7
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleFirstWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkFirstSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day7 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkFirstSchedule
                                                                  .day7 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  TrainerUser imTrainer;
  ManagingSState parent;
  ClientUser client;
  _ClientProfileFinalSetStateState mainParent;
  bool scheduleChanged;
  SecondPage(
      {@required this.client,
      @required this.scheduleChanged,
      @required this.parent,
      this.imTrainer,
      this.mainParent});
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with WidgetsBindingObserver {
  ClientUser client;
  bool scheduleChanged = false;
  String locationName;
  String locationDistrict;
  String locationWebsite;
  String locationStreet;
  String gymWebsite;
  var selected;
  @override
  Widget build(BuildContext context) {
    if (client != null) {
      widget.client = client;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 140 * prefs.getDouble('height'),
            ),
          ),
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 530 * prefs.getDouble('height'),
              width: 310 * prefs.getDouble('width'),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff3E3E45)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10 * prefs.getDouble('height'),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      'assets/scheduleSecondWeek.svg',
                      width: 250.0 * prefs.getDouble('width'),
                      height: 130.0 * prefs.getDouble('height'),
                    ),
                  ),
                  SizedBox(
                    height: 15 * prefs.getDouble('height'),
                  ),
                  Text(
                    widget.client.firstName + " " + widget.client.lastName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 14 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        15 * prefs.getDouble('width'),
                        15 * prefs.getDouble('height'),
                        15 * prefs.getDouble('width'),
                        0),
                    width: 300 * prefs.getDouble('width'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 330 * prefs.getDouble('height'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 330 * prefs.getDouble('height'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day1
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day1
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day1
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day1
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day1 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day8 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day1 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day1 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day8 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 8,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day1
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day1
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day1
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day1 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day8 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day1 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day2
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day2
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day2
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day2
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day2 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day9 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day2 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day2 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day9 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 9,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day2
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day2
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day2
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day2 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day9 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day2 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day3
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day3
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day3
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day3
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day3 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day10 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day3 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day3 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day10 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 10,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day3
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day3
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day3
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day3 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day10 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day3 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day4
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day4
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day4
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day4
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day4 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day11 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day4 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day4 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day11 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 11,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day4
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day4
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day4
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day4 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day11 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day4 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day5
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day5
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day5
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day5
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day5 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day12 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day5 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day5 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day12 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 12,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day5
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day5
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day5
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day5 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day12 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day5 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day6
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day6
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day6
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day6
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day6 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day13 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day6 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day6 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day13 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 13,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day6
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day6
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day6
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day6 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day13 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day6 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 46 * prefs.getDouble('height'),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              8 * prefs.getDouble('height')),
                                      width: 260 * prefs.getDouble('width'),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            daysOfTheWeek[widget.client
                                                        .scheduleSecondWeek.day7
                                                        .toDate()
                                                        .weekday -
                                                    1] +
                                                ", " +
                                                (widget
                                                            .client
                                                            .scheduleSecondWeek
                                                            .day7
                                                            .toDate()
                                                            .day
                                                            .toInt() <
                                                        10
                                                    ? "0"
                                                    : "") +
                                                widget.client.scheduleSecondWeek
                                                    .day7
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                " " +
                                                monthsOfTheYear[widget.client
                                                        .scheduleSecondWeek.day7
                                                        .toDate()
                                                        .month
                                                        .toInt() -
                                                    1],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 13 *
                                                    prefs.getDouble('height'),
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    200, 255, 255, 255)),
                                          ),
                                          Container(
                                            width: 108.0 *
                                                prefs.getDouble('width'),
                                            height: 29.0 *
                                                prefs.getDouble('height'),
                                            child: Material(
                                              color: (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day7 ==
                                                          'true' &&
                                                      widget
                                                              .client
                                                              .trainingSessionTrainerId
                                                              .day14 ==
                                                          prefs.getString('id'))
                                                  ? mainColor
                                                  : widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day7 ==
                                                          'false'
                                                      ? mainColor
                                                      : Color(0xff57575E),
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              child: MaterialButton(
                                                onPressed: () {
                                                  if (widget
                                                              .client
                                                              .checkSecondSchedule
                                                              .day7 ==
                                                          'false' ||
                                                      (widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day14 ==
                                                              prefs.getString(
                                                                  'id'))) {
                                                    bool friendOrNot = false;
                                                    widget.imTrainer.clients
                                                        .forEach((element) {
                                                      if (element.clientId ==
                                                          widget.client.id) {
                                                        friendOrNot = true;
                                                      }
                                                    });
                                                    if (friendOrNot == true) {
                                                      Navigator.push(
                                                          context,
                                                          DetailsPopUp2(
                                                              mainParent: widget
                                                                  .mainParent,
                                                              index: 14,
                                                              client: widget
                                                                  .client,
                                                              trainerUser: widget
                                                                  .imTrainer,
                                                              parent1: this,
                                                              day: daysOfTheWeek[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .weekday -
                                                                      1] +
                                                                  ", " +
                                                                  (widget.client.scheduleSecondWeek.day7
                                                                              .toDate()
                                                                              .day
                                                                              .toInt() <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  widget
                                                                      .client
                                                                      .scheduleSecondWeek
                                                                      .day7
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  " " +
                                                                  monthsOfTheYear[widget
                                                                          .client
                                                                          .scheduleSecondWeek
                                                                          .day7
                                                                          .toDate()
                                                                          .month
                                                                          .toInt() -
                                                                      1]));
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  (widget.client.checkSecondSchedule
                                                                  .day7 ==
                                                              'true' &&
                                                          widget
                                                                  .client
                                                                  .trainingSessionTrainerId
                                                                  .day14 ==
                                                              prefs.getString(
                                                                  'id'))
                                                      ? 'Edit workout'
                                                      : widget
                                                                  .client
                                                                  .checkSecondSchedule
                                                                  .day7 ==
                                                              'false'
                                                          ? 'Set workout'
                                                          : "Unavailable",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        ],
      ),
    );
  }
}

class DetailsPopUp2 extends PopupRoute<void> {
  DetailsPopUp2(
      {this.parent,
      this.trainerUser,
      this.day,
      this.client,
      this.index,
      this.mainParent,
      this.parent1});
  _ClientProfileFinalSetStateState mainParent;
  final int index;
  final ClientUser client;
  final String day;
  final _FirstPageState parent;
  final _SecondPageState parent1;

  final TrainerUser trainerUser;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      DetailsPage2(
          trainer: trainerUser,
          parent: parent,
          day: day,
          client: client,
          index: index,
          mainParent: mainParent,
          parent1: parent1);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPopUp3 extends PopupRoute<void> {
  DetailsPopUp3(
      {this.parent,
      this.trainerUser,
      this.day,
      this.locationName,
      this.locationStreet,
      this.client,
      this.index,
      this.mainParent,
      this.parent1});
  _ClientProfileFinalSetStateState mainParent;
  final _SecondPageState parent1;
  final int index;
  final ClientUser client;
  final String locationName;
  final String locationStreet;
  final String day;
  final _FirstPageState parent;

  final TrainerUser trainerUser;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      DetailsPage3(
          trainer: trainerUser,
          parent: parent,
          day: day,
          locationName: locationName,
          locationStreet: locationStreet,
          client: client,
          index: index,
          mainParent: mainParent,
          parent1: parent1);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPage3 extends StatefulWidget {
  _ClientProfileFinalSetStateState mainParent;
  final _SecondPageState parent1;
  final String locationName;
  final String locationStreet;
  final _FirstPageState parent;
  final TrainerUser trainer;
  final String day;
  final ClientUser client;
  final int index;
  DetailsPage3(
      {Key key,
      @required this.trainer,
      @required this.parent,
      this.day,
      this.locationName,
      this.locationStreet,
      this.client,
      @required this.index,
      this.mainParent,
      this.parent1})
      : super(key: key);

  @override
  State createState() => DetailsPage3State(index: index);
}

class DetailsPage3State extends State<DetailsPage3> {
  String hinttText = "Scrie";
  Image image;
  final int index;
  String hintName, hintStreet, hintSector;
  DetailsPage3State({Key key, @required this.index});
  @override
  void initState() {
    super.initState();
  }

  var selected;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    return showTimePicker1(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

  var transitionFinal2;
  var transitionFinal2End;

  @override
  Widget build(BuildContext context) {
    String hour1, hour2, minute1, minute2;

    if (transitionFinal2 != null) {
      if (transitionFinal2.hour < 10) {
        hour1 = "0" + transitionFinal2.hour.toString();
      } else {
        hour1 = transitionFinal2.hour.toString();
      }

      if (transitionFinal2.minute < 10) {
        minute1 = "0" + transitionFinal2.minute.toString();
      } else {
        minute1 = transitionFinal2.minute.toString();
      }
    }
    if (transitionFinal2End != null) {
      if (transitionFinal2End.hour < 10) {
        hour2 = "0" + transitionFinal2End.hour.toString();
      } else {
        hour2 = transitionFinal2End.hour.toString();
      }

      if (transitionFinal2End.minute < 10) {
        minute2 = "0" + transitionFinal2End.minute.toString();
      } else {
        minute2 = transitionFinal2End.minute.toString();
      }
    }

    if (hour1 == null && minute1 == null) {
      if (index == 1 && widget.client.checkFirstSchedule.day1 == 'true') {
        if (widget.client.scheduleFirstWeek.day1.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day1.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day1.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day1.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day1.toDate().minute.toString();
        }
      }

      if (index == 2 && widget.client.checkFirstSchedule.day2 == 'true') {
        if (widget.client.scheduleFirstWeek.day2.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day2.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day2.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day2.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day2.toDate().minute.toString();
        }
      }

      if (index == 3 && widget.client.checkFirstSchedule.day3 == 'true') {
        if (widget.client.scheduleFirstWeek.day3.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day3.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day3.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day3.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day3.toDate().minute.toString();
        }
      }

      if (index == 4 && widget.client.checkFirstSchedule.day4 == 'true') {
        if (widget.client.scheduleFirstWeek.day4.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day4.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day4.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day4.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day4.toDate().minute.toString();
        }
      }

      if (index == 5 && widget.client.checkFirstSchedule.day5 == 'true') {
        if (widget.client.scheduleFirstWeek.day5.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day5.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day5.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day5.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day5.toDate().minute.toString();
        }
      }

      if (index == 6 && widget.client.checkFirstSchedule.day6 == 'true') {
        if (widget.client.scheduleFirstWeek.day6.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day6.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day6.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day6.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day6.toDate().minute.toString();
        }
      }

      if (index == 7 && widget.client.checkFirstSchedule.day7 == 'true') {
        if (widget.client.scheduleFirstWeek.day7.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleFirstWeek.day7.toDate().hour.toString();
        } else {
          hour1 = widget.client.scheduleFirstWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstWeek.day7.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleFirstWeek.day7.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleFirstWeek.day7.toDate().minute.toString();
        }
      }

      if (index == 8 && widget.client.checkSecondSchedule.day1 == 'true') {
        if (widget.client.scheduleSecondWeek.day1.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day1.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day1.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day1.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day1.toDate().minute.toString();
        }
      }

      if (index == 9 && widget.client.checkSecondSchedule.day2 == 'true') {
        if (widget.client.scheduleSecondWeek.day2.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day2.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day2.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day2.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day2.toDate().minute.toString();
        }
      }

      if (index == 10 && widget.client.checkSecondSchedule.day3 == 'true') {
        if (widget.client.scheduleSecondWeek.day3.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day3.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day3.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day3.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day3.toDate().minute.toString();
        }
      }

      if (index == 11 && widget.client.checkSecondSchedule.day4 == 'true') {
        if (widget.client.scheduleSecondWeek.day4.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day4.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day4.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day4.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day4.toDate().minute.toString();
        }
      }

      if (index == 12 && widget.client.checkSecondSchedule.day5 == 'true') {
        if (widget.client.scheduleSecondWeek.day5.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day5.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day5.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day5.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day5.toDate().minute.toString();
        }
      }

      if (index == 13 && widget.client.checkSecondSchedule.day6 == 'true') {
        if (widget.client.scheduleSecondWeek.day6.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day6.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day6.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day6.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day6.toDate().minute.toString();
        }
      }

      if (index == 14 && widget.client.checkSecondSchedule.day7 == 'true') {
        if (widget.client.scheduleSecondWeek.day7.toDate().hour < 10) {
          hour1 = "0" +
              widget.client.scheduleSecondWeek.day7.toDate().hour.toString();
        } else {
          hour1 =
              widget.client.scheduleSecondWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondWeek.day7.toDate().minute < 10) {
          minute1 = "0" +
              widget.client.scheduleSecondWeek.day7.toDate().minute.toString();
        } else {
          minute1 =
              widget.client.scheduleSecondWeek.day7.toDate().minute.toString();
        }
      }
    }
    if (hour2 == null && minute2 == null) {
      if (index == 1 && widget.client.checkFirstSchedule.day1 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day1.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day1.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day1.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day1
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day1
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 2 && widget.client.checkFirstSchedule.day2 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day2.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day2.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day2.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day2
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day2
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 3 && widget.client.checkFirstSchedule.day3 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day3.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day3.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day3.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day3
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day3
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 4 && widget.client.checkFirstSchedule.day4 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day4.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day4.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day4.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day4
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day4
              .toDate()
              .minute
              .toString();
        }
      }
      if (index == 5 && widget.client.checkFirstSchedule.day5 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day5.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day5.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day5.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day5
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day5
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 6 && widget.client.checkFirstSchedule.day6 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day6.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day6.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day6.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day6
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day6
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 7 && widget.client.checkFirstSchedule.day7 == 'true') {
        if (widget.client.scheduleFirstEndWeek.day7.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleFirstEndWeek.day7.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleFirstEndWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleFirstEndWeek.day7.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleFirstEndWeek.day7
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleFirstEndWeek.day7
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 8 && widget.client.checkSecondSchedule.day1 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day1.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day1.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day1.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day1.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day1
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day1
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 9 && widget.client.checkSecondSchedule.day2 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day2.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day2.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day2.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day2.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day2
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day2
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 10 && widget.client.checkSecondSchedule.day3 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day3.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day3.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day3.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day3.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day3
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day3
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 11 && widget.client.checkSecondSchedule.day4 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day4.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day4.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day4.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day4.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day4
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day4
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 12 && widget.client.checkSecondSchedule.day5 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day5.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day5.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day5.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day5.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day5
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day5
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 13 && widget.client.checkSecondSchedule.day6 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day6.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day6.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day6.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day6.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day6
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day6
              .toDate()
              .minute
              .toString();
        }
      }

      if (index == 14 && widget.client.checkSecondSchedule.day7 == 'true') {
        if (widget.client.scheduleSecondEndWeek.day7.toDate().hour < 10) {
          hour2 = "0" +
              widget.client.scheduleSecondEndWeek.day7.toDate().hour.toString();
        } else {
          hour2 =
              widget.client.scheduleSecondEndWeek.day7.toDate().hour.toString();
        }
        if (widget.client.scheduleSecondEndWeek.day7.toDate().minute < 10) {
          minute2 = "0" +
              widget.client.scheduleSecondEndWeek.day7
                  .toDate()
                  .minute
                  .toString();
        } else {
          minute2 = widget.client.scheduleSecondEndWeek.day7
              .toDate()
              .minute
              .toString();
        }
      }
    }
    return Center(
      child: Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: 0 * prefs.getDouble('width')),
          backgroundColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor,
              ),
              width: 310 * prefs.getDouble('width'),
              height: 210 * prefs.getDouble('height'),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16 * prefs.getDouble('height'),
                    horizontal: 12 * prefs.getDouble('width')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.day,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13 * prefs.getDouble('height'),
                                letterSpacing: -0.066,
                                fontFamily: 'Roboto')),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: (hour1 == null && minute1 == null)
                                    ? "hh:mm"
                                    : (hour1 + ":" + minute1),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13 * prefs.getDouble('height'),
                                    letterSpacing: -0.066,
                                    fontFamily: 'Roboto'),
                              ),
                              TextSpan(
                                  text: " - ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.066,
                                      fontFamily: 'Roboto')),
                              TextSpan(
                                  text: (hour2 == null && minute2 == null)
                                      ? "hh:mm"
                                      : (hour2 + ":" + minute2),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13 * prefs.getDouble('height'),
                                      letterSpacing: -0.066,
                                      fontFamily: 'Roboto')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Workout with ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.078),
                          ),
                          TextSpan(
                            text:
                                "${widget.trainer.firstName} ${widget.trainer.lastName}",
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.078),
                          ),
                          TextSpan(
                            text:
                                " - at ${widget.locationName}, ${widget.locationStreet}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11 * prefs.getDouble('height'),
                                letterSpacing: -0.078),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 130.0 * prefs.getDouble('width'),
                          height: 30.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                selected = await _selectTime(context);
                                DateTime transition;
                                if (widget.client.scheduleFirstWeek.day1
                                    is Timestamp) {
                                  Timestamp transitionFINAL =
                                      widget.client.scheduleFirstWeek.day1;
                                  transition = transitionFINAL.toDate();
                                } else {
                                  transition = widget
                                      .client.scheduleFirstWeek.day1
                                      .toDate();
                                }
                                var transitionFinal1 = transition.subtract(
                                  Duration(
                                      hours: transition.hour,
                                      minutes: transition.minute),
                                );
                                transitionFinal2 = transitionFinal1.add(
                                  Duration(
                                      days: index - 1,
                                      hours: selected.hour,
                                      minutes: selected.minute),
                                );
                                setState(
                                  () {},
                                );
                              },
                              child: Text(
                                'Set starting hour',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 12.0 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 130.0 * prefs.getDouble('width'),
                          height: 30.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                selected = await _selectTime(context);
                                DateTime transition;
                                if (widget.client.scheduleFirstEndWeek.day1
                                    is Timestamp) {
                                  Timestamp transitionFINAL =
                                      widget.client.scheduleFirstEndWeek.day1;
                                  transition = transitionFINAL.toDate();
                                } else {
                                  transition = widget
                                      .client.scheduleFirstEndWeek.day1
                                      .toDate();
                                }

                                var transitionFinal1 = transition.subtract(
                                  Duration(
                                      hours: transition.hour,
                                      minutes: transition.minute),
                                );
                                transitionFinal2End = transitionFinal1.add(
                                  Duration(
                                      days: index - 1,
                                      hours: selected.hour,
                                      minutes: selected.minute),
                                );

                                setState(
                                  () {},
                                );
                              },
                              child: Text(
                                'Set end hour',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 12.0 * prefs.getDouble('height'),
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    Container(
                      height: 1.0 * prefs.getDouble('height'),
                      color: Color(0xff57575E),
                    ),
                    SizedBox(height: 8 * prefs.getDouble('height')),
                    InkWell(
                      onTap: () async {
                        if (transitionFinal2 != null &&
                            transitionFinal2End != null) {
                          bool friendsOrNot = false;
                          widget.trainer.clients.forEach((element) {
                            if (element.clientId == widget.client.id) {
                              friendsOrNot = true;
                            }
                          });
                          if (friendsOrNot == true) {
                            int miniIndex = 0;
                            if (widget.index > 7) {
                              miniIndex = widget.index - 7;

                              widget.parent1.widget.parent.batch.updateData(
                                widget.parent1.widget.parent.db
                                    .collection('clientUsers')
                                    .document(widget.client.id),
                                {
                                  'scheduleHour2End.$miniIndex':
                                      transitionFinal2End,
                                  'scheduleHour2.$miniIndex': transitionFinal2,
                                  'scheduleBool2.$miniIndex': 'true',
                                  'trainingSessionLocationName.$index':
                                      widget.locationName,
                                  'trainingSessionLocationStreet.$index':
                                      widget.locationStreet,
                                  'trainingSessionTrainerName.$index':
                                      "${widget.trainer.firstName} ${widget.trainer.lastName}",
                                  'trainingSessionTrainerId.$index':
                                      widget.trainer.id,
                                },
                              );

                              if (index == 8) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day1 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day1 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day8 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day8 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day8 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day8 = widget.trainer.id;
                              }

                              if (index == 9) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day2 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day2 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day9 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day9 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day9 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day9 = widget.trainer.id;
                              }

                              if (index == 10) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day3 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day3 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day10 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day10 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day10 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day10 = widget.trainer.id;
                              }

                              if (index == 11) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day4 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day4 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day11 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day11 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day11 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day11 = widget.trainer.id;
                              }

                              if (index == 12) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day5 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day5 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day12 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day12 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day12 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day12 = widget.trainer.id;
                              }

                              if (index == 13) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day6 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day6 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day13 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day13 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day13 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day13 = widget.trainer.id;
                              }

                              if (index == 14) {
                                widget.parent1.scheduleChanged = true;
                                widget.parent1.widget.client.scheduleSecondWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent1.widget.client
                                        .scheduleSecondEndWeek.day7 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent1.widget.client.checkSecondSchedule
                                    .day7 = 'true';
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day14 = widget.locationName;
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day14 = widget.locationStreet;
                                widget.parent1.widget.client
                                        .trainingSessionTrainerName.day14 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent1
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day14 = widget.trainer.id;
                              }
                            } else {
                              widget.parent.widget.parent.batch.updateData(
                                widget.parent.widget.parent.db
                                    .collection('clientUsers')
                                    .document(widget.client.id),
                                {
                                  'scheduleHour1End.$index':
                                      transitionFinal2End,
                                  'scheduleHour1.$index': transitionFinal2,
                                  'scheduleBool1.$index': 'true',
                                  'trainingSessionLocationName.$index':
                                      widget.locationName,
                                  'trainingSessionLocationStreet.$index':
                                      widget.locationStreet,
                                  'trainingSessionTrainerName.$index':
                                      "${widget.trainer.firstName} ${widget.trainer.lastName}",
                                  'trainingSessionTrainerId.$index':
                                      widget.trainer.id,
                                },
                              );

                              if (index == 1) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day1 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent.widget.client.checkFirstSchedule
                                    .day1 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day1 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day1 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day1 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day1 = widget.trainer.id;
                              }

                              if (index == 2) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day2 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent.widget.client.checkFirstSchedule
                                    .day2 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day2 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day2 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day2 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day2 = widget.trainer.id;
                              }

                              if (index == 3) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day3 =
                                    Timestamp.fromDate(transitionFinal2End);
                                widget.parent.widget.client.checkFirstSchedule
                                    .day3 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day3 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day3 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day3 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day3 = widget.trainer.id;
                              }

                              if (index == 4) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day4 =
                                    Timestamp.fromDate(transitionFinal2End);

                                widget.parent.widget.client.checkFirstSchedule
                                    .day4 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day4 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day4 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day4 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day4 = widget.trainer.id;
                              }

                              if (index == 5) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day5 =
                                    Timestamp.fromDate(transitionFinal2End);

                                widget.parent.widget.client.checkFirstSchedule
                                    .day5 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day5 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day5 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day5 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day5 = widget.trainer.id;
                              }

                              if (index == 6) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day6 =
                                    Timestamp.fromDate(transitionFinal2End);

                                widget.parent.widget.client.checkFirstSchedule
                                    .day6 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day6 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day6 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day6 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day6 = widget.trainer.id;
                              }

                              if (index == 7) {
                                widget.parent.scheduleChanged = true;
                                widget.parent.widget.client.scheduleFirstWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2);
                                widget.parent.widget.client.scheduleFirstEndWeek
                                        .day7 =
                                    Timestamp.fromDate(transitionFinal2End);

                                widget.parent.widget.client.checkFirstSchedule
                                    .day7 = 'true';
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationName
                                    .day7 = widget.locationName;
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionLocationStreet
                                    .day7 = widget.locationStreet;
                                widget.parent.widget.client
                                        .trainingSessionTrainerName.day7 =
                                    "${widget.trainer.firstName} ${widget.trainer.lastName}";
                                widget
                                    .parent
                                    .widget
                                    .client
                                    .trainingSessionTrainerId
                                    .day7 = widget.trainer.id;
                              }
                            }

                            widget.mainParent.setState(() {
                              widget.mainParent.scheduleChanged = true;

                              if (widget.parent != null) {
                                widget.parent.widget.parent.setState(() {
                                  widget.parent.widget.parent.scheduleChanged =
                                      true;

                                  widget.parent.setState(() {});
                                });
                              }
                              if (widget.parent1 != null) {
                                widget.parent1.widget.parent.setState(() {
                                  widget.parent1.widget.parent.scheduleChanged =
                                      true;

                                  widget.parent1.setState(() {});
                                });
                              }
                            });

                            Navigator.of(context).pop();
                          }
                        } else {
                          Navigator.push(context, PopUpMissingRoute());
                        }
                      },
                      child: Container(
                        height: 32 * prefs.getDouble('height'),
                        child: Center(
                            child: Text(
                          "Confirm",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * prefs.getDouble('height'),
                              fontFamily: 'Roboto'),
                        )),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}

class DetailsPage2 extends StatefulWidget {
  _ClientProfileFinalSetStateState mainParent;
  final _SecondPageState parent1;
  final String day;
  final _FirstPageState parent;
  final TrainerUser trainer;
  final ClientUser client;
  final int index;
  DetailsPage2(
      {Key key,
      @required this.trainer,
      @required this.parent,
      this.day,
      this.client,
      this.index,
      this.mainParent,
      this.parent1})
      : super(key: key);

  @override
  State createState() => DetailsPage2State();
}

class DetailsPage2State extends State<DetailsPage2> {
  String hinttText = "Scrie";
  Image image;

  String hintName, hintStreet, hintSector;

  @override
  void initState() {
   
    super.initState();
  }

  Widget buildItem(index) {
    return InkWell(
      onTap: () {
        if (widget.parent != null) {
          widget.parent.setState(() {
            if (index == 0) {
              widget.parent.locationName = widget.trainer.gym1;
              widget.parent.locationDistrict = widget.trainer.gym1Sector;
              widget.parent.locationStreet = widget.trainer.gym1Street;
              widget.parent.gymWebsite = widget.trainer.gym1Website;
            }
            if (index == 1) {
              widget.parent.locationName = widget.trainer.gym2;
              widget.parent.locationDistrict = widget.trainer.gym2Sector;
              widget.parent.locationStreet = widget.trainer.gym2Street;

              widget.parent.gymWebsite = widget.trainer.gym2Website;
            }
            if (index == 2) {
              widget.parent.locationName = widget.trainer.gym3;
              widget.parent.locationDistrict = widget.trainer.gym3Sector;
              widget.parent.locationStreet = widget.trainer.gym3Street;
              widget.parent.gymWebsite = widget.trainer.gym3Website;
            }
            if (index == 3) {
              widget.parent.locationName = widget.trainer.gym4;
              widget.parent.locationDistrict = widget.trainer.gym4Sector;
              widget.parent.locationStreet = widget.trainer.gym4Street;
              widget.parent.gymWebsite = widget.trainer.gym4Website;
            }
            Navigator.of(context).pop();

            Navigator.push(
                context,
                DetailsPopUp3(
                    index: widget.index,
                    trainerUser: widget.trainer,
                    day: widget.day,
                    locationName: widget.parent.locationName,
                    locationStreet: widget.parent.locationStreet,
                    client: widget.client,
                    parent: widget.parent,
                    mainParent: widget.mainParent,
                    parent1: widget.parent1));
          });
        }
        if (widget.parent1 != null) {
          widget.parent1.setState(() {
            if (index == 0) {
              widget.parent1.locationName = widget.trainer.gym1;
              widget.parent1.locationDistrict = widget.trainer.gym1Sector;
              widget.parent1.locationStreet = widget.trainer.gym1Street;
              widget.parent1.gymWebsite = widget.trainer.gym1Website;
            }
            if (index == 1) {
              widget.parent1.locationName = widget.trainer.gym2;
              widget.parent1.locationDistrict = widget.trainer.gym2Sector;
              widget.parent1.locationStreet = widget.trainer.gym2Street;

              widget.parent1.gymWebsite = widget.trainer.gym2Website;
            }
            if (index == 2) {
              widget.parent1.locationName = widget.trainer.gym3;
              widget.parent1.locationDistrict = widget.trainer.gym3Sector;
              widget.parent1.locationStreet = widget.trainer.gym3Street;
              widget.parent1.gymWebsite = widget.trainer.gym3Website;
            }
            if (index == 3) {
              widget.parent1.locationName = widget.trainer.gym4;
              widget.parent1.locationDistrict = widget.trainer.gym4Sector;
              widget.parent1.locationStreet = widget.trainer.gym4Street;
              widget.parent1.gymWebsite = widget.trainer.gym4Website;
            }
            Navigator.of(context).pop();

            Navigator.push(
                context,
                DetailsPopUp3(
                    index: widget.index,
                    trainerUser: widget.trainer,
                    day: widget.day,
                    locationName: widget.parent1.locationName,
                    locationStreet: widget.parent1.locationStreet,
                    client: widget.client,
                    parent: widget.parent,
                    mainParent: widget.mainParent,
                    parent1: widget.parent1));
          });
        }
      },
      child: Container(
        height: 61 * prefs.getDouble('height'),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 60 * prefs.getDouble('height'),
              child: Center(
                  child: Text(
                index == 0
                    ? widget.trainer.gym1
                    : index == 1
                        ? widget.trainer.gym2
                        : index == 2
                            ? widget.trainer.gym3
                            : widget.trainer.gym4,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13 * prefs.getDouble('height'),
                  color: Color.fromARGB(200, 255, 255, 255),
                  letterSpacing: -0.078,
                ),
                textAlign: TextAlign.center,
              )),
            ),
            Container(
              height: 1.0 * prefs.getDouble('height'),
              color: Color(0xff57575E),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int multiplier = 0;
    if (widget.trainer.gym1 != null && widget.trainer.gym1 != "") {
      multiplier += 1;
    }
    if (widget.trainer.gym2 != null && widget.trainer.gym2 != "") {
      multiplier += 1;
    }
    if (widget.trainer.gym3 != null && widget.trainer.gym3 != "") {
      multiplier += 1;
    }
    if (widget.trainer.gym4 != null && widget.trainer.gym4 != "") {
      multiplier += 1;
    }
    return Center(
      child: Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: 0 * prefs.getDouble('width')),
        backgroundColor: Colors.transparent,
        child: multiplier != 0
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff3E3E45)),
                width: 310 * prefs.getDouble('width'),
                height: ((multiplier * 61 + 156) * prefs.getDouble('height')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 82 * prefs.getDouble('height'),
                      child: Center(
                        child: Text(
                          "Select the gym",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 20 * prefs.getDouble('height'),
                              letterSpacing: 0.75,
                              color: Color.fromARGB(200, 255, 255, 255)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 1.0 * prefs.getDouble('height'),
                      color: Color(0xff57575E),
                    ),
                    (widget.trainer.gym1 != null && widget.trainer.gym1 != "")
                        ? buildItem(0)
                        : Container(),
                    (widget.trainer.gym2 != null && widget.trainer.gym2 != "")
                        ? buildItem(1)
                        : Container(),
                    (widget.trainer.gym3 != null && widget.trainer.gym3 != "")
                        ? buildItem(2)
                        : Container(),
                    (widget.trainer.gym4 != null && widget.trainer.gym4 != "")
                        ? buildItem(3)
                        : Container(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 72 * prefs.getDouble('height'),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                letterSpacing: -0.408,
                                fontWeight: FontWeight.w600,
                                fontSize: 17 * prefs.getDouble('height'),
                                fontFamily: 'Roboto',
                                color: Color.fromARGB(200, 255, 255, 255)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff3E3E45)),
                width: 340 * prefs.getDouble('width'),
                height: 500 * prefs.getDouble('height'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 16 * prefs.getDouble('height')),
                    SvgPicture.asset(
                      'assets/editCardsf1.svg',
                      width: 180.0 * prefs.getDouble('width'),
                      height: 100.0 * prefs.getDouble('height'),
                    ),
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    Container(
                      width: 180 * prefs.getDouble('width'),
                      child: Center(
                        child: Text(
                          "Please edit your gym cards accordingly!",
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15 * prefs.getDouble('height'),
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28 * prefs.getDouble('height'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 150 * prefs.getDouble('width'),
                        padding: EdgeInsets.only(
                          right: 15 * prefs.getDouble('width'),
                        ),
                        height: 30 * prefs.getDouble('width'),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xff57575E),
                          child: MaterialButton(
                            onPressed: () {
                              if (prefs.getInt('currentCard') >= 0 &&
                                  prefs.getInt('currentCard') <= 3) {
                                Navigator.push(
                                    context,
                                    MyPopupRoute1(
                                        trainerUser: widget.trainer,
                                        currentCard:
                                            prefs.getInt('currentCard'),
                                        parent: this,
                                        parentParent: widget.parent));
                              }
                            },
                            child: Text(
                              "Edit card",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11 * prefs.getDouble('height')),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          top: 8.0 * prefs.getDouble('height'),
                        ),
                        child: Container(
                          width: 330 * prefs.getDouble('width'),
                          height: 230 * prefs.getDouble('height'),
                          child: CardSlider(
                            height: 0.0,
                            trainerUser: widget.trainer,
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}

class PopUpMissingRoute extends PopupRoute<void> {
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      PopUpMissing();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpMissing extends StatefulWidget {
  @override
  State createState() => PopUpMissingState();
}

class PopUpMissingState extends State<PopUpMissing> {
  List<ReviewMapDelay> revs = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: secondaryColor,
          ),
          height: 256 * prefs.getDouble('height'),
          width: 313 * prefs.getDouble('width'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/waitf1.svg',
                width: 180.0 * prefs.getDouble('width'),
                height: 100.0 * prefs.getDouble('height'),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Text(
                "Please set the time-interval!",
                style: TextStyle(
                  fontSize: 16 * prefs.getDouble('height'),
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardSlider extends StatefulWidget {
  final double height;
  final TrainerUser trainerUser;
  CardSlider({Key key, this.height, this.trainerUser}) : super(key: key);

  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  double positionY_line1;
  double positionY_line2;
  double _middleAreaHeight;
  double _outsideCardInterval;
  double scrollOffsetY;
  List<CardInfo> _cardInfoList;
  bool edit = false;
  List<double> cardsOpacity = [0, 0, 0, 0];

  int currentCard = 3;

  @override
  void initState() {
   
    super.initState();

    positionY_line1 = 3 * prefs.getDouble('height');
    positionY_line2 = positionY_line1 + 105 * prefs.getDouble('height');

    _middleAreaHeight = positionY_line2 - positionY_line1;
    _outsideCardInterval = 22.0 * prefs.getDouble('height');
    scrollOffsetY = 0;

    _cardInfoList = [
      CardInfo(
          leftColor: prefix0.mainColor,
          rightColor: prefix0.mainColor,
          hintTextGym: widget.trainerUser.gym1,
          hintTextGymAddress: widget.trainerUser.gym1Street),
      CardInfo(
          leftColor: Color(0xffAC70F1),
          rightColor: Color(0xffAC70F1),
          hintTextGym: widget.trainerUser.gym2,
          hintTextGymAddress: widget.trainerUser.gym2Street),
      CardInfo(
          leftColor: Color(0xff8D5BC7),
          rightColor: Color(0xff8D5BC7),
          hintTextGym: widget.trainerUser.gym3,
          hintTextGymAddress: widget.trainerUser.gym3Street),
      CardInfo(
          leftColor: Color(0xff683E99),
          rightColor: Color(0xff683E99),
          hintTextGym: widget.trainerUser.gym4,
          hintTextGymAddress: widget.trainerUser.gym4Street)
    ];

    for (var i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[i];
      if (i == 0) {
        cardInfo.positionY = positionY_line1;
        cardInfo.opacity = 1.0;
        cardInfo.scale = 1.0;
        cardInfo.rotate = 1.0;
      } else {
        cardInfo.positionY = positionY_line2 + (i - 1) * _outsideCardInterval;
        cardInfo.opacity = 0.7;
        cardsOpacity[3 - i] = 0.85 - (3 - i) * 0.1;
        cardInfo.scale = 0.9;
        cardInfo.rotate = -60.0;
      }
    }

    _cardInfoList = _cardInfoList.reversed.toList();
  }

  _buildCards() {
    List widgetList = [];

    for (CardInfo cardInfo in _cardInfoList) {
      widgetList.add(Positioned(
        top: cardInfo.positionY,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(pi / 180 * cardInfo.rotate)
            ..scale(cardInfo.scale),
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: cardInfo.opacity,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10 * prefs.getDouble('height'),
                      offset: Offset(5 * prefs.getDouble('height'),
                          10 * prefs.getDouble('height')))
                ],
                borderRadius:
                    BorderRadius.circular(16 * prefs.getDouble('height')),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardInfo.leftColor,
                      cardInfo.rightColor,
                    ]),
              ),
              width: 310 * prefs.getDouble('width'),
              height: 150.0 * prefs.getDouble('height'),
              child: Stack(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 20 * prefs.getDouble('height'),
                            left: 20 * prefs.getDouble('width'),
                          ),
                          child: Text(
                            prefs.getString('gym4') != null && cardInfo == _cardInfoList[0]
                                ? prefs.getString('gym4')
                                : prefs.getString('gym3') != null && cardInfo == _cardInfoList[1]
                                    ? prefs.getString('gym3')
                                    : prefs.getString('gym2') != null &&
                                            cardInfo == _cardInfoList[2]
                                        ? prefs.getString('gym2')
                                        : prefs.getString('gym1') != null &&
                                                cardInfo == _cardInfoList[3]
                                            ? prefs.getString('gym1')
                                            : (cardInfo == _cardInfoList[3]
                                                        ? widget
                                                            .trainerUser.gym1
                                                        : cardInfo == _cardInfoList[2]
                                                            ? widget.trainerUser
                                                                .gym2
                                                            : cardInfo == _cardInfoList[1]
                                                                ? widget
                                                                    .trainerUser
                                                                    .gym3
                                                                : widget
                                                                    .trainerUser
                                                                    .gym4) ==
                                                    ""
                                                ? "Name"
                                                : (cardInfo == _cardInfoList[3]
                                                    ? widget.trainerUser.gym1
                                                    : cardInfo == _cardInfoList[2]
                                                        ? widget.trainerUser.gym2
                                                        : cardInfo == _cardInfoList[1] ? widget.trainerUser.gym3 : widget.trainerUser.gym4),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                color: Color.fromARGB(210, 255, 255, 255)
                                    .withOpacity(cardInfo == _cardInfoList[3]
                                        ? 1
                                        : cardInfo.opacity > 0.7 &&
                                                cardInfo == _cardInfoList[2]
                                            ? cardInfo.opacity
                                            : cardInfo.opacity > 0.7 &&
                                                    cardInfo == _cardInfoList[1]
                                                ? cardInfo.opacity
                                                : cardInfo.opacity > 0.7 &&
                                                        cardInfo ==
                                                            _cardInfoList[0]
                                                    ? cardInfo.opacity
                                                    : 0),
                                fontSize: 20 * prefs.getDouble('height'),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (cardInfo == _cardInfoList[1]) {
                              if (prefs.getString('gym3Website') != null) {
                                launch(prefs.getString('gym3Website'));
                              } else {
                                if (widget.trainerUser.gym3Website != null) {
                                  launch(widget.trainerUser.gym3Website);
                                }
                              }
                            }
                            if (cardInfo == _cardInfoList[0]) {
                              if (prefs.getString('gym4Website') != null) {
                                launch(prefs.getString('gym4Website'));
                              } else {
                                if (widget.trainerUser.gym4Website != null) {
                                  launch(widget.trainerUser.gym4Website);
                                }
                              }
                            }
                            if (cardInfo == _cardInfoList[2]) {
                              if (prefs.getString('gym2Website') != null) {
                                launch(prefs.getString('gym2Website'));
                              } else {
                                if (widget.trainerUser.gym2Website != null) {
                                  launch(widget.trainerUser.gym2Website);
                                }
                              }
                            }
                            if (cardInfo == _cardInfoList[3]) {
                              if (prefs.getString('gym1Website') != null) {
                                launch(prefs.getString('gym1Website'));
                              } else {
                                if (widget.trainerUser.gym1Website != null) {
                                  launch(widget.trainerUser.gym1Website);
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20 * prefs.getDouble('height'),
                              right: 20 * prefs.getDouble('width'),
                            ),
                            child: Icon(Icons.public,
                                size: 22 * prefs.getDouble('height'),
                                color: Colors.white),
                          ),
                        )
                      ]),
                  Positioned(
                    top: 68 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "Address",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 11 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Positioned(
                    top: 100 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "Street: " +
                          (prefs.getString('gym4Street') != null && cardInfo == _cardInfoList[0]
                              ? prefs.getString('gym4Street')
                              : prefs.getString('gym3Street') != null && cardInfo == _cardInfoList[1]
                                  ? prefs.getString('gym3Street')
                                  : prefs.getString('gym2Street') != null && cardInfo == _cardInfoList[2]
                                      ? prefs.getString('gym2Street')
                                      : prefs.getString('gym1Street') != null &&
                                              cardInfo == _cardInfoList[3]
                                          ? prefs.getString('gym1Street')
                                          : (cardInfo == _cardInfoList[3]
                                                      ? widget.trainerUser
                                                          .gym1Street
                                                      : cardInfo == _cardInfoList[2]
                                                          ? widget.trainerUser
                                                              .gym2Street
                                                          : cardInfo == _cardInfoList[1]
                                                              ? widget
                                                                  .trainerUser
                                                                  .gym3Street
                                                              : widget
                                                                  .trainerUser
                                                                  .gym4Street) ==
                                                  ""
                                              ? ""
                                              : (cardInfo == _cardInfoList[3]
                                                  ? widget
                                                      .trainerUser.gym1Street
                                                  : cardInfo == _cardInfoList[2]
                                                      ? widget.trainerUser.gym2Street
                                                      : cardInfo == _cardInfoList[1] ? widget.trainerUser.gym3Street : widget.trainerUser.gym4Street)),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 14 * prefs.getDouble('height'),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Positioned(
                    top: 120 * prefs.getDouble('height'),
                    left: 20 * prefs.getDouble('width'),
                    child: Text(
                      "District: " +
                          (prefs.getString('gym4Sector') != null && cardInfo == _cardInfoList[0]
                              ? prefs.getString('gym4Sector')
                              : prefs.getString('gym3Sector') != null && cardInfo == _cardInfoList[1]
                                  ? prefs.getString('gym3Sector')
                                  : prefs.getString('gym2Sector') != null && cardInfo == _cardInfoList[2]
                                      ? prefs.getString('gym2Sector')
                                      : prefs.getString('gym1Sector') != null &&
                                              cardInfo == _cardInfoList[3]
                                          ? prefs.getString('gym1Sector')
                                          : (cardInfo == _cardInfoList[3]
                                                      ? widget.trainerUser
                                                          .gym1Sector
                                                      : cardInfo == _cardInfoList[2]
                                                          ? widget.trainerUser
                                                              .gym2Sector
                                                          : cardInfo == _cardInfoList[1]
                                                              ? widget
                                                                  .trainerUser
                                                                  .gym3Sector
                                                              : widget
                                                                  .trainerUser
                                                                  .gym4Sector) ==
                                                  ""
                                              ? ""
                                              : (cardInfo == _cardInfoList[3]
                                                  ? widget
                                                      .trainerUser.gym1Sector
                                                  : cardInfo == _cardInfoList[2]
                                                      ? widget.trainerUser.gym2Sector
                                                      : cardInfo == _cardInfoList[1] ? widget.trainerUser.gym3Sector : widget.trainerUser.gym4Sector)),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(210, 255, 255, 255).withOpacity(
                              cardInfo == _cardInfoList[3]
                                  ? 1
                                  : cardInfo.opacity > 0.7 &&
                                          cardInfo == _cardInfoList[2]
                                      ? cardInfo.opacity
                                      : cardInfo.opacity > 0.7 &&
                                              cardInfo == _cardInfoList[1]
                                          ? cardInfo.opacity
                                          : cardInfo.opacity > 0.7 &&
                                                  cardInfo == _cardInfoList[0]
                                              ? cardInfo.opacity
                                              : 0),
                          fontSize: 14 * prefs.getDouble('height'),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    return widgetList;
  }

  _updateCardsPosition(double offsetY) {
    void updatePosition(
        CardInfo cardInfo, double firstCardAtAreaIdx, int cardIdx) {
      double currentCardAtAreaIdx = firstCardAtAreaIdx + cardIdx;
      if (currentCardAtAreaIdx < 0) {
        cardInfo.positionY =
            positionY_line1 + currentCardAtAreaIdx * _outsideCardInterval;
        cardInfo.rotate = -90.0 /
            _outsideCardInterval *
            (positionY_line1 - cardInfo.positionY);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -90.0) cardInfo.rotate = -90.0;

        cardInfo.scale = 1.0 -
            0.2 / _outsideCardInterval * (positionY_line1 - cardInfo.positionY);
        if (cardInfo.scale < 0.8) cardInfo.scale = 0.8;
        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;
      } else if (currentCardAtAreaIdx >= 0 && currentCardAtAreaIdx < 1) {
        cardInfo.positionY =
            positionY_line1 + currentCardAtAreaIdx * _middleAreaHeight;
        cardInfo.rotate = -60.0 /
            (positionY_line2 - positionY_line1) *
            (cardInfo.positionY - positionY_line1);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;
        cardInfo.textOpacity = 0;
        cardInfo.scale = 1.0 -
            0.1 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.scale < 0.9) cardInfo.scale = 0.9;
        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;

        cardInfo.opacity = 1.0 -
            0.3 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAreaIdx >= 1) {
        cardInfo.positionY =
            positionY_line2 + (currentCardAtAreaIdx - 1) * _outsideCardInterval;
        cardInfo.textOpacity = 0;
        cardInfo.rotate = -60.0;
        cardInfo.scale = 0.9;
        cardInfo.opacity = 0.7;
      }
    }

    scrollOffsetY += offsetY;

    double firstCardAtAreaIdx = scrollOffsetY / _middleAreaHeight;
    prefs.setDouble('edgeParameter', firstCardAtAreaIdx);
    for (var i = 0; i < _cardInfoList.length; i++) {
      prefs.setInt('currentCard', firstCardAtAreaIdx.toInt() + 3);
      if (firstCardAtAreaIdx + 3 == _cardInfoList.length - 1 - i) {
        currentCard = _cardInfoList.length - 1 - i;
      }
      CardInfo cardInfo = _cardInfoList[_cardInfoList.length - 1 - i];
      updatePosition(cardInfo, firstCardAtAreaIdx, i);
    }
    setState(() {});
  }

  double deltaY = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails d) {
              deltaY = d.delta.dy;
              if (prefs.getDouble('edgeParameter') >= -3.01 &&
                  prefs.getDouble('edgeParameter') <= 0) {
                _updateCardsPosition(d.delta.dy);
              }
            },
            onVerticalDragEnd: (DragEndDetails d) {
              scrollOffsetY = (scrollOffsetY / _middleAreaHeight).round() *
                  _middleAreaHeight;
              _updateCardsPosition(0);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Positioned(
                    top: positionY_line1,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: positionY_line2,
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  ..._buildCards(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 140.0 * prefs.getDouble('height'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 9.0),
                      width: 90.0 * prefs.getDouble('width'),
                      height: 35.0 * prefs.getDouble('height'),
                      child: FlatButton(
                        onPressed: () => {
                          setState(() {
                            edit = true;
                          })
                        },
                        shape: StadiumBorder(),
                        child: Align(
                            alignment: Alignment.center, child: Container()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardInfo {
  String hintTextGym;
  String hintTextGymAddress;
  Color leftColor;
  Color rightColor;
  String userName;
  String cardCategory;
  double positionY = 0;
  double rotate = 0;
  double opacity = 0;
  double scale = 0;
  double textOpacity = 1;
  CardInfo(
      {this.userName,
      this.cardCategory,
      this.positionY,
      this.rotate,
      this.opacity,
      this.scale,
      this.leftColor,
      this.rightColor,
      this.hintTextGym,
      this.hintTextGymAddress});
}

class MyPopupRoute1 extends PopupRoute<void> {
  MyPopupRoute1({
    this.trainerUser,
    this.currentCard,
    this.parent,
    this.parentParent,
  });
  final _FirstPageState parentParent;
  final DetailsPage2State parent;
  final int currentCard;
  final TrainerUser trainerUser;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      EditGymCards(
          trainer: trainerUser,
          currentCard: currentCard,
          parent: parent,
          parentParent: parentParent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class EditGymCards extends StatefulWidget {
  final _FirstPageState parentParent;
  final DetailsPage2State parent;
  final TrainerUser trainer;
  final int currentCard;
  EditGymCards(
      {Key key,
      @required this.trainer,
      @required this.currentCard,
      @required this.parent,
      @required this.parentParent})
      : super(key: key);

  @override
  State createState() => EditGymCardsState(trainer: trainer);
}

class EditGymCardsState extends State<EditGymCards> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector, hintWebsite;

  EditGymCardsState({
    @required this.trainer,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff3E3E45)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30 * prefs.getDouble('height'),
                  ),
                  Text(
                    "Edit gym card",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 17 * prefs.getDouble('height'),
                        color: Color.fromARGB(200, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50 * prefs.getDouble('height'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    height: 73 * prefs.getDouble('width'),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLength: 20,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          height: 1.0 * prefs.getDouble('height'),
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.location_city,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: "Gym's name",
                      ),
                      onChanged: (String str) {
                        hintName = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 73 * prefs.getDouble('width'),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      maxLength: 25,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          height: 1 * prefs.getDouble('height'),
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: 'Street',
                      ),
                      onChanged: (String str) {
                        hintStreet = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 73 * prefs.getDouble('width'),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLength: 10,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.my_location,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: 'District',
                      ),
                      onChanged: (String str) {
                        hintSector = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 73 * prefs.getDouble('width'),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15 * prefs.getDouble('width')),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      maxLength: 100,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                                vertical:
                                    20.0 * MediaQuery.of(context).size.height) /
                            812,
                        fillColor: Color.fromARGB(255, 88, 88, 94),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(90.0),
                            borderSide: BorderSide(
                                color: mainColor,
                                style: BorderStyle.solid,
                                width: 2 * prefs.getDouble('height'))),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Icon(
                            Icons.public,
                            color: Color.fromARGB(255, 152, 152, 157),
                            size:
                                24.0 * MediaQuery.of(context).size.height / 812,
                          ),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        border: InputBorder.none,
                        hintText: 'Website',
                      ),
                      onChanged: (String str) {
                        hintWebsite = str;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20 * prefs.getDouble('height'),
                  ),
                  Container(
                    width: 150.0 * prefs.getDouble('width'),
                    height: 50.0 * prefs.getDouble('height'),
                    child: Material(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(90.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (hintWebsite == null || hintWebsite == "") {
                            Navigator.push(context, PopUpMissingCardsRoute());
                          } else {
                            if (hintName == null || hintName == "") {
                              Navigator.push(context, PopUpMissingCardsRoute());
                            } else {
                              if (hintSector == null || hintSector == "") {
                                Navigator.push(
                                    context, PopUpMissingCardsRoute());
                              } else {
                                if (hintStreet == null || hintStreet == "") {
                                  Navigator.push(
                                      context, PopUpMissingCardsRoute());
                                } else {
                                  var db = Firestore.instance;
                                  var batch = db.batch();
                                  if (hintWebsite != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}Website':
                                            '$hintWebsite',
                                      },
                                    );
                                  }
                                  if (hintName != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}':
                                            '$hintName',
                                      },
                                    );
                                  }
                                  if (hintStreet != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}Street':
                                            '$hintStreet',
                                      },
                                    );
                                  }
                                  if (hintSector != null) {
                                    batch.updateData(
                                      db
                                          .collection('clientUsers')
                                          .document(widget.trainer.id),
                                      {
                                        'gym${4 - widget.currentCard}Sector':
                                            '$hintSector',
                                      },
                                    );
                                  }

                                  batch.commit();
                                  if (4 - widget.currentCard == 1) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym1Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym1 =
                                          hintName;
                                      prefs.setString('gym1', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym1Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym1Sector', hintSector);
                                    }
                                  }
                                  if (4 - widget.currentCard == 2) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym2Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym2 =
                                          hintName;
                                      prefs.setString('gym2', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym2Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym2Sector', hintSector);
                                    }
                                  }
                                  if (4 - widget.currentCard == 3) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym3Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym3 =
                                          hintName;
                                      prefs.setString('gym3', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym3Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym3Sector', hintSector);
                                    }
                                  }
                                  if (4 - widget.currentCard == 4) {
                                    if (hintWebsite != null) {
                                      prefs.setString(
                                          'gym4Website', hintWebsite);
                                    }
                                    if (hintName != null) {
                                      widget.parent.widget.trainer.gym4 =
                                          hintName;
                                      prefs.setString('gym4', hintName);
                                    }
                                    if (hintStreet != null) {
                                      prefs.setString('gym4Street', hintStreet);
                                    }
                                    if (hintSector != null) {
                                      prefs.setString('gym4Sector', hintSector);
                                    }
                                  }
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          }
                        },
                        child: Text(
                          'Save changes',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 15.0 * prefs.getDouble('height'),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30 * prefs.getDouble('height'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopUpMissingCardsRoute extends PopupRoute<void> {
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      PopUpMissingCards();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpMissingCards extends StatefulWidget {
  @override
  State createState() => PopUpMissingCardsState();
}

class PopUpMissingCardsState extends State<PopUpMissingCards> {
  List<ReviewMapDelay> revs = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: secondaryColor,
          ),
          height: 256 * prefs.getDouble('height'),
          width: 313 * prefs.getDouble('width'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/completeallfieldsf1.svg',
                width: 180.0 * prefs.getDouble('width'),
                height: 100.0 * prefs.getDouble('height'),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Text(
                "Please complete all fields before submitting new changes!",
                style: TextStyle(
                  fontSize: 16 * prefs.getDouble('height'),
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
