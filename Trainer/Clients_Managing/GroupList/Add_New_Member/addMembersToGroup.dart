
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Trainer/const.dart';
import 'package:Bsharkr/models/clientUser.dart';

class AddMembersToGroup extends StatefulWidget {
  final String currentUserId;
  final List<String> peerIds;

  AddMembersToGroup(
      {Key key, @required this.currentUserId, @required this.peerIds})
      : super(key: key);

  @override
  State createState() =>
      AddMembersToGroupState(currentUserId: currentUserId, peerIds: peerIds);
}

class AddMembersToGroupState extends State<AddMembersToGroup> {
  AddMembersToGroupState(
      {Key key, @required this.currentUserId, @required this.peerIds});
  final List<String> peerIds;
  List<int> listaGroupCounter = [];
  List<String> listaEdit = [];
  int counterNewMembers = 0;
  final String currentUserId;

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    ClientUser _clientUser = ClientUser(document);
    if (_clientUser.id == currentUserId || peerIds.contains(_clientUser.id)) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${_clientUser.nickname}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            listaEdit.add(document.documentID);
            listaGroupCounter.add(_clientUser.groupCounter);
            counterNewMembers++;
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    listaEdit = [];
    listaGroupCounter = [];
    counterNewMembers = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Member/s to group"),
      ),
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('clientUsers')
                  .where('trainerMap.$currentUserId', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),
          RaisedButton(
            child: Text("CONFIRM"),
            onPressed: () {
              peerIds.forEach(
                (element) async {
                  QuerySnapshot query = await Firestore.instance
                      .collection('clientUsers')
                      .where('id', isEqualTo: element)
                      .getDocuments();
                  ClientUser _clientUser = ClientUser(query.documents[0]);
                  for (int i = 0; i < _clientUser.groupCounter; i++) {
                    if (_clientUser.groups[i].length == peerIds.length) {
                      bool semafor = true;
                      for (int j = 0; j < _clientUser.groups[i].length; j++) {
                        if (_clientUser.groups[i][j].userId != peerIds[j]) {
                          semafor = false;
                        }
                      }
                      if (semafor == true) {
                        int c = _clientUser.groups[i].length;
                        var db = Firestore.instance;
                        var batch = db.batch();
                        for (int k = 0; k < counterNewMembers; k++) {
                          batch.updateData(
                            db
                                .collection('clientUsers')
                                .document(_clientUser.id),
                            {'group${i + 1}.${c + k}': '${listaEdit[k]}'},
                          );
                        }
                        batch.commit();
                      }
                    }
                  }
                },
              );
              for (int i = 0; i < listaEdit.length; i++) {
                Firestore.instance
                    .collection('clientUsers')
                    .document(
                      listaEdit[i],
                    )
                    .updateData(
                  {'groupCounter': int.parse('${listaGroupCounter[i] + 1}')},
                );
                for (int j = 0; j < peerIds.length; j++) {
                  Firestore.instance
                      .collection('clientUsers')
                      .document(
                        listaEdit[i],
                      )
                      .updateData(
                    {'group${listaGroupCounter[i] + 1}.$j': '${peerIds[j]}'},
                  );
                }
                ;
                for (int j = 0; j < counterNewMembers; j++) {
                  Firestore.instance
                      .collection('clientUsers')
                      .document(
                        listaEdit[i],
                      )
                      .updateData(
                    {
                      'group${listaGroupCounter[i] + 1}.${peerIds.length + j}':
                          '${listaEdit[j]}'
                    },
                  );
                }
              }
            },
          ),
          // Loading
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
