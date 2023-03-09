
import 'package:Bsharkr/Trainer/Classes/AddNewClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class CrudMethods {
  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();
  }
}

class CustomGraphRight extends CustomPainter {
  final double attribute1;
  final double originn;

  CustomGraphRight({this.attribute1, this.originn});

  Paint trackBarPaint = Paint()
    ..color = prefix0.mainColor
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12 * prefs.getDouble('height');

  Paint trackPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12 * prefs.getDouble('height');

  @override
  void paint(Canvas canvas, Size size) {
    Path trackPath = Path();
    Path trackBarPath = Path();
    var valoare = attribute1 / 5;
    double origin = 0;

    trackPath.moveTo(310 * prefs.getDouble('width'), origin);
    trackPath.lineTo(0, origin);

    trackBarPath.moveTo(0, origin);
    trackBarPath.lineTo(valoare * 310 * prefs.getDouble('width'), origin);

    canvas.drawPath(trackPath, trackPaint);
    canvas.drawPath(trackBarPath, trackBarPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class EditProfilePageCards extends StatefulWidget {
  @override
  EditProfilePageCardsState createState() => new EditProfilePageCardsState();
}

class EditProfilePageCardsState extends State<EditProfilePageCards>
    with SingleTickerProviderStateMixin {
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;

  Future _getData;

  CrudMethods crudObj;

  bool permission;

  gtlocation() async {
    await PermissionHandler()
        .requestPermissions([PermissionGroup.location]).then((status) {
      if (status.containsValue(PermissionStatus.granted)) {
        permission = true;
      } else {
        permission = false;
      }
    });
  }

  int a, b, c;
  @override
  void initState() {
    super.initState();
    gtlocation();
    prefs.setInt('currentCard', 3);
    prefs.setString('gym1', null);
    prefs.setString('gym2', null);
    prefs.setString('gym3', null);
    prefs.setString('gym4', null);
    prefs.setString('gym1Street', null);
    prefs.setString('gym2Street', null);
    prefs.setString('gym3Street', null);
    prefs.setString('gym4Street', null);
    prefs.setString('gym1Sector', null);
    prefs.setString('gym2Sector', null);
    prefs.setString('gym3Sector', null);
    prefs.setString('gym4Sector', null);
    prefs.setString('gym1Website', null);
    prefs.setString('gym2Website', null);
    prefs.setString('gym3Website', null);
    prefs.setString('gym4Website', null);
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
    crudObj = CrudMethods();
    _getData = crudObj.getData();
  }

  List<String> specialList = [];

  bool restart = false;
  TrainerUser _trainerUser;
  String trainersSpecializations;

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return FutureBuilder<QuerySnapshot>(
      future: _getData,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(prefix0.mainColor),
              ),
            ),
            color: prefix0.backgroundColor,
          );
        }

        if (restart == false) {
          trainersSpecializations = "";
          _trainerUser = TrainerUser(snapshot.data.documents[0]);
          _trainerUser.specializations.forEach((special) {
            if (special.certified == true) {
              trainersSpecializations = trainersSpecializations +
                  special.specialization[0].toUpperCase() +
                  special.specialization.substring(1) +
                  ", ";
            }
          });
          if (trainersSpecializations.length > 2) {
            trainersSpecializations = trainersSpecializations.substring(
                0, trainersSpecializations.length - 2);
          }
        }

        return new AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) {
            return Container(
              color: prefix0.backgroundColor,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: prefix0.backgroundColor,
                  body: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 24 * prefs.getDouble('width')),
                                child: Icon(
                                  Icons.access_time,
                                  size: 24 * prefs.getDouble('height'),
                                  color: prefix0.backgroundColor,
                                ),
                              ),
                              Text(
                                _trainerUser.firstName +
                                    " " +
                                    _trainerUser.lastName,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    letterSpacing:
                                        0.8 * prefs.getDouble('height'),
                                    wordSpacing: 7 * prefs.getDouble('height'),
                                    fontSize: 20.0 * prefs.getDouble('width'),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24 * prefs.getDouble('height'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 32 * prefs.getDouble('width')),
                                child: (_trainerUser.photoUrl == null
                                    ? ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255,
                                                _trainerUser.colorRed,
                                                _trainerUser.colorGreen,
                                                _trainerUser.colorBlue),
                                            shape: BoxShape.circle,
                                          ),
                                          height:
                                              (80 * prefs.getDouble('height')),
                                          width:
                                              (80 * prefs.getDouble('height')),
                                          child: Center(
                                            child: Text(
                                                _trainerUser.firstName[0],
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 50 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              ProfilePhotoPopUp(
                                                trainerUser: _trainerUser,
                                              ));
                                        },
                                        child: Material(
                                          child: Container(
                                            color: Colors.black,
                                            width:
                                                80 * prefs.getDouble('height'),
                                            height:
                                                80 * prefs.getDouble('height'),
                                            child: Image.network(
                                              _trainerUser.photoUrl,
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
                                                              prefix0
                                                                  .mainColor),
                                                      backgroundColor: prefix0
                                                          .backgroundColor,
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
                                      ))),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 32 * prefs.getDouble('width')),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 220 * prefs.getDouble('width'),
                                    child: Text(
                                      trainersSpecializations == null
                                          ? ""
                                          : trainersSpecializations,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        letterSpacing:
                                            -0.408 * prefs.getDouble('width'),
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize:
                                            16.0 * prefs.getDouble('height'),
                                        color:
                                            Color.fromARGB(80, 255, 255, 255),
                                      ),
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Text(
                                    (_trainerUser.gender == 'male'
                                            ? 'Man, '
                                            : 'Woman, ') +
                                        (_trainerUser.age.toString() +
                                            " years" +
                                            " | ") +
                                        (_trainerUser.clients.length
                                                .toString() +
                                            " clients"),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing:
                                          -0.408 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          16.0 * prefs.getDouble('height'),
                                      color: Color.fromARGB(80, 255, 255, 255),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    _trainerUser.freeTraining == true
                                        ? "First session is free"
                                        : "",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing:
                                          -0.408 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize:
                                          16.0 * prefs.getDouble('height'),
                                      color: prefix0.mainColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15 * prefs.getDouble('height'),
                        ),
                        Container(
                          width: 310 * prefs.getDouble('width'),
                          height: 32 * prefs.getDouble('height'),
                          child: Material(
                            borderRadius: BorderRadius.circular(4),
                            color: secondaryColor,
                            child: MaterialButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditeazaProfilul(
                                              parent: this,
                                              status: permission,
                                            )),
                                  );
                                },
                                child: Row(
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
                                      "Edit Profile",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              12 * prefs.getDouble('height')),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 36.0 * prefs.getDouble('height'),
                        ),
                        Container(
                          width: double.infinity,
                          height: 20 * prefs.getDouble('height'),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32 * prefs.getDouble('width')),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Trainer rating: ${((_trainerUser.attributeMapDelay.attribute1 + _trainerUser.attributeMapDelay.attribute2) / 2).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        letterSpacing: -0.408,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            17.0 * prefs.getDouble('height'),
                                        color:
                                            Color.fromARGB(200, 255, 255, 255)),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        DetailsPopUpReviews(
                                          trainerUser: _trainerUser,
                                        ));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Reviews",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              letterSpacing: -0.408,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0 *
                                                  prefs.getDouble('height'),
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255)),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0 * prefs.getDouble('width'),
                                      ),
                                      Icon(
                                        Icons.add_box,
                                        size: 15 * prefs.getDouble('height'),
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18.0 * prefs.getDouble('height'),
                        ),
                        RepaintBoundary(
                          child: Container(
                            height: 165 * prefs.getDouble('height'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 32 * prefs.getDouble('width'),
                                  ),
                                  child: Text(
                                    "Communication: ${_trainerUser.attributeMapDelay.attribute1.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                        fontSize:
                                            12.0 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0 * prefs.getDouble('height'),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 34 * prefs.getDouble('width')),
                                  height: 25 * prefs.getDouble('height'),
                                  child: CustomPaint(
                                    foregroundPainter: CustomGraphRight(
                                      attribute1: _trainerUser
                                          .attributeMapDelay.attribute1,
                                    ),
                                    child: Container(
                                      height: 25 * prefs.getDouble('height'),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 32 * prefs.getDouble('width'),
                                  ),
                                  child: Text(
                                    "Profesionalism: ${_trainerUser.attributeMapDelay.attribute2.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                        fontSize:
                                            12.0 * prefs.getDouble('height'),
                                        letterSpacing: -0.066,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0 * prefs.getDouble('height'),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 34 * prefs.getDouble('width')),
                                  height: 25 * prefs.getDouble('height'),
                                  child: CustomPaint(
                                    foregroundPainter: CustomGraphRight(
                                      attribute1: _trainerUser
                                          .attributeMapDelay.attribute2,
                                    ),
                                    child: Container(
                                      height: 25 * prefs.getDouble('height'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30 * prefs.getDouble('height'),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  height: 30 * prefs.getDouble('height'),
                                  padding: EdgeInsets.only(
                                      left: 32 * prefs.getDouble('width')),
                                  child: Center(
                                    child: Text(
                                      "Gyms",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize:
                                              15 * prefs.getDouble('height'),
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                          color: Color.fromARGB(
                                              120, 255, 255, 255)),
                                    ),
                                  )),
                              Container(
                                width: 150 * prefs.getDouble('width'),
                                padding: EdgeInsets.only(
                                    right: 33 * prefs.getDouble('width')),
                                height: 30 * prefs.getDouble('width'),
                                child: Material(
                                  borderRadius: BorderRadius.circular(30),
                                  color: prefix0.secondaryColor,
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Edit card",
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              11 * prefs.getDouble('height')),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32 * prefs.getDouble('height'),
                        ),
                        Container(
                          width: 330 * prefs.getDouble('width'),
                          height: 300 * prefs.getDouble('height'),
                          child: CardSlider(
                            height: 0.0,
                            trainerUser: _trainerUser,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Consts {
  Consts._();

  static const double padding = 8.0;
  static const double avatarRadius = 66.0;
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
                          
                                if(prefs.getString('gym3Website') != null) {
                                  launch(prefs.getString('gym3Website'));
                                } else {
                                  if (
                                  widget.trainerUser.gym3Website != null) {
                                launch(widget.trainerUser.gym3Website);
                              } 
                                }
                              
                            }
                             if (cardInfo == _cardInfoList[0]) {
                          
                                if(prefs.getString('gym4Website') != null) {
                                  launch(prefs.getString('gym4Website'));
                                } else {
                                  if (
                                  widget.trainerUser.gym4Website != null) {
                                launch(widget.trainerUser.gym4Website);
                              } 
                                }
                              
                            }
                              if (cardInfo == _cardInfoList[2]) {
                          
                                if(prefs.getString('gym2Website') != null) {
                                  launch(prefs.getString('gym2Website'));
                                } else {
                                  if (
                                  widget.trainerUser.gym2Website != null) {
                                launch(widget.trainerUser.gym2Website);
                              } 
                                }
                              
                            }
                              if (cardInfo == _cardInfoList[3]) {
                          
                                if(prefs.getString('gym1Website') != null) {
                                  launch(prefs.getString('gym1Website'));
                                } else {
                                  if (
                                  widget.trainerUser.gym1Website != null) {
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

class DetailsPopUpReviews extends PopupRoute<void> {
  DetailsPopUpReviews({this.trainerUser});
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
      DetailsPageReviews(
        trainer: trainerUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class MyPopupRoute1 extends PopupRoute<void> {
  MyPopupRoute1({this.trainerUser, this.currentCard, this.parent});
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
          trainer: trainerUser, currentCard: currentCard, parent: parent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DetailsPageReviews extends StatefulWidget {
  final TrainerUser trainer;
  DetailsPageReviews({Key key, @required this.trainer}) : super(key: key);

  @override
  State createState() => DetailsPageReviewsState(trainer: trainer);
}

class DetailsPageReviewsState extends State<DetailsPageReviews> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector;

  DetailsPageReviewsState({
    @required this.trainer,
  });

  List<ReviewMapDelay> revs = [];

   buildItem(List<ReviewMapDelay> reviews, int index) {
    if (index < 5) {
      if (reviews.length <= 5) {
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          index != (reviews.length - 1)
              ? Container(
                  width: double.infinity,
                  height: 1 * prefs.getDouble('height'),
                  color: Color.fromARGB(150, 255, 255, 255))
              : Container(),
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
                  reviews[index].review,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13 * prefs.getDouble('height'),
                      letterSpacing: -0.078,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
            ),
          ),
        ]);
      } else {
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          index < 4
              ? Container(
                  width: double.infinity,
                  height: 1 * prefs.getDouble('height'),
                  color: Color.fromARGB(150, 255, 255, 255))
              : Container(),
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
                  reviews[index + reviews.length - 5].review,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13 * prefs.getDouble('height'),
                      letterSpacing: -0.078,
                      color: Color.fromARGB(200, 255, 255, 255)),
                ),
              ),
            ),
          ),
        ]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.trainer.reviewMapDelay.length - 1; i++) {
      for (int j = i + 1; j < widget.trainer.reviewMapDelay.length; j++) {
        if (widget.trainer.reviewMapDelay[i].time
            .toDate()
            .isAfter(widget.trainer.reviewMapDelay[j].time.toDate())) {
          var aux = widget.trainer.reviewMapDelay[i];
          widget.trainer.reviewMapDelay[i] = widget.trainer.reviewMapDelay[j];
          widget.trainer.reviewMapDelay[j] = aux;
        }
      }
    }
    setState(() {
      revs = widget.trainer.reviewMapDelay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Dialog(
            backgroundColor: Colors.transparent,
            child: trainer.reviewMapDelay.length == 0
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
                                "You did not receive reviews yet.",
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
                    padding:
                        EdgeInsets.only(top: 10.0 * prefs.getDouble('height')),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff3E3E45)),
                    height: (90 *
                                    (trainer.reviewMapDelay.length < 5
                                        ? (trainer.reviewMapDelay.length)
                                        : 5) +
                                60)
                            .toDouble() *
                        prefs.getDouble('height'),
                    child: Container(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0 * prefs.getDouble('height')),
                        itemBuilder: (context, index) => buildItem(revs, index),
                        itemCount: trainer.reviewMapDelay.length < 5
                            ? trainer.reviewMapDelay.length
                            : 5,
                        reverse: true,
                      ),
                    ),
                  )));
  }
}

class EditGymCards extends StatefulWidget {
  final DetailsPage2State parent;
  final TrainerUser trainer;
  final int currentCard;
  EditGymCards(
      {Key key,
      @required this.trainer,
      @required this.currentCard,
      @required this.parent})
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
                          widget.parent.setState(() {
                            if (hintWebsite == null || hintWebsite == "") {
                              Navigator.push(context, PopUpMissingFieldsRoute());
                            } else {
                              if (hintName == null || hintName == "") {
                                Navigator.push(context, PopUpMissingFieldsRoute());
                              } else {
                                if (hintSector == null || hintSector == "") {
                                  Navigator.push(context, PopUpMissingFieldsRoute());
                                } else {
                                  if (hintStreet == null || hintStreet == "") {
                                    Navigator.push(
                                        context, PopUpMissingFieldsRoute());
                                  } else {
                                    var db = Firestore.instance;
                                    var batch = db.batch();
                                    if(hintWebsite != null) {
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
                                      if(hintWebsite != null) {

                                        prefs.setString('gym1Website', hintWebsite);
                                      }
                                        if (hintName != null) {
                                        prefs.setString('gym1', hintName);
                                      }
                                      if (hintStreet != null) {
                                        prefs.setString(
                                            'gym1Street', hintStreet);
                                      }
                                      if (hintSector != null) {
                                        prefs.setString(
                                            'gym1Sector', hintSector);
                                      }
                                    }
                                    if (4 - widget.currentCard == 2) { if(hintWebsite != null) {

                                        prefs.setString('gym2Website', hintWebsite);
                                      }
                                      if (hintName != null) {
                                        prefs.setString('gym2', hintName);
                                      }
                                      if (hintStreet != null) {
                                        prefs.setString(
                                            'gym2Street', hintStreet);
                                      }
                                      if (hintSector != null) {
                                        prefs.setString(
                                            'gym2Sector', hintSector);
                                      }
                                    }
                                    if (4 - widget.currentCard == 3) { if(hintWebsite != null) {

                                        prefs.setString('gym3Website', hintWebsite);
                                      }
                                      if (hintName != null) {
                                        prefs.setString('gym3', hintName);
                                      }
                                      if (hintStreet != null) {
                                        prefs.setString(
                                            'gym3Street', hintStreet);
                                      }
                                      if (hintSector != null) {
                                        prefs.setString(
                                            'gym3Sector', hintSector);
                                      }
                                    }
                                    if (4 - widget.currentCard == 4) { if(hintWebsite != null) {

                                        prefs.setString('gym4Website', hintWebsite);
                                      }
                                      if (hintName != null) {
                                        prefs.setString('gym4', hintName);
                                      }
                                      if (hintStreet != null) {
                                        prefs.setString(
                                            'gym4Street', hintStreet);
                                      }
                                      if (hintSector != null) {
                                        prefs.setString(
                                            'gym4Sector', hintSector);
                                      }
                                    }
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
                            }
                          });
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

class EditeazaProfilul extends StatefulWidget {
  EditeazaProfilul({this.parent, this.auth, this.status});
  final bool status;
  final EditProfilePageCardsState parent;
  final BaseAuth auth;
  @override
  _EditeazaProfilulState createState() => _EditeazaProfilulState();
}

class _EditeazaProfilulState extends State<EditeazaProfilul> {
  Future<void> sendPasswordResetEmail(String email) async {
    await widget.auth.resetPassword(email);
  }

  Completer<GoogleMapController> _controller = Completer();
  static LatLng _center;

  Geoflutterfire geo = Geoflutterfire();
  Future _getData;

  CrudMethods crudObj;
  bool toggleValue = false;

  bool workoutButton = false;
  bool zumbaButton = false;
  bool pilatesButton = false;
  bool trxButton = false;
  bool kangoojumpsButton = false;
  bool aerobicButton = false;
  bool restart = false;

  _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon, size: 36.0),
    );
  }

  toggleButton() {
    setState(() {
      restart = true;
      toggleValue = !toggleValue;
    });
  }

  int randomInt = Random().nextInt(1000000);
  var tempImage;
  Future _getImage() async {
    var aux = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tempImage = aux;
    });
  }

  TrainerUser _trainerUser;

  @override
  void initState() {
    super.initState();
    crudObj = CrudMethods();
    _getData = crudObj.getData();
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await rootBundle.loadString('assets/dark.json');

    controller.setMapStyle(value);
  }

  PanelController _pc = new PanelController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _getData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(prefix0.mainColor),
                ),
              ),
              color: prefix0.backgroundColor,
            );
          }
          if (restart == false) {
            _trainerUser = TrainerUser(snapshot.data.documents[0]);
            _trainerUser.specializations.forEach((specialization) {
              toggleValue = _trainerUser.freeTraining;
              if (specialization.specialization == 'workout' &&
                  specialization.certified == true) {
                workoutButton = true;
              }
              if (specialization.specialization == 'zumba' &&
                  specialization.certified == true) {
                zumbaButton = true;
              }
              if (specialization.specialization == 'kangooJumps' &&
                  specialization.certified == true) {
                kangoojumpsButton = true;
              }
              if (specialization.specialization == 'aerobic' &&
                  specialization.certified == true) {
                aerobicButton = true;
              }
              if (specialization.specialization == 'pilates' &&
                  specialization.certified == true) {
                pilatesButton = true;
              }
              if (specialization.specialization == 'trx' &&
                  specialization.certified == true) {
                trxButton = true;
              }
            });
          }
          if (_trainerUser.locationGeopoint != null) {
            _center = LatLng(_trainerUser.locationGeopoint.latitude,
                _trainerUser.locationGeopoint.longitude);
          } else {
            _center = LatLng(45.521563, -122.677433);
          }
          return MaterialApp(
         debugShowCheckedModeBanner: false,
            home: Scaffold(
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
                      padding:
                          EdgeInsets.only(right: 15 * prefs.getDouble('width')),
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
                            final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance
                                    .ref()
                                    .child('${_trainerUser.id}');
                            final StorageUploadTask task =
                                firebaseStorageRef.putFile(tempImage);
                            final StorageTaskSnapshot downloadUrl =
                                (await task.onComplete);
                            final String url =
                                (await downloadUrl.ref.getDownloadURL());
                            await prefs.setString('photoUrl', url);

                                       batch.updateData(
                                        db
                                            .collection('clientUsers')
                                            .document(   prefs.getString('id')),
                                        {
                                        
                              'photoUrl': url,
                                        },
                                      );
                         
                            widget.parent.setState(() {
                              widget.parent._trainerUser.photoUrl = url;
                              restart = true;
                            });
                          }
                         
                           batch.updateData(
                                        db
                                            .collection('clientUsers')
                                            .document(   prefs.getString('id')),
                                        {
                                        
                                  'specialization.workout': workoutButton,
                              'specialization.zumba': zumbaButton,
                              'specialization.pilates': pilatesButton,
                              'specialization.trx': trxButton,
                              'specialization.kangooJumps': kangoojumpsButton,
                              'specialization.aerobic': aerobicButton,
                              'freeTraining': toggleValue
                                        },
                                      );
                                      batch.commit();
                          bool temporaryFlag = false;
                          widget.parent.setState(() {
                            widget.parent._trainerUser.freeTraining =
                                toggleValue;
                            widget.parent.restart = true;
                            widget.parent.trainersSpecializations = "";
                            if (workoutButton == true) {
                              widget.parent.trainersSpecializations =
                                  widget.parent.trainersSpecializations +
                                      'Workout';
                              temporaryFlag = true;
                            }

                            if (aerobicButton == true) {
                              widget.parent.trainersSpecializations =
                                  widget.parent.trainersSpecializations +
                                      (temporaryFlag == false
                                          ? 'Aerobic'
                                          : ', Aerobic');
                              temporaryFlag = true;
                            }

                            if (pilatesButton == true) {
                              widget.parent.trainersSpecializations =
                                  widget.parent.trainersSpecializations +
                                      (temporaryFlag == false
                                          ? 'Pilates'
                                          : ', Pilates');
                              temporaryFlag = true;
                            }

                            if (trxButton == true) {
                              widget.parent.trainersSpecializations = widget
                                      .parent.trainersSpecializations +
                                  (temporaryFlag == false ? 'Trx' : ', Trx');
                              temporaryFlag = true;
                            }

                            if (kangoojumpsButton == true) {
                              widget.parent.trainersSpecializations =
                                  widget.parent.trainersSpecializations +
                                      (temporaryFlag == false
                                          ? 'Kangoo Jumps'
                                          : ', Kangoo Jumps');
                              temporaryFlag = true;
                            }

                            if (zumbaButton == true) {
                              widget.parent.trainersSpecializations =
                                  widget.parent.trainersSpecializations +
                                      (temporaryFlag == false
                                          ? 'Zumba'
                                          : ', Zumba');
                              temporaryFlag = true;
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                  backgroundColor: prefix0.backgroundColor,
                  elevation: 0.0,
                  title: Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontSize: 20 * prefs.getDouble('height'),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                body: Builder(
                  builder: (context) => SlidingUpPanel(
                    isDraggable: false,
                    controller: _pc,
                    maxHeight: 600 * prefs.getDouble('height'),
                    minHeight: 120 * prefs.getDouble('height'),
                    renderPanelSheet: false,
                    panelBuilder: (ScrollController sc) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      ),
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 450 * prefs.getDouble('height'),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(
                                  24.0 * prefs.getDouble('width'),
                                  42.0 * prefs.getDouble('height'),
                                  24.0 * prefs.getDouble('width'),
                                  42.0 * prefs.getDouble('height')),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: GoogleMap(
                                      rotateGesturesEnabled: false,
                                      myLocationButtonEnabled: widget.status,
                                      myLocationEnabled: true,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _setStyle(controller);
                                        _controller.complete(controller);
                                      },
                                      initialCameraPosition: CameraPosition(
                                          target: _center, zoom: 11.0),
                                      onCameraMove: _onCameraMove,
                                      mapType: MapType.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 450 * prefs.getDouble('height'),
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(
                                  24.0 * prefs.getDouble('width'),
                                  42.0 * prefs.getDouble('height'),
                                  24.0 * prefs.getDouble('width'),
                                  42.0 * prefs.getDouble('height')),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.place,
                                      color: Colors.white,
                                      size: 42 * prefs.getDouble('height'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: InkWell(
                                onTap: () {
                                  _pc.close();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: mainColor,
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 22 * prefs.getDouble('height')),
                                  height: 40 * prefs.getDouble('height'),
                                  width: 40 * prefs.getDouble('height'),
                                  child: Center(
                                      child: Icon(
                                    Icons.arrow_downward,
                                    size: 22 * prefs.getDouble('height'),
                                    color: Colors.white,
                                  )),
                                ),
                              )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () async {
                                GeoFirePoint myLocation = geo.point(
                                    latitude: _center.latitude,
                                    longitude: _center.longitude);
                                await Firestore.instance
                                    .collection('clientUsers')
                                    .document(
                                      prefs.getString('id'),
                                    )
                                    .updateData(
                                  {'location': myLocation.data},
                                );
                                _pc.close();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  color: mainColor,
                                ),
                                height: 40 * prefs.getDouble('height'),
                                margin: EdgeInsets.fromLTRB(
                                    24.0 * prefs.getDouble('width'),
                                    42.0 * prefs.getDouble('height'),
                                    24.0 * prefs.getDouble('width'),
                                    42.0 * prefs.getDouble('height')),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "Salveaza locatia",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize:
                                            16.0 * prefs.getDouble('height'),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    collapsed: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: prefix0.secondaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                          ),
                          margin: EdgeInsets.fromLTRB(
                              24.0 * prefs.getDouble('width'),
                              42.0 * prefs.getDouble('height'),
                              24.0 * prefs.getDouble('width'),
                              0.0),
                          child: Center(
                            child: Text(
                              "Locatie",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16 * prefs.getDouble('height'),
                                  color: Colors.white,
                                  letterSpacing: -0.078),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                              onTap: () {
                                _pc.open();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: mainColor,
                                ),
                                margin: EdgeInsets.only(
                                    top: 22 * prefs.getDouble('height')),
                                height: 40 * prefs.getDouble('height'),
                                width: 40 * prefs.getDouble('height'),
                                child: Center(
                                    child: Icon(
                                  Icons.arrow_upward,
                                  size: 22 * prefs.getDouble('height'),
                                  color: Colors.white,
                                )),
                              ),
                            )),
                      ],
                    ),
                    backdropEnabled: true,
                    body: Column(
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
                                  ? (_trainerUser.photoUrl == null
                                      ? Stack(
                                          children: <Widget>[
                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255,
                                                      _trainerUser.colorRed,
                                                      _trainerUser.colorGreen,
                                                      _trainerUser.colorBlue),
                                                  shape: BoxShape.circle,
                                                ),
                                                height: (120 *
                                                    prefs.getDouble('height')),
                                                width: (120 *
                                                    prefs.getDouble('height')),
                                                child: Center(
                                                  child: Text(
                                                      _trainerUser.firstName[0],
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
                                              top: 85.0 *
                                                  prefs.getDouble('height'),
                                              left: 85.0 *
                                                  prefs.getDouble('height'),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: prefix0
                                                        .backgroundColor),
                                                padding: EdgeInsets.all(5.0 *
                                                    prefs.getDouble('height')),
                                                child: Container(
                                                  width: 28 *
                                                      prefs.getDouble('height'),
                                                  height: 28 *
                                                      prefs.getDouble('height'),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: prefix0.mainColor,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 15.0 *
                                                        prefs.getDouble(
                                                            'height'),
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
                                                width: 120 *
                                                    prefs.getDouble('height'),
                                                height: 120 *
                                                    prefs.getDouble('height'),
                                                child: Image.network(
                                                  _trainerUser.photoUrl,
                                                  fit: BoxFit.cover,
                                                  scale: 1.0,
                                                  loadingBuilder:
                                                      (BuildContext ctx,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  prefix0
                                                                      .mainColor),
                                                          backgroundColor: prefix0
                                                              .backgroundColor,
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
                                              top: 85.0 *
                                                  prefs.getDouble('height'),
                                              left: 85.0 *
                                                  prefs.getDouble('height'),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: prefix0
                                                        .backgroundColor),
                                                padding: EdgeInsets.all(5.0 *
                                                    prefs.getDouble('height')),
                                                child: Container(
                                                  width: 28 *
                                                      prefs.getDouble('height'),
                                                  height: 28 *
                                                      prefs.getDouble('height'),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: prefix0.mainColor,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 15.0 *
                                                        prefs.getDouble(
                                                            'height'),
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
                                            width: 120.0 *
                                                prefs.getDouble('height'),
                                            height: 120.0 *
                                                prefs.getDouble('height'),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(90.0),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        Positioned(
                                          top: 85.0 * prefs.getDouble('height'),
                                          left:
                                              85.0 * prefs.getDouble('height'),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: prefix0.backgroundColor),
                                            padding: EdgeInsets.all(5.0 *
                                                prefs.getDouble('height')),
                                            child: Container(
                                              width: 28 *
                                                  prefs.getDouble('height'),
                                              height: 28 *
                                                  prefs.getDouble('height'),
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
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 26 * prefs.getDouble('height')),
                        Container(
                          height: 66 * prefs.getDouble('height'),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32 * prefs.getDouble('width')),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Specializations",
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
                                "Select the training specializations according to your certificates",
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
                          height: 128 * prefs.getDouble('height'),
                          width: 310 * prefs.getDouble('width'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            restart = true;
                                            workoutButton = !workoutButton;
                                          });
                                        },
                                        child: workoutButton == false
                                            ? Container(
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
                                                width: 150 *
                                                    prefs.getDouble('width'),
                                                padding: EdgeInsets.all(
                                                  8.0 *
                                                      prefs.getDouble('height'),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "Workout",
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
                                                    Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 16 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    color: prefix0.mainColor,
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
                                                  8.0 *
                                                      prefs.getDouble('height'),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      "Workout",
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
                                                    Icon(
                                                      Icons.cancel,
                                                      size: 16 *
                                                          prefs.getDouble(
                                                              'height'),
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
                                          pilatesButton = !pilatesButton;
                                        });
                                      },
                                      child: pilatesButton == false
                                          ? Container(
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Pilates",
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
                                                  Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.mainColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Pilates",
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
                                                  Icon(
                                                    Icons.cancel,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          restart = true;
                                          kangoojumpsButton =
                                              !kangoojumpsButton;
                                        });
                                      },
                                      child: kangoojumpsButton == false
                                          ? Container(
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Kangoo Jumps",
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
                                                  Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.mainColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Kangoo Jumps",
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
                                                  Icon(
                                                    Icons.cancel,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          restart = true;
                                          zumbaButton = !zumbaButton;
                                        });
                                      },
                                      child: zumbaButton == false
                                          ? Container(
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Zumba",
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
                                                  Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.mainColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Zumba",
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
                                                  Icon(
                                                    Icons.cancel,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          restart = true;
                                          trxButton = !trxButton;
                                        });
                                      },
                                      child: trxButton == false
                                          ? Container(
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "TRX",
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
                                                  Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.mainColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "TRX",
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
                                                  Icon(
                                                    Icons.cancel,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          restart = true;
                                          aerobicButton = !aerobicButton;
                                        });
                                      },
                                      child: aerobicButton == false
                                          ? Container(
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Aerobic",
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
                                                  Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: prefix0.mainColor,
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Aerobic",
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
                                                  Icon(
                                                    Icons.cancel,
                                                    size: 16 *
                                                        prefs.getDouble(
                                                            'height'),
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
                                "Offer the first training for free",
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
                                            duration:
                                                Duration(milliseconds: 400),
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
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ))
                                                : Text("No",
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Colors.white,
                                                      fontSize: 11.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                  sendPasswordResetEmail(_trainerUser.nickname);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                    "Resetting password email has been sent.",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize:
                                            18.0 * prefs.getDouble('height'),
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        color: mainColor),
                                    textAlign: TextAlign.center,
                                  )));
                                },
                                child: Text("Change password",
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
                              SizedBox(
                                  height: 18.0 * prefs.getDouble('height')),
                              Text(
                                "Delete account",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14.0 * prefs.getDouble('height'),
                                    letterSpacing: -0.08,
                                    color: Color(0xffFF453A),
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}

class ProfilePhotoPopUp extends PopupRoute<void> {
  ProfilePhotoPopUp({this.trainerUser, this.currentCard});
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
      ProfilePhoto(
        trainer: trainerUser,
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ProfilePhoto extends StatefulWidget {
  final TrainerUser trainer;
  ProfilePhoto({Key key, @required this.trainer}) : super(key: key);

  @override
  State createState() => ProfilePhotoState(trainer: trainer);
}

class ProfilePhotoState extends State<ProfilePhoto> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  String hintName, hintStreet, hintSector;

  ProfilePhotoState({
    @required this.trainer,
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
                    trainer.photoUrl,
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

class PopUpMissingFieldsRoute extends PopupRoute<void> {
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      PopUpMissingFields();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpMissingFields extends StatefulWidget {
  @override
  State createState() => PopUpMissingFieldsState();
}

class PopUpMissingFieldsState extends State<PopUpMissingFields> {
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
