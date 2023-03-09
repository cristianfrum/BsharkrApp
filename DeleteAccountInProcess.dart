import 'dart:ui';

import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class DeleteAccountInProcessPopup extends PopupRoute<void> {
  DeleteAccountInProcessPopup({this.auth, this.role});
  final String role;
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
      Container(
        color: Colors.transparent,
        child: DeleteInProcessDialogue(auth: auth, role: role),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeleteInProcessDialogue extends StatefulWidget {
  DeleteInProcessDialogue({this.auth, this.role});
  final BaseAuth auth;
  final String role;
  @override
  State createState() => DeleteInProcessDialogueState();
}

class DeleteInProcessDialogueState extends State<DeleteInProcessDialogue> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              height: 370 * prefs.getDouble('height'),
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
                    SizedBox(
                      height: 18 * prefs.getDouble('height'),
                    ),
                    Text(
                      "Delete account",
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
                      "Your account will be permanently deleted in several days. This process is irreversible. Afterwards you will be able to register again using this email. ",
                      style: TextStyle(
                          fontSize: 17 * prefs.getDouble('height'),
                          letterSpacing: -0.078,
                          fontWeight: FontWeight.normal,
                          color: Colors.white.withOpacity(0.6),
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 48.0 * prefs.getDouble('height')),
                      child: Container(
                        width: 150.0 * prefs.getDouble('width'),
                        height: 60.0 * prefs.getDouble('height'),
                        child: Material(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(90.0),
                          child: MaterialButton(
                            onPressed: () async {
                              if (widget.role == 'trainer') {
                                try {
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
                                  await prefs.setStringList(
                                      'previousClients', null);
                                  await prefs.setInt('clientsCounter', null);
                                  await widget.auth.signOut();
                                } catch (e) {
                                  print(e);
                                }
                              }
                              if (widget.role == 'client') {
                                try {
                                  await prefs.setString('logOut', 'true');
                                  await prefs.setString('expectations', null);
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
                                  await widget.auth.signOut();
                                } catch (e) {
                                  print(e);
                                }
                              }
                              if (mounted) {
                                Phoenix.rebirth(context);
                              }
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
                    SizedBox(height: 32 * prefs.getDouble('height')),
                    InkWell(
                      onTap: () async {
                        var db = Firestore.instance;
                        if (widget.role == 'trainer') {
                          try {
                            db
                                .collection('deleteAccountTrainer')
                                .document(prefs.getString('id'))
                                .delete();
                            await Firestore.instance
                                .collection('clientUsers')
                                .document(prefs.getString('id'))
                                .updateData(
                              {
                                'pendingDeletion': false,
                              },
                            );
                          } catch (e) {}
                          if (mounted) {
                            Phoenix.rebirth(context);
                          }
                        }
                        if (widget.role == 'client') {
                          try {
                            db
                                .collection('deleteAccountClient')
                                .document(prefs.getString('id'))
                                .delete();
                            await Firestore.instance
                                .collection('clientUsers')
                                .document(prefs.getString('id'))
                                .updateData(
                              {
                                'pendingDeletion': false,
                              },
                            );
                          } catch (e) {}
                          if (mounted) {
                            Phoenix.rebirth(context);
                          }
                        }
                      },
                      child: Container(
                        height: 32 * prefs.getDouble('height'),
                        child: Center(
                          child: Text(
                            "Deactivate deleting my account",
                            style: TextStyle(
                                fontSize: 18 * prefs.getDouble('height'),
                                letterSpacing: -0.078,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Roboto'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
