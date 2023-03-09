import 'package:Bsharkr/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Client/globals.dart';

class DisabledAppError extends StatefulWidget {
  @override
  State createState() => DisabledAppErrorState();
}

class DisabledAppErrorState extends State<DisabledAppError> {
  String hinttText = "Scrie";
  Image image;
  String reviewText;
  int localAttribute1 = 1, localAttribute2 = 1;

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
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * prefs.getDouble('width')),
              height: 380 * prefs.getDouble('height'),
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
                  SizedBox(height: 16 * prefs.getDouble('height'),),
                  SvgPicture.asset(
                    'assets/reviewTextf1.svg',
                    width: 260.0 * prefs.getDouble('width'),
                    height: 180.0 * prefs.getDouble('height'),
                  ),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ), 
                  Text(
                    "We are currently working on fixing some issues. You will be notified as soon as the app will be available again.",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 17 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16*prefs.getDouble('height')),
                  Text(
                    "Thanks for being patient!",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 17 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
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
