import 'package:Bsharkr/Client/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../colors.dart';

class PendingApprovalPopUp extends PopupRoute<void> {
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
            Future.delayed(Duration.zero, () { Navigator.of(context).pop(); });
        },
        child: Pending(),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class Pending extends StatefulWidget {
  @override
  State createState() => PendingState();
}

class PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            Future.delayed(Duration.zero, () { Navigator.of(context).pop(); });
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * prefs.getDouble('width')),
              height: 379 * prefs.getDouble('height'),
              width: 310 * prefs.getDouble('width'),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: secondaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Container(
                      width: 200.0 * prefs.getDouble('width'),
                      height: 120 * prefs.getDouble('height'),
                      child: SvgPicture.asset(
                        'assets/waitf1.svg',
                        width: 230.0 * prefs.getDouble('width'),
                        height: 150 * prefs.getDouble('height'),
                      )),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Text(
                    "Please wait",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 20 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8 * prefs.getDouble('height'),),
                  Text(
                    "Your account is still in review, please wait for approval.",maxLines: 2,
                    style: TextStyle(
                      letterSpacing: -0.408,
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(150, 255, 255, 255),
                        fontSize: 17 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8 * prefs.getDouble('height'),),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 32.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 150.0 * prefs.getDouble('width'),
                      height: 50.0 * prefs.getDouble('height'),
                      child: Material(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(90.0),
                        child: MaterialButton(
                          onPressed: () {
            Future.delayed(Duration.zero, () { Navigator.of(context).pop(); });
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
            ),
          ),
        ),
      ),
    );
  }
}
