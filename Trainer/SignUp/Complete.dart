
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Main_Menu/MainTrainer.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';

class CompletedSignUp extends StatefulWidget {
  CompletedSignUp({this.auth, this.onSignedOut, });
  final BaseAuth auth;
  final Function onSignedOut;
  @override
  _CompletedSignUpState createState() => _CompletedSignUpState();
}

class _CompletedSignUpState extends State<CompletedSignUp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("DONT"),
                  actions: <Widget>[
                    FlatButton(onPressed: null, child: Text("NO")),
                    FlatButton(onPressed: null, child: Text("Yes")),
                  ],
                ));
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new Container(),
          elevation: 0.0,
          backgroundColor: backgroundColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0 * prefs.getDouble('height'),
                offset: Offset(0.0, 15.0 * prefs.getDouble('height')),
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.fromLTRB(
                15.0 * prefs.getDouble('height'),
                50.0 * prefs.getDouble('height'),
                15.0 * prefs.getDouble('height'),
                100.0 * prefs.getDouble('height')),
            color: Color(0xff3E3E45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/finishf1.svg',
                    width: 250.0 * prefs.getDouble('width'),
                    height: 180.0 * prefs.getDouble('height'),
                  ),
                  SizedBox(
                    height: 30.0 * prefs.getDouble('height'),
                  ),
                  Text(
                    "Congratulations!",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0 * prefs.getDouble('height')),
                  ),
                  Text(
                    "You have registered successfully.",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0 * prefs.getDouble('height')),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 150.0 * prefs.getDouble('width'),
                      height: 50.0 * prefs.getDouble('height'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.0 * prefs.getDouble('height')),
                    child: Container(
                      width: 180.0 * prefs.getDouble('width'),
                      height: 50.0 * prefs.getDouble('height'),
                      child: Material(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(90.0),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MainTrainer(
                                    auth: widget.auth,
                                    onSignedOut: widget.onSignedOut,
                                    selectedPage: 1,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'See your profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0 * prefs.getDouble('height'),
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
