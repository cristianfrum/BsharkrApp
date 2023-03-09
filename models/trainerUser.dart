import 'package:Bsharkr/models/clientUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerUser {
  bool pendingDeletion;
  bool appIsOn;
  int colorRed;
  int colorGreen;
  int colorBlue;
  Month1 month1;
  Month2 month2;
  Month3 month3;
  Month4 month4;
  Month5 month5;
  Month6 month6;
  int age;
  List<ClientUser> clientUsersFriendsList;
  bool nearbyFlag;
  List<Users> unseenMessagesCounter = [];
  String certify, firstName, lastName, gender, currentGym;
  AttributeMap attributeMap;
  AttributeMapDelay attributeMapDelay;
  int cardioSessions;
  int workoutSessions;
  List<Specialization> specializations = [];
  List<ReviewMap> reviewMap = [];
  List<ReviewMapDelay> reviewMapDelay = [];
  List<Client> clients = [];
  List<Friend> friends = [];
  List<List<Group>> groups = [];
  int groupCounter;
  String id;
  String nickname;
  String photoUrl;
  String role;
  String searchKeyFirstName;
  int votes;
  String gym1;
  String gym2;
  String gym3;
  String gym4;
  String gym1Street;
  String gym2Street;
  String gym3Street;
  String gym4Street;
  String gym1Sector;
  String gym2Sector;
  String gym3Sector;
  String gym4Sector;
  String gym1Website;
  String gym2Website;
  String gym3Website;
  String gym4Website;
  double rating;
  double ratingAttribute1;
  double ratingAttribute2;
  bool freeTraining;
  GeoPoint locationGeopoint;
  String locationGeohash;
  bool newFriendRequest;
  bool newBusinessRequest;
  bool acceptedFriendship;
  bool newFriend;
  bool newClient;
  int workoutCounter;
  int zumbaCounter;
  int aerobicCounter;
  int pilatesCounter;
  int kangooJumpsCounter;
  int trxCounter;
  String pushToken;
  bool newMemberJoined;
  int trophies;
  bool approved;
  List<NearbyList> nearbyList = [];
  List<NearbyDateList> nearbyDateList = [];
  List<BusinessRequestDateList> businessRequestDateList = [];
  List<FriendRequestDateList> friendRequestDateList = [];

  int counterClasses;
  List<Class> classes = [];

  TrainerUser(DocumentSnapshot document) {
    if (document.data["location"] != null) {
      this.locationGeohash = document.data["location"]["geohash"] ?? null;

      this.locationGeopoint = document.data["location"]["geopoint"] ?? null;
    }
    this.pendingDeletion = document.data["pendingDeletion"] ?? false;
    this.appIsOn = document.data["appIsOn"] ?? false;
    this.approved = document.data["approved"] ?? false;
    this.trophies = document.data["trophies"] ?? 0;
    this.nearbyFlag = document.data["nearbyFlag"] ?? null;
    this.newMemberJoined = document.data["newMemberJoined"] ?? null;
    this.trxCounter = document.data["trxCounter"] ?? 0;
    this.pushToken = document.data["pushToken"] ?? null;
    this.workoutCounter = document.data["workoutCounter"] ?? 0;
    this.zumbaCounter = document.data["zumbaCounter"] ?? 0;
    this.aerobicCounter = document.data["aerobicCounter"] ?? 0;
    this.pilatesCounter = document.data["pilatesCounter"] ?? 0;
    this.kangooJumpsCounter = document.data["kangooJumpsCounter"] ?? 0;
    this.counterClasses = document.data["counterClasses"] ?? null;
    this.newFriendRequest = document.data["newFriendRequest"] ?? null;
    this.newFriend = document.data["newFriend"] ?? null;
    this.newClient = document.data["newClient"] ?? null;
    this.acceptedFriendship = document.data["acceptedFriendship"] ?? null;
    this.newBusinessRequest = document.data["newBusinessRequest"] ?? null;
    this.rating = document.data["rating"]['1'].toDouble() ?? 0;
    this.ratingAttribute1 = document.data["ratingAttribute1"]['1'].toDouble();
    this.ratingAttribute2 = document.data["ratingAttribute2"]['1'].toDouble();
    this.freeTraining = document.data["freeTraining"];
    this.colorRed = document.data["colorRed"];
    this.colorGreen = document.data["colorGreen"];
    this.colorBlue = document.data["colorBlue"];
    this.gym1Street = document.data["gym1Street"] ?? null;
    this.gym2Street = document.data["gym2Street"] ?? null;
    this.gym3Street = document.data["gym3Street"] ?? null;
    this.gym4Street = document.data["gym4Street"] ?? null;
    this.gym1 = document.data["gym1"] ?? null;
    this.gym2 = document.data["gym2"] ?? null;
    this.gym3 = document.data["gym3"] ?? null;
    this.gym4 = document.data["gym4"] ?? null;
    this.gym1Sector = document.data["gym1Sector"] ?? null;
    this.gym2Sector = document.data["gym2Sector"] ?? null;
    this.gym3Sector = document.data["gym3Sector"] ?? null;
    this.gym4Sector = document.data["gym4Sector"] ?? null;
    this.gym1Website = document.data["gym1Website"] ?? null;
    this.gym2Website = document.data["gym2Website"] ?? null;
    this.gym3Website = document.data["gym3Website"] ?? null;
    this.gym4Website = document.data["gym4Website"] ?? null;
    this.age = document.data["age"] ?? "";
    this.certify = document.data["certify"];
    this.gender = document.data["gender"] ?? "";
    this.firstName = document.data["firstName"] ?? "";
    this.lastName = document.data["lastName"] ?? "";
    this.currentGym = document.data["currentGym"] ?? "";
    this.attributeMap = AttributeMap(document.data["attributeMap"]);
    this.attributeMapDelay =
        AttributeMapDelay(document.data["attributeMapDelay"]);
    this.month1 = Month1(document.data["month1"]);
    this.month2 = Month2(document.data["month2"]);
    this.month3 = Month3(document.data["month3"]);
    this.month4 = Month4(document.data["month4"]);
    this.month5 = Month5(document.data["month5"]);
    this.month6 = Month6(document.data["month6"]);
    this.groupCounter = document.data["groupCounter"];
    this.id = document.documentID;
    this.nickname = document.data["nickname"];
    this.photoUrl = document.data["photoUrl"] ?? null;
    this.role = document.data["role"];
    this.searchKeyFirstName = document.data["searchKeyFirstName"] ?? null;
    this.votes = document.data["votes"] ?? 0;
    this.cardioSessions = document.data["cardios"] ?? 0;
    this.workoutSessions = document.data["works"] ?? 0;

    for (int i = 0; i < (document.data["trainerMap"] as Map).length; ++i) {
      String key =
          (document.data["trainerMap"] as Map).keys.toList()[i].toString();
      bool value = (document.data["trainerMap"] as Map)[key];
      clients.add(Client(key, value));
    }

    for (int i = 0; i < (document.data["nearby"] as Map).length; ++i) {
      String key = (document.data["nearby"] as Map).keys.toList()[i].toString();
      bool value = (document.data["nearby"] as Map)[key];
      nearbyList.add(NearbyList(key, value));
    }

    for (int i = 0; i < (document.data["nearbyDate"] as Map).length; ++i) {
      String key =
          (document.data["nearbyDate"] as Map).keys.toList()[i].toString();
      Timestamp value = (document.data["nearbyDate"] as Map)[key];
      nearbyDateList.add(NearbyDateList(key, value));
    }

    for (int i = 0;
        i < (document.data["businessRequestDate"] as Map).length;
        ++i) {
      String key = (document.data["businessRequestDate"] as Map)
          .keys
          .toList()[i]
          .toString();
      Timestamp value = (document.data["businessRequestDate"] as Map)[key];
      businessRequestDateList.add(BusinessRequestDateList(key, value));
    }

    for (int i = 0;
        i < (document.data["friendRequestDate"] as Map).length;
        ++i) {
      String key = (document.data["friendRequestDate"] as Map)
          .keys
          .toList()[i]
          .toString();
      Timestamp value = (document.data["friendRequestDate"] as Map)[key];
      friendRequestDateList.add(FriendRequestDateList(key, value));
    }

    for (int j = 1; j <= counterClasses; j++) {
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
        List<Spots> key12 = [];
        String key14 = document.data["class$j"]["firstName"];
        String key15 = document.data["class$j"]["lastName"];
        List<EnrolledClientsAge> key16 = [];
        List<EnrolledClientsGender> key17 = [];
        List<EnrolledClientsFirstName> key18 = [];
        List<EnrolledClientsLastName> key19 = [];
        List<EnrolledClientsPhotoUrl> key20 = [];
        List<EnrolledClientsColorRed> key21 = [];
        List<EnrolledClientsColorGreen> key22 = [];
        List<EnrolledClientsColorBlue> key23 = [];
        List<EnrolledClientsRating> key24 = [];
        String key25 = document.data["class$j"]["gymWebsite"];
        int key26 = document.data["class$j"]["views"];

        for (int i = 0;
            i < (document.data["class$j"]["clientsRating"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsRating"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsRating"] as Map)[key];
          key24.add(EnrolledClientsRating(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["occupiedSpots"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["occupiedSpots"] as Map)
              .keys
              .toList()[i]
              .toString();
          bool value = (document.data["class$j"]["occupiedSpots"] as Map)[key];
          key12.add(Spots(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsPhotoUrl"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsPhotoUrl"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsPhotoUrl"] as Map)[key];
          key20.add(EnrolledClientsPhotoUrl(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsColorRed"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsColorRed"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsColorRed"] as Map)[key];
          key21.add(EnrolledClientsColorRed(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsColorGreen"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsColorGreen"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsColorGreen"] as Map)[key];
          key22.add(EnrolledClientsColorGreen(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsColorBlue"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsColorBlue"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsColorBlue"] as Map)[key];
          key23.add(EnrolledClientsColorBlue(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsAge"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsAge"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value = (document.data["class$j"]["clientsAge"] as Map)[key];
          key16.add(EnrolledClientsAge(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsGender"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsGender"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsGender"] as Map)[key];
          key17.add(EnrolledClientsGender(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsFirstName"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsFirstName"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsFirstName"] as Map)[key];
          key18.add(EnrolledClientsFirstName(key, value));
        }

        for (int i = 0;
            i < (document.data["class$j"]["clientsLastName"] as Map).length;
            ++i) {
          String key = (document.data["class$j"]["clientsLastName"] as Map)
              .keys
              .toList()[i]
              .toString();
          String value =
              (document.data["class$j"]["clientsLastName"] as Map)[key];
          key19.add(EnrolledClientsLastName(key, value));
        }

        int key13 = document.data["class$j"]["number"];
        classes.add(Class(
            key,
            key1,
            key2,
            key3,
            key4,
            key5,
            key6,
            key7,
            key8,
            key9,
            key10,
            key11,
            key12,
            key13,
            key14,
            key15,
            key16,
            key17,
            key18,
            key19,
            key20,
            key21,
            key22,
            key23,
            key24,
            key25,
            key26));
      }
    }

    for (int i = 0; i < (document.data["specialization"] as Map).length; ++i) {
      String key =
          (document.data["specialization"] as Map).keys.toList()[i].toString();
      bool value = (document.data["specialization"] as Map)[key];
      specializations.add(Specialization(key, value));
    }
    for (int i = 0; i < (document.data["reviewDelay"] as Map).length; ++i) {
      String key =
          (document.data["reviewDelay"] as Map).keys.toList()[i].toString();
      Timestamp value = (document.data["reviewDelay"] as Map)[key];
      reviewMapDelay.add(ReviewMapDelay(key, value));
    }

    for (int i = 0; i < (document.data["reviewMap"] as Map).length; ++i) {
      String key =
          (document.data["reviewMap"] as Map).keys.toList()[i].toString();
      Timestamp value = (document.data["reviewMap"] as Map)[key];
      reviewMap.add(ReviewMap(key, value));
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

    for (int i = 0; i < (document.data["friendsMap"] as Map).length; ++i) {
      String key =
          (document.data["friendsMap"] as Map).keys.toList()[i].toString();
      bool value = (document.data["friendsMap"] as Map)[key];
      friends.add(Friend(key, value));
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

class Specialization {
  String specialization;
  bool certified;

  Specialization(String specialization, bool certified) {
    this.specialization = specialization;
    this.certified = certified;
  }
}

class AttributeMap {
  double attribute1;
  double attribute2;

  AttributeMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class ReviewMapDelay {
  Timestamp time;
  String review;

  ReviewMapDelay(String review, Timestamp time) {
    this.time = time;
    this.review = review;
  }
}

class ReviewMap {
  Timestamp time;
  String review;

  ReviewMap(String review, Timestamp time) {
    this.time = time;
    this.review = review;
  }
}

class AttributeMapDelay {
  double attribute1;
  double attribute2;

  AttributeMapDelay(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Month1 {
  double attribute1;
  double attribute2;

  Month1(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Month2 {
  double attribute1;
  double attribute2;

  Month2(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Month3 {
  double attribute1;
  double attribute2;

  Month3(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Month4 {
  double attribute1;
  double attribute2;

  Month4(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Month5 {
  double attribute1;
  double attribute2;

  Month5(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Month6 {
  double attribute1;
  double attribute2;

  Month6(Map<dynamic, dynamic> map) {
    if (map == null) {
      this.attribute1 = 0.0;
      this.attribute2 = 0.0;
    } else {
      this.attribute1 = double.parse(map["1"].toString()) ?? 0.0;
      this.attribute2 = double.parse(map["2"].toString()) ?? 0.0;
    }
  }
}

class Client {
  String clientId;
  bool clientAccepted;

  Client(String clientId, bool clientAccepted) {
    this.clientId = clientId;
    this.clientAccepted = clientAccepted;
  }
}

class Friend {
  String friendId;
  bool friendAccepted;

  Friend(String friendId, bool friendAccepted) {
    this.friendId = friendId;
    this.friendAccepted = friendAccepted;
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
  String gymWebsite;
  bool public;
  int spots;
  String type;
  DateTime dateAndTimeDateTime;
  Timestamp duration;
  List<Spots> occupiedSpots;
  int number;
  String firstName;
  String lastName;
  List<EnrolledClientsAge> clientsAge;
  List<EnrolledClientsGender> clientsGender;
  List<EnrolledClientsFirstName> clientsFirstName;
  List<EnrolledClientsLastName> clientsLastName;
  List<EnrolledClientsPhotoUrl> clientsPhotoUrl;
  List<EnrolledClientsColorRed> clientsColorRed;
  List<EnrolledClientsColorGreen> clientsColorGreen;
  List<EnrolledClientsColorBlue> clientsColorBlue;
  List<EnrolledClientsRating> clientsRating;
  int views;

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
      List<Spots> occupiedSpots,
      int number,
      String firstName,
      String lastName,
      List<EnrolledClientsAge> clientsAge,
      List<EnrolledClientsGender> clientsGender,
      List<EnrolledClientsFirstName> clientsFirstName,
      List<EnrolledClientsLastName> clientsLastName,
      List<EnrolledClientsPhotoUrl> clientsPhotoUrl,
      List<EnrolledClientsColorRed> clientsColorRed,
      List<EnrolledClientsColorGreen> clientsColorGreen,
      List<EnrolledClientsColorBlue> clientsColorBlue,
      List<EnrolledClientsRating> clientsRating,
      String gymWebsite,
      int views) {
    this.clientsRating = clientsRating;

    this.clientsPhotoUrl = clientsPhotoUrl;

    this.clientsColorRed = clientsColorRed;

    this.clientsColorGreen = clientsColorGreen;

    this.clientsColorBlue = clientsColorBlue;

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

    this.firstName = firstName;

    this.lastName = lastName;

    this.clientsAge = clientsAge;

    this.clientsGender = clientsGender;

    this.clientsFirstName = clientsFirstName;

    this.clientsLastName = clientsLastName;

    this.gymWebsite = gymWebsite;

    this.views = views;
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

class Spots {
  String id;
  bool flag;

  Spots(String id, bool flag) {
    this.id = id;
    this.flag = flag;
  }
}

class EnrolledClientsFirstName {
  String id;
  String firstName;

  EnrolledClientsFirstName(String id, String firstName) {
    this.id = id;
    this.firstName = firstName;
  }
}

class EnrolledClientsLastName {
  String id;
  String lastName;

  EnrolledClientsLastName(String id, String lastName) {
    this.id = id;
    this.lastName = lastName;
  }
}

class EnrolledClientsAge {
  String id;
  String age;

  EnrolledClientsAge(String id, String age) {
    this.id = id;
    this.age = age;
  }
}

class EnrolledClientsGender {
  String id;
  String gender;

  EnrolledClientsGender(String id, String gender) {
    this.id = id;
    this.gender = gender;
  }
}

class EnrolledClientsPhotoUrl {
  String id;
  String photoUrl;

  EnrolledClientsPhotoUrl(String id, String photoUrl) {
    this.id = id;
    this.photoUrl = photoUrl;
  }
}

class EnrolledClientsColorRed {
  String id;
  String colorRed;

  EnrolledClientsColorRed(String id, String colorRed) {
    this.id = id;
    this.colorRed = colorRed;
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

class EnrolledClientsColorGreen {
  String id;
  String colorGreen;

  EnrolledClientsColorGreen(String id, String colorGreen) {
    this.id = id;
    this.colorGreen = colorGreen;
  }
}

class EnrolledClientsColorBlue {
  String id;
  String colorBlue;

  EnrolledClientsColorBlue(String id, String colorBlue) {
    this.id = id;
    this.colorBlue = colorBlue;
  }
}

class EnrolledClientsRating {
  String id;
  String vote;

  EnrolledClientsRating(String id, String vote) {
    this.id = id;
    this.vote = vote;
  }
}

class NearbyDateList {
  String id;
  Timestamp time;

  NearbyDateList(String id, Timestamp time) {
    this.id = id;
    this.time = time;
  }
}

class BusinessRequestDateList {
  String id;
  Timestamp time;

  BusinessRequestDateList(String id, Timestamp time) {
    this.id = id;
    this.time = time;
  }
}

class FriendRequestDateList {
  String id;
  Timestamp time;

  FriendRequestDateList(String id, Timestamp time) {
    this.id = id;
    this.time = time;
  }
}
