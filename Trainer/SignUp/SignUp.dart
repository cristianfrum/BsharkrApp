import 'dart:math';

import 'package:dashed_container/dashed_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:Bsharkr/Trainer/SignUp/Complete.dart';
import 'package:Bsharkr/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math' as math;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_listview/infinite_listview.dart';

class SignUpCarouselTrainer extends StatefulWidget {
  final String email;
  final String password;
  final BaseAuth auth;
  final Function onSignedIn;
  final Function onSignedOut;
  SignUpCarouselTrainer({
    Key key,
    @required this.email,
    @required this.password,
    @required this.auth,
    @required this.onSignedIn,
    @required this.onSignedOut,
  }) : super(key: key);
  State createState() => _SignUpCarouselTrainerState(
        email: email,
        password: password,
      );
}

class _SignUpCarouselTrainerState extends State<SignUpCarouselTrainer> {
  var profilePhoto;
  var certificatePhoto;
  final String email;
  final String password;
  _SignUpCarouselTrainerState({
    Key key,
    @required this.email,
    @required this.password,
  });
  PageController _pageController;
  int currentPage = 0;

  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;
  TextEditingController _controllerConfirmPassword;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String gender = "";
  bool marked = false;
  String hinttText1 = "";
  String hinttText2 = "";

  String labelText1 = "Enter First Name";
  String labelText2 = "Enter Last Name";

  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  bool pressedRegisterButton = false;

  String pushToken;

  @override
  void initState() {
    super.initState();
    _controllerEmail = new TextEditingController(
        text:
            (prefs.getString('email') == null || prefs.getString('email') == '')
                ? ''
                : prefs.getString('email'));
    _controllerPassword = new TextEditingController(
        text: (prefs.getString('password1') == null ||
                prefs.getString('password1') == '')
            ? ''
            : prefs.getString('password1'));
    _controllerConfirmPassword = new TextEditingController(
        text: (prefs.getString('password2') == null ||
                prefs.getString('password2') == '')
            ? ''
            : prefs.getString('password2'));
    _pageController = PageController(
      initialPage: currentPage,
    );
  }

  Widget dot(int index, int current) {
    return Container(
      width: 24.0 * prefs.getDouble('width'),
      height: 8.0 * prefs.getDouble('height'),
      margin: EdgeInsets.symmetric(
          vertical: 20.0 * prefs.getDouble('height'),
          horizontal: 5.0 * prefs.getDouble('width')),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90.0),
          color: current == index ? mainColor : Color(0xff3E3E45)),
    );
  }

  bool _passwordVisible2 = true, _passwordVisible1 = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(
                Icons.backspace,
                color: Colors.white,
                size: 24 * prefs.getDouble('height'),
              ),
              onPressed: () async {
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainLoginScreen(
                            onSignedIn: widget.onSignedIn,
                            onSignedOut: widget.onSignedOut,
                            auth: widget.auth)));
              }),
          centerTitle: true,
          title: Text(
            "Register",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 21 * prefs.getDouble('height'),
                color: Colors.white),
          ),
          backgroundColor: backgroundColor,
          elevation: 0.0,
        ),
        body: Builder(
            builder: (context) => IgnorePointer(
                  ignoring: pressedRegisterButton,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: backgroundColor),
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              PageView(
                                controller: _pageController,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPage = value;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius:
                                              10.0 * prefs.getDouble('height'),
                                          offset: Offset(0.0,
                                              15.0 * prefs.getDouble('height')),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.fromLTRB(
                                          15.0 * prefs.getDouble('width'),
                                          18.0 * prefs.getDouble('height'),
                                          15.0 * prefs.getDouble('width'),
                                          82.0 * prefs.getDouble('height')),
                                      color: Color(0xff3E3E45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0 * prefs.getDouble('height')),
                                      ),
                                      child: AgeInsertion(
                                          pageController: _pageController,
                                          parent: this),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius:
                                              10.0 * prefs.getDouble('height'),
                                          offset: Offset(0.0,
                                              15.0 * prefs.getDouble('height')),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.fromLTRB(
                                          15.0 * prefs.getDouble('width'),
                                          18.0 * prefs.getDouble('height'),
                                          15.0 * prefs.getDouble('width'),
                                          82.0 * prefs.getDouble('height')),
                                      color: Color(0xff3E3E45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0 * prefs.getDouble('height')),
                                      ),
                                      child: PhotoUpload(parent: this),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius:
                                              10.0 * prefs.getDouble('height'),
                                          offset: Offset(0.0,
                                              15.0 * prefs.getDouble('height')),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.fromLTRB(
                                          15.0 * prefs.getDouble('width'),
                                          18.0 * prefs.getDouble('height'),
                                          15.0 * prefs.getDouble('width'),
                                          82.0 * prefs.getDouble('height')),
                                      color: Color(0xff3E3E45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0 * prefs.getDouble('height')),
                                      ),
                                      child: CertificateUpload(
                                        parent: this,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius:
                                              10.0 * prefs.getDouble('height'),
                                          offset: Offset(0.0,
                                              15.0 * prefs.getDouble('height')),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.fromLTRB(
                                          15.0 * prefs.getDouble('width'),
                                          18.0 * prefs.getDouble('height'),
                                          15.0 * prefs.getDouble('width'),
                                          82.0 * prefs.getDouble('height')),
                                      color: Color(0xff3E3E45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0 * prefs.getDouble('height')),
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 42.0 *
                                                    prefs.getDouble('height'),
                                              ),
                                              SvgPicture.asset(
                                                'assets/personalInfof1.svg',
                                                width: 250.0 *
                                                    prefs.getDouble('width'),
                                                height: 180.0 *
                                                    prefs.getDouble('height'),
                                              ),
                                              SizedBox(
                                                height: 48.0 *
                                                    prefs.getDouble('height'),
                                              ),
                                              Container(
                                                height: 65 *
                                                    prefs.getDouble('height'),
                                                width: 300 *
                                                    prefs.getDouble('width'),
                                                child: TextField(
                                                  controller: _controllerEmail,
                                                  keyboardAppearance:
                                                      Brightness.dark,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                  decoration:
                                                      new InputDecoration(
                                                          hasFloatingPlaceholder:
                                                              false,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              vertical: 20.0 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                          fillColor: Color.fromARGB(
                                                              255, 88, 88, 94),
                                                          filled: true,
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      90.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  width: 2 *
                                                                      prefs.getDouble('height'))),
                                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0), borderSide: BorderSide(color: mainColor, style: BorderStyle.solid, width: 2 * prefs.getDouble('height'))),
                                                          prefixIcon: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 14 *
                                                                    prefs.getDouble(
                                                                        'width')),
                                                            child: Icon(
                                                                Icons.email,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        152,
                                                                        152,
                                                                        157),
                                                                size: 26 *
                                                                    prefs.getDouble(
                                                                        'height')),
                                                          ),
                                                          hintStyle: TextStyle(fontFamily: 'Roboto', color: Color(0xffFFFFFF), fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
                                                          labelStyle: TextStyle(fontFamily: 'Roboto', color: Color(0xffFFFFFF), fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
                                                          border: InputBorder.none,
                                                          labelText: (prefs.getString('email') == null || prefs.getString('email') == '') ? 'Email address' : prefs.getString('email')),
                                                  onChanged: (String str) {
                                                    setState(() {
                                                      hinttText1 = str;
                                                      prefs.setString(
                                                          'email', str);
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0 *
                                                    prefs.getDouble('height'),
                                              ),
                                              Container(
                                                height: 65 *
                                                    prefs.getDouble('height'),
                                                width: 300 *
                                                    prefs.getDouble('width'),
                                                child: TextField(
                                                  controller:
                                                      _controllerPassword,
                                                  keyboardAppearance:
                                                      Brightness.dark,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  obscureText:
                                                      _passwordVisible1,
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                  decoration:
                                                      new InputDecoration(
                                                          suffixIcon: Padding(
                                                            padding: EdgeInsets.only(
                                                                right: 8 *
                                                                    prefs.getDouble(
                                                                        'height')),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                // Based on passwordVisible state choose the icon
                                                                _passwordVisible1
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color:
                                                                    mainColor,
                                                                size: 22 *
                                                                    prefs.getDouble(
                                                                        'height'),
                                                              ),
                                                              onPressed: () {
                                                                // Update the state i.e. toogle the state of passwordVisible variable
                                                                setState(() {
                                                                  _passwordVisible1 =
                                                                      !_passwordVisible1;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          hasFloatingPlaceholder:
                                                              false,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .never,
                                                          contentPadding: EdgeInsets.symmetric(
                                                              vertical: 20.0 *
                                                                  prefs.getDouble(
                                                                      'height')),
                                                          fillColor: Color.fromARGB(
                                                              255, 88, 88, 94),
                                                          filled: true,
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      90.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  width: 2 *
                                                                      prefs.getDouble('height'))),
                                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0), borderSide: BorderSide(color: mainColor, style: BorderStyle.solid, width: 2 * prefs.getDouble('height'))),
                                                          prefixIcon: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 14 *
                                                                    prefs.getDouble(
                                                                        'width')),
                                                            child: Icon(
                                                                Icons.lock,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        152,
                                                                        152,
                                                                        157),
                                                                size: 26 *
                                                                    prefs.getDouble(
                                                                        'height')),
                                                          ),
                                                          labelStyle: TextStyle(fontFamily: 'Roboto', color: Color(0xffFFFFFF), fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
                                                          border: InputBorder.none,
                                                          labelText: (prefs.getString('password1') == null || prefs.getString('password1') == '') ? 'Password' : prefs.getString('password1')),
                                                  onChanged: (String str) {
                                                    setState(() {
                                                      hinttText1 = str;
                                                      prefs.setString(
                                                          'password1', str);
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0 *
                                                    prefs.getDouble('height'),
                                              ),
                                              Container(
                                                height: 65 *
                                                    prefs.getDouble('height'),
                                                width: 300 *
                                                    prefs.getDouble('width'),
                                                child: TextField(
                                                  controller:
                                                      _controllerConfirmPassword,
                                                  keyboardAppearance:
                                                      Brightness.dark,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  obscureText:
                                                      _passwordVisible2,
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 15.0 *
                                                          prefs.getDouble(
                                                              'height'),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                  decoration:
                                                      new InputDecoration(
                                                    hasFloatingPlaceholder:
                                                        false,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20.0 *
                                                                prefs.getDouble(
                                                                    'height')),
                                                    fillColor: Color.fromARGB(
                                                        255, 88, 88, 94),
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90.0),
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 2 *
                                                                prefs.getDouble(
                                                                    'height'))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90.0),
                                                        borderSide: BorderSide(
                                                            color: mainColor,
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 2 *
                                                                prefs.getDouble(
                                                                    'height'))),
                                                    suffixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8 *
                                                              prefs.getDouble(
                                                                  'height')),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          // Based on passwordVisible state choose the icon
                                                          _passwordVisible2
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: mainColor,
                                                          size: 22 *
                                                              prefs.getDouble(
                                                                  'height'),
                                                        ),
                                                        onPressed: () {
                                                          // Update the state i.e. toogle the state of passwordVisible variable
                                                          setState(() {
                                                            _passwordVisible2 =
                                                                !_passwordVisible2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 14 *
                                                                  prefs.getDouble(
                                                                      'width')),
                                                      child: Icon(Icons.lock,
                                                          color: Color.fromARGB(
                                                              255,
                                                              152,
                                                              152,
                                                              157),
                                                          size: 24 *
                                                              prefs.getDouble(
                                                                  'height')),
                                                    ),
                                                    labelStyle: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                    border: InputBorder.none,
                                                    labelText: (prefs.getString(
                                                                    'password2') ==
                                                                null ||
                                                            prefs.getString(
                                                                    'password2') ==
                                                                '')
                                                        ? 'Confirm password'
                                                        : prefs.getString(
                                                            'password2'),
                                                  ),
                                                  onChanged: (String str) {
                                                    setState(() {
                                                      hinttText1 = str;
                                                      prefs.setString(
                                                          'password2', str);
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 36.0 *
                                                        prefs.getDouble(
                                                            'height')),
                                                child: Container(
                                                  width: 150.0 *
                                                      prefs.getDouble('width'),
                                                  height: 50.0 *
                                                      prefs.getDouble('height'),
                                                  child: Material(
                                                    color: mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90.0),
                                                    child: MaterialButton(
                                                      onPressed: () async {
                                                        if (pressedRegisterButton ==
                                                            false) {
                                                          if (prefs.getInt(
                                                                  'age') ==
                                                              null) {
                                                            Scaffold.of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                "Age is missing",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize: 18.0 *
                                                                        prefs.getDouble(
                                                                            'height'),
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        mainColor),
                                                              ),
                                                              action:
                                                                  SnackBarAction(
                                                                label: "Ignore",
                                                                onPressed: Scaffold.of(
                                                                        context)
                                                                    .hideCurrentSnackBar,
                                                              ),
                                                            ));
                                                          } else {
                                                            if (prefs.getString(
                                                                    'gender') ==
                                                                null) {
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "Gender is missing",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize: 18.0 *
                                                                          prefs.getDouble(
                                                                              'height'),
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          mainColor),
                                                                ),
                                                                action:
                                                                    SnackBarAction(
                                                                  label:
                                                                      "Ignore",
                                                                  onPressed: Scaffold.of(
                                                                          context)
                                                                      .hideCurrentSnackBar,
                                                                ),
                                                              ));
                                                            } else {
                                                              if (prefs.getString(
                                                                      'firstName') ==
                                                                  null) {
                                                                Scaffold.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    "First name is missing",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize: 18.0 *
                                                                            prefs.getDouble(
                                                                                'height'),
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color:
                                                                            mainColor),
                                                                  ),
                                                                  action:
                                                                      SnackBarAction(
                                                                    label:
                                                                        "Ignore",
                                                                    onPressed: Scaffold.of(
                                                                            context)
                                                                        .hideCurrentSnackBar,
                                                                  ),
                                                                ));
                                                              } else {
                                                                if (prefs.getString(
                                                                        'lastName') ==
                                                                    null) {
                                                                  Scaffold.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content:
                                                                        Text(
                                                                      "Last name is missing",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize: 18.0 *
                                                                              prefs.getDouble(
                                                                                  'height'),
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              mainColor),
                                                                    ),
                                                                    action:
                                                                        SnackBarAction(
                                                                      label:
                                                                          "Ignore",
                                                                      onPressed:
                                                                          Scaffold.of(context)
                                                                              .hideCurrentSnackBar,
                                                                    ),
                                                                  ));
                                                                } else {
                                                                  if (prefs.getString(
                                                                          'certificateUrl') ==
                                                                      null) {
                                                                    Scaffold.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content:
                                                                          Text(
                                                                        "The certificate is missing",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Roboto',
                                                                            fontSize:
                                                                                18.0 * prefs.getDouble('height'),
                                                                            fontStyle: FontStyle.normal,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: mainColor),
                                                                      ),
                                                                      action:
                                                                          SnackBarAction(
                                                                        label:
                                                                            "Ignore",
                                                                        onPressed:
                                                                            Scaffold.of(context).hideCurrentSnackBar,
                                                                      ),
                                                                    ));
                                                                  } else {
                                                                    if (prefs.getString(
                                                                            'email') ==
                                                                        null) {
                                                                      Scaffold.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content:
                                                                            Text(
                                                                          "The email is missing",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontSize: 18.0 * prefs.getDouble('height'),
                                                                              fontStyle: FontStyle.normal,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: mainColor),
                                                                        ),
                                                                        action:
                                                                            SnackBarAction(
                                                                          label:
                                                                              "Ignore",
                                                                          onPressed:
                                                                              Scaffold.of(context).hideCurrentSnackBar,
                                                                        ),
                                                                      ));
                                                                    } else {
                                                                      if (prefs.getString(
                                                                              'password1') ==
                                                                          null) {
                                                                        Scaffold.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text(
                                                                            "The password is missing",
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: 18.0 * prefs.getDouble('height'),
                                                                                fontStyle: FontStyle.normal,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: mainColor),
                                                                          ),
                                                                          action:
                                                                              SnackBarAction(
                                                                            label:
                                                                                "Ignore",
                                                                            onPressed:
                                                                                Scaffold.of(context).hideCurrentSnackBar,
                                                                          ),
                                                                        ));
                                                                      } else {
                                                                        if (prefs.getString('password1').length <
                                                                            6) {
                                                                          Scaffold.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text(
                                                                              "The password needs at least 6 characters",
                                                                              style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0 * prefs.getDouble('height'), fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: mainColor),
                                                                            ),
                                                                            action:
                                                                                SnackBarAction(
                                                                              label: "Ignore",
                                                                              onPressed: Scaffold.of(context).hideCurrentSnackBar,
                                                                            ),
                                                                          ));
                                                                        } else {
                                                                          if (prefs.getString('password1') !=
                                                                              prefs.getString('password2')) {
                                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                              content: Text(
                                                                                "The passwords do not match",
                                                                                style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0 * prefs.getDouble('height'), fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: mainColor),
                                                                              ),
                                                                              action: SnackBarAction(
                                                                                label: "Ignore",
                                                                                onPressed: Scaffold.of(context).hideCurrentSnackBar,
                                                                              ),
                                                                            ));
                                                                          } else {
                                                                            if (mounted) {
                                                                              setState(() {
                                                                                pressedRegisterButton = true;
                                                                              });
                                                                            }
                                                                            if (validateAndSave()) {
                                                                              String userId;

                                                                              userId = await widget.auth.createUserWithEmailAndPassword(prefs.getString('email'), prefs.getString('password1'));
                                                                              if (userId == "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)") {
                                                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                                                  content: Text(
                                                                                    "This email is already being used by somebody else.",
                                                                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0 * prefs.getDouble('height'), fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: mainColor),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ));
                                                                              } else {
                                                                                if (userId == "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)") {
                                                                                  Scaffold.of(context).showSnackBar(SnackBar(
                                                                                    content: Text(
                                                                                      "This email is not valid",
                                                                                      style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0 * prefs.getDouble('height'), fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: mainColor),
                                                                                      textAlign: TextAlign.center,
                                                                                    ),
                                                                                  ));
                                                                                } else {
                                                                                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                                                                  user.delete();
                                                                                  Navigator.push(context, PopUpAgreeRoute(auth: widget.auth, onSignedIn: widget.onSignedIn, onSignedOut: widget.onSignedOut, profilePhoto: profilePhoto, certificatePhoto: certificatePhoto));
                                                                                }
                                                                              }
                                                                              if (mounted) {
                                                                                setState(() {
                                                                                  pressedRegisterButton = false;
                                                                                });
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        'Register',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Colors.white,
                                                            fontSize: 17.0 *
                                                                prefs.getDouble(
                                                                    'height'),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FontStyle
                                                                .normal),
                                                        textAlign:
                                                            TextAlign.center,
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
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      32.0 * prefs.getDouble('height')),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      dot(0, currentPage),
                                      dot(1, currentPage),
                                      dot(2, currentPage),
                                      dot(3, currentPage),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pressedRegisterButton == true
                          ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      8.0 * prefs.getDouble('height')),
                                  color: backgroundColor,
                                ),
                                height: 80 * prefs.getDouble('height'),
                                width: 80 * prefs.getDouble('width'),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          mainColor),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                )),
      ),
    );
  }
}

class PhotoUpload extends StatefulWidget {
  PhotoUpload({this.parent});
  final _SignUpCarouselTrainerState parent;
  State createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload>
    with SingleTickerProviderStateMixin {
  TextEditingController _controllerFirstName;
  TextEditingController _controllerSecondName;
  var tempImage;
  String hinttText1 = "";
  String hinttText2 = "";

  String labelText1 = "Introdu Prenumele";
  String labelText2 = "Introdu Numele";

  Future _getImage() async {
    var aux = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      tempImage = aux;
      widget.parent.setState(() {
        widget.parent.profilePhoto = tempImage;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tempImage = widget.parent.profilePhoto;
    _controllerFirstName = new TextEditingController(
        text: (prefs.getString('firstName') == null ||
                prefs.getString('firstName') == '')
            ? ''
            : prefs.getString('firstName'));
    _controllerSecondName = new TextEditingController(
        text: (prefs.getString('lastName') == null ||
                prefs.getString('lastName') == '')
            ? ''
            : prefs.getString('lastName'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60 * prefs.getDouble('height'),
            ),
            tempImage == null
                ? GestureDetector(
                    onTap: () async {
                      _getImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0 * prefs.getDouble('height')),
                      child: DashedContainer(
                        strokeWidth: 5.0 * prefs.getDouble('height'),
                        blankLength: 6.0 * prefs.getDouble('height'),
                        dashColor: mainColor,
                        boxShape: BoxShape.circle,
                        child: Container(
                          width: 150.0 * prefs.getDouble('height'),
                          height: 150.0 * prefs.getDouble('height'),
                          decoration: BoxDecoration(
                            color: Color(0xff57575E),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            size: 35.0 * prefs.getDouble('height'),
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      _getImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0 * prefs.getDouble('height')),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: backgroundColor),
                      child: Stack(
                        children: <Widget>[
                          Material(
                            color: secondaryColor,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100.0),
                                ),
                              ),
                              child: Image.file(
                                tempImage,
                                width: 150.0 * prefs.getDouble('height'),
                                height: 150.0 * prefs.getDouble('height'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(100.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          Positioned(
                            top: 115.0 * prefs.getDouble('height'),
                            left: 115.0 * prefs.getDouble('height'),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: backgroundColor),
                              child: Container(
                                width: 28 * prefs.getDouble('height'),
                                height: 28 * prefs.getDouble('height'),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: mainColor,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 15.0 * prefs.getDouble('height'),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: 20.0 * prefs.getDouble('height'),
            ),
            Container(
              height: 20.0 * prefs.getDouble('height'),
              child: Text(
                "Pick your avatar",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0 * prefs.getDouble('height')),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 105.0 * prefs.getDouble('height'),
            ),
            Container(
              height: 138 * prefs.getDouble('height'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 65 * prefs.getDouble('height'),
                    width: 300 * prefs.getDouble('width'),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: _controllerFirstName,
                      keyboardAppearance: Brightness.dark,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0 * prefs.getDouble('height')),
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
                                horizontal: 14 * prefs.getDouble('width')),
                            child: Icon(Icons.account_circle,
                                color: Color.fromARGB(255, 152, 152, 157),
                                size: 26 * prefs.getDouble('height')),
                          ),
                          hasFloatingPlaceholder: false,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
                          labelStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
                          border: InputBorder.none,
                          labelText: (prefs.getString('firstName') == null ||
                                  prefs.getString('firstName') == '')
                              ? 'First name'
                              : (prefs.getString('firstName')[0].toUpperCase() +
                                  prefs.getString('firstName').substring(1))),
                      onChanged: (String str) {
                        setState(() {
                          if (str != '') {
                            hinttText1 =
                                str[0].toUpperCase() + str.substring(1);
                            prefs.setString('firstName',
                                str[0].toUpperCase() + str.substring(1));
                            _controllerFirstName.value = TextEditingValue(
                                text: str[0].toUpperCase() + str.substring(1),
                                selection: _controllerFirstName.selection);
                          } else {
                            prefs.setString('firstName', null);
                            _controllerFirstName.value = TextEditingValue(
                                text: '',
                                selection: _controllerFirstName.selection);
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8.0 * prefs.getDouble('height'),
                  ),
                  Container(
                    height: 65 * prefs.getDouble('height'),
                    width: 300 * prefs.getDouble('width'),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: _controllerSecondName,
                      enabled: true,
                      keyboardAppearance: Brightness.dark,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15.0 * prefs.getDouble('height'),
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0 * prefs.getDouble('height')),
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
                                horizontal: 14 * prefs.getDouble('width')),
                            child: Icon(Icons.account_circle,
                                color: Color.fromARGB(255, 152, 152, 157),
                                size: 26 * prefs.getDouble('height')),
                          ),
                          hasFloatingPlaceholder: false,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal),
                          border: InputBorder.none,
                          labelText: (prefs.getString('lastName') == null ||
                                  prefs.getString('lastName') == '')
                              ? 'Last name'
                              : prefs.getString('lastName')),
                      onChanged: (String str) {
                        setState(() {
                          if (str != '') {
                            hinttText2 = str;
                            prefs.setString('lastName',
                                str[0].toUpperCase() + str.substring(1));
                            _controllerSecondName.value = TextEditingValue(
                                text: str[0].toUpperCase() + str.substring(1),
                                selection: _controllerSecondName.selection);
                          } else {
                            prefs.setString('lastName', null);
                            _controllerSecondName.value = TextEditingValue(
                                text: '',
                                selection: _controllerSecondName.selection);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 24.0 * prefs.getDouble('height')),
              child: Container(
                width: 150.0 * prefs.getDouble('width'),
                height: 50.0 * prefs.getDouble('height'),
                child: Material(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(90.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (widget.parent._pageController.hasClients) {
                        setState(() {
                          widget.parent._pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        });
                      }
                    },
                    child: Text(
                      'Continue',
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
        )),
      ),
    );
  }
}

class AgeInsertion extends StatefulWidget {
  AgeInsertion({this.pageController, this.parent});
  final _SignUpCarouselTrainerState parent;
  final PageController pageController;
  State createState() => _AgeInsertionState();
}

class _AgeInsertionState extends State<AgeInsertion> {
  int _currentValue = 25;
  bool enabledButton1 = false;
  bool enabledButton2 = false;

  @override
  void initState() {
   
    super.initState();
    if (prefs.getInt('age') != null) {
      _currentValue = prefs.getInt('age');
    } else {
      prefs.setInt('age', 25);
    }

    if (prefs.getString('gender') != null) {
      if (prefs.getString('gender') == 'male') {
        enabledButton1 = true;
      } else {
        enabledButton2 = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30.0 * prefs.getDouble('height'),
          ),
          SvgPicture.asset(
            'assets/birthdayf1.svg',
            width: 250.0 * prefs.getDouble('width'),
            height: 180.0 * prefs.getDouble('height'),
          ),
          SizedBox(
            height: 40 * prefs.getDouble('height'),
          ),
          Container(
            height: 139 * prefs.getDouble('height'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 20 * prefs.getDouble('height'),
                  child: Text(
                    "Select your age",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17.0 * prefs.getDouble('height'),
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        color: Color.fromARGB(155, 255, 255, 255)),
                  ),
                ),
                SizedBox(
                  height: 15.0 * prefs.getDouble('height'),
                ),
                Container(
                  height: 16 * prefs.getDouble('height'),
                  child: Text(
                    "|",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: mainColor,
                        fontSize: 15.0 * prefs.getDouble('height')),
                  ),
                ),
                Container(
                  height: 50 * prefs.getDouble('height'),
                  child: NumberPicker.horizontal(
                      itemExtent: 35 * prefs.getDouble('width'),
                      listViewHeight: 50 * prefs.getDouble('height'),
                      initialValue: _currentValue,
                      minValue: 18,
                      maxValue: 60,
                      onChanged: (newValue) {
                        setState(() {
                          _currentValue = newValue;
                          prefs.setInt('age', _currentValue);
                        });
                      }),
                ),
                Container(
                  height: 16 * prefs.getDouble('height'),
                  child: Text(
                    "|",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: mainColor,
                        fontSize: 15.0 * prefs.getDouble('height')),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 28.0 * prefs.getDouble('height'),
          ),
          Container(
            height: 20 * prefs.getDouble('height'),
            child: Text(
              "Select your gender",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17.0 * prefs.getDouble('height'),
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Color.fromARGB(155, 255, 255, 255)),
            ),
          ),
          SizedBox(
            height: 24.0 * prefs.getDouble('height'),
          ),
          Container(
            height: 45 * prefs.getDouble('height'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 45.0 * prefs.getDouble('height'),
                  width: 125.0 * prefs.getDouble('width'),
                  child: OutlineButton(
                      onPressed: () async {
                        if (enabledButton1 == false) {
                          await prefs.setString('gender', 'male');
                        } else {
                          await prefs.setString('gender', null);
                        }
                        if (enabledButton2 == true) {
                          setState(() {
                            enabledButton2 = !enabledButton2;
                            enabledButton1 = !enabledButton1;
                          });
                        } else {
                          setState(() {
                            enabledButton1 = !enabledButton1;
                          });
                        }
                      },
                      borderSide: BorderSide(
                          color: enabledButton1 == false
                              ? Colors.black
                              : mainColor,
                          style: BorderStyle.solid,
                          width: 2 * prefs.getDouble('height')),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            MdiIcons.humanMale,
                            color: enabledButton1 == false
                                ? Colors.black
                                : mainColor,
                            size: 30.0 * prefs.getDouble('height'),
                          ),
                          Text(
                            "Man",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: enabledButton1 == false
                                    ? Colors.black
                                    : mainColor,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0 * prefs.getDouble('height')),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  width: 15.0 * prefs.getDouble('width'),
                ),
                Container(
                  height: 45.0 * prefs.getDouble('height'),
                  width: 125.0 * prefs.getDouble('width'),
                  child: OutlineButton(
                    onPressed: () async {
                      if (enabledButton2 == false) {
                        await prefs.setString('gender', 'female');
                      } else {
                        await prefs.setString('gender', null);
                      }
                      if (enabledButton1 == true) {
                        setState(() {
                          enabledButton2 = !enabledButton2;
                          enabledButton1 = !enabledButton1;
                        });
                      } else {
                        setState(() {
                          enabledButton2 = !enabledButton2;
                        });
                      }
                    },
                    borderSide: BorderSide(
                        color:
                            enabledButton2 == false ? Colors.black : mainColor,
                        style: BorderStyle.solid,
                        width: 2 * prefs.getDouble('height')),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          MdiIcons.humanFemale,
                          color: enabledButton2 == false
                              ? Colors.black
                              : mainColor,
                          size: 30.0 * prefs.getDouble('height'),
                        ),
                        Text(
                          "Woman",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: enabledButton2 == false
                                  ? Colors.black
                                  : mainColor,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0 * prefs.getDouble('height')),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 21.0 * prefs.getDouble('height')),
            child: Container(
              width: 150.0 * prefs.getDouble('width'),
              height: 50.0 * prefs.getDouble('height'),
              child: Material(
                color: mainColor,
                borderRadius: BorderRadius.circular(90.0),
                child: MaterialButton(
                  onPressed: () async {
                    if (widget.parent._pageController.hasClients) {
                      setState(() {
                        widget.parent._pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      });
                    }
                  },
                  child: Text(
                    'Continue',
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
    );
  }
}

class NumberPicker extends StatelessWidget {
  ///height of every list element for normal number picker
  ///width of every list element for horizontal number picker
  static const double kDefaultItemExtent = 35.0;

  ///width of list view for normal number picker
  ///height of list view for horizontal number picker
  static const double kDefaultListViewCrossAxisSize = 100.0;

  ///constructor for horizontal number picker
  NumberPicker.horizontal({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    @required this.itemExtent,
    this.listViewHeight = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue - minValue) ~/ step * itemExtent,
        ),
        scrollDirection = Axis.horizontal,
        decimalScrollController = null,
        listViewWidth = 9 * itemExtent,
        infiniteLoop = false,
        integerItemCount = (maxValue - minValue) ~/ step,
        super(key: key);

  ///constructor for integer number picker
  NumberPicker.integer({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.scrollDirection = Axis.vertical,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        assert(scrollDirection != null),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = infiniteLoop
            ? new InfiniteScrollController(
                initialScrollOffset:
                    (initialValue - minValue) ~/ step * itemExtent,
              )
            : new ScrollController(
                initialScrollOffset:
                    (initialValue - minValue) ~/ step * itemExtent,
              ),
        decimalScrollController = null,
        listViewHeight = 3 * itemExtent,
        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);

  ///constructor for decimal number picker
  NumberPicker.decimal({
    Key key,
    @required double initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.decimalPlaces = 1,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(decimalPlaces != null && decimalPlaces > 0),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        selectedIntValue = initialValue.floor(),
        selectedDecimalValue = ((initialValue - initialValue.floorToDouble()) *
                math.pow(10, decimalPlaces))
            .round(),
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue.floor() - minValue) * itemExtent,
        ),
        decimalScrollController = new ScrollController(
          initialScrollOffset: ((initialValue - initialValue.floorToDouble()) *
                      math.pow(10, decimalPlaces))
                  .roundToDouble() *
              itemExtent,
        ),
        listViewHeight = 3 * itemExtent,
        step = 1,
        scrollDirection = Axis.vertical,
        integerItemCount = maxValue.floor() - minValue.floor() + 1,
        infiniteLoop = false,
        zeroPad = false,
        super(key: key);

  ///called when selected value changes
  final ValueChanged<num> onChanged;

  ///min value user can pick
  final int minValue;

  ///max value user can pick
  final int maxValue;

  ///inidcates how many decimal places to show
  /// e.g. 0=>[1,2,3...], 1=>[1.0, 1.1, 1.2...]  2=>[1.00, 1.01, 1.02...]
  final int decimalPlaces;

  ///height of every list element in pixels
  final double itemExtent;

  ///height of list view in pixels
  final double listViewHeight;

  ///width of list view in pixels
  final double listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///ScrollController used for decimal list
  final ScrollController decimalScrollController;

  ///Currently selected integer value
  final int selectedIntValue;

  ///Currently selected decimal value
  final int selectedDecimalValue;

  ///If currently selected value should be highlighted
  final bool highlightSelectedValue;

  ///Decoration to apply to central box where the selected value is placed
  final Decoration decoration;

  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// Direction of scrolling
  final Axis scrollDirection;

  ///Repeat values infinitely
  final bool infiniteLoop;

  ///Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  ///Amount of items
  final int integerItemCount;

  //
  //----------------------------- PUBLIC ------------------------------
  //

  /// Used to animate integer number picker to new selected value
  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  /// Used to animate integer number picker to new selected index
  void animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  /// Used to animate decimal part of double value to new selected value
  void animateDecimal(int decimalValue) {
    _animate(decimalScrollController, decimalValue * itemExtent);
  }

  /// Used to animate decimal number picker to selected value
  void animateDecimalAndInteger(double valueToSelect) {
    animateInt(valueToSelect.floor());
    animateDecimal(((valueToSelect - valueToSelect.floorToDouble()) *
            math.pow(10, decimalPlaces))
        .round());
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  ///main widget
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    if (infiniteLoop) {
      return _integerInfiniteListView(themeData);
    }
    if (decimalPlaces == 0) {
      return _integerListView(themeData);
    } else {
      return new Row(
        children: <Widget>[
          _integerListView(themeData),
          _decimalListView(themeData),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
  }

  Widget _integerListView(ThemeData themeData) {
    TextStyle defaultStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14.0 * prefs.getDouble('height'),
        color: Color.fromARGB(155, 255, 255, 255));
    TextStyle selectedStyle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24.0 * prefs.getDouble('height'),
        color: mainColor);

    var listItemCount = integerItemCount + 2;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (intScrollController.position.activity is HoldScrollActivity) {
          animateInt(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight * prefs.getDouble('height'),
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              new ListView.builder(
                scrollDirection: scrollDirection,
                controller: intScrollController,
                itemExtent: itemExtent,
                itemCount: listItemCount,
                cacheExtent: _calculateCacheExtent(listItemCount),
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                      value == selectedIntValue && highlightSelectedValue
                          ? selectedStyle
                          : defaultStyle;

                  bool isExtra = index == 0 || index == listItemCount - 1;

                  return isExtra
                      ? new Container() //empty first and last element
                      : new Center(
                          child: new Text(
                            getDisplayedValue(value),
                            style: itemStyle,
                          ),
                        );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  Widget _decimalListView(ThemeData themeData) {
    TextStyle defaultStyle = themeData.textTheme.body1;
    TextStyle selectedStyle =
        themeData.textTheme.headline.copyWith(color: themeData.accentColor);

    int decimalItemCount =
        selectedIntValue == maxValue ? 3 : math.pow(10, decimalPlaces) + 2;

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (decimalScrollController.position.activity is HoldScrollActivity) {
          animateDecimal(selectedDecimalValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              new ListView.builder(
                controller: decimalScrollController,
                itemExtent: itemExtent,
                itemCount: decimalItemCount,
                itemBuilder: (BuildContext context, int index) {
                  final int value = index - 1;

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                      value == selectedDecimalValue && highlightSelectedValue
                          ? selectedStyle
                          : defaultStyle;

                  bool isExtra = index == 0 || index == decimalItemCount - 1;

                  return isExtra
                      ? new Container() //empty first and last element
                      : new Center(
                          child: new Text(
                              value.toString().padLeft(decimalPlaces, '0'),
                              style: itemStyle),
                        );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onDecimalNotification,
      ),
    );
  }

  Widget _integerInfiniteListView(ThemeData themeData) {
    TextStyle defaultStyle = themeData.textTheme.body1;
    TextStyle selectedStyle =
        themeData.textTheme.headline.copyWith(color: themeData.accentColor);

    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (intScrollController.position.activity is HoldScrollActivity) {
          _animateIntWhenUserStoppedScrolling(selectedIntValue);
        }
      },
      child: new NotificationListener(
        child: new Container(
          height: listViewHeight,
          width: listViewWidth,
          child: Stack(
            children: <Widget>[
              InfiniteListView.builder(
                controller: intScrollController,
                itemExtent: itemExtent,
                itemBuilder: (BuildContext context, int index) {
                  final int value = _intValueFromIndex(index);

                  //define special style for selected (middle) element
                  final TextStyle itemStyle =
                      value == selectedIntValue && highlightSelectedValue
                          ? selectedStyle
                          : defaultStyle;

                  return new Center(
                    child: new Text(
                      getDisplayedValue(value),
                      style: itemStyle,
                    ),
                  );
                },
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  String getDisplayedValue(int value) {
    return zeroPad
        ? value.toString().padLeft(maxValue.toString().length, '0')
        : value.toString();
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) {
    index--;
    index %= integerItemCount;
    return minValue - 3 + index * step;
  }

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          (notification.metrics.pixels / itemExtent).round();
      if (!infiniteLoop) {
        intIndexOfMiddleElement =
            intIndexOfMiddleElement.clamp(0, integerItemCount - 4);
      }
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement + 4);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        if (decimalPlaces == 0) {
          //return integer value
          newValue = (intValueInTheMiddle);
        } else {
          if (intValueInTheMiddle == maxValue) {
            //if new value is maxValue, then return that value and ignore decimal
            newValue = (intValueInTheMiddle.toDouble());
            animateDecimal(0);
          } else {
            //return integer+decimal
            double decimalPart = _toDecimal(selectedDecimalValue);
            newValue = ((intValueInTheMiddle + decimalPart).toDouble());
          }
        }
        onChanged(newValue);
      }
    }
    return true;
  }

  bool _onDecimalNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate middle value
      int indexOfMiddleElement =
          (notification.metrics.pixels + listViewHeight / 2) ~/ itemExtent;
      int decimalValueInTheMiddle = indexOfMiddleElement - 1;
      decimalValueInTheMiddle =
          _normalizeDecimalMiddleValue(decimalValueInTheMiddle);

      if (_userStoppedScrolling(notification, decimalScrollController)) {
        //center selected value
        animateDecimal(decimalValueInTheMiddle);
      }

      //update selection
      if (selectedIntValue != maxValue &&
          decimalValueInTheMiddle != selectedDecimalValue) {
        double decimalPart = _toDecimal(decimalValueInTheMiddle);
        double newValue = ((selectedIntValue + decimalPart).toDouble());
        onChanged(newValue);
      }
    }
    return true;
  }

  ///There was a bug, when if there was small integer range, e.g. from 1 to 5,
  ///When user scrolled to the top, whole listview got displayed.
  ///To prevent this we are calculating cacheExtent by our own so it gets smaller if number of items is smaller
  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * kDefaultItemExtent <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * kDefaultItemExtent);
    }
    return cacheExtent;
  }

  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  int _normalizeDecimalMiddleValue(int decimalValueInTheMiddle) {
    return _normalizeMiddleValue(
        decimalValueInTheMiddle, 0, math.pow(10, decimalPlaces) - 1);
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  /// Allows to find currently selected element index and animate this element
  /// Use it only when user manually stops scrolling in infinite loop
  void _animateIntWhenUserStoppedScrolling(int valueToSelect) {
    // estimated index of currently selected element based on offset and item extent
    int currentlySelectedElementIndex =
        intScrollController.offset ~/ itemExtent;

    // when more(less) than half of the top(bottom) element is hidden
    // then we should increment(decrement) index in case of positive(negative) offset
    if (intScrollController.offset > 0 &&
        intScrollController.offset % itemExtent > itemExtent / 2) {
      currentlySelectedElementIndex++;
    } else if (intScrollController.offset < 0 &&
        intScrollController.offset % itemExtent < itemExtent / 2) {
      currentlySelectedElementIndex--;
    }

    animateIntToIndex(currentlySelectedElementIndex);
  }

  ///converts integer indicator of decimal value to double
  ///e.g. decimalPlaces = 1, value = 4  >>> result = 0.4
  ///     decimalPlaces = 2, value = 12 >>> result = 0.12
  double _toDecimal(int decimalValueAsInteger) {
    return double.parse((decimalValueAsInteger * math.pow(10, -decimalPlaces))
        .toStringAsFixed(decimalPlaces));
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration decoration;

  const _NumberPickerSelectedItemDecoration(
      {Key key,
      @required this.axis,
      @required this.itemExtent,
      @required this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new IgnorePointer(
        child: new Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}

///Returns AlertDialog as a Widget so it is designed to be used in showDialog method
class NumberPickerDialog extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialIntegerValue;
  final double initialDoubleValue;
  final int decimalPlaces;
  final Widget title;
  final EdgeInsets titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;
  final int step;
  final bool infiniteLoop;
  final bool zeroPad;
  final bool highlightSelectedValue;
  final Decoration decoration;

  ///constructor for integer values
  NumberPickerDialog.integer({
    @required this.minValue,
    @required this.maxValue,
    @required this.initialIntegerValue,
    this.title,
    this.titlePadding,
    this.step = 1,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL"),
        decimalPlaces = 0,
        initialDoubleValue = -1.0;

  ///constructor for decimal values
  NumberPickerDialog.decimal({
    @required this.minValue,
    @required this.maxValue,
    @required this.initialDoubleValue,
    this.decimalPlaces = 1,
    this.title,
    this.titlePadding,
    this.highlightSelectedValue = true,
    this.decoration,
    Widget confirmWidget,
    Widget cancelWidget,
  })  : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL"),
        initialIntegerValue = -1,
        step = 1,
        infiniteLoop = false,
        zeroPad = false;

  @override
  State<NumberPickerDialog> createState() =>
      new _NumberPickerDialogControllerState(
          initialIntegerValue, initialDoubleValue);
}

class _NumberPickerDialogControllerState extends State<NumberPickerDialog> {
  int selectedIntValue;
  double selectedDoubleValue;

  _NumberPickerDialogControllerState(
      this.selectedIntValue, this.selectedDoubleValue);

  void _handleValueChanged(num value) {
    if (value is int) {
      setState(() => selectedIntValue = value);
    } else {
      setState(() => selectedDoubleValue = value);
    }
  }

  NumberPicker _buildNumberPicker() {
    if (widget.decimalPlaces > 0) {
      return new NumberPicker.decimal(
          initialValue: selectedDoubleValue,
          minValue: widget.minValue,
          maxValue: widget.maxValue,
          decimalPlaces: widget.decimalPlaces,
          highlightSelectedValue: widget.highlightSelectedValue,
          decoration: widget.decoration,
          onChanged: _handleValueChanged);
    } else {
      return new NumberPicker.integer(
        initialValue: selectedIntValue,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        step: widget.step,
        infiniteLoop: widget.infiniteLoop,
        zeroPad: widget.zeroPad,
        highlightSelectedValue: widget.highlightSelectedValue,
        decoration: widget.decoration,
        onChanged: _handleValueChanged,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: _buildNumberPicker(),
      actions: [
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        new FlatButton(
            onPressed: () => Navigator.of(context).pop(widget.decimalPlaces > 0
                ? selectedDoubleValue
                : selectedIntValue),
            child: widget.confirmWidget),
      ],
    );
  }
}

class CertificateUpload extends StatefulWidget {
  CertificateUpload({this.pageController, this.parent});
  final _SignUpCarouselTrainerState parent;
  final PageController pageController;
  State createState() => _CertificateUploadState();
}

class _CertificateUploadState extends State<CertificateUpload>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
   
    super.initState();
    tempImageCertificate = widget.parent.certificatePhoto;
  }

  var tempImageCertificate;

  Future openCamera(BuildContext context) async {
    var aux = await ImagePicker.pickImage(source: ImageSource.camera);

    await prefs.setString('certificateUrl', 'approved');
    setState(() {
      tempImageCertificate = aux;
      widget.parent.setState(() {
        widget.parent.certificatePhoto = tempImageCertificate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50 * prefs.getDouble('height'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * prefs.getDouble('width')),
              child: Container(
                height: 80 * prefs.getDouble('height'),
                child: Text(
                  "Please upload a picture of your trainer certificate so we can verify your identity.",
                  style: TextStyle(
                      fontSize: 20.0 * prefs.getDouble('height'),
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ),
            SizedBox(
              height: 36 * prefs.getDouble('height'),
            ),
            GestureDetector(
                onTap: () {
                  openCamera(context);
                },
                child: DashedContainer(
                    strokeWidth: 5.0 * prefs.getDouble('height'),
                    blankLength: 6.0 * prefs.getDouble('height'),
                    dashColor: mainColor,
                    boxShape: BoxShape.rectangle,
                    child: Container(
                      height: 330 * prefs.getDouble('height'),
                      child: Material(
                        child: tempImageCertificate == null
                            ? Container(
                                width: 280 * prefs.getDouble('width'),
                                height: 330 * prefs.getDouble('height'),
                                color: Color(0xff57575E),
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 35 * prefs.getDouble('height'),
                                  color: mainColor,
                                ),
                              )
                            : Container(
                                width: 280 * prefs.getDouble('width'),
                                height: 330 * prefs.getDouble('height'),
                                color: Color(0xff57575E),
                                child: Image.file(
                                  tempImageCertificate,
                                  width: 280.0 * prefs.getDouble('height'),
                                  height: 330.0 * prefs.getDouble('height'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ))),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 32.0 * prefs.getDouble('height')),
              child: Container(
                width: 150.0 * prefs.getDouble('width'),
                height: 50.0 * prefs.getDouble('height'),
                child: Material(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(90.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (widget.parent._pageController.hasClients) {
                        setState(() {
                          widget.parent._pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        });
                      }
                    },
                    child: Text(
                      'Continue',
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
    );
  }
}

class PopUpAgreeRoute extends PopupRoute<void> {
  PopUpAgreeRoute(
      {this.auth,
      this.onSignedIn,
      this.onSignedOut,
      this.profilePhoto,
      this.certificatePhoto});
  final profilePhoto;
  final certificatePhoto;
  final BaseAuth auth;
  final Function onSignedIn;
  final Function onSignedOut;

  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Container(
        color: Colors.transparent,
        child: PopUpAgree(
          auth: auth,
          onSignedIn: onSignedIn,
          onSignedOut: onSignedOut,
          profilePhoto: profilePhoto,
          certificatePhoto: certificatePhoto,
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpAgree extends StatefulWidget {
  PopUpAgree(
      {this.auth,
      this.onSignedIn,
      this.onSignedOut,
      this.profilePhoto,
      this.certificatePhoto});
  final profilePhoto;
  final certificatePhoto;
  final BaseAuth auth;
  final Function onSignedIn;
  final Function onSignedOut;
  @override
  State createState() => PopUpAgreeState();
}

class PopUpAgreeState extends State<PopUpAgree> {
  bool isLoading = false;

  Future<bool> signUpAsTrainer(BuildContext context) async {
    BaseAuth auth = Auth();
    String userId;
    try {
      userId = await auth.createUserWithEmailAndPassword(
          prefs.getString('email'), prefs.getString('password1'));

      if (userId ==
          "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)") {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "This email is already being used by somebody else.",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0 * prefs.getDouble('height'),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: mainColor),
            textAlign: TextAlign.center,
          ),
        ));
        return false;
      } else {
        if (userId ==
            "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)") {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "This email is not valid",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18.0 * prefs.getDouble('height'),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: mainColor),
              textAlign: TextAlign.center,
            ),
          ));
          return false;
        } else {
          if (widget.profilePhoto != null) {
            final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child('$userId');
            final StorageUploadTask task =
                firebaseStorageRef.putFile(widget.profilePhoto);
            final StorageTaskSnapshot downloadUrl = (await task.onComplete);
            final String url = (await downloadUrl.ref.getDownloadURL());
            await prefs.setString('photoUrl', url);
          }
          if (widget.certificatePhoto != null) {
            final StorageReference firebaseStorageRefCertificate =
                FirebaseStorage.instance.ref().child('$userId' + 'certificate');
            final StorageUploadTask taskCertificate =
                firebaseStorageRefCertificate.putFile(widget.certificatePhoto);
            final StorageTaskSnapshot downloadUrlCertificate =
                (await taskCertificate.onComplete);
            final String urlCertificate =
                (await downloadUrlCertificate.ref.getDownloadURL());
            await prefs.setString('certificateUrl', urlCertificate);
          }
          var db = Firestore.instance;
          var batch = db.batch();
          QuerySnapshot queryAppIsOn = await Firestore.instance
              .collection('AppIsOn')
              .where(
                'id',
                isEqualTo: '1VF1fKfglISG93D9miB3',
              )
              .getDocuments();
          batch.setData(
            db.collection('clientUsers').document(userId),
            {
              'pendingDeletion': false,
              'appIsOn': queryAppIsOn.documents[0]['appIsOn'],
              'approved': false,
              'certificateUrl': prefs.getString('certificateUrl'),
              'friendRequestDate': {},
              'businessRequestDate': {},
              'trophies': 1000,
              'nickname': prefs.getString('email'),
              'id': userId,
              'photoUrl': prefs.getString('photoUrl'),
              'friendsMap': {},
              'role': 'trainer',
              'searchKeyFirstName':
                  '${prefs.getString('firstName').substring(0, 1)}',
              'acceptTrainerRequests': false,
              'searchKeyLastName':
                  '${prefs.getString('lastName').substring(0, 1)}',
              'cardios': 5,
              'works': 10,
              'trainerMap': {},
              'groupCounter': 0,
              'votes': 0,
              'nearbyFlag': false,
              'nearby': {},
              'nearbyDate': {},
              'age': prefs.getInt('age'),
              'firstName': prefs.getString('firstName') ?? '',
              'lastName': prefs.getString('lastName') ?? '',
              'gender': prefs.getString('gender') ?? '',
              'gym1': "",
              'gym2': "",
              'gym3': "",
              'gym4': "",
              'newFriend': false,
              'newClient': false,
              'gym1Street': "",
              'gym2Street': "",
              'gym3Street': "",
              'gym4Street': "",
              'gym1Sector': "",
              'gym2Sector': "",
              'gym3Sector': "",
              'gym4Sector': "",
              'colorRed': Random().nextInt(255),
              'colorGreen': Random().nextInt(255),
              'colorBlue': Random().nextInt(255),
              'unseenMessagesCounter': {},
              'accepted': false,
              'specialization': {},
              'freeTraining': false,
              'reviewMap': {},
              'reviewDelay': {},
              'counterClasses': 0,
              'trxCounter': 0,
              'workoutCounter': 0,
              'zumbaCounter': 0,
              'kangooJumpsCounter': 0,
              'pilatesCounter': 0,
              'aerobicCounter': 0,
              'specializationClasses': {},
            },
          );
          batch.updateData(db.collection('clientUsers').document(userId), {
            'attributeMap.1': 0.0,
            'attributeMap.2': 0.0,
            'attributeMapDelay.1': 0.0,
            'attributeMapDelay.2': 0.0,
            'month1.1': 0.01,
            'month1.2': 0.01,
            'month2.1': 0.0,
            'month2.2': 0.0,
            'month3.1': 0.0,
            'month3.2': 0.0,
            'month4.1': 0.0,
            'month4.2': 0.0,
            'month5.1': 0.0,
            'month5.2': 0.0,
            'month6.1': 0.0,
            'month6.2': 0.0,
            'rating.1': 0.0,
            'ratingAttribute1.1': 0.01,
            'ratingAttribute2.1': 0.01,
            'specialization.aerobic': false,
            'specialization.kangooJumps': false,
            'specialization.pilates': false,
            'specialization.trx': false,
            'specialization.workout': false,
            'specialization.zumba': false,
          });
          batch.setData(db.collection('profileVisits').document(userId), {
            'timeZone': DateTime.now().timeZoneName,
            'id': userId,
            'visits': 0,
            'graphDate': {
              '1': DateTime.now().subtract(Duration(days: 29)),
              '2': DateTime.now().subtract(Duration(days: 28)),
              '3': DateTime.now().subtract(Duration(days: 27)),
              '4': DateTime.now().subtract(Duration(days: 26)),
              '5': DateTime.now().subtract(Duration(days: 25)),
              '6': DateTime.now().subtract(Duration(days: 24)),
              '7': DateTime.now().subtract(Duration(days: 23)),
              '8': DateTime.now().subtract(Duration(days: 22)),
              '9': DateTime.now().subtract(Duration(days: 21)),
              '10': DateTime.now().subtract(Duration(days: 20)),
              '11': DateTime.now().subtract(Duration(days: 19)),
              '12': DateTime.now().subtract(Duration(days: 18)),
              '13': DateTime.now().subtract(Duration(days: 17)),
              '14': DateTime.now().subtract(Duration(days: 16)),
              '15': DateTime.now().subtract(Duration(days: 15)),
              '16': DateTime.now().subtract(Duration(days: 14)),
              '17': DateTime.now().subtract(Duration(days: 13)),
              '18': DateTime.now().subtract(Duration(days: 12)),
              '19': DateTime.now().subtract(Duration(days: 11)),
              '20': DateTime.now().subtract(Duration(days: 10)),
              '21': DateTime.now().subtract(Duration(days: 9)),
              '22': DateTime.now().subtract(Duration(days: 8)),
              '23': DateTime.now().subtract(Duration(days: 7)),
              '24': DateTime.now().subtract(Duration(days: 6)),
              '25': DateTime.now().subtract(Duration(days: 5)),
              '26': DateTime.now().subtract(Duration(days: 4)),
              '27': DateTime.now().subtract(Duration(days: 3)),
              '28': DateTime.now().subtract(Duration(days: 2)),
              '29': DateTime.now().subtract(Duration(days: 1)),
              '30': DateTime.now(),
            },
            'graphViews': {
              '1': 0,
              '2': 0,
              '3': 0,
              '4': 0,
              '5': 0,
              '6': 0,
              '7': 0,
              '8': 0,
              '9': 0,
              '10': 0,
              '11': 0,
              '12': 0,
              '13': 0,
              '14': 0,
              '15': 0,
              '16': 0,
              '17': 0,
              '18': 0,
              '19': 0,
              '20': 0,
              '21': 0,
              '22': 0,
              '23': 0,
              '24': 0,
              '25': 0,
              '26': 0,
              '27': 0,
              '28': 0,
              '29': 0,
              '30': 0,
            },
          });
          batch.commit();
          await registerNotification(userId);
          await prefs.setString('nickname', prefs.getString('email'));
          await prefs.setString('id', userId);
          await prefs.setString('role', 'trainer');
          await prefs.setDouble(
              'height', MediaQuery.of(context).size.height / 812);
          await prefs.setDouble(
              'width', MediaQuery.of(context).size.width / 375);

          await sendEmail();
          await prefs.setString('token', null);
          widget.onSignedIn(context);

          return true;
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      return false;
    }
  }

  Future sendEmail() async {
    String username = 'bsharkr.requests@gmail.com';
    String password = 'accountRqSend0044';

    final smtpServer = gmail(username, password);

    if (DateTime.now().timeZoneName == 'EEST' || DateTime.now().timeZoneName =='EET') {
      final message = Message()
        ..from = Address(username, '123')
        ..recipients.add('ro.bsharkr.supp@gmail.com')
        ..subject = 'New trainer'
        ..text =
            'Trainer`s info:\n - First name: ${prefs.getString('firstName')}\n - Last name: ${prefs.getString('lastName')}\n - Age: ${prefs.getInt('age')}\n - Gender: ${prefs.getString('gender')}\n Certificate`s url: ${prefs.getString('certificateUrl')}\n - Email: ${prefs.getString('email')}\n - Id: ${prefs.getString('id')}\n - Token: ${prefs.getString('token')}';

      try {
        await send(message, smtpServer);
      } on MailerException catch (e) {
      }
    }

    if (DateTime.now().timeZoneName == 'CEST' || DateTime.now().timeZoneName == 'CET') {
      final message = Message()
        ..from = Address(username, '123')
        ..recipients.add('no.bsharkr.supp@gmail.com')
        ..subject = 'New trainer'
        ..text =
            'Trainer`s info:\n - First name: ${prefs.getString('firstName')}\n - Last name: ${prefs.getString('lastName')}\n - Age: ${prefs.getInt('age')}\n - Gender: ${prefs.getString('gender')}\n Certificate`s url: ${prefs.getString('certificateUrl')}\n - Email: ${prefs.getString('email')}\n - Id: ${prefs.getString('id')}\n - Token: ${prefs.getString('token')}';

      try {
        await send(message, smtpServer);
      } on MailerException catch (e) {
      }
    }
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future registerNotification(String id) async {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      return;
    }, onResume: (Map<String, dynamic> message) {
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      return;
    });

    _firebaseMessaging.getToken().then((token) async {
      await prefs.setString('token', token);

      print("REGISTER");
      print(prefs.getString('token'));
      await Firestore.instance
          .collection('pushNotifications')
          .document(id)
          .setData({
        'id': prefs.getString('id'),
        'pushToken': token,
        'chattingWith': null,
        'nickname': prefs.getString('firstName')
      });
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "$err",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18.0 * prefs.getDouble('height'),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: mainColor),
          textAlign: TextAlign.center,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor,
              ),
              height: 386 * prefs.getDouble('height'),
              width: 313 * prefs.getDouble('width'),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/tc.svg',
                        width: 180.0 * prefs.getDouble('width'),
                        height: 100.0 * prefs.getDouble('height'),
                      ),
                      SizedBox(
                        height: 16 * prefs.getDouble('height'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16 * prefs.getDouble('width')),
                        height: 100 * prefs.getDouble('height'),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15 * prefs.getDouble('height'),
                                  fontFamily: 'Roboto',
                                  letterSpacing: -0.24),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "       Acceptarea acestor termeni \nAccesul dvs. şi utilizarea acestei aplicaţii se supun acestor Termeni şi Condiţii. Nu veti folosi aceasta aplicatie în scopuri ilegale sau interzise prin Termenii şi Condiţiile care urmează. Prin utilizarea aplicaţiei acceptaţi termenii, condiţiile şi disclaimer-ele din această pagină. Dacă nu acceptaţi Termenii şi Condiţiile atunci trebuie să încetaţi utilizarea aplicaţiei imediat.\n  •	Recomandări\nConţinutul acestei aplicatii nu poate fi considerat ca recomandare şi nu ar trebui considerat ca bază pentru luarea de decizii.\n  •	Modificări ale aplicatiei mobile, software-ului şi ale serviciilor\nBsharkr Company S.R.L. rezervă dreptul de a:\n  •	Modifica sau şterge (temporar sau permanent) această aplicaţie mobila sau orice parte a acesteia fără a anunţa, iar dvs. acceptaţi faptul că Bsharkr Company S.R.L. nu este responsabilă pentru asemenea modificări sau ştergeri.\n  •	Modifica, şterge sau întrerupe orice software, serviciu sau promoţie (inclusiv dar fără a se limita la orice prevederi, părţi, licenţe, preţuri), fără a anunţa, iar dvs. acceptaţi faptul că Bsharkr Company S.R.L. nu este responsabilă pentru asemenea modificări sau ştergeri.\n  •	Modifica sau întrerupe orice voucher promoţional de reducere sau cod de cupon de reducere în orice moment cu anunţ prealabil, iar dvs. acceptaţi faptul că Bsharkr Company S.R.L. nu este responsabilă pentru asemenea modificări sau ştergeri.\n  •	Modifica această înţelegere în orice moment, iar continuarea utilizării aplicatiei de către dvs. după aceste schimbări se va supune acceptării acestor modificări de către dvs.\n  •	Păstra informaţiile personale pentru a face verificarea conturilor dar și pentru a fi utilizate de către terți.",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 11 * prefs.getDouble('height'),
                                    letterSpacing: -0.408,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        "\n  •	În urma ștergerii unui cont, datele si contul vor fi păstrate pentru maxLines: 30 de zile.\n  •	Linkuri către terţi\nAplicatia poate include link-uri către website-urile terţilor sau aplicații terte, care sunt controlate şi conduse de alţii. Orice link spre un alt website sau aplicație nu este o recomandare a acelui web site sau aplicație, iar dvs. luaţi la cunoştinţă acest fapt şi sunteţi conştienţi de faptul că nu ne asumăm responsabilitatea pentru conţinutul sau pentru disponibilitatea acestor website-uri sau aplicatii.\n  •	Copyright\nDrepturile asupra Proprietăţii Intelectuale din aceasta aplicatie şi din materialele din aceasta sau accesibile prin aceasta aparţin Bsharkr Company S.R.L. sau licenţelor sale. Aplicatia, materialele incluse in aplicaţie sau cele accesibile prin aceasta şi Drepturile asupra Proprietăţii Intelectuale inerente nu pot fi copiate, distribuite, publicate, licenţiate, folosite sau reproduse în niciun fel (în afară de măsura strict necesară pentru şi cu scopul legat de accesarea şi utilizarea acestei aplicatii).\nBsharkr Company S.R.L. şi logo-ul Bsharkr Company S.R.L. aparţin Bsharkr Company S.R.L. şi nu pot fi utilizate, copiate sau reproduse în niciun fel fără acordul scris al Bsharkr Company S.R.L.\nPentru aceste scopuri “Drepturile asupra Proprietăţii Intelectuale” includ următoarele (oriunde şi oricând apar şi pentru întregul termen al acestora): orice drept, marcă înregistrată, nume înregistrat, nume de serviciu, design, drept asupra design-ului, copyright, drept asupra bazelor de date, drepturi morale, know how, secrete de muncă şi alte informaţii confidenţiale, drepturi de natura oricăror dintre aceste elemente în orice ţară, drepturi de natura competiţiei neloiale şi drepturi de a da în judecată pentru transmitere sau alte drepturi similare intelectuale şi comerciale (caz în care sunt sau nu înregistrate sau înregistrabile) şi înregistrările şi aplicaţiile de înregistrare pentru oricare dintre ele.\n 	•	Limitarea răspunderii\nAplicaţia este distribuită pe baza “aşa cum este” şi “disponibilă” fără nicio reprezentare sau promovare făcută şi fără garanţie de niciun fel expresă sau implicită, incluzând dar fără a se limita la garanţiile de calitate satisfăcătoare, pentru un anumit scop, neîncălcare, compatibilitate, securitate şi acurateţe.\nÎn limita impusă de lege, Bsharkr Company S.R.L. nu va fi trasă la răspundere pentru pierderi indirecte sau rezultate sau pentru pierderi de orice fel (incluzând dar nelimitându-se la pierderi de afaceri, de oportunităţi, de date, de profituri), ce rezultă din sau în legătură cu folosirea aplicatiei.\nBsharkr Company S.R.L. nu oferă nicio garanţie că funcţionarea aplicatiei va fi fără întrerupere sau fără erori, că defectele vor fi corectate sau că aplicația sau serverul care o face disponibilă sunt lipsite de viruşi sau orice altceva ce poate fi dăunător sau distructiv.\nNimic din aceşti Termenii şi Condiţii nu poate fi interpretat ca excluzând sau limitând răspunderea Bsharkr Company S.R.L. pentru moartea sau accidentarea personală ca rezultat al neglijenţei Bsharkr Company S.R.L. sau a angajaţilor sau a agenţilor săi.\n 	•	Despăgubiri\nSunteţi de acord să despăgubiţi şi să absolviţi Bsharkr Company S.R.L. şi angajaţii şi agenţii săi de toate răspunderile, taxele legale, stricăciunile, pierderile, costurile şi toate celelalte cheltuieli în relaţie cu revendicările sau acţiunile aduse împotriva Bsharkr Company S.R.L. apărute din orice încălcare a Termenilor şi Condiţiilor de către dvs. sau alte responsabilităţi născute din utilizarea acestei aplicaţii.\n 	•	Anulare\nÎn cazul în care oricare dintre prevederile acestei înţelegeri sunt declarate, de către orice autoritate juridică sau de o altă competenţă, nule, anulabile, ilegale sau non executabile în vreun fel sau indicative de orice alt fel, ce sunt primite de dvs. sau de noi din partea unei autorităţii competente, vom modifica acea prevedere într-o manieră rezonabilă de aşa natură astfel încât să se conformeze intenţiilor părţilor fără a intra în ilegalitate sau, la discreţia noastră, prevederile în cauză pot fi scoase din această înţelegere, iar prevederile rămase în această înţelegere rămân în vigoare.\n	•	Legi aplicabile şi dispute\nAceastă înţelegere şi toate cele ce rezultă din ea sunt guvernate de şi formulate în acord cu legea din România ale cărei curţi au jurisdicţie exclusivă asupra tuturor disputelor ce rezultă din această înţelegere, iar dvs. sunteţi de acord că locul de punere în practică al acestei înţelegeri este România.\n	•	Titluri\nTitlurile sunt incluse în această înţelegere pentru convenienţă şi nu vor afecta înţelegerea acesteia.\n 	•	Înţelegerea completă\nAceşti termeni şi aceste condiţii împreună cu alte documente la care se face referinţă expres în înţelegere includ întreaga înţelegere dintre noi în legătură cu subiectul exprimat şi înlocuiesc orice înţelegeri, aranjamente, angajamente sau propuneri anterioare, scrise sau orale: între noi şi acele aspecte. Orice explicaţie orală sau informare orală dată de vreuna dintre cele două părţi nu poate altera interpretarea termenilor şi a condiţiilor. Prin acceptarea termenilor şi condiţiilor, nu v-aţi bazat pe o altă reprezentare decât cea stipulată în această înţelegere şi sunteţi de acord că nu veţi avea nicio cale de atac cu privire la orice falsă reprezentare ce nu a fost exprimată expres în această înţelegere.",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize:
                                            11 * prefs.getDouble('height'),
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8 * prefs.getDouble('height'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0 * prefs.getDouble('height')),
                        child: Container(
                          width: 150.0 * prefs.getDouble('width'),
                          height: 50.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                if (mounted) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                                if (await signUpAsTrainer(context) == true) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CompletedSignUp(
                                                auth: widget.auth,
                                                onSignedOut: widget.onSignedOut,
                                              )));
                                }
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              child: Text(
                                'Agree',
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 30 * prefs.getDouble('height'),
                          child: Center(
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 14 * prefs.getDouble('height'),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto')),
                          ),
                        ),
                      )
                    ],
                  ),
                  isLoading == true
                      ? Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8.0 * prefs.getDouble('height')),
                              color: backgroundColor,
                            ),
                            height: 80 * prefs.getDouble('height'),
                            width: 80 * prefs.getDouble('width'),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(mainColor),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              )),
        ),
      ),
    );
  }
}
