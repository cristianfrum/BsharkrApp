import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Main_Menu/MainTrainer.dart';
import 'package:Bsharkr/auth.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/main.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
    this.id,
  });
  final String id;
  final BaseAuth auth;
  final Function onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _getData;

 

  Future<QuerySnapshot> getData() async {
    QuerySnapshot q = await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();

    if (q.documents.length == 0) {
      prefs.setString("id", null);
      Navigator.of(context).pop();
    } else {
      return q;
    }
  }

  @override
  void initState() {
   
    super.initState();

    _getData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: _getData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null ||
              snapshot.data.documents.length == 0) {
            return Container(color: backgroundColor,);
          }

          return Scaffold(backgroundColor: backgroundColor,
                      body: snapshot.data.documents[0].data["role"] == "client"
                ? MyApp(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    selectedPage: 2,
                  )
                : MainTrainer(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    selectedPage: 1,
                  ),
          );
        });
  }
}
