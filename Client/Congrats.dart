import 'dart:ui';

import 'package:Bsharkr/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'globals.dart';

class CongratsPopup extends PopupRoute<void> {
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: CongratsDialogue(),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CongratsDialogue extends StatefulWidget {
  @override
  State createState() => CongratsDialogueState();
}

class CongratsDialogueState extends State<CongratsDialogue> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                height: 428 * prefs.getDouble('height'),
                width: 310 * prefs.getDouble('width'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: secondaryColor,
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    16 * prefs.getDouble('height'),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 16 * prefs.getDouble('height')),
                      SvgPicture.asset(
                        'assets/congratsEnrolledf1.svg',
                        width: 200.0 * prefs.getDouble('width'),
                        height: 160.0 * prefs.getDouble('height'),
                      ),
                      SizedBox(
                        height: 36 * prefs.getDouble('height'),
                      ),
                      Text(
                        "Congratulations!",
                        style: TextStyle(
                            fontSize: 20 * prefs.getDouble('height'),
                            letterSpacing: -0.078,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto'),
                      ),
                      SizedBox(
                        height: 12 * prefs.getDouble('height'),
                      ),
                      Text(
                        "You will be notified 2-3 hours before the class will start",
                        style: TextStyle(
                            fontSize: 17 * prefs.getDouble('height'),
                            letterSpacing: -0.078,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 32.0 * prefs.getDouble('height')),
                        child: Container(
                          width: 150.0 * prefs.getDouble('width'),
                          height: 60.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Okay',
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
                )),
          ),
        ),
      ),
    );
  }
}
