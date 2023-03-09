/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bsharkr/Client/globals.dart';
import 'package:bsharkr/models/trainerUser.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

class MyTrainer extends StatefulWidget {
  final String myTrainerId;

  MyTrainer({Key key, @required this.myTrainerId}) : super(key: key);
  @override
  _MyTrainerState createState() =>
      new _MyTrainerState(myTrainerId: myTrainerId);
}

class _MyTrainerState extends State<MyTrainer>
    with SingleTickerProviderStateMixin {
  final String myTrainerId;

  _MyTrainerState({Key key, @required this.myTrainerId});
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation;
  AnimationController controller;

  Future<QuerySnapshot> getDataMyTrainer(String id) async {
    return await Firestore.instance
        .collection('clientUsers')
        .where('id', isEqualTo: id)
        .getDocuments();
  }

  Future _getData;

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
    _getData = getDataMyTrainer(myTrainerId);
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0));
    return FutureBuilder<QuerySnapshot>(
        future: _getData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            );
          }
          print(myTrainerId);
          TrainerUser myTrainer = TrainerUser(snapshot.data.documents[0]);
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return Scaffold(
                  body: SlidingUpPanel(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                renderPanelSheet: false,
                panel: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                          ),
                        ]),
                    margin: const EdgeInsets.fromLTRB(24.0, 72.0, 24.0, 0.0),
                    child: CardSlider(
                      height: MediaQuery.of(context).size.height * 0.6,
                      trainerUser: myTrainer,
                    )),
                collapsed: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                  ),
                  margin: const EdgeInsets.fromLTRB(24.0, 72.0, 24.0, 0.0),
                  child: Center(
                    child: Text(
                      "Swipe for gym's details",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                body: Column(children: <Widget>[
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        height: 225.0 * prefs.getDouble('height'),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5 * prefs.getDouble('height'),
                                color: Colors.black,
                                offset: Offset(3.0 * prefs.getDouble('height'),
                                    3.0 * prefs.getDouble('height')),
                              ),
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.indigo,
                                  Colors.indigoAccent,
                                ]),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(28),
                                bottomRight: Radius.circular(28))),
                      ),
                      Positioned.fill(
                        top: 25 * prefs.getDouble('height'),
                        bottom: 50.0 * prefs.getDouble('height'),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            myTrainer.lastName == null
                                ? "nume"
                                : myTrainer.firstName +
                                    " " +
                                    myTrainer.lastName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30 * prefs.getDouble('height')),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 140.0 * prefs.getDouble('height'),
                        left: ((414.0 * prefs.getDouble('width') -
                                    (145 * prefs.getDouble('height'))) /
                                2 -
                            12 * prefs.getDouble('height')),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2.65 * prefs.getDouble('height'),
                                color: Colors.black,
                                offset: Offset(
                                    0.0, 3.5 * prefs.getDouble('height')),
                              ),
                            ],
                            color: Colors.indigo,
                          ),
                          padding:
                              EdgeInsets.all(8.0 * prefs.getDouble('height')),
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.all(
                                  4.0 * prefs.getDouble('height')),
                              color: Colors.white,
                              child: myTrainer.photoUrl == null
                                  ? ClipOval(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          height: (145 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              896),
                                          width: (145 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              896),
                                          child:
                                              Image.asset("assets/snapy.png")),
                                    )
                                  : Material(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.blue),
                                              ),
                                              width: 145.0 *
                                                  prefs.getDouble('height'),
                                              height: 145.0 *
                                                  prefs.getDouble('height'),
                                              padding: EdgeInsets.all(15.0 *
                                                  prefs.getDouble('height')),
                                            ),
                                        imageUrl: myTrainer.photoUrl,
                                        width:
                                            145.0 * prefs.getDouble('height'),
                                        height:
                                            145.0 * prefs.getDouble('height'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(77.5),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 90.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    width: double.infinity,
                    height: 160.0 * prefs.getDouble('height'),
                    padding: EdgeInsets.fromLTRB(
                      50.0 * prefs.getDouble('width'),
                      25.0 * prefs.getDouble('height'),
                      50.0 * prefs.getDouble('width'),
                      25.0 * prefs.getDouble('height'),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialogVotes(
                                trainer: myTrainer,
                              ),
                        );
                      },
                      child: TopGraph(),
                    ),
                  ),
                  SizedBox(
                    height: 5.0 * prefs.getDouble('height'),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Voturi",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20 * prefs.getDouble('height')),
                    ),
                  ),
                  SizedBox(
                    height: 20.0 * prefs.getDouble('height'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.indigo),
                        width: 70 * MediaQuery.of(context).size.width / 414,
                        height: 1.0 * MediaQuery.of(context).size.height / 896,
                      ),
                      Container(
                        height: 45.0 * prefs.getDouble('height'),
                        child: OutlineButton(
                          borderSide: BorderSide(color: Colors.indigo),
                          onPressed: () => null,
                          shape: StadiumBorder(),
                          child: SizedBox(
                            width: 90.0 * prefs.getDouble('width'),
                            child: Center(
                              child: Text("Clienti: 10",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize:
                                          17.0 * prefs.getDouble('height'),
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.indigo),
                        width: 70 * prefs.getDouble('width'),
                        height: 1.0 * prefs.getDouble('height'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0 * prefs.getDouble('height'),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Rating",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20 * prefs.getDouble('height')),
                    ),
                  ),
                  SizedBox(
                    height: 5 * prefs.getDouble('height'),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      50.0 * prefs.getDouble('width'),
                      20.0 * prefs.getDouble('height'),
                      50.0 * prefs.getDouble('width'),
                      20.0 * prefs.getDouble('height'),
                    ),
                    height: 160.0 * prefs.getDouble('height'),
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0 * prefs.getDouble('width')),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogRating(
                                  trainer: myTrainer,
                                ),
                          );
                        },
                        child: BottomGraph(),
                      ),
                    ),
                  ),
                ]),
              ));
            },
          );
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
    ovalPath.moveTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(width * 0.5, height * 0.28, width, height * 0.2);
    canvas.drawPath(ovalPath, paint);
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height * 0.2 + 1), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class BottomGraph extends StatefulWidget {
  BottomGraph();
  @override
  _BottomGraphState createState() => _BottomGraphState();
}

class _BottomGraphState extends State<BottomGraph>
    with SingleTickerProviderStateMixin<BottomGraph> {
  AnimationController _graphAnimationController;

  @override
  void initState() {
    super.initState();
    _graphAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _graphAnimationController.forward();
  }

  @override
  void dispose() {
    _graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Graph2(
      animationController: _graphAnimationController,
    );
  }
}

class Graph2 extends StatelessWidget {
  final double height;
  final AnimationController animationController;

  Graph2({this.animationController, this.height = 120});

  final List val = [0.8, 0.5, 0.9, 0.8, 0.5];

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 32.0),
      height: height * prefs.getDouble('height'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GraphBar2(animationController, val[0]),
          GraphBar2(animationController, val[1]),
          GraphBar2(animationController, val[2]),
          GraphBar2(animationController, val[3]),
          GraphBar2(animationController, val[4]),
        ],
      ),
    );
  }
}

class GraphBar2 extends StatefulWidget {
  final double i;
  final AnimationController _graphBarAnimationController;

  GraphBar2(this._graphBarAnimationController, this.i);

  @override
  _GraphBar2State createState() => _GraphBar2State();
}

class _GraphBar2State extends State<GraphBar2> {
  Animation<double> _percentageAnimation;
  @override
  void initState() {
    super.initState();
    _percentageAnimation = Tween<double>(begin: 0, end: widget.i)
        .animate(widget._graphBarAnimationController);
    _percentageAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: GraphPainter(_percentageAnimation.value),
      child: Container(
        height: 120.0 * prefs.getDouble('height'),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final double percentage;

  GraphPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Offset topPoint = Offset(0, size.height);
    Offset bottomPoint = Offset(0, size.height / 2);
    Paint trackBarPaint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.pink.shade500, Color(0xff818aab)],
              begin: Alignment.topCenter)
          .createShader(Rect.fromPoints(topPoint, bottomPoint))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    Paint trackPaint = Paint()
      ..color = Color(0xffdee6f1)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    double origin = 0;

    canvas.drawLine(Offset(0, size.height), Offset(0, 0), trackPaint);
    double filledHalfHeight = size.height * (1 - percentage);
    canvas.drawLine(
        Offset(0, size.height), Offset(0, filledHalfHeight), trackBarPaint);
    origin = origin + size.width * 0.25;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TopGraph extends StatefulWidget {
  @override
  _TopGraphState createState() => _TopGraphState();
}

class _TopGraphState extends State<TopGraph>
    with SingleTickerProviderStateMixin<TopGraph> {
  AnimationController _graphAnimationController;

  @override
  void initState() {
    super.initState();
    _graphAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _graphAnimationController.forward();
  }

  @override
  void dispose() {
    _graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.center,
        child: Graph(
          animationController: _graphAnimationController,
        ),
      ),
    );
  }
}

class Graph extends StatelessWidget {
  final double height;
  final AnimationController animationController;

  Graph({this.animationController, this.height = 120});

  @override
  Widget build(BuildContext context) {
    double height1 = height * prefs.getDouble('height');
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 32.0 * prefs.getDouble('width')),
      height: height1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GraphBar(height1, 0.5, animationController),
          GraphBar(height1, 0.8, animationController),
          GraphBar(height1, 0.1, animationController),
          GraphBar(height1, 0.7, animationController),
          GraphBar(height1, 0.9, animationController),
        ],
      ),
    );
  }
}

class GraphBar extends StatefulWidget {
  final double height, percentage;
  final AnimationController _graphBarAnimationController;

  GraphBar(this.height, this.percentage, this._graphBarAnimationController);

  @override
  _GraphBarState createState() => _GraphBarState();
}

class _GraphBarState extends State<GraphBar> {
  Animation<double> _percentageAnimation;

  @override
  void initState() {
    super.initState();
    _percentageAnimation = Tween<double>(begin: 0, end: widget.percentage)
        .animate(widget._graphBarAnimationController);
    _percentageAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BarPainter(_percentageAnimation.value),
      child: Container(
        height: widget.height,
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  double percentage;

  BarPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint greyPaint = Paint()
      ..color = Color(0xffdee6f1)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    Offset topPoint = Offset(0, 0);
    Offset bottomPoint = Offset(0, size.height);
    Offset centerPoint = Offset(0, size.height / 2);

    canvas.drawLine(topPoint, bottomPoint, greyPaint);

    Paint filledPaint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.pink.shade500, Color(0xff818aab)],
              begin: Alignment.topCenter)
          .createShader(Rect.fromPoints(topPoint, bottomPoint))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    double filledHeight = percentage * size.height;
    double filledHalfHeight = filledHeight / 2;

    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy - filledHalfHeight), filledPaint);
    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy + filledHalfHeight), filledPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CustomDialogVotes extends StatefulWidget {
  final TrainerUser trainer;

  CustomDialogVotes({Key key, @required this.trainer}) : super(key: key);

  @override
  State createState() => CustomDialogVotesState(trainer: trainer);
}

class CustomDialogVotesState extends State<CustomDialogVotes> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  CustomDialogVotesState({
    @required this.trainer,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    dialogContent(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: (Consts.avatarRadius + Consts.padding) *
                  prefs.getDouble('height'),
              bottom: Consts.padding * prefs.getDouble('height'),
              left: Consts.padding * prefs.getDouble('width'),
              right: Consts.padding * prefs.getDouble('width'),
            ),
            margin: EdgeInsets.only(
                top: Consts.avatarRadius * prefs.getDouble('height')),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0 * prefs.getDouble('height'),
                  offset: const Offset(0.0, 15.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  "Votes",
                  style: TextStyle(
                    fontSize: 24.0 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0 * prefs.getDouble('height')),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute1",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute2",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute3",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute4",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute5",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                SizedBox(height: 24.0 * prefs.getDouble('height')),
              ],
            ),
          ),
          Positioned(
            left: Consts.padding * prefs.getDouble('width'),
            right: Consts.padding * prefs.getDouble('width'),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: Consts.avatarRadius * prefs.getDouble('height'),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset("assets/voting.png"),
              ),
            ),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

class CustomDialogRating extends StatefulWidget {
  final TrainerUser trainer;

  CustomDialogRating({Key key, @required this.trainer}) : super(key: key);

  @override
  State createState() => CustomDialogRatingState(trainer: trainer);
}

class CustomDialogRatingState extends State<CustomDialogRating> {
  String hinttText = "Scrie";
  Image image;
  final TrainerUser trainer;

  CustomDialogRatingState({
    @required this.trainer,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    dialogContent(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: (Consts.avatarRadius + Consts.padding) *
                  prefs.getDouble('height'),
              bottom: Consts.padding * prefs.getDouble('height'),
              left: Consts.padding * prefs.getDouble('width'),
              right: Consts.padding * prefs.getDouble('width'),
            ),
            margin: EdgeInsets.only(
                top: Consts.avatarRadius * prefs.getDouble('height')),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0 * prefs.getDouble('height'),
                  offset: const Offset(0.0, 15.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  "Rating",
                  style: TextStyle(
                    fontSize: 24.0 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0 * prefs.getDouble('height')),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute1",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute2",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute3",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute4",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people,
                      color: Colors.indigo,
                      size: 20.0 * MediaQuery.of(context).size.width / 414),
                  title: Text(
                    "Attribute5",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                  trailing: Text(
                    "123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontSize: 15 * prefs.getDouble('height')),
                  ),
                ),
                SizedBox(height: 24.0 * prefs.getDouble('height')),
              ],
            ),
          ),
          Positioned(
            left: Consts.padding * prefs.getDouble('width'),
            right: Consts.padding * prefs.getDouble('width'),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Consts.avatarRadius * prefs.getDouble('height'),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset("assets/success.png"),
              ),
            ),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
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

  @override
  void initState() {
   
    super.initState();

    positionY_line1 = widget.height * 0.05;
    positionY_line2 = positionY_line1 + 208;

    _middleAreaHeight = positionY_line2 - positionY_line1;
    _outsideCardInterval = 30.0;
    scrollOffsetY = 0;

    _cardInfoList = [
      CardInfo(
          userName: "Name: Andrew Mitchell 1",
          leftColor: Color.fromARGB(255, 85, 67, 91),
          rightColor: Color.fromARGB(200, 108, 90, 112),
          hintTextGym: widget.trainerUser.gym1,
          hintTextGymAddress: widget.trainerUser.gym1Description),
      CardInfo(
          userName: "ANDREW MITCHELL 2",
          leftColor: Color.fromARGB(255, 168, 133, 254),
          rightColor: Color.fromARGB(200, 58, 150, 239),
          hintTextGym: widget.trainerUser.gym2,
          hintTextGymAddress: widget.trainerUser.gym2Description),
      CardInfo(
          userName: "ANDREW MITCHELL 3",
          leftColor: Color.fromARGB(255, 14, 0, 38),
          rightColor: Color.fromARGB(200, 31, 41, 109),
          hintTextGym: widget.trainerUser.gym3,
          hintTextGymAddress: widget.trainerUser.gym3Description),
      CardInfo(
          userName: "ANDREW MITCHELL 4",
          leftColor: Color.fromARGB(255, 243, 0, 122),
          rightColor: Color.fromARGB(250, 243, 0, 246),
          hintTextGym: widget.trainerUser.gym4,
          hintTextGymAddress: widget.trainerUser.gym4Description)
    ];

    for (var i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[i];
      if (i == 0) {
        cardInfo.positionY = positionY_line1;
        cardInfo.opacity = 1.0;
        cardInfo.scale = 1.0;
        cardInfo.rotate = 1.0;
      } else {
        cardInfo.positionY = positionY_line2 + (i - 1) * 30;
        cardInfo.opacity = 0.85 - (i - 1) * 0.1;
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
                      blurRadius: 10,
                      offset: Offset(5, 10))
                ],
                borderRadius: BorderRadius.circular(16),
                color: Colors.red,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardInfo.leftColor,
                      cardInfo.rightColor,
                    ]),
              ),
              width: 300.0,
              height: 190.0,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: 30,
                      width: 200,
                      child: Center(
                        child: Text(
                          cardInfo.hintTextGym,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0, top: 70.0),
                      height: 30,
                      width: 200,
                      child: Center(
                        child: Text(
                          cardInfo.hintTextGymAddress,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: 20,
                    child: Text(
                      "Gender: male",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 20,
                    child: Text(
                      "Age: 24",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: 20,
                    child: Text(
                      cardInfo.userName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  )
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

        cardInfo.opacity = 1.0 -
            0.7 / _outsideCardInterval * (positionY_line1 - cardInfo.positionY);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAreaIdx >= 0 && currentCardAtAreaIdx < 1) {
        cardInfo.positionY =
            positionY_line1 + currentCardAtAreaIdx * _middleAreaHeight;
        cardInfo.rotate = -60.0 /
            (positionY_line2 - positionY_line1) *
            (cardInfo.positionY - positionY_line1);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;

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

        cardInfo.rotate = -60.0;
        cardInfo.scale = 0.9;
        cardInfo.opacity = 0.7;
      }
    }

    scrollOffsetY += offsetY;

    double firstCardAtAreaIdx = scrollOffsetY / _middleAreaHeight;

    for (var i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[_cardInfoList.length - 1 - i];
      updatePosition(cardInfo, firstCardAtAreaIdx, i);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.indigo,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails d) {
              _updateCardsPosition(d.delta.dy);
            },
            onVerticalDragEnd: (DragEndDetails d) {
              scrollOffsetY = (scrollOffsetY / _middleAreaHeight).round() *
                  _middleAreaHeight;
              _updateCardsPosition(0);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
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
                      height: 140.0,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(0, 255, 255, 255),
                              Color.fromARGB(255, 255, 2555, 255)
                            ]),
                      ),
                    ),
                  ),
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

















Container(
                      padding: EdgeInsets.all(30.0 * prefs.getDouble('height')),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50.0 * prefs.getDouble('height'),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 5.0 * prefs.getDouble('height'),
                                    right: 5.0 * prefs.getDouble('height')),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 250, 250, 250)
                                            .withOpacity(0.9),
                                        Color.fromARGB(255, 200, 200, 200)
                                            .withOpacity(0.7),
                                      ]),
                                ),
                                height: 40 * prefs.getDouble('height'),
                                width: 80.0 * prefs.getDouble('width'),
                                child: new GestureDetector(
                                  onTap: () {
                                    SearchServiceA().searchByA('nickname').then(
                                      (QuerySnapshot docss) {
                                        setState(
                                          () {
                                            tempSearchStore = [];
                                            for (int i = 0;
                                                i < docss.documents.length;
                                                ++i) {
                                              TrainerUser _trainerUser =
                                                  TrainerUser(
                                                      docss.documents[i]);
                                              tempSearchStore.add(_trainerUser);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                      child: Text(
                                    "Attribute1",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            15.0 * prefs.getDouble('height')),
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 5.0 * prefs.getDouble('width'),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 5.0 * prefs.getDouble('height'),
                                    right: 5.0 * prefs.getDouble('height')),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      5.0 * prefs.getDouble('height')),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 250, 250, 250)
                                            .withOpacity(0.9),
                                        Color.fromARGB(255, 200, 200, 200)
                                            .withOpacity(0.7),
                                      ]),
                                ),
                                height: 40 * prefs.getDouble('height'),
                                width: 80.0 * prefs.getDouble('width'),
                                child: new GestureDetector(
                                  onTap: () {
                                    SearchServiceB().searchByB('b').then(
                                      (QuerySnapshot docss) {
                                        setState(
                                          () {
                                            tempSearchStore = [];
                                            for (int i = 0;
                                                i < docss.documents.length;
                                                ++i) {
                                              tempSearchStore
                                                  .add(docss.documents[i].data);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                      child: Text(
                                    "Attribute2",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            15.0 * prefs.getDouble('height')),
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 5.0 * prefs.getDouble('height'),
                                    right: 5.0 * prefs.getDouble('height')),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 250, 250, 250)
                                            .withOpacity(0.9),
                                        Color.fromARGB(255, 200, 200, 200)
                                            .withOpacity(0.7),
                                      ]),
                                ),
                                height: 40 * prefs.getDouble('height'),
                                width: 80.0 * prefs.getDouble('width'),
                                child: new GestureDetector(
                                  onTap: () {
                                    SearchServiceC().searchByC('c').then(
                                      (QuerySnapshot docss) {
                                        setState(
                                          () {
                                            tempSearchStore = [];
                                            for (int i = 0;
                                                i < docss.documents.length;
                                                ++i) {
                                              tempSearchStore
                                                  .add(docss.documents[i].data);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                      child: Text("Attribute3",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0 *
                                                  prefs.getDouble('height')))),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 5.0 * prefs.getDouble('height'),
                                    right: 5.0 * prefs.getDouble('height')),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      5.0 * prefs.getDouble('height')),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 250, 250, 250)
                                            .withOpacity(0.9),
                                        Color.fromARGB(255, 200, 200, 200)
                                            .withOpacity(0.7),
                                      ]),
                                ),
                                height: 40 * prefs.getDouble('height'),
                                width: 80.0 * prefs.getDouble('width'),
                                child: new GestureDetector(
                                  onTap: () {
                                    SearchServiceD().searchByD('d').then(
                                      (QuerySnapshot docss) {
                                        setState(
                                          () {
                                            tempSearchStore = [];
                                            for (int i = 0;
                                                i < docss.documents.length;
                                                ++i) {
                                              tempSearchStore
                                                  .add(docss.documents[i].data);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                      child: Text("Attribute4",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0 *
                                                  prefs.getDouble('height')))),
                                ),
                              ),
                              SizedBox(
                                width: 5.0 *
                                    MediaQuery.of(context).size.width /
                                    414,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 5.0 * prefs.getDouble('height'),
                                    right: 5.0 * prefs.getDouble('height')),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      5.0 * prefs.getDouble('height')),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 250, 250, 250)
                                            .withOpacity(0.9),
                                        Color.fromARGB(255, 200, 200, 200)
                                            .withOpacity(0.7),
                                      ]),
                                ),
                                height: 40 * prefs.getDouble('height'),
                                width: 80.0 * prefs.getDouble('width'),
                                child: new GestureDetector(
                                  onTap: () {
                                    SearchServiceE().searchByE('e').then(
                                      (QuerySnapshot docss) {
                                        setState(
                                          () {
                                            tempSearchStore = [];
                                            for (int i = 0;
                                                i < docss.documents.length;
                                                ++i) {
                                              tempSearchStore
                                                  .add(docss.documents[i].data);
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                      child: Text("Attribute5",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0 *
                                                  prefs.getDouble('height')))),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  5.0 * prefs.getDouble('height')),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 250, 250, 250)
                                        .withOpacity(0.9),
                                    Color.fromARGB(255, 200, 200, 200)
                                        .withOpacity(0.7),
                                  ]),
                            ),
                            height: 40 * prefs.getDouble('height'),
                            width: 80.0 * prefs.getDouble('width'),
                            child: new GestureDetector(
                              onTap: () {},
                              child: Center(
                                  child: Text("All",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0 *
                                              prefs.getDouble('height')))),
                            ),
                          ),
                        ],
                      ),
                    ),
*/

 