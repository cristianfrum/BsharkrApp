import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/SignUp/SignUp.dart';
import 'package:Bsharkr/Client/SignUp/SignUp.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/homepage.dart';

import 'Client/globals.dart';

class MainLoginScreen extends StatefulWidget {
  MainLoginScreen(
      {Key key, this.title, this.auth, this.onSignedIn, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final Function onSignedIn;
  final String title;
  final Function onSignedOut;
  @override
  _MainLoginScreenState createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  LoginScreen child;

  @override
  void initState() {
   
    super.initState();
    child = LoginScreen(
      auth: widget.auth,
      onSignedIn: widget.onSignedIn,
      onSignedOut: widget.onSignedOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        body: child);
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen(
      {Key key, this.title, this.auth, this.onSignedIn, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final Function onSignedIn;
  final String title;
  final Function onSignedOut;

  @override
  LoginScreenState createState() => LoginScreenState(onSignedIn: onSignedIn);
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenState({Key key, @required this.onSignedIn});
  final Function onSignedIn;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  QuerySnapshot document;

  bool isLoggedIn = false;
  FirebaseUser currentUser;
  Future<void> initialization() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool splashScreen = false;

  checkIfUserIsLoggedIn(BuildContext context) async {
    if (prefs.getString('id') != null) {
      print("user logged in, redirecting...");
      Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return HomePage(
                auth: widget.auth,
                onSignedOut: widget.onSignedOut,
                id: prefs.getString('id'),
              );
            },
          ));
    } else {
      setState(() {
        splashScreen = true;
      });
      await prefs.setDouble('height', null);
      await prefs.setDouble('width', null);
      await prefs.setString('id', null);
      await prefs.setString('nickname', null);
      await prefs.setString('role', null);
      await prefs.setString('email', null);
      await prefs.setString('password1', null);
      await prefs.setString('password2', null);
      await prefs.setString('firstName', null);
      await prefs.setString('lastName', null);
      await prefs.setInt('age', null);
      await prefs.setString('gender', null);
      await prefs.setString('photoUrl', null);
      await prefs.setString('certificateUrl', null);
    }
  }

  String appID = "";
  String output = "";

  @override
  void initState() {
    super.initState();
    initialization().then((x) {
      checkIfUserIsLoggedIn(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static String _email, _password;
  String atentionare = "";

  Future<void> saveEmailPreference(String email) async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    await prefs1.setString("email", email);
  }

  Future<String> getEmailPreference() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    String email = prefs1.getString("email");
    return email;
  }

  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  bool signingIn = false;

  Future<void> signIn(BuildContext ctx) async {
    //validation
    if (validateAndSave()) {
      setState(() {
        loading = true;
      });
      //login to firebase
      try {
        String userId =
            await widget.auth.signInWithEmailAndPassword(_email, _password);
        try {
          await prefs.setString('nickname', _email);
          await prefs.setString('id', userId);

          // set the role
          prefs.setString(
            "role",
            (await Firestore.instance
                    .collection('clientUsers')
                    .document(userId)
                    .get())
                .data["role"],
          );
          await prefs.setString('expectations', null);
          await prefs.setDouble(
              'width', MediaQuery.of(context).size.width / 375);
          await prefs.setDouble(
              'height', MediaQuery.of(context).size.height / 812);

          widget.onSignedIn(ctx);
        } catch (e) {
          print(e);
          //implementeaza alerta
        }
      } catch (e) {
        if (e.message ==
            "The password is invalid or the user does not have a password.") {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(
              "The email or password you entered is not valid.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0 * MediaQuery.of(context).size.height / 812,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: mainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ));
        }
        if (e.message == "The email address is badly formatted.") {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(
              "The email address is badly formatted.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0 * MediaQuery.of(context).size.height / 812,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: mainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ));
        }
        if (e.message ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(
              "There is no user record corresponding to this identifier. The user may have been deleted.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0 * MediaQuery.of(context).size.height / 812,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: mainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ));
        }
      }
      setState(() {
        loading = false;
      });
    }
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: prefix0.backgroundColor, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ,
        statusBarIconBrightness: Brightness.light));
    return splashScreen == true
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: IgnorePointer(
              ignoring: loading,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: prefix0.backgroundColor,
                body: Builder(
                  builder: (context) => SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 24.0 *
                                  MediaQuery.of(context).size.width /
                                  375,
                              right: 24.0 *
                                  MediaQuery.of(context).size.width /
                                  375),
                          child: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              ListView(
                                children: <Widget>[
                                  Container(
                                    width: 210,
                                    height: (210 *
                                        MediaQuery.of(context).size.height /
                                        812),
                                    child: SvgPicture.asset(
                                      'assets/logof1.svg',
                                      height: 20.0,
                                      width: 20.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.0 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                  ),
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 28.0 *
                                          MediaQuery.of(context).size.height /
                                          812,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 25.0 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                  ),
                                  Container(
                                    height: 65 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                    width: 300 *
                                        MediaQuery.of(context).size.width /
                                        375,
                                    child: TextFormField(
                                        keyboardAppearance: Brightness.dark,
                                        onSaved: (input) => _email = input,
                                        autofocus: false,
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15.0 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                812,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20.0 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                          fillColor:
                                              Color.fromARGB(255, 88, 88, 94),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 2 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      812)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              borderSide: BorderSide(
                                                  color: mainColor,
                                                  style: BorderStyle.solid,
                                                  width: 2 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      812)),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    375),
                                            child: Icon(Icons.email,
                                                color: Color.fromARGB(
                                                    255, 152, 152, 157),
                                                size: 24 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    812),
                                          ),
                                          hintStyle: TextStyle(
                                              height: 1 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812,
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255),
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                          border: InputBorder.none,
                                          hintText: 'Email Address',
                                        )),
                                  ),
                                  SizedBox(
                                    height: 15.0 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                  ),
                                  Container(
                                    height: 65 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                    width: 300 *
                                        MediaQuery.of(context).size.width /
                                        375,
                                    child: TextFormField(
                                        keyboardAppearance: Brightness.dark,
                                        onSaved: (input) => _password = input,
                                        autofocus: false,
                                        obscureText: true,
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15.0 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                812,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20.0 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                          fillColor:
                                              Color.fromARGB(255, 88, 88, 94),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 2 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      812)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(90.0),
                                              borderSide: BorderSide(
                                                  color: mainColor,
                                                  style: BorderStyle.solid,
                                                  width: 2 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      812)),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    375),
                                            child: Icon(Icons.lock,
                                                color: Color.fromARGB(
                                                    255, 152, 152, 157),
                                                size: 24 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    812),
                                          ),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Roboto',
                                              height: 1 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812,
                                              color: Color.fromARGB(
                                                  150, 255, 255, 255),
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10.0 *
                                            MediaQuery.of(context).size.width /
                                            375,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                812),
                                        child: Container(
                                          width: 200.0 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              375,
                                          height: 56.0 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              812,
                                          child: Material(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(90.0),
                                            child: MaterialButton(
                                              onPressed: () {
                                                signIn(context);
                                              },
                                              child: Text(
                                                'Log in',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Colors.white,
                                                    fontSize: 17.0 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        812,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FontStyle.normal),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0 *
                                            MediaQuery.of(context).size.width /
                                            375,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25.0 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("or Sign up, ",
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              color: Colors.white,
                                              fontSize: 16.0 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal),
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30.0 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          await prefs.setDouble(
                                              'width',
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  375);
                                          await prefs.setDouble(
                                              'height',
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SignUpCarouselClient(
                                                            email: _email,
                                                            password: _password,
                                                            auth: widget.auth,
                                                            onSignedIn: widget
                                                                .onSignedIn,
                                                            onSignedOut: widget
                                                                .onSignedOut,
                                                          )));
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/loginIcon1f1.svg',
                                              height: (60 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                              width: (60 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                            ),
                                            SizedBox(
                                              height: 7.0 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812,
                                            ),
                                            Text(
                                              'Client',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 15.0 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      812,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 56.0 *
                                            MediaQuery.of(context).size.width /
                                            375,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          //login to firebase
                                          await prefs.setDouble(
                                              'width',
                                              MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  375);
                                          await prefs.setDouble(
                                              'height',
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SignUpCarouselTrainer(
                                                            email: _email,
                                                            password: _password,
                                                            auth: widget.auth,
                                                            onSignedIn: widget
                                                                .onSignedIn,
                                                            onSignedOut: widget
                                                                .onSignedOut,
                                                          )));
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/loginIcon2f1.svg',
                                              height: (60 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                              width: (60 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812),
                                            ),
                                            SizedBox(
                                              height: 7.0 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  812,
                                            ),
                                            Text(
                                              'Trainer',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.white,
                                                  fontSize: 15.0 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      812,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 36 *
                                        MediaQuery.of(context).size.height /
                                        812,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        ResetPassword(auth: widget.auth),
                                      );
                                    },
                                    child: Text("I forgot my password",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 16.0 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                812,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                              loading == true
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    mainColor),
                                          ),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                    )
                                  : Container()
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            color: backgroundColor,
          );
  }
}

class ResetPassword extends PopupRoute<void> {
  ResetPassword({this.auth});

  final BaseAuth auth;
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
        child: CustomResetPassword(
          auth: auth,
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomResetPassword extends StatefulWidget {
  CustomResetPassword({this.auth});

  final BaseAuth auth;
  @override
  _CustomResetPasswordState createState() => _CustomResetPasswordState();
}

class _CustomResetPasswordState extends State<CustomResetPassword> {
  Future<void> sendPasswordResetEmail(String email) async {
    await widget.auth.resetPassword(email);
  }

  String emailAddress = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * MediaQuery.of(context).size.width / 375),
              height: 489 * MediaQuery.of(context).size.height / 812,
              width: 310 * MediaQuery.of(context).size.width / 375,
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
                    height: 25.0 * MediaQuery.of(context).size.height / 812,
                  ),
                  SvgPicture.asset(
                    'assets/resetPasswordEmail.svg',
                    height: 150.0 * MediaQuery.of(context).size.height / 812,
                    width: 200.0,
                  ),
                  SizedBox(
                    height: 33.0 * MediaQuery.of(context).size.height / 812,
                  ),
                  SizedBox(
                    height: 15.0 * MediaQuery.of(context).size.height / 812,
                  ),
                  Text(
                    "Introduce your email in order to receive the resetting password mail.",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize:
                            14.0 * MediaQuery.of(context).size.height / 812,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: Color.fromARGB(200, 255, 255, 255)),
                  ),
                  SizedBox(
                      height: 24.0 * MediaQuery.of(context).size.height / 812),
                  Container(
                    height: 65 * MediaQuery.of(context).size.height / 812,
                    width: 300 * MediaQuery.of(context).size.width / 375,
                    child: TextField(
                      enabled: true,
                      keyboardAppearance: Brightness.dark,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize:
                              15.0 * MediaQuery.of(context).size.height / 812,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0 *
                                  MediaQuery.of(context).size.height /
                                  812),
                          fillColor: Color.fromARGB(255, 88, 88, 94),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 2 *
                                      MediaQuery.of(context).size.height /
                                      812)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                              borderSide: BorderSide(
                                  color: mainColor,
                                  style: BorderStyle.solid,
                                  width: 2 *
                                      MediaQuery.of(context).size.height /
                                      812)),
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14 *
                                    MediaQuery.of(context).size.width /
                                    375),
                            child: Icon(Icons.email,
                                color: Color.fromARGB(255, 152, 152, 157),
                                size: 26 *
                                    MediaQuery.of(context).size.height /
                                    812),
                          ),
                          hasFloatingPlaceholder: false,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
                          border: InputBorder.none,
                          labelText: "Email Address"),
                      onChanged: (String str) {
                        emailAddress = str;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            15.0 * MediaQuery.of(context).size.height / 812),
                    child: Container(
                      width: 150.0 * MediaQuery.of(context).size.width / 375,
                      height: 50.0 * MediaQuery.of(context).size.height / 812,
                      child: Material(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () async {
                            if (emailAddress != "") {
                              sendPasswordResetEmail(emailAddress);
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontSize: 17.0 *
                                    MediaQuery.of(context).size.height /
                                    812,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 200 * MediaQuery.of(context).size.width / 375,
                      height: 50 * MediaQuery.of(context).size.height / 812,
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize:
                                  17 * MediaQuery.of(context).size.height / 812,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
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
