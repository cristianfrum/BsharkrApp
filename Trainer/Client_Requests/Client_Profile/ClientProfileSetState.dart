import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Client_Requests/Friends_Requests/Friends_Requests.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Meals/ManagingMeals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/BusinessList/Managing_Schedule/ManagingSchedule.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/Chat/chatscreen.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'dart:async';

import 'package:Bsharkr/models/trainerUser.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClientProfileSetState extends StatefulWidget {
  ClientProfileSetState(this.clientId, this.trainerId, this.parent) : super();
  final String clientId;
  final FriendsRequestsState parent;
  final String trainerId;

  @override
  _ClientProfileSetStateState createState() => _ClientProfileSetStateState();
}

class _ClientProfileSetStateState extends State<ClientProfileSetState>
    with SingleTickerProviderStateMixin {
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;
  bool flagBusinessAccepted = false;
  bool flagFriendshipAccepted = false;
  bool flagFriendshipPending = false;
  bool flagBusinessPending = false;
  bool restart = false;
  Future _getClientData;
  Future _getTrainerData;
  TrainerUser _trainerUser;
  int specializationCounter = 0;

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

  ClientUser bookedClient;

  @override
  void initState() {
   
    super.initState();
    _getTrainerData = getDataTrainer();
    _getClientData = getDataClient();
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

  Future<QuerySnapshot> getDataTrainer() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();
  }

  Future<QuerySnapshot> getDataClient() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: widget.clientId,
        )
        .getDocuments();
  }

  bool availabilityFlag = false;

  bool preferences(String preference) {
    bool result = false;
    bookedClient.preferencesList.forEach((clientPreference) {
      if (clientPreference.preference == preference)
        result = clientPreference.wanted;
    });
    return result;
  }

   showSetHour2(int index) {
    if (index == 1) {
      if (bookedClient.availability.mondayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day1 == 'true') {
          return (bookedClient.hour2Availability.day1.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day1.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day1.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day1
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return " hour";
        }
      }
    }

    if (index == 2) {
      if (bookedClient.availability.mondayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day2 == 'true') {
          return (bookedClient.hour2Availability.day2.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day2.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day2.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day2
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 3) {
      if (bookedClient.availability.mondayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day3 == 'true') {
          return (bookedClient.hour2Availability.day3.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day3.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day3.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day3
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 4) {
      if (bookedClient.availability.tuesdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day4 == 'true') {
          return (bookedClient.hour2Availability.day4.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day4.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day4.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day4
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 5) {
      if (bookedClient.availability.tuesdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day5 == 'true') {
          return (bookedClient.hour2Availability.day5.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day5.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day5.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day5
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 6) {
      if (bookedClient.availability.tuesdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day6 == 'true') {
          return (bookedClient.hour2Availability.day6.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day6.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day6.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day6
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 7) {
      if (bookedClient.availability.wednesdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day7 == 'true') {
          return (bookedClient.hour2Availability.day7.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day7.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day7.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day7
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 8) {
      if (bookedClient.availability.wednesdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day8 == 'true') {
          return (bookedClient.hour2Availability.day8.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day8.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day8.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day8
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day8
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 9) {
      if (bookedClient.availability.wednesdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day9 == 'true') {
          return (bookedClient.hour2Availability.day9.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day9.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day9.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day9
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day9
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 10) {
      if (bookedClient.availability.thursdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day10 == 'true') {
          return (bookedClient.hour2Availability.day10.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day10.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day10.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day10
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day10
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 11) {
      if (bookedClient.availability.thursdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day11 == 'true') {
          return (bookedClient.hour2Availability.day11.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day11.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day11.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day11
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day11
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 12) {
      if (bookedClient.availability.thursdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day12 == 'true') {
          return (bookedClient.hour2Availability.day12.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day12.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day12.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day12
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day12
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 13) {
      if (bookedClient.availability.fridayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day13 == 'true') {
          return (bookedClient.hour2Availability.day13.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day13.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day13.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day13
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day13
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 14) {
      if (bookedClient.availability.fridayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day14 == 'true') {
          return (bookedClient.hour2Availability.day14.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day14.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day14.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day14
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day14
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 15) {
      if (bookedClient.availability.fridayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day15 == 'true') {
          return (bookedClient.hour2Availability.day15.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day15.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day15.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day15
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day15
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 16) {
      if (bookedClient.availability.saturdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day16 == 'true') {
          return (bookedClient.hour2Availability.day16.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day16.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day16.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day16
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day16
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 17) {
      if (bookedClient.availability.saturdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day17 == 'true') {
          return (bookedClient.hour2Availability.day17.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day17.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day17.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day17
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day17
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 18) {
      if (bookedClient.availability.saturdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day18 == 'true') {
          return (bookedClient.hour2Availability.day18.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day18.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day18.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day18
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day18
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 19) {
      if (bookedClient.availability.sundayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day19 == 'true') {
          return (bookedClient.hour2Availability.day19.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day19.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day19.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day19
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day19
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 20) {
      if (bookedClient.availability.sundayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day20 == 'true') {
          return (bookedClient.hour2Availability.day20.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day20.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day20.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day20
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day20
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 21) {
      if (bookedClient.availability.sundayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailabilityV2.day21 == 'true') {
          return (bookedClient.hour2Availability.day21.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour2Availability.day21.toDate().hour.toString() +
              " : " +
              (bookedClient.hour2Availability.day21.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour2Availability.day21
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour2Availability.day21
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
      if (bookedClient.availability.mondayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day1 == 'true') {
          return (bookedClient.hour1Availability.day1.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day1.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day1.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day1
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day1
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour ";
        }
      }
    }

    if (index == 2) {
      if (bookedClient.availability.mondayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day2 == 'true') {
          return (bookedClient.hour1Availability.day2.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day2.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day2.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day2
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day2
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 3) {
      if (bookedClient.availability.mondayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day3 == 'true') {
          return (bookedClient.hour1Availability.day3.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day3.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day3.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day3
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day3
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 4) {
      if (bookedClient.availability.tuesdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day4 == 'true') {
          return (bookedClient.hour1Availability.day4.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day4.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day4.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day4
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day4
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 5) {
      if (bookedClient.availability.tuesdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day5 == 'true') {
          return (bookedClient.hour1Availability.day5.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day5.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day5.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day5
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day5
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 6) {
      if (bookedClient.availability.tuesdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day6 == 'true') {
          return (bookedClient.hour1Availability.day6.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day6.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day6.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day6
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day6
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 7) {
      if (bookedClient.availability.wednesdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day7 == 'true') {
          return (bookedClient.hour1Availability.day7.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day7.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day7.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day7
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day7
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 8) {
      if (bookedClient.availability.wednesdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day8 == 'true') {
          return (bookedClient.hour1Availability.day8.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day8.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day8.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day8
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day8
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 9) {
      if (bookedClient.availability.wednesdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day9 == 'true') {
          return (bookedClient.hour1Availability.day9.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day9.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day9.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day9
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day9
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 10) {
      if (bookedClient.availability.thursdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day10 == 'true') {
          return (bookedClient.hour1Availability.day10.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day10.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day10.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day10
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day10
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 11) {
      if (bookedClient.availability.thursdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day11 == 'true') {
          return (bookedClient.hour1Availability.day11.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day11.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day11.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day11
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day11
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 12) {
      if (bookedClient.availability.thursdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day12 == 'true') {
          return (bookedClient.hour1Availability.day12.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day12.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day12.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day12
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day12
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 13) {
      if (bookedClient.availability.fridayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day13 == 'true') {
          return (bookedClient.hour1Availability.day13.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day13.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day13.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day13
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day13
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 14) {
      if (bookedClient.availability.fridayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day14 == 'true') {
          return (bookedClient.hour1Availability.day14.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day14.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day14.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day14
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day14
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 15) {
      if (bookedClient.availability.fridayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day15 == 'true') {
          return (bookedClient.hour1Availability.day15.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day15.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day15.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day15
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day15
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 16) {
      if (bookedClient.availability.saturdayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day16 == 'true') {
          return (bookedClient.hour1Availability.day16.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day16.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day16.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day16
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day16
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 17) {
      if (bookedClient.availability.saturdayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day17 == 'true') {
          return (bookedClient.hour1Availability.day17.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day17.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day17.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day17
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day17
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 18) {
      if (bookedClient.availability.saturdayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day18 == 'true') {
          return (bookedClient.hour1Availability.day18.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day18.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day18.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day18
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day18
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 19) {
      if (bookedClient.availability.sundayMorning.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day19 == 'true') {
          return (bookedClient.hour1Availability.day19.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day19.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day19.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day19
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day19
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 20) {
      if (bookedClient.availability.sundayMidday.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day20 == 'true') {
          return (bookedClient.hour1Availability.day20.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day20.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day20.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day20
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day20
                      .toDate()
                      .minute
                      .toString());
        } else {
          return "hour";
        }
      }
    }

    if (index == 21) {
      if (bookedClient.availability.sundayEvening.toString() == "Busy")
        return "";
      else {
        if (bookedClient.checkDailyAvailability.day21 == 'true') {
          return (bookedClient.hour1Availability.day21.toDate().hour < 10
                  ? "0"
                  : "") +
              bookedClient.hour1Availability.day21.toDate().hour.toString() +
              " : " +
              (bookedClient.hour1Availability.day21.toDate().minute.toInt() < 10
                  ? ("0" +
                      bookedClient.hour1Availability.day21
                          .toDate()
                          .minute
                          .toString())
                  : bookedClient.hour1Availability.day21
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
    return FutureBuilder<QuerySnapshot>(
        future: _getTrainerData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
              color: backgroundColor,
            );
          }
          return FutureBuilder<QuerySnapshot>(
              future: _getClientData,
              builder: (ctx, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting ||
                    snapshot1.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                      ),
                    ),
                    color: backgroundColor,
                  );
                }
                if (restart == false) {
                  _trainerUser = TrainerUser(snapshot.data.documents[0]);
                  bookedClient = ClientUser(snapshot1.data.documents[0]);
                }
                specializationCounter = 0;
                bookedClient.preferencesList.forEach((preference) {
                  if (preference.wanted == true) {
                    preferencesList.add(preference.preference);
                    specializationCounter++;
                  }
                });
                _trainerUser.clients.forEach((client) {
                  if (client.clientId == bookedClient.id &&
                      client.clientAccepted == true)
                    flagBusinessAccepted = true;
                });
                _trainerUser.friends.forEach((friend) {
                  if (friend.friendId == bookedClient.id &&
                      friend.friendAccepted == true)
                    flagFriendshipAccepted = true;
                });
                _trainerUser.friends.forEach((friend) {
                  if (friend.friendId == bookedClient.id &&
                      friend.friendAccepted == false)
                    flagFriendshipPending = true;
                });
                _trainerUser.clients.forEach((friend) {
                  if (friend.clientId == bookedClient.id &&
                      friend.clientAccepted == false)
                    flagBusinessPending = true;
                });

             List week = [
                  Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(1),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .mondayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(1),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(2),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .mondayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(2),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(3),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .mondayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(3),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .mondayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.mondayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .mondayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.mondayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .mondayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.mondayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(4),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .tuesdayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(4),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(5),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .tuesdayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(5),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(6),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .tuesdayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(6),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .tuesdayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .tuesdayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                        color: bookedClient.availability
                                                    .tuesdayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.tuesdayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                        color: bookedClient.availability
                                                    .tuesdayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .tuesdayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(7),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .wednesdayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(7),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(8),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .wednesdayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(8),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(9),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .wednesdayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(9),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .wednesdayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .wednesdayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .wednesdayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .wednesdayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .wednesdayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .wednesdayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(10),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .thursdayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(10),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(11),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .thursdayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(11),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(12),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .thursdayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(12),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .thursdayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .thursdayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .thursdayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .thursdayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .thursdayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .thursdayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(13),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .fridayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(13),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(14),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .fridayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(14),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(15),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .fridayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(15),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .fridayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.fridayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .fridayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.fridayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .fridayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.fridayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(16),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .saturdayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(16),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(17),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .saturdayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(17),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(18),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .saturdayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(18),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .saturdayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .saturdayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .saturdayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .saturdayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .saturdayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability
                                                  .saturdayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 5 * prefs.getDouble('height')),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                          fontSize:
                                              14 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0 * prefs.getDouble('height'),
                                    ),
                                    Container(
                                        height: 15 * prefs.getDouble('height'),
                                        width: 98 * prefs.getDouble('width'),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(19),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .sundayMorning ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(19),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(20),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .sundayMidday ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(20),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour1(21),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  12 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  bookedClient.availability
                                                              .sundayEvening ==
                                                          'Available'
                                                      ? " - "
                                                      : "",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 15 *
                                                  prefs.getDouble('height'),
                                              width:
                                                  43 * prefs.getDouble('width'),
                                              child: Center(
                                                child: Text(
                                                  showSetHour2(21),
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 13 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Color.fromARGB(
                                                          200, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .sundayMorning ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.sundayMorning ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .sundayMidday ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.sundayMidday ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                                            width:
                                                1 * prefs.getDouble('height')),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        color: bookedClient.availability
                                                    .sundayEvening ==
                                                'Available'
                                            ? prefix0.mainColor
                                            : Color(0xff57575E)),
                                    child: Text(
                                      bookedClient.availability.sundayEvening ==
                                              'Available'
                                          ? "Available"
                                          : "Busy",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize:
                                              12 * prefs.getDouble('height'),
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
                bookedClient.votesMap.forEach((element) {
                  votFinal = votFinal + element.vote;
                });

               if(votFinal != 0){
                  votFinal = (votFinal / bookedClient.votesMap.length).round();
               }
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
                          if (flagFriendshipAccepted == true) {
                            widget.parent.setState(() {
                              restart1 = true;
                              list1.removeWhere(
                                  (element) => element.id == bookedClient.id);
                            });
                          }
                        },
                      ),
                      centerTitle: true,
                      elevation: 0.0,
                      title: Text(
                        bookedClient.lastName == null
                            ? "nume"
                            : bookedClient.firstName +
                                " " +
                                bookedClient.lastName,
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
                            padding: EdgeInsets.only(
                                left: 32 * prefs.getDouble('width')),
                            child: InkWell(
                              onTap: (){  Navigator.push(
                                              context,
                                              ProfilePhotoPopUp(
                                                client: bookedClient,
                                              ));},
                                                          child: bookedClient.photoUrl == null
                                  ? ClipOval(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255,
                                                bookedClient.colorRed,
                                                bookedClient.colorGreen,
                                                bookedClient.colorBlue),
                                            shape: BoxShape.circle,
                                          ),
                                          height:
                                              (80 * prefs.getDouble('height')),
                                          width: (80 * prefs.getDouble('height')),
                                          child: Center(
                                            child: Text(
                                              bookedClient.firstName[0],
                                              style: TextStyle(
                                        fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 50 *
                                                      prefs.getDouble('height')),
                                            ),
                                          )),
                                    )
                                  : Material(
                                      child: Container(
                                        width: 80 * prefs.getDouble('height'),
                                        height: 80 * prefs.getDouble('height'),
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            shape: BoxShape.circle),
                                        child: Image.network(
                                          bookedClient.photoUrl,
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
                                        Radius.circular(77.5),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 32 * prefs.getDouble('width')),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Gender: " + bookedClient.gender,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                    letterSpacing:
                                        -0.408 * prefs.getDouble('width'),
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 17.0 * prefs.getDouble('height'),
                                    color: Color.fromARGB(80, 255, 255, 255),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Age: " +
                                      bookedClient.age.toString() +
                                      " years",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                    letterSpacing:
                                        -0.408 * prefs.getDouble('height'),
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
                                            client: bookedClient,
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
                              flagFriendshipPending == true
                                  ? Container(
                                      width: 310 * prefs.getDouble('width'),
                                      height: 32 * prefs.getDouble('height'),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(4),
                                        color: prefix0.secondaryColor,
                                        child: MaterialButton(
                                            onPressed: () async {
                                              QuerySnapshot query = await Firestore
                                                  .instance
                                                  .collection('clientUsers')
                                                  .where('id',
                                                      isEqualTo:
                                                          prefs.getString('id'))
                                                  .where(
                                                      'friendsMap.${bookedClient.id}',
                                                      isEqualTo: false)
                                                  .getDocuments();
                                              if (query.documents.length != 0) {
                                                  Firestore.instance
                                              .collection('clientUsers')
                                              .document(prefs.getString('id'))
                                              .updateData(
                                            {
                                              'friendsMap.${bookedClient.id}': true,
                                              'newFriend': true
                                            },
                                          );
                                          Firestore.instance
                                              .collection('clientUsers')
                                              .document(bookedClient.id)
                                              .updateData(
                                            {
                                              'friendsMap.${prefs.getString('id')}':
                                                  true,
                                              'newFriend': true
                                            },
                                          );

                                          QuerySnapshot query2 = await Firestore
                                              .instance
                                              .collection('pushNotifications')
                                              .where('id', isEqualTo: bookedClient.id)
                                              .getDocuments();
                                          Firestore.instance
                                              .collection(
                                                  'clientAcceptedFriendship')
                                              .document(bookedClient.id)
                                              .setData(
                                            {
                                              'idFrom': prefs.getString('id'),
                                              'idTo': bookedClient.id,
                                              'pushToken': query2.documents[0]
                                                  ['pushToken'],
                                              'nickname':
                                                _trainerUser.firstName
                                            },
                                          );
                                                setState(() {
                                                  var i = 0;
                                                  _trainerUser.friends
                                                      .forEach((friend) {
                                                    if (friend.friendId ==
                                                            bookedClient.id &&
                                                        friend.friendAccepted ==
                                                            false) {
                                                      _trainerUser.friends[i]
                                                              .friendAccepted =
                                                          true;
                                                    }
                                                    i++;
                                                  });
                                                  restart = true;
                                                  flagFriendshipPending = false;
                                                  flagFriendshipAccepted = true;
                                                });
                                              }
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
                                                  "Accept friend request",
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
                                  : flagFriendshipAccepted == true &&
                                          flagBusinessPending == false &&
                                          flagBusinessAccepted == false
                                      ? Container(
                                          width: 310 * prefs.getDouble('width'),
                                          height:
                                              32 * prefs.getDouble('height'),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: prefix0.secondaryColor,
                                            child: MaterialButton(
                                                onPressed: ()  {
                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Chat(
                                                        peerId: bookedClient.id,
                                                      ),
                                                    ),
                                                  );
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
                                                      Icons.message,
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
                                      : Container(),
                              flagBusinessPending == true
                                  ? Row(
                                      children: <Widget>[
                                        Container(
                                            child: Container(
                                          width: 150 * prefs.getDouble('width'),
                                          height:
                                              32 * prefs.getDouble('height'),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: prefix0.secondaryColor,
                                            child: MaterialButton(
                                                onPressed: () async {
                                                  QuerySnapshot query =
                                                      await Firestore.instance
                                                          .collection(
                                                              'clientUsers')
                                                          .where('id',
                                                              isEqualTo: prefs
                                                                  .getString(
                                                                      'id'))
                                                          .where(
                                                              'trainerMap.${bookedClient.id}',
                                                              isEqualTo: false)
                                                          .getDocuments();
                                                  if (query.documents.length !=
                                                      0) {
                                                    Firestore.instance
                                                        .collection(
                                                            'clientUsers')
                                                        .document(prefs
                                                            .getString('id'))
                                                        .updateData(
                                                      {
                                                        'trainerMap.${bookedClient.id}':
                                                            true,
                                                        'friendsMap.${bookedClient.id}':
                                                            FieldValue.delete()
                                                      },
                                                    );
                                                    Firestore.instance
                                                        .collection(
                                                            'clientUsers')
                                                        .document(
                                                            bookedClient.id)
                                                        .updateData(
                                                      {
                                                        'trainerMap.${prefs.getString('id')}':
                                                            true,
                                                        'friendsMap.${prefs.getString('id')}':
                                                            FieldValue.delete()
                                                      },
                                                    );
                                                    setState(
                                                      () {
                                                        var i = 0;
                                                        _trainerUser.clients
                                                            .forEach((client) {
                                                          if (client.clientId ==
                                                                  bookedClient
                                                                      .id &&
                                                              client.clientAccepted ==
                                                                  false) {
                                                            _trainerUser
                                                                    .clients[i]
                                                                    .clientAccepted =
                                                                true;
                                                            flagBusinessPending =
                                                                false;
                                                          }
                                                          i++;
                                                        });
                                                        restart = true;
                                                        flagBusinessPending =
                                                            false;
                                                        flagBusinessAccepted =
                                                            true;
                                                      },
                                                    );
                                                  }
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
                                                      "Accept colaborarea",
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
                                        )),
                                        SizedBox(
                                          width: 10 * prefs.getDouble('width'),
                                        ),
                                        Container(
                                            child: Container(
                                          width: 150 * prefs.getDouble('width'),
                                          height:
                                              32 * prefs.getDouble('height'),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: prefix0.secondaryColor,
                                            child: MaterialButton(
                                                onPressed: ()  {  
                                                  Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Chat(
                                                        peerId: bookedClient.id,
                                                      ),
                                                    ),
                                                  );
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
                                        ))
                                      ],
                                    )
                                  : flagBusinessAccepted == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                child: Container(
                                              width:
                                                  96 * prefs.getDouble('width'),
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
                                                        MyPopupRouteMeals(
                                                          clientUser:
                                                              bookedClient,
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
                                                          Icons.local_dining,
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
                                                          "Nutritie",
                                                          style: TextStyle(
                                      fontFamily: 'Roboto',
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
                                            )),
                                            SizedBox(
                                              width:
                                                  10 * prefs.getDouble('width'),
                                            ),
                                            Container(
                                                child: Container(
                                              width:
                                                  96 * prefs.getDouble('width'),
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
                                                          ManagingSchedule(
                                                              clientUser:
                                                                  bookedClient, imTrainer: _trainerUser));
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
                                                          "Program",
                                                          style: TextStyle(
                                      fontFamily: 'Roboto',
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
                                            )),
                                            SizedBox(
                                              width:
                                                  10 * prefs.getDouble('width'),
                                            ),
                                            Container(
                                                child: Container(
                                              width:
                                                  96 * prefs.getDouble('width'),
                                              height: 32 *
                                                  prefs.getDouble('height'),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: prefix0.secondaryColor,
                                                child: MaterialButton(
                                                    onPressed: ()  {  
                                                      Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Chat(
                                                            peerId:
                                                                bookedClient.id,
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
                                      fontFamily: 'Roboto',
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
                                        fontSize:
                                            17 * prefs.getDouble('width')),
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
                                        fontSize:
                                            17 * prefs.getDouble('width')),
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
                                                  15 *
                                                      prefs.getDouble('height'),
                                                  10 * prefs.getDouble('width'),
                                                  15 *
                                                      prefs
                                                          .getDouble('height')),
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
                                                borderRadius:
                                                    BorderRadius.circular(4.0 *
                                                        prefs.getDouble(
                                                            'height'))),
                                            height:
                                                32 * prefs.getDouble('height'),
                                            width:
                                                310 * prefs.getDouble('width'),
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
                                            ))
                                        : specializationCounter == 2
                                            ? Container(
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
                                      fontFamily: 'Roboto',
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
                                      fontFamily: 'Roboto',
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
                                            : specializationCounter == 3
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
                                      fontFamily: 'Roboto',
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
                                      fontFamily: 'Roboto',
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
                                      fontFamily: 'Roboto',
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
                                                : specializationCounter == 4
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
                                      fontFamily: 'Roboto',
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
                                      fontFamily: 'Roboto',
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
                                      fontFamily: 'Roboto',
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
                                      fontFamily: 'Roboto',
                                                                            fontSize:
                                                                                12 * prefs.getDouble('height'),
                                                                            fontWeight: FontWeight.w400,
                                                                            fontStyle: FontStyle.normal,
                                                                            color: Colors.white),
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
                                                                  decoration: BoxDecoration(
                                                                      color: prefix0
                                                                          .secondaryColor,
                                                                      borderRadius: BorderRadius.circular(4.0 *
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
                                                                      "${translate(preferencesList[4])}",
                                                                      style: TextStyle(
                                      fontFamily: 'Roboto',
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
                                                          )
                                                        : specializationCounter ==
                                                                6
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
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
                                                                            decoration:
                                                                                BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                            height: 32 * prefs.getDouble('height'),
                                                                            width: 150 * prefs.getDouble('width'),
                                                                            padding: EdgeInsets.all(
                                                                              8.0 * prefs.getDouble('height'),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${translate(preferencesList[0])}",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                              ),
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              10 * prefs.getDouble('width'),
                                                                        ),
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                            height: 32 * prefs.getDouble('height'),
                                                                            width: 150 * prefs.getDouble('width'),
                                                                            padding: EdgeInsets.all(
                                                                              8.0 * prefs.getDouble('height'),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${translate(preferencesList[1])}",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
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
                                                                            decoration:
                                                                                BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                            height: 32 * prefs.getDouble('height'),
                                                                            width: 150 * prefs.getDouble('width'),
                                                                            padding: EdgeInsets.all(
                                                                              8.0 * prefs.getDouble('height'),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${translate(preferencesList[2])}",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                              ),
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              10 * prefs.getDouble('width'),
                                                                        ),
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                            height: 32 * prefs.getDouble('height'),
                                                                            width: 150 * prefs.getDouble('width'),
                                                                            padding: EdgeInsets.all(
                                                                              8.0 * prefs.getDouble('height'),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${translate(preferencesList[3])}",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
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
                                                                            decoration:
                                                                                BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                            height: 32 * prefs.getDouble('height'),
                                                                            width: 150 * prefs.getDouble('width'),
                                                                            padding: EdgeInsets.all(
                                                                              8.0 * prefs.getDouble('height'),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${translate(preferencesList[5])}",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                              ),
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              10 * prefs.getDouble('width'),
                                                                        ),
                                                                        Container(
                                                                            decoration:
                                                                                BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                            height: 32 * prefs.getDouble('height'),
                                                                            width: 150 * prefs.getDouble('width'),
                                                                            padding: EdgeInsets.all(
                                                                              8.0 * prefs.getDouble('height'),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "${translate(preferencesList[6])}",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                              ),
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : specializationCounter ==
                                                                    7
                                                                ? Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        height: 32 *
                                                                            prefs.getDouble('height'),
                                                                        width: 310 *
                                                                            prefs.getDouble('width'),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                                decoration: BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                                height: 32 * prefs.getDouble('height'),
                                                                                width: 150 * prefs.getDouble('width'),
                                                                                padding: EdgeInsets.all(
                                                                                  8.0 * prefs.getDouble('height'),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "${translate(preferencesList[0])}",
                                                                                    style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                                  ),
                                                                                )),
                                                                            SizedBox(
                                                                              width: 10 * prefs.getDouble('width'),
                                                                            ),
                                                                            Container(
                                                                                decoration: BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                                height: 32 * prefs.getDouble('height'),
                                                                                width: 150 * prefs.getDouble('width'),
                                                                                padding: EdgeInsets.all(
                                                                                  8.0 * prefs.getDouble('height'),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "${translate(preferencesList[1])}",
                                                                                    style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
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
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                                decoration: BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                                height: 32 * prefs.getDouble('height'),
                                                                                width: 150 * prefs.getDouble('width'),
                                                                                padding: EdgeInsets.all(
                                                                                  8.0 * prefs.getDouble('height'),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "${translate(preferencesList[2])}",
                                                                                    style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                                  ),
                                                                                )),
                                                                            SizedBox(
                                                                              width: 10 * prefs.getDouble('width'),
                                                                            ),
                                                                            Container(
                                                                                decoration: BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                                height: 32 * prefs.getDouble('height'),
                                                                                width: 150 * prefs.getDouble('width'),
                                                                                padding: EdgeInsets.all(
                                                                                  8.0 * prefs.getDouble('height'),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "${translate(preferencesList[3])}",
                                                                                    style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
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
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                                decoration: BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                                height: 32 * prefs.getDouble('height'),
                                                                                width: 150 * prefs.getDouble('width'),
                                                                                padding: EdgeInsets.all(
                                                                                  8.0 * prefs.getDouble('height'),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "${translate(preferencesList[4])}",
                                                                                    style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                                  ),
                                                                                )),
                                                                            SizedBox(
                                                                              width: 10 * prefs.getDouble('width'),
                                                                            ),
                                                                            Container(
                                                                                decoration: BoxDecoration(color: prefix0.secondaryColor, borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                                height: 32 * prefs.getDouble('height'),
                                                                                width: 150 * prefs.getDouble('width'),
                                                                                padding: EdgeInsets.all(
                                                                                  8.0 * prefs.getDouble('height'),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "${translate(preferencesList[5])}",
                                                                                    style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                                  ),
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10 * prefs.getDouble('height')),
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              color: prefix0.secondaryColor,
                                                                              borderRadius: BorderRadius.circular(4.0 * prefs.getDouble('height'))),
                                                                          height: 32 * prefs.getDouble('height'),
                                                                          width: 310 * prefs.getDouble('width'),
                                                                          padding: EdgeInsets.all(
                                                                            8.0 *
                                                                                prefs.getDouble('height'),
                                                                          ),
                                                                          child: Center(
                                                                            child:
                                                                                Text(
                                                                              "${translate(preferencesList[6])}",
                                                                              style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 12 * prefs.getDouble('height'), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, color: Colors.white),
                                                                            ),
                                                                          ))
                                                                    ],
                                                                  )
                                                                : Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
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
                                                                          Text(
                                                                              "No preferences set",
                                                                              style: TextStyle(
                                      fontFamily: 'Roboto',fontSize: 17.0 * prefs.getDouble('height'), color: Colors.white, fontWeight: FontWeight.normal, letterSpacing: -0.408),
                                                                              textAlign: TextAlign.center),
                                                                          SizedBox(
                                                                              height: 8 * prefs.getDouble('height')),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 36.0 * prefs.getDouble('width')),
                                                                            child: Text("This person did not set up the preferences regarding the ideal trainer.",
                                                                                style: TextStyle(
                                      fontFamily: 'Roboto',
                                                                                  fontSize: 13.0 * prefs.getDouble('height'),
                                                                                  color: Color.fromARGB(100, 255, 255, 255),
                                                                                ),
                                                                                textAlign: TextAlign.center),
                                                                          ),
                                                                        ]),
                                                                  ),
                                  ),
                          )),
                      Container(
                        height: 220.0 * prefs.getDouble('height'),
                        width: 350.0 * prefs.getDouble('width'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 25.0 * prefs.getDouble('height'),
                            ),
                            Padding(
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
                            SizedBox(
                              height: 10.0 * prefs.getDouble('height'),
                            ),
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 32.0 * prefs.getDouble('width')),
                                  child: Container(
                                    child: Text(
                                      bookedClient.expectations == null ?
                                              "Introduce a brief description in order to help fitness trainers offer compatible services with your lifestyle. For a harmonious collaboration it is preferable that the expectations regarding your future trainer to be inserted."
                            
                                          : bookedClient.expectations,
                                      style: TextStyle(
                                      fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.normal,
                                          fontSize:
                                              15 * prefs.getDouble('height'),
                                          color: Color.fromARGB(
                                              200, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
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
  DetailsPage({Key key, @required this.client}) : super(key: key);

  @override
  State createState() => DetailsPageState(client: client);
}

class DetailsPageState extends State<DetailsPage> {
  String hinttText = "Scrie";
  Image image;
  final ClientUser client;

  String hintName, hintStreet, hintSector;

  DetailsPageState({
    @required this.client,
  });

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
        mainAxisSize: MainAxisSize.min, children: <Widget>[
        index != (reviews.length - 1)
            ? Container(
                width: double.infinity,
                height: 1 * prefs.getDouble('height'),
                color: Color.fromARGB(150, 255, 255, 255))
            : Container(),
        Padding(
          padding: EdgeInsets.only(top : 8 * prefs.getDouble('height'),bottom: 8 * prefs.getDouble('height'),left: 16 * prefs.getDouble('width'),right: 16 * prefs.getDouble('width'),),
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
                      revv[index].review != null ? revv[index].review : "",
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
            child: client.reviewsMap.length == 0
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
                                (client.reviewsMap.length < 5
                                    ? client.reviewsMap.length
                                    : 5) +
                            50)
                        .toDouble(),
                    child: Container(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0 * prefs.getDouble('height')),
                        itemBuilder: (context, index) => buildItem(
                            client.votesMap, index, client.reviewsMap),
                        itemCount: client.reviewsMap.length,
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
