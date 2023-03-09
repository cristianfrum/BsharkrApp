import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/homepage.dart';
import 'package:Bsharkr/login.dart';


String role = "";

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String id;
  @override
  void initState() {
    super.initState();
  }


  void _signedIn(BuildContext context) {
    authStatus = AuthStatus.signedIn;
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context1) => HomePage(
                  auth: widget.auth,
                  onSignedOut: _signedOut,
                  id: id,
                )),
      );
    } catch (ex) {
      print(ex);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context1) => HomePage(
                  auth: widget.auth,
                  onSignedOut: _signedOut,
                  id: id,
                )),
      );
    }
  }

  void _signedOut(BuildContext context) {
    authStatus = AuthStatus.notSignedIn;

    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation animation, Animation secondaryAnimation) {
          return MainLoginScreen(
              auth: widget.auth,
              onSignedIn: _signedIn,
              onSignedOut: _signedOut);
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
        (Route route) => false);
  }


  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: backgroundColor, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ,
        statusBarIconBrightness: Brightness.light));
       
    return MainLoginScreen(
        auth: widget.auth, onSignedIn: _signedIn, onSignedOut: _signedOut);
  }
}
