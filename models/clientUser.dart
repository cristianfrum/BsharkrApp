import 'package:cloud_firestore/cloud_firestore.dart';

class ClientUser {
  bool appIsOn;
  bool dailyVote;
  int cardioSessions;
  int groupCounter;
  String id;
  String nickname;
  String photoUrl;
  String searchKeyFirstName;
  String role;
  String firstName, lastName;
  int votes;
  int workoutSessions;
  Map trainerMap;

  List<Preferences> preferencesList = [];
  List<List<Group>> groups = [];
  List<Friend1> friends = [];
  List<Users> unseenMessagesCounter = [];
  List<Votes> votesMap = [];
  List<Reviews> reviewsMap = [];
  MealsBreakfast mealsBreakfast;
  MealsLunch mealsLunch;
  MealsDinner mealsDinner;
  SessionsFirstWeek sessionsFirstWeek;
  TrainingSessionLocationName trainingSessionLocationName;
  TrainingSessionLocationStreet trainingSessionLocationStreet;
  TrainingSessionTrainerId trainingSessionTrainerId;
  TrainingSessionTrainerName trainingSessionTrainerName;
  SessionsSecondWeek sessionsSecondWeek;
  CheckFirstSchedule checkFirstSchedule;
  CheckSecondSchedule checkSecondSchedule;
  CheckDailyAvailability checkDailyAvailability;
  CheckDailyAvailabilityV2 checkDailyAvailabilityV2;
  Hour1Availability hour1Availability;
  Hour2Availability hour2Availability;
  ScheduleFirstWeek scheduleFirstWeek;
  ScheduleFirstWeek scheduleFirstEndWeek;
  ScheduleSecondWeek scheduleSecondWeek;
  ScheduleSecondWeek scheduleSecondEndWeek;
  Availability availability;
  int age;
  String gender;
  String expectations;
  int colorRed;
  int colorGreen;
  int colorBlue;
  bool newFriend;
  bool newBusiness;
  bool scheduleUpdated;
  bool mealPlanUpdated;
  GeoPoint locationGeopoint;
  String locationGeohash;
  List<Trainer> trainers = [];
  bool trainerRequestedClient;
  bool acceptTrainerRequests;
  int counterClassesClient;
  bool enrolled;
  List<Class> classes = [];
  String pushToken;
  bool newPrivateClass;
  bool deletedClient;
  List<NearbyList> nearbyList = [];
  bool popUpVote = false;
  bool popUpNotification = false;
  String classVote;

  ClientUser(DocumentSnapshot document) {
    if (document.data["location"] != null) {
      this.locationGeohash = document.data["location"]["geohash"] ?? null;

      this.locationGeopoint = document.data["location"]["geopoint"] ?? null;
    }
    this.appIsOn = document.data["appIsOn"];
    this.popUpVote = document.data["popUpVote"];
    this.popUpNotification = document.data["popUpNotification"];
    this.enrolled = document.data["enrolled"] ?? null;
    this.deletedClient = document.data["deletedClient"] ?? null;
    this.newPrivateClass = document.data["newPrivateClass"] ?? null;
    this.pushToken = document.data["pushToken"] ?? null;
    this.counterClassesClient = document.data["counterClassesClient"] ?? 0;
    this.acceptTrainerRequests = document.data["acceptTrainerRequests"] ?? null;
    this.colorRed = document.data["colorRed"];
    this.newFriend = document.data["newFriend"] ?? null;
    this.newBusiness = document.data["newBusiness"] ?? null;
    this.scheduleUpdated = document.data["scheduleUpdated"] ?? null;
    this.trainerRequestedClient =
        document.data["trainerRequestedClient"] ?? null;
    this.mealPlanUpdated = document.data["mealPlanUpdated"] ?? null;
    this.colorGreen = document.data["colorGreen"];
    this.colorBlue = document.data["colorBlue"];
    this.availability = Availability(document.data["day"]);
    this.expectations = document.data["expectations"] ?? null;
    this.gender = document.data["gender"];
    this.age = document.data["age"];
    this.firstName = document.data["firstName"];
    this.lastName = document.data["lastName"];
    this.dailyVote = document.data["dailyVote"];
    this.cardioSessions = document.data["cardios"] ?? 0;
    this.groupCounter = document.data["groupCounter"] ?? 0;
    this.id = document.documentID;
    this.nickname = document.data["nickname"];
    this.photoUrl = document.data["photoUrl"] ?? null;
    this.classVote = document.data["classVote"] ?? null;
    this.role = document.data["role"] ?? null;
    this.workoutSessions = document.data["works"] ?? 0;
    this.mealsBreakfast = MealsBreakfast(document.data["mealsBreakfast"]);
    this.mealsLunch = MealsLunch(document.data["mealsLunch"]);
    this.mealsDinner = MealsDinner(document.data["mealsDinner"]);

    this.sessionsFirstWeek = SessionsFirstWeek(document.data["schedule1"]);
    this.trainingSessionLocationName = TrainingSessionLocationName(
        document.data["trainingSessionLocationName"]);
    this.trainingSessionLocationStreet = TrainingSessionLocationStreet(
        document.data["trainingSessionLocationStreet"]);
    this.trainingSessionTrainerId =
        TrainingSessionTrainerId(document.data["trainingSessionTrainerId"]);
    this.trainingSessionTrainerName =
        TrainingSessionTrainerName(document.data["trainingSessionTrainerName"]);
    this.sessionsSecondWeek = SessionsSecondWeek(document.data["schedule2"]);
    this.checkDailyAvailabilityV2 =
        CheckDailyAvailabilityV2(document.data["checkDay2"]);
    this.checkFirstSchedule =
        CheckFirstSchedule(document.data["scheduleBool1"]);
    this.checkDailyAvailability =
        CheckDailyAvailability(document.data["checkDay"]);
    this.checkSecondSchedule =
        CheckSecondSchedule(document.data["scheduleBool2"]);

    this.hour1Availability = Hour1Availability(document.data["hour1Day"]);
    this.hour2Availability = Hour2Availability(document.data["hour2Day"]);
    this.scheduleFirstWeek = ScheduleFirstWeek(document.data["scheduleHour1"]);
    this.scheduleFirstEndWeek =
        ScheduleFirstWeek(document.data["scheduleHour1End"]);
    this.scheduleSecondEndWeek =
        ScheduleSecondWeek(document.data["scheduleHour2End"]);
    this.scheduleSecondWeek =
        ScheduleSecondWeek(document.data["scheduleHour2"]);

    for (int i = 0; i < (document.data["nearby"] as Map).length; ++i) {
      String key = (document.data["nearby"] as Map).keys.toList()[i].toString();
      bool value = (document.data["nearby"] as Map)[key];
      nearbyList.add(NearbyList(key, value));
    }

    for (int j = 1; j <= counterClassesClient; j++) {
      if (document.data["class$j"] as Map != null) {
        String key = document.data["class$j"]["dateAndTime"];
        String key1 = document.data["class$j"]["individualPrice"];
        String key2 = document.data["class$j"]["memberPrice"];
        String key3 = document.data["class$j"]["locationName"];
        String key4 = document.data["class$j"]["locationDistrict"];
        String key5 = document.data["class$j"]["locationStreet"];
        String key6 = document.data["class$j"]["classLevel"];
        bool key7 = document.data["class$j"]["public"];
        String key8 = document.data["class$j"]["type"];
        int key9 = document.data["class$j"]["spots"];
        Timestamp key10 = document.data["class$j"]["dateAndTimeDateTime"];
        Timestamp key11 = document.data["class$j"]["duration"];
        String key14 = document.data["class$j"]["trainerId"];
        String key15 = document.data["class$j"]["trainerFirstName"];
        String key16 = document.data["class$j"]["trainerLastName"];
        String key17 = document.data["class$j"]["gymWebsite"];

        int key13 = document.data["class$j"]["number"];
        classes.add(Class(key, key1, key2, key3, key4, key5, key6, key7, key8,
            key9, key10, key11, key13, key14, key15, key16, key17));
      }
    }

    for (int i = 0; i < (document.data["preferencesList"] as Map).length; ++i) {
      String key =
          (document.data["preferencesList"] as Map).keys.toList()[i].toString();
      bool value = (document.data["preferencesList"] as Map)[key];
      preferencesList.add(Preferences(key, value));
    }

    for (int i = 0;
        i <
            (document.data["unseenMessagesCounter"] as Map)
                .keys
                .toList()
                .length;
        ++i) {
      String key = (document.data["unseenMessagesCounter"] as Map)
          .keys
          .toList()[i]
          .toString();
      int value = (document.data["unseenMessagesCounter"] as Map)[key];
      unseenMessagesCounter.add(Users(key, value));
    }

    for (int i = 0;
        i < (document.data["votesMap"] as Map).keys.toList().length;
        ++i) {
      String key =
          (document.data["votesMap"] as Map).keys.toList()[i].toString();
      int value = (document.data["votesMap"] as Map)[key];
      votesMap.add(Votes(key, value));
    }

    List<String> reviewsList = [];
    List<int> keysList = [];

    for (int i = 0;
        i < (document.data["reviewsMap"] as Map).keys.toList().length;
        ++i) {
      String value = (document.data["reviewsMap"] as Map)["${i + 1}"];
      reviewsMap.add(Reviews("${i + 1}", value));
    }

    for (int i = 0; i < (document.data["friendsMap"] as Map).length; ++i) {
      String key =
          (document.data["friendsMap"] as Map).keys.toList()[i].toString();
      bool value = (document.data["friendsMap"] as Map)[key];
      friends.add(Friend1(key, value));
    }

    for (int i = 0; i < (document.data["trainersMap"] as Map).length; ++i) {
      String key =
          (document.data["trainersMap"] as Map).keys.toList()[i].toString();
      bool value = (document.data["trainersMap"] as Map)[key];
      trainers.add(Trainer(key, value));
    }

    for (int j = 1; j <= groupCounter; j++) {
      List<Group> _temp = [];
      for (int i = 0; i < (document.data["group$j"] as Map).length; ++i) {
        String key =
            (document.data["group$j"] as Map).keys.toList()[i].toString();
        String value = (document.data["group$j"] as Map)[key];
        _temp.add(Group(key, value));
      }
      groups.add(_temp);
    }
  }
}

class Users {
  String userId;
  int counter;

  Users(String userId, int counter) {
    this.userId = userId;
    this.counter = counter;
  }
}

class Votes {
  String counter;
  int vote;

  Votes(String counter, int vote) {
    this.counter = counter;
    this.vote = vote;
  }
}

class Reviews {
  String counter;
  String review;

  Reviews(String counter, String review) {
    this.counter = counter;
    this.review = review;
  }
}

class Friend1 {
  String friendId;
  bool friendAccepted;

  Friend1(String friendId, bool friendAccepted) {
    this.friendId = friendId;
    this.friendAccepted = friendAccepted;
  }
}

class NearbyList {
  String id;
  bool flag;

  NearbyList(String id, bool flag) {
    this.id = id;
    this.flag = flag;
  }
}

class Availability {
  String mondayMorning;
  String mondayMidday;
  String mondayEvening;
  String tuesdayMorning;
  String tuesdayMidday;
  String tuesdayEvening;
  String wednesdayMorning;
  String wednesdayMidday;
  String wednesdayEvening;
  String thursdayMorning;
  String thursdayMidday;
  String thursdayEvening;
  String fridayMorning;
  String fridayMidday;
  String fridayEvening;
  String saturdayMorning;
  String saturdayMidday;
  String saturdayEvening;
  String sundayMorning;
  String sundayMidday;
  String sundayEvening;

  Availability(Map<dynamic, dynamic> map) {
    if (map == null || map.length == 0) {
      this.mondayMorning = 'Ocupat';
      this.mondayMidday = 'Ocupat';
      this.mondayEvening = 'Ocupat';
      this.tuesdayMorning = 'Ocupat';
      this.tuesdayMidday = 'Ocupat';
      this.tuesdayEvening = 'Ocupat';
      this.wednesdayMorning = 'Ocupat';
      this.wednesdayMidday = 'Ocupat';
      this.wednesdayEvening = 'Ocupat';
      this.thursdayMorning = 'Ocupat';
      this.thursdayMidday = 'Ocupat';
      this.thursdayEvening = 'Ocupat';
      this.fridayMorning = 'Ocupat';
      this.fridayMidday = 'Ocupat';
      this.fridayEvening = 'Ocupat';
      this.saturdayMorning = 'Ocupat';
      this.saturdayMidday = 'Ocupat';
      this.saturdayEvening = 'Ocupat';
      this.sundayMorning = 'Ocupat';
      this.sundayMidday = 'Ocupat';
      this.sundayEvening = 'Ocupat';
    } else {
      this.mondayMorning = map["1"].toString();
      this.mondayMidday = map["2"].toString();
      this.mondayEvening = map["3"].toString();
      this.tuesdayMorning = map["4"].toString();
      this.tuesdayMidday = map["5"].toString();
      this.tuesdayEvening = map["6"].toString();
      this.wednesdayMorning = map["7"].toString();
      this.wednesdayMidday = map["8"].toString();
      this.wednesdayEvening = map["9"].toString();
      this.thursdayMorning = map["10"].toString();
      this.thursdayMidday = map["11"].toString();
      this.thursdayEvening = map["12"].toString();
      this.fridayMorning = map["13"].toString();
      this.fridayMidday = map["14"].toString();
      this.fridayEvening = map["15"].toString();
      this.saturdayMorning = map["16"].toString();
      this.saturdayMidday = map["17"].toString();
      this.saturdayEvening = map["18"].toString();
      this.sundayMorning = map["19"].toString();
      this.sundayMidday = map["20"].toString();
      this.sundayEvening = map["21"].toString();
    }
  }
}

class MealsBreakfast {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  MealsBreakfast(Map<dynamic, dynamic> map) {
    if (map == null || map.length == 0) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
      this.day8 = 'default';
      this.day9 = 'default';
      this.day10 = 'default';
      this.day11 = 'default';
      this.day12 = 'default';
      this.day13 = 'default';
      this.day14 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class MealsDinner {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  MealsDinner(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
      this.day8 = 'default';
      this.day9 = 'default';
      this.day10 = 'default';
      this.day11 = 'default';
      this.day12 = 'default';
      this.day13 = 'default';
      this.day14 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class Trainer {
  String trainerId;
  bool trainerAccepted;

  Trainer(String trainerId, bool trainerAccepted) {
    this.trainerId = trainerId;
    this.trainerAccepted = trainerAccepted;
  }
}

class MealsLunch {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  MealsLunch(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
      this.day8 = 'default';
      this.day9 = 'default';
      this.day10 = 'default';
      this.day11 = 'default';
      this.day12 = 'default';
      this.day13 = 'default';
      this.day14 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class SessionsFirstWeek {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;

  SessionsFirstWeek(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
    }
  }
}

class TrainingSessionLocationName {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  TrainingSessionLocationName(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = '';
      this.day2 = '';
      this.day3 = '';
      this.day4 = '';
      this.day5 = '';
      this.day6 = '';
      this.day7 = '';
      this.day8 = '';
      this.day9 = '';
      this.day10 = '';
      this.day11 = '';
      this.day12 = '';
      this.day13 = '';
      this.day14 = '';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class TrainingSessionLocationStreet {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  TrainingSessionLocationStreet(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = '';
      this.day2 = '';
      this.day3 = '';
      this.day4 = '';
      this.day5 = '';
      this.day6 = '';
      this.day7 = '';
      this.day8 = '';
      this.day9 = '';
      this.day10 = '';
      this.day11 = '';
      this.day12 = '';
      this.day13 = '';
      this.day14 = '';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class TrainingSessionTrainerName {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  TrainingSessionTrainerName(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = '';
      this.day2 = '';
      this.day3 = '';
      this.day4 = '';
      this.day5 = '';
      this.day6 = '';
      this.day7 = '';
      this.day8 = '';
      this.day9 = '';
      this.day10 = '';
      this.day11 = '';
      this.day12 = '';
      this.day13 = '';
      this.day14 = '';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class TrainingSessionTrainerId {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;

  TrainingSessionTrainerId(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = '';
      this.day2 = '';
      this.day3 = '';
      this.day4 = '';
      this.day5 = '';
      this.day6 = '';
      this.day7 = '';
      this.day8 = '';
      this.day9 = '';
      this.day10 = '';
      this.day11 = '';
      this.day12 = '';
      this.day13 = '';
      this.day14 = '';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
    }
  }
}

class SessionsSecondWeek {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;

  SessionsSecondWeek(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
    }
  }
}

class Preferences {
  String preference;
  bool wanted;

  Preferences(String preference, bool wanted) {
    this.preference = preference;
    this.wanted = wanted;
  }
}

class CheckDailyAvailability {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;
  String day15;
  String day16;
  String day17;
  String day18;
  String day19;
  String day20;
  String day21;

  CheckDailyAvailability(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
      this.day8 = 'default';
      this.day9 = 'default';
      this.day10 = 'default';
      this.day11 = 'default';
      this.day12 = 'default';
      this.day13 = 'default';
      this.day14 = 'default';
      this.day15 = 'default';
      this.day16 = 'default';
      this.day17 = 'default';
      this.day18 = 'default';
      this.day19 = 'default';
      this.day20 = 'default';
      this.day21 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
      this.day15 = map["15"].toString();
      this.day16 = map["16"].toString();
      this.day17 = map["17"].toString();
      this.day18 = map["18"].toString();
      this.day19 = map["19"].toString();
      this.day20 = map["20"].toString();
      this.day21 = map["21"].toString();
    }
  }
}

class CheckDailyAvailabilityV2 {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;
  String day15;
  String day16;
  String day17;
  String day18;
  String day19;
  String day20;
  String day21;

  CheckDailyAvailabilityV2(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
      this.day8 = 'default';
      this.day9 = 'default';
      this.day10 = 'default';
      this.day11 = 'default';
      this.day12 = 'default';
      this.day13 = 'default';
      this.day14 = 'default';
      this.day15 = 'default';
      this.day16 = 'default';
      this.day17 = 'default';
      this.day18 = 'default';
      this.day19 = 'default';
      this.day20 = 'default';
      this.day21 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
      this.day8 = map["8"].toString();
      this.day9 = map["9"].toString();
      this.day10 = map["10"].toString();
      this.day11 = map["11"].toString();
      this.day12 = map["12"].toString();
      this.day13 = map["13"].toString();
      this.day14 = map["14"].toString();
      this.day15 = map["15"].toString();
      this.day16 = map["16"].toString();
      this.day17 = map["17"].toString();
      this.day18 = map["18"].toString();
      this.day19 = map["19"].toString();
      this.day20 = map["20"].toString();
      this.day21 = map["21"].toString();
    }
  }
}

class CheckFirstSchedule {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;

  CheckFirstSchedule(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
    }
  }
}

class CheckSecondSchedule {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;

  CheckSecondSchedule(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.day1 = 'default';
      this.day2 = 'default';
      this.day3 = 'default';
      this.day4 = 'default';
      this.day5 = 'default';
      this.day6 = 'default';
      this.day7 = 'default';
    } else {
      this.day1 = map["1"].toString();
      this.day2 = map["2"].toString();
      this.day3 = map["3"].toString();
      this.day4 = map["4"].toString();
      this.day5 = map["5"].toString();
      this.day6 = map["6"].toString();
      this.day7 = map["7"].toString();
    }
  }
}

class Hour1Availability {
  Timestamp day1;
  Timestamp day2;
  Timestamp day3;
  Timestamp day4;
  Timestamp day5;
  Timestamp day6;
  Timestamp day7;
  Timestamp day8;
  Timestamp day9;
  Timestamp day10;
  Timestamp day11;
  Timestamp day12;
  Timestamp day13;
  Timestamp day14;
  Timestamp day15;
  Timestamp day16;
  Timestamp day17;
  Timestamp day18;
  Timestamp day19;
  Timestamp day20;
  Timestamp day21;

  Hour1Availability(Map<dynamic, dynamic> map) {
    if (map == null) {
      day1 = null;
      day2 = null;
      day3 = null;
      day4 = null;
      day5 = null;
      day6 = null;
      day7 = null;
      day8 = null;
      day9 = null;
      day10 = null;
      day11 = null;
      day12 = null;
      day13 = null;
      day14 = null;
      day15 = null;
      day16 = null;
      day17 = null;
      day18 = null;
      day19 = null;
      day20 = null;
      day21 = null;
    } else {
      this.day1 = map["1"];
      this.day2 = map["2"];
      this.day3 = map["3"];
      this.day4 = map["4"];
      this.day5 = map["5"];
      this.day6 = map["6"];
      this.day7 = map["7"];

      this.day8 = map["8"];
      this.day9 = map["9"];
      this.day10 = map["10"];
      this.day11 = map["11"];
      this.day12 = map["12"];
      this.day13 = map["13"];
      this.day14 = map["14"];

      this.day15 = map["15"];
      this.day16 = map["16"];
      this.day17 = map["17"];
      this.day18 = map["18"];
      this.day19 = map["19"];
      this.day20 = map["20"];
      this.day21 = map["21"];
    }
  }
}

class Hour2Availability {
  Timestamp day1;
  Timestamp day2;
  Timestamp day3;
  Timestamp day4;
  Timestamp day5;
  Timestamp day6;
  Timestamp day7;
  Timestamp day8;
  Timestamp day9;
  Timestamp day10;
  Timestamp day11;
  Timestamp day12;
  Timestamp day13;
  Timestamp day14;
  Timestamp day15;
  Timestamp day16;
  Timestamp day17;
  Timestamp day18;
  Timestamp day19;
  Timestamp day20;
  Timestamp day21;

  Hour2Availability(Map<dynamic, dynamic> map) {
    if (map == null) {
      day1 = null;
      day2 = null;
      day3 = null;
      day4 = null;
      day5 = null;
      day6 = null;
      day7 = null;
      day8 = null;
      day9 = null;
      day10 = null;
      day11 = null;
      day12 = null;
      day13 = null;
      day14 = null;
      day15 = null;
      day16 = null;
      day17 = null;
      day18 = null;
      day19 = null;
      day20 = null;
      day21 = null;
    } else {
      this.day1 = map["1"];
      this.day2 = map["2"];
      this.day3 = map["3"];
      this.day4 = map["4"];
      this.day5 = map["5"];
      this.day6 = map["6"];
      this.day7 = map["7"];

      this.day8 = map["8"];
      this.day9 = map["9"];
      this.day10 = map["10"];
      this.day11 = map["11"];
      this.day12 = map["12"];
      this.day13 = map["13"];
      this.day14 = map["14"];

      this.day15 = map["15"];
      this.day16 = map["16"];
      this.day17 = map["17"];
      this.day18 = map["18"];
      this.day19 = map["19"];
      this.day20 = map["20"];
      this.day21 = map["21"];
    }
  }
}

class ScheduleFirstWeek {
  Timestamp day1;
  Timestamp day2;
  Timestamp day3;
  Timestamp day4;
  Timestamp day5;
  Timestamp day6;
  Timestamp day7;

  ScheduleFirstWeek(Map<dynamic, dynamic> map) {
    if (map == null) {
      day1 = null;
      day2 = null;
      day3 = null;
      day4 = null;
      day5 = null;
      day6 = null;
      day7 = null;
    } else {
      this.day1 = map["1"];
      this.day2 = map["2"];
      this.day3 = map["3"];
      this.day4 = map["4"];
      this.day5 = map["5"];
      this.day6 = map["6"];
      this.day7 = map["7"];
    }
  }
}

class ScheduleSecondWeek {
  Timestamp day1;
  Timestamp day2;
  Timestamp day3;
  Timestamp day4;
  Timestamp day5;
  Timestamp day6;
  Timestamp day7;

  ScheduleSecondWeek(Map<dynamic, dynamic> map) {
    if (map == null) {
      day1 = null;
      day2 = null;
      day3 = null;
      day4 = null;
      day5 = null;
      day6 = null;
      day7 = null;
    } else {
      this.day1 = map["1"];
      this.day2 = map["2"];
      this.day3 = map["3"];
      this.day4 = map["4"];
      this.day5 = map["5"];
      this.day6 = map["6"];
      this.day7 = map["7"];
    }
  }
}

class Group {
  String userIndex;
  String userId;

  Group(String userIndex, String userId) {
    this.userIndex = userIndex;
    this.userId = userId;
  }
}

class Class {
  String dateAndTime;
  String individualPrice;
  String memberPrice;
  String locationName;
  String locationDistrict;
  String locationStreet;
  String classLevel;
  bool public;
  int spots;
  String type;
  DateTime dateAndTimeDateTime;
  Timestamp duration;
  List<Spots> occupiedSpots;
  int number;
  String trainerId;
  String firstName;
  String lastName;
  String gymWebsite;

  Class(
      String dateAndTime,
      String individualPrice,
      String memberPrice,
      String locationName,
      String locationDistrict,
      String locationStreet,
      String classLevel,
      bool public,
      String type,
      int spots,
      Timestamp dateAndTimeDateTime,
      Timestamp duration,
      int number,
      String trainerId,
      String firstName,
      String lastName,
      String gymWebsite) {
    this.gymWebsite = gymWebsite;

    this.dateAndTime = dateAndTime;

    this.individualPrice = individualPrice;

    this.memberPrice = memberPrice;

    this.locationName = locationName;

    this.classLevel = classLevel;

    this.public = public;

    this.type = type;

    this.spots = spots;

    this.dateAndTimeDateTime = dateAndTimeDateTime.toDate();

    this.duration = duration;

    this.locationDistrict = locationDistrict;

    this.locationStreet = locationStreet;

    this.occupiedSpots = occupiedSpots;

    this.number = number;

    this.trainerId = trainerId;

    this.firstName = firstName;

    this.lastName = lastName;
  }
}

class Spots {
  String id;
  bool flag;

  Spots(String id, bool flag) {
    this.id = id;
    this.flag = flag;
  }
}
