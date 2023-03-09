import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../colors.dart';
import 'globals.dart';

class ReviewTextErrorClientPopUp extends PopupRoute<void> {
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
          voteFlag = false;
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.transparent,
          child: ReviewTextError(),
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class ReviewTextError extends StatefulWidget {
  @override
  State createState() => ReviewTextErrorState();
}

class ReviewTextErrorState extends State<ReviewTextError> {
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
            voteFlag = false;
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * prefs.getDouble('width')),
              height: 369 * prefs.getDouble('height'),
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
                  SvgPicture.asset(
                    'assets/reviewTextf1.svg',
                    width: 260.0 * prefs.getDouble('width'),
                    height: 180.0 * prefs.getDouble('height'),
                  ),
                  SizedBox(
                    height: 32 * prefs.getDouble('height'),
                  ),
                  Text(
                    "Please avoid using these characters when writing your review: "
                    "~ * / []",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 17 * prefs.getDouble('height'),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 32.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 150.0 * prefs.getDouble('width'),
                      height: 50.0 * prefs.getDouble('height'),
                      child: Material(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(90.0),
                        child: MaterialButton(
                          onPressed: () {
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
            ),
          ),
        ),
      ),
    );
  }
}
