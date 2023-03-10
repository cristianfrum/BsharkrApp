import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashed_container/dashed_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Bsharkr/Client/SignUp/CompletedSignUp.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:infinite_listview/infinite_listview.dart';

import '../../login.dart';

class SignUpCarouselClient extends StatefulWidget {
  final String email;
  final String password;
  final BaseAuth auth;
  final Function onSignedIn;
  final Function onSignedOut;

  SignUpCarouselClient(
      {Key key,
      @required this.email,
      @required this.password,
      @required this.auth,
      @required this.onSignedIn,
      @required this.onSignedOut})
      : super(key: key);
  State createState() =>
      _SignUpCarouselClientState(email: email, password: password);
}

class _SignUpCarouselClientState extends State<SignUpCarouselClient> {
  var profilePhoto;
  final String email;
  final String password;

  String gender = "";
  bool marked = false;
  String hinttText1 = "";
  String hinttText2 = "";

  String labelText1 = "Enter First Name";
  String labelText2 = "Enter Last Name";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _SignUpCarouselClientState({
    Key key,
    @required this.email,
    @required this.password,
  });
  PageController _pageController;
  int currentPage = 0;
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;
  TextEditingController _controllerConfirmPassword;
  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

  int x = 0;

  bool pressedRegisterButton = false;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  void registerNotification(String id) {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      return;
    }, onResume: (Map<String, dynamic> message) {
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      return;
    });
    _firebaseMessaging.getToken().then((token) {
      Firestore.instance.collection('pushNotifications').document(id).setData({
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

  bool _passwordVisible1 = true;
  bool _passwordVisible2 = true;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: pressedRegisterButton,
      child: GestureDetector(
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
              builder: (context) => Stack(
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
                                      child: PhotoUpload(
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
                                                                size: 24 *
                                                                    prefs.getDouble(
                                                                        'height')),
                                                          ),
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
                                                  keyboardType:
                                                      TextInputType.text,
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
                                                                size: 24 *
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
                                                  keyboardType:
                                                      TextInputType.text,
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
                                                                            'password1') ==
                                                                        null) {
                                                                      Scaffold.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
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
                                                                      if (prefs
                                                                              .getString('password1')
                                                                              .length <
                                                                          6) {
                                                                        Scaffold.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text(
                                                                            "The password needs at least 6 characters",
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
                                                                        if (prefs.getString('password1') !=
                                                                            prefs.getString('password2')) {
                                                                          Scaffold.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text(
                                                                              "The passwords do not match",
                                                                              style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0 * prefs.getDouble('height'), fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: mainColor),
                                                                            ),
                                                                            action:
                                                                                SnackBarAction(
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
                                                                          String
                                                                              userId;

                                                                          userId = await widget.auth.createUserWithEmailAndPassword(
                                                                              prefs.getString('email'),
                                                                              prefs.getString('password1'));
                                                                          if (userId ==
                                                                              "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)") {
                                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                              content: Text(
                                                                                "This email is already being used by somebody else.",
                                                                                style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0 * prefs.getDouble('height'), fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, color: mainColor),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ));
                                                                          } else {
                                                                            if (userId ==
                                                                                "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)") {
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

                                                                              Navigator.push(context, PopUpAgreeRoute(auth: widget.auth, profilePhoto: profilePhoto, onSignedIn: widget.onSignedIn, onSignedOut: widget.onSignedOut));
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
                                    ],
                                  ),
                                ),
                              )
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
                          : Container(),
                    ],
                  )),
        ),
      ),
    );
  }
}

class PhotoUpload extends StatefulWidget {
  PhotoUpload({this.parent});
  final _SignUpCarouselClientState parent;
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
  final _SignUpCarouselClientState parent;
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

class PopUpAgreeRoute extends PopupRoute<void> {
  PopUpAgreeRoute({
    this.auth,
    this.onSignedIn,
    this.onSignedOut,
    this.profilePhoto,
  });
  final profilePhoto;
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
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class PopUpAgree extends StatefulWidget {
  PopUpAgree({
    this.auth,
    this.onSignedIn,
    this.onSignedOut,
    this.profilePhoto,
  });
  final profilePhoto;
  final BaseAuth auth;
  final Function onSignedIn;
  final Function onSignedOut;
  @override
  State createState() => PopUpAgreeState();
}

class PopUpAgreeState extends State<PopUpAgree> {
  Future<bool> signUpAsClient(BuildContext context) async {
    try {
      BaseAuth auth = Auth();
      String userId = await auth.createUserWithEmailAndPassword(
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
              "This email address is not valid",
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
        QuerySnapshot queryAppIsOn =   await Firestore.instance
        .collection('AppIsOn')
        .where(
          'id',
          isEqualTo:'1VF1fKfglISG93D9miB3',
        )
        .getDocuments();
          var db = Firestore.instance;
          var batch = db.batch();
          batch.setData(
            db.collection('clientUsers').document(userId),
            {
              'appIsOn': queryAppIsOn.documents[0]['appIsOn'],
              'nickname': prefs.getString('email'),
              'id': userId,
              'photoUrl': prefs.getString('photoUrl') ?? null,
              'friendsMap': {},
              'trainersMap': {},
              'role': 'client',
              'mealsBreakfast': {},
              'mealsLunch': {},
              'mealsDinner': {},
              'searchKeyFirstName':
                  '${prefs.getString('firstName').substring(0, 1)}',
              'searchKeyLastName':
                  '${prefs.getString('lastName').substring(0, 1)}',
              'groupCounter': 0,
              'scheduleHour1': {},
              'scheduleHour1End': {},
              'scheduleHour2End': {},
              'scheduleHour2': {},
              'scheduleBool1': {},
              'scheduleBool2': {},
              'dailyVote': false,
              'unseenMessagesCounter': {},
              'preferencesList': {},
              'votesMap': {},
              'reviewsMap': {},
              'enrolled': false,
              'counterClassesClient': 0,
              'nearby': {},
              'popUpVote': false,
              'popUpNotification': false,
              'trainingSessionTrainerId': {},
              'trainingSessionLocationName': {},
              'trainingSessionLocationStreet': {},
              'trainingSessionTrainerName': {},
              'classVote': "",
              'workoutReminder': false,
            },
          );
          batch.updateData(
            db.collection('clientUsers').document(userId),
            {
              'trainingSessionTrainerId.1': "",
              'trainingSessionTrainerId.2': "",
              'trainingSessionTrainerId.3': "",
              'trainingSessionTrainerId.4': "",
              'trainingSessionTrainerId.5': "",
              'trainingSessionTrainerId.6': "",
              'trainingSessionTrainerId.7': "",
              'trainingSessionTrainerId.8': "",
              'trainingSessionTrainerId.9': "",
              'trainingSessionTrainerId.10': "",
              'trainingSessionTrainerId.11': "",
              'trainingSessionTrainerId.12': "",
              'trainingSessionTrainerId.13': "",
              'trainingSessionTrainerId.14': "",
              'trainingSessionLocationName.1': "",
              'trainingSessionLocationName.2': "",
              'trainingSessionLocationName.3': "",
              'trainingSessionLocationName.4': "",
              'trainingSessionLocationName.5': "",
              'trainingSessionLocationName.6': "",
              'trainingSessionLocationName.7': "",
              'trainingSessionLocationName.8': "",
              'trainingSessionLocationName.9': "",
              'trainingSessionLocationName.10': "",
              'trainingSessionLocationName.11': "",
              'trainingSessionLocationName.12': "",
              'trainingSessionLocationName.13': "",
              'trainingSessionLocationName.14': "",
              'trainingSessionLocationStreet.1': "",
              'trainingSessionLocationStreet.2': "",
              'trainingSessionLocationStreet.3': "",
              'trainingSessionLocationStreet.4': "",
              'trainingSessionLocationStreet.5': "",
              'trainingSessionLocationStreet.6': "",
              'trainingSessionLocationStreet.7': "",
              'trainingSessionLocationStreet.8': "",
              'trainingSessionLocationStreet.9': "",
              'trainingSessionLocationStreet.10': "",
              'trainingSessionLocationStreet.11': "",
              'trainingSessionLocationStreet.12': "",
              'trainingSessionLocationStreet.13': "",
              'trainingSessionLocationStreet.14': "",
              'trainingSessionTrainerName.1': "",
              'trainingSessionTrainerName.2': "",
              'trainingSessionTrainerName.3': "",
              'trainingSessionTrainerName.4': "",
              'trainingSessionTrainerName.5': "",
              'trainingSessionTrainerName.6': "",
              'trainingSessionTrainerName.7': "",
              'trainingSessionTrainerName.8': "",
              'trainingSessionTrainerName.9': "",
              'trainingSessionTrainerName.10': "",
              'trainingSessionTrainerName.11': "",
              'trainingSessionTrainerName.12': "",
              'trainingSessionTrainerName.13': "",
              'trainingSessionTrainerName.14': "",
              'preferencesList.anatomyKnowledge': false,
              'preferencesList.disciplined': false,
              'preferencesList.dynamic': false,
              'preferencesList.goodListener': false,
              'preferencesList.motivating': false,
              'preferencesList.nutritionist': false,
              'preferencesList.sociable': false,
              'colorRed': Random().nextInt(255),
              'colorGreen': Random().nextInt(255),
              'colorBlue': Random().nextInt(255),
              'trainerWorkoutScheduleId.1': "",
              'trainerWorkoutScheduleId.2': "",
              'trainerWorkoutScheduleId.3': "",
              'trainerWorkoutScheduleId.4': "",
              'trainerWorkoutScheduleId.5': "",
              'trainerWorkoutScheduleId.6': "",
              'trainerWorkoutScheduleId.7': "",
              'trainerWorkoutScheduleId.8': "",
              'trainerWorkoutScheduleId.9': "",
              'trainerWorkoutScheduleId.10': "",
              'trainerWorkoutScheduleId.11': "",
              'trainerWorkoutScheduleId.12': "",
              'trainerWorkoutScheduleId.13': "",
              'trainerWorkoutScheduleId.14': "",
              'mealsBreakfast.1': 'default',
              'mealsBreakfast.2': 'default',
              'mealsBreakfast.3': 'default',
              'mealsBreakfast.4': 'default',
              'mealsBreakfast.5': 'default',
              'mealsBreakfast.6': 'default',
              'mealsBreakfast.7': 'default',
              'mealsBreakfast.8': 'default',
              'mealsBreakfast.9': 'default',
              'mealsBreakfast.10': 'default',
              'mealsBreakfast.11': 'default',
              'mealsBreakfast.12': 'default',
              'mealsBreakfast.13': 'default',
              'mealsBreakfast.14': 'default',
              'mealsLunch.1': 'default',
              'mealsLunch.2': 'default',
              'mealsLunch.3': 'default',
              'mealsLunch.4': 'default',
              'mealsLunch.5': 'default',
              'mealsLunch.6': 'default',
              'mealsLunch.7': 'default',
              'mealsLunch.8': 'default',
              'mealsLunch.9': 'default',
              'mealsLunch.10': 'default',
              'mealsLunch.11': 'default',
              'mealsLunch.12': 'default',
              'mealsLunch.13': 'default',
              'mealsLunch.14': 'default',
              'mealsDinner.1': 'default',
              'mealsDinner.2': 'default',
              'mealsDinner.3': 'default',
              'mealsDinner.4': 'default',
              'mealsDinner.5': 'default',
              'mealsDinner.6': 'default',
              'mealsDinner.7': 'default',
              'mealsDinner.8': 'default',
              'mealsDinner.9': 'default',
              'mealsDinner.10': 'default',
              'mealsDinner.11': 'default',
              'mealsDinner.12': 'default',
              'mealsDinner.13': 'default',
              'mealsDinner.14': 'default',
              'day.1': 'Busy',
              'day.2': 'Busy',
              'day.3': 'Busy',
              'day.4': 'Busy',
              'day.5': 'Busy',
              'day.6': 'Busy',
              'day.7': 'Busy',
              'day.8': 'Busy',
              'day.9': 'Busy',
              'day.10': 'Busy',
              'day.11': 'Busy',
              'day.12': 'Busy',
              'day.13': 'Busy',
              'day.14': 'Busy',
              'day.15': 'Busy',
              'day.16': 'Busy',
              'day.17': 'Busy',
              'day.18': 'Busy',
              'day.19': 'Busy',
              'day.20': 'Busy',
              'day.21': 'Busy',
              'checkDay.1': 'false',
              'checkDay.2': 'false',
              'checkDay.3': 'false',
              'checkDay.4': 'false',
              'checkDay.5': 'false',
              'checkDay.6': 'false',
              'checkDay.7': 'false',
              'checkDay.8': 'false',
              'checkDay.9': 'false',
              'checkDay.10': 'false',
              'checkDay.11': 'false',
              'checkDay.12': 'false',
              'checkDay.13': 'false',
              'checkDay.14': 'false',
              'checkDay.15': 'false',
              'checkDay.16': 'false',
              'checkDay.17': 'false',
              'checkDay.18': 'false',
              'checkDay.19': 'false',
              'checkDay.20': 'false',
              'checkDay.21': 'false',
              'checkDay2.1': 'false',
              'checkDay2.2': 'false',
              'checkDay2.3': 'false',
              'checkDay2.4': 'false',
              'checkDay2.5': 'false',
              'checkDay2.6': 'false',
              'checkDay2.7': 'false',
              'checkDay2.8': 'false',
              'checkDay2.9': 'false',
              'checkDay2.10': 'false',
              'checkDay2.11': 'false',
              'checkDay2.12': 'false',
              'checkDay2.13': 'false',
              'checkDay2.14': 'false',
              'checkDay2.15': 'false',
              'checkDay2.16': 'false',
              'checkDay2.17': 'false',
              'checkDay2.18': 'false',
              'checkDay2.19': 'false',
              'checkDay2.20': 'false',
              'checkDay2.21': 'false',
              'hour1Day.1': DateTime.now(),
              'hour1Day.2': DateTime.now(),
              'hour1Day.3': DateTime.now(),
              'hour1Day.4': DateTime.now(),
              'hour1Day.5': DateTime.now(),
              'hour1Day.6': DateTime.now(),
              'hour1Day.7': DateTime.now(),
              'hour1Day.8': DateTime.now(),
              'hour1Day.9': DateTime.now(),
              'hour1Day.10': DateTime.now(),
              'hour1Day.11': DateTime.now(),
              'hour1Day.12': DateTime.now(),
              'hour1Day.13': DateTime.now(),
              'hour1Day.14': DateTime.now(),
              'hour1Day.15': DateTime.now(),
              'hour1Day.16': DateTime.now(),
              'hour1Day.17': DateTime.now(),
              'hour1Day.18': DateTime.now(),
              'hour1Day.19': DateTime.now(),
              'hour1Day.20': DateTime.now(),
              'hour1Day.21': DateTime.now(),
              'hour2Day.1': DateTime.now(),
              'hour2Day.2': DateTime.now(),
              'hour2Day.3': DateTime.now(),
              'hour2Day.4': DateTime.now(),
              'hour2Day.5': DateTime.now(),
              'hour2Day.6': DateTime.now(),
              'hour2Day.7': DateTime.now(),
              'hour2Day.8': DateTime.now(),
              'hour2Day.9': DateTime.now(),
              'hour2Day.10': DateTime.now(),
              'hour2Day.11': DateTime.now(),
              'hour2Day.12': DateTime.now(),
              'hour2Day.13': DateTime.now(),
              'hour2Day.14': DateTime.now(),
              'hour2Day.16': DateTime.now(),
              'hour2Day.17': DateTime.now(),
              'hour2Day.18': DateTime.now(),
              'hour2Day.19': DateTime.now(),
              'hour2Day.20': DateTime.now(),
              'hour2Day.21': DateTime.now(),
              'scheduleHour1.1': DateTime.now(),
              'scheduleHour1.2': DateTime.now().add(Duration(days: 1)),
              'scheduleHour1.3': DateTime.now().add(Duration(days: 2)),
              'scheduleHour1.4': DateTime.now().add(Duration(days: 3)),
              'scheduleHour1.5': DateTime.now().add(Duration(days: 4)),
              'scheduleHour1.6': DateTime.now().add(Duration(days: 5)),
              'scheduleHour1.7': DateTime.now().add(Duration(days: 6)),
              'scheduleHour2.1': DateTime.now().add(Duration(days: 7)),
              'scheduleHour2.2': DateTime.now().add(Duration(days: 8)),
              'scheduleHour2.3': DateTime.now().add(Duration(days: 9)),
              'scheduleHour2.4': DateTime.now().add(Duration(days: 10)),
              'scheduleHour2.5': DateTime.now().add(Duration(days: 11)),
              'scheduleHour2.6': DateTime.now().add(Duration(days: 12)),
              'scheduleHour2.7': DateTime.now().add(Duration(days: 13)),
              'scheduleHour1End.1': DateTime.now(),
              'scheduleHour1End.2': DateTime.now().add(Duration(days: 1)),
              'scheduleHour1End.3': DateTime.now().add(Duration(days: 2)),
              'scheduleHour1End.4': DateTime.now().add(Duration(days: 3)),
              'scheduleHour1End.5': DateTime.now().add(Duration(days: 4)),
              'scheduleHour1End.6': DateTime.now().add(Duration(days: 5)),
              'scheduleHour1End.7': DateTime.now().add(Duration(days: 6)),
              'scheduleHour2End.1': DateTime.now().add(Duration(days: 7)),
              'scheduleHour2End.2': DateTime.now().add(Duration(days: 8)),
              'scheduleHour2End.3': DateTime.now().add(Duration(days: 9)),
              'scheduleHour2End.4': DateTime.now().add(Duration(days: 10)),
              'scheduleHour2End.5': DateTime.now().add(Duration(days: 11)),
              'scheduleHour2End.6': DateTime.now().add(Duration(days: 12)),
              'scheduleHour2End.7': DateTime.now().add(Duration(days: 13)),
              'scheduleBool1.1': 'false',
              'scheduleBool1.2': 'false',
              'scheduleBool1.3': 'false',
              'scheduleBool1.4': 'false',
              'scheduleBool1.5': 'false',
              'scheduleBool1.6': 'false',
              'scheduleBool1.7': 'false',
              'scheduleBool2.1': 'false',
              'scheduleBool2.2': 'false',
              'scheduleBool2.3': 'false',
              'scheduleBool2.4': 'false',
              'scheduleBool2.5': 'false',
              'scheduleBool2.6': 'false',
              'scheduleBool2.7': 'false',
              'expectations': "",
              'age': prefs.getInt('age'),
              'firstName': prefs.getString('firstName') ?? 'none',
              'lastName': prefs.getString('lastName') ?? 'none',
              'gender': prefs.getString('gender') ?? 'none',
            },
          );
          batch.commit();
          registerNotification(userId);
          await prefs.setString('expectations', null);
          await prefs.setString('nickname', prefs.getString('email'));
          await prefs.setString('id', userId);
          await prefs.setString('role', 'client');
          await prefs.setDouble(
              'height', MediaQuery.of(context).size.height / 812);
          await prefs.setDouble(
              'width', MediaQuery.of(context).size.width / 375);

          widget.onSignedIn(context);
          return true;
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      return false;
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

  bool isLoading = false;

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
                      height: 96 * prefs.getDouble('height'),
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
                                    "       Acceptarea acestor termeni \nAccesul dvs. ??i utilizarea acestei aplica??ii se supun acestor Termeni ??i Condi??ii. Nu veti folosi aceasta aplicatie ??n scopuri ilegale sau interzise prin Termenii ??i Condi??iile care urmeaz??. Prin utilizarea aplica??iei accepta??i termenii, condi??iile ??i disclaimer-ele din aceast?? pagin??. Dac?? nu accepta??i Termenii ??i Condi??iile atunci trebuie s?? ??nceta??i utilizarea aplica??iei imediat.\n  ???	Recomand??ri\nCon??inutul acestei aplicatii nu poate fi considerat ca recomandare ??i nu ar trebui considerat ca baz?? pentru luarea de decizii.\n  ???	Modific??ri ale aplicatiei mobile, software-ului ??i ale serviciilor\nBsharkr Company S.R.L. rezerv?? dreptul de a:\n  ???	Modifica sau ??terge (temporar sau permanent) aceast?? aplica??ie mobila sau orice parte a acesteia f??r?? a anun??a, iar dvs. accepta??i faptul c?? Bsharkr Company S.R.L. nu este responsabil?? pentru asemenea modific??ri sau ??tergeri.\n  ???	Modifica, ??terge sau ??ntrerupe orice software, serviciu sau promo??ie (inclusiv dar f??r?? a se limita la orice prevederi, p??r??i, licen??e, pre??uri), f??r?? a anun??a, iar dvs. accepta??i faptul c?? Bsharkr Company S.R.L. nu este responsabil?? pentru asemenea modific??ri sau ??tergeri.\n  ???	Modifica sau ??ntrerupe orice voucher promo??ional de reducere sau cod de cupon de reducere ??n orice moment cu anun?? prealabil, iar dvs. accepta??i faptul c?? Bsharkr Company S.R.L. nu este responsabil?? pentru asemenea modific??ri sau ??tergeri.\n  ???	Modifica aceast?? ??n??elegere ??n orice moment, iar continuarea utiliz??rii aplicatiei de c??tre dvs. dup?? aceste schimb??ri se va supune accept??rii acestor modific??ri de c??tre dvs.\n  ???	P??stra informa??iile personale pentru a face verificarea conturilor dar ??i pentru a fi utilizate de c??tre ter??i.",
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
                                      "\n  ???	??n urma ??tergerii unui cont, datele si contul vor fi p??strate pentru maxLines: 30 de zile.\n  ???	Linkuri c??tre ter??i\nAplicatia poate include link-uri c??tre website-urile ter??ilor sau aplica??ii terte, care sunt controlate ??i conduse de al??ii. Orice link spre un alt website sau aplica??ie nu este o recomandare a acelui web site sau aplica??ie, iar dvs. lua??i la cuno??tin???? acest fapt ??i sunte??i con??tien??i de faptul c?? nu ne asum??m responsabilitatea pentru con??inutul sau pentru disponibilitatea acestor website-uri sau aplicatii.\n  ???	Copyright\nDrepturile asupra Propriet????ii Intelectuale din aceasta aplicatie ??i din materialele din aceasta sau accesibile prin aceasta apar??in Bsharkr Company S.R.L. sau licen??elor sale. Aplicatia, materialele incluse in aplica??ie sau cele accesibile prin aceasta ??i Drepturile asupra Propriet????ii Intelectuale inerente nu pot fi copiate, distribuite, publicate, licen??iate, folosite sau reproduse ??n niciun fel (??n afar?? de m??sura strict necesar?? pentru ??i cu scopul legat de accesarea ??i utilizarea acestei aplicatii).\nBsharkr Company S.R.L. ??i logo-ul Bsharkr Company S.R.L. apar??in Bsharkr Company S.R.L. ??i nu pot fi utilizate, copiate sau reproduse ??n niciun fel f??r?? acordul scris al Bsharkr Company S.R.L.\nPentru aceste scopuri ???Drepturile asupra Propriet????ii Intelectuale??? includ urm??toarele (oriunde ??i oric??nd apar ??i pentru ??ntregul termen al acestora): orice drept, marc?? ??nregistrat??, nume ??nregistrat, nume de serviciu, design, drept asupra design-ului, copyright, drept asupra bazelor de date, drepturi morale, know how, secrete de munc?? ??i alte informa??ii confiden??iale, drepturi de natura oric??ror dintre aceste elemente ??n orice ??ar??, drepturi de natura competi??iei neloiale ??i drepturi de a da ??n judecat?? pentru transmitere sau alte drepturi similare intelectuale ??i comerciale (caz ??n care sunt sau nu ??nregistrate sau ??nregistrabile) ??i ??nregistr??rile ??i aplica??iile de ??nregistrare pentru oricare dintre ele.\n 	???	Limitarea r??spunderii\nAplica??ia este distribuit?? pe baza ???a??a cum este??? ??i ???disponibil????? f??r?? nicio reprezentare sau promovare f??cut?? ??i f??r?? garan??ie de niciun fel expres?? sau implicit??, incluz??nd dar f??r?? a se limita la garan??iile de calitate satisf??c??toare, pentru un anumit scop, ne??nc??lcare, compatibilitate, securitate ??i acurate??e.\n??n limita impus?? de lege, Bsharkr Company S.R.L. nu va fi tras?? la r??spundere pentru pierderi indirecte sau rezultate sau pentru pierderi de orice fel (incluz??nd dar nelimit??ndu-se la pierderi de afaceri, de oportunit????i, de date, de profituri), ce rezult?? din sau ??n leg??tur?? cu folosirea aplicatiei.\nBsharkr Company S.R.L. nu ofer?? nicio garan??ie c?? func??ionarea aplicatiei va fi f??r?? ??ntrerupere sau f??r?? erori, c?? defectele vor fi corectate sau c?? aplica??ia sau serverul care o face disponibil?? sunt lipsite de viru??i sau orice altceva ce poate fi d??un??tor sau distructiv.\nNimic din ace??ti Termenii ??i Condi??ii nu poate fi interpretat ca excluz??nd sau limit??nd r??spunderea Bsharkr Company S.R.L. pentru moartea sau accidentarea personal?? ca rezultat al neglijen??ei Bsharkr Company S.R.L. sau a angaja??ilor sau a agen??ilor s??i.\n 	???	Desp??gubiri\nSunte??i de acord s?? desp??gubi??i ??i s?? absolvi??i Bsharkr Company S.R.L. ??i angaja??ii ??i agen??ii s??i de toate r??spunderile, taxele legale, stric??ciunile, pierderile, costurile ??i toate celelalte cheltuieli ??n rela??ie cu revendic??rile sau ac??iunile aduse ??mpotriva Bsharkr Company S.R.L. ap??rute din orice ??nc??lcare a Termenilor ??i Condi??iilor de c??tre dvs. sau alte responsabilit????i n??scute din utilizarea acestei aplica??ii.\n 	???	Anulare\n??n cazul ??n care oricare dintre prevederile acestei ??n??elegeri sunt declarate, de c??tre orice autoritate juridic?? sau de o alt?? competen????, nule, anulabile, ilegale sau non executabile ??n vreun fel sau indicative de orice alt fel, ce sunt primite de dvs. sau de noi din partea unei autorit????ii competente, vom modifica acea prevedere ??ntr-o manier?? rezonabil?? de a??a natur?? astfel ??nc??t s?? se conformeze inten??iilor p??r??ilor f??r?? a intra ??n ilegalitate sau, la discre??ia noastr??, prevederile ??n cauz?? pot fi scoase din aceast?? ??n??elegere, iar prevederile r??mase ??n aceast?? ??n??elegere r??m??n ??n vigoare.\n	???	Legi aplicabile ??i dispute\nAceast?? ??n??elegere ??i toate cele ce rezult?? din ea sunt guvernate de ??i formulate ??n acord cu legea din Rom??nia ale c??rei cur??i au jurisdic??ie exclusiv?? asupra tuturor disputelor ce rezult?? din aceast?? ??n??elegere, iar dvs. sunte??i de acord c?? locul de punere ??n practic?? al acestei ??n??elegeri este Rom??nia.\n	???	Titluri\nTitlurile sunt incluse ??n aceast?? ??n??elegere pentru convenien???? ??i nu vor afecta ??n??elegerea acesteia.\n 	???	??n??elegerea complet??\nAce??ti termeni ??i aceste condi??ii ??mpreun?? cu alte documente la care se face referin???? expres ??n ??n??elegere includ ??ntreaga ??n??elegere dintre noi ??n leg??tur?? cu subiectul exprimat ??i ??nlocuiesc orice ??n??elegeri, aranjamente, angajamente sau propuneri anterioare, scrise sau orale: ??ntre noi ??i acele aspecte. Orice explica??ie oral?? sau informare oral?? dat?? de vreuna dintre cele dou?? p??r??i nu poate altera interpretarea termenilor ??i a condi??iilor. Prin acceptarea termenilor ??i condi??iilor, nu v-a??i bazat pe o alt?? reprezentare dec??t cea stipulat?? ??n aceast?? ??n??elegere ??i sunte??i de acord c?? nu ve??i avea nicio cale de atac cu privire la orice fals?? reprezentare ce nu a fost exprimat?? expres ??n aceast?? ??n??elegere.",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 11 * prefs.getDouble('height'),
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
                              if (await signUpAsClient(context) == true) {
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
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                                          child: Container(height: 30 * prefs.getDouble('height'),
                      child: Center(child: Text("Cancel", style: TextStyle(fontSize: 14 * prefs.getDouble('height'), color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),),
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
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
