import 'package:flutter/material.dart';

class CardDetail extends StatefulWidget {
  final String trainerName;

  CardDetail({Key key, this.trainerName}) : super(key: key);

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("${widget.trainerName}"),
      ),
      body: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.0 * MediaQuery.of(context).size.height / 896),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 25.0,
              child: Container(
                height: MediaQuery.of(context).size.height -
                    250 * MediaQuery.of(context).size.height / 896,
                width: MediaQuery.of(context).size.width -
                    120 * MediaQuery.of(context).size.width / 414,
                child: Container(
                  margin: EdgeInsets.only(
                      top: 30.0 * MediaQuery.of(context).size.height / 896,
                      bottom: 30.0 * MediaQuery.of(context).size.height / 896),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.time_to_leave, size: 90.0),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "blabla",
                              style: TextStyle(
                                  fontSize: 60.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Qwigley'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0 *
                                      MediaQuery.of(context).size.height /
                                      896),
                              child: Text(
                                "• frectue •",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontFamily: 'Dosis',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(color: Colors.blue),
                            width: 70 * MediaQuery.of(context).size.width / 414,
                            height:
                                1.0 * MediaQuery.of(context).size.height / 896,
                          ),
                          Container(
                            child: OutlineButton(
                              borderSide: BorderSide(color: Colors.blue),
                              onPressed: () => null,
                              shape: StadiumBorder(),
                              child: SizedBox(
                                width: 90.0 *
                                    MediaQuery.of(context).size.width /
                                    414,
                                height: 45.0 *
                                    MediaQuery.of(context).size.height /
                                    896,
                                child: Center(
                                  child: Text("cal",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.blue),
                            width: 70 * MediaQuery.of(context).size.width / 414,
                            height:
                                1.0 * MediaQuery.of(context).size.height / 896,
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Icon(Icons.people),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0 *
                                          MediaQuery.of(context).size.height /
                                          896),
                                  child: Text(" min"),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.people),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0 *
                                          MediaQuery.of(context).size.height /
                                          896),
                                  child: Text(" min"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        back: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.0 * MediaQuery.of(context).size.height / 896),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 25.0,
              child: Container(
                height: MediaQuery.of(context).size.height -
                    250 * MediaQuery.of(context).size.height / 896,
                width: MediaQuery.of(context).size.width -
                    120 * MediaQuery.of(context).size.width / 414,
                child: Container(
                  margin: EdgeInsets.only(
                      top: 30.0 * MediaQuery.of(context).size.height / 896,
                      bottom: 30.0 * MediaQuery.of(context).size.height / 896),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.time_to_leave, size: 90.0),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "blabla",
                              style: TextStyle(
                                  fontSize: 60.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Qwigley'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0 *
                                      MediaQuery.of(context).size.height /
                                      896),
                              child: Text(
                                "• frectue •",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontFamily: 'Dosis',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(color: Colors.blue),
                            width: 70 * MediaQuery.of(context).size.width / 414,
                            height:
                                1.0 * MediaQuery.of(context).size.height / 896,
                          ),
                          Container(
                            child: OutlineButton(
                              borderSide: BorderSide(color: Colors.blue),
                              onPressed: () => null,
                              shape: StadiumBorder(),
                              child: SizedBox(
                                width: 60.0 *
                                    MediaQuery.of(context).size.width /
                                    414,
                                height: 45.0 *
                                    MediaQuery.of(context).size.height /
                                    896,
                                child: Center(
                                  child: Text("cal",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: Colors.blue),
                            width: 70 * MediaQuery.of(context).size.width / 414,
                            height:
                                1.0 * MediaQuery.of(context).size.height / 896,
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Icon(Icons.people),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0 *
                                          MediaQuery.of(context).size.height /
                                          896),
                                  child: Text(" min"),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.people),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0 *
                                          MediaQuery.of(context).size.height /
                                          896),
                                  child: Text(" min"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum FlipDirection {
  VERTICAL,
  HORIZONTAL,
}

class AnimationCard extends StatelessWidget {
  AnimationCard({this.child, this.animation, this.direction});

  final Widget child;
  final Animation<double> animation;
  final FlipDirection direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        if (direction == FlipDirection.VERTICAL) {
          transform.rotateX(animation.value);
        } else {
          transform.rotateY(animation.value);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final int speed = 500;
  final FlipDirection direction;

  const FlipCard(
      {Key key,
      @required this.front,
      @required this.back,
      this.direction = FlipDirection.HORIZONTAL})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlipCardState();
  }
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;

  var pi = 3.14;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.speed), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2).chain(
            CurveTween(curve: Curves.linear),
          ),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0).chain(
            CurveTween(curve: Curves.linear),
          ),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  _toggleCard() {
    if (isFront) {
      controller.forward();
    } else {
      controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimationCard(
            animation: _frontRotation,
            child: widget.front,
            direction: widget.direction,
          ),
          AnimationCard(
            animation: _backRotation,
            child: widget.back,
            direction: widget.direction,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
