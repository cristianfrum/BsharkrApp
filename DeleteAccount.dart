import 'dart:ui';

import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class DeleteAccountPopup extends PopupRoute<void> {
  DeleteAccountPopup({this.auth, this.id, this.role});
  final BaseAuth auth;
  final String id;
  final String role;
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
        child: DeleteDialogue(
          role: role,
          id: id,
          auth: auth,
        ),
      );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeleteDialogue extends StatefulWidget {
  final BaseAuth auth;
  final String id;
  final String role;
  DeleteDialogue({this.auth, this.id, this.role});
  @override
  State createState() => DeleteDialogueState();
}

class DeleteDialogueState extends State<DeleteDialogue> {
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
                height: 356 * prefs.getDouble('height'),
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
                        height: 36 * prefs.getDouble('height'),
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
                        "Your account will be permanently deleted in 30 days. This process is irreversible. Afterwards you will be able to register again using this email. ",
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
                            top: 32.0 * prefs.getDouble('height')),
                        child: Container(
                          width: 150.0 * prefs.getDouble('width'),
                          height: 60.0 * prefs.getDouble('height'),
                          child: Material(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(90.0),
                            child: MaterialButton(
                              onPressed: () async {
                                if (widget.role == 'trainer') {
                                  await Firestore.instance
                                      .collection('deleteAccountTrainer')
                                      .document(widget.id)
                                      .setData(
                                    {
                                      'id': widget.id,
                                      'date': DateTime.now().add(Duration(days: 30)),
                                    },
                                  );
                                  await Firestore.instance
                                      .collection('clientUsers')
                                      .document(widget.id)
                                      .updateData(
                                    {
                                      'pendingDeletion': true,
                                    },
                                  );
                                  Navigator.of(context).pop();
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
                                    await prefs.setString(
                                        'certificateUrl', null);
                                    await prefs.setStringList(
                                        'previousClients', null);
                                    await prefs.setInt('clientsCounter', null);
                                    await widget.auth.signOut();
                                  } catch (e) {
                                    print(e);
                                  }
                                  if (mounted) {
                                    Phoenix.rebirth(context);
                                  }
                                }
                                if (widget.role == 'client') {
                                  await Firestore.instance
                                      .collection('clientUsers')
                                      .document(widget.id)
                                      .updateData(
                                    {
                                      'pendingDeletion': true,
                                    },
                                  );
                                  await Firestore.instance
                                      .collection('deleteAccountClient')
                                      .document(widget.id)
                                      .setData(
                                    {
                                      'id': widget.id,
                                      'date': DateTime.now().add(Duration(days: 30)),
                                    },
                                  );
                                  Navigator.of(context).pop();
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
                                    await prefs.setString(
                                        'certificateUrl', null);
                                    await prefs.setStringList(
                                        'previousClients', null);
                                    await prefs.setInt('clientsCounter', null);
                                    await widget.auth.signOut();
                                  } catch (e) {
                                    print(e);
                                  }
                                  if (mounted) {
                                    Phoenix.rebirth(context);
                                  }
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
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 32 * prefs.getDouble('height'),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 17 * prefs.getDouble('height'),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.408,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
