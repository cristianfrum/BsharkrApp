
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Clients_Managing/GroupList/Chat/groupChat.dart';
import 'package:Bsharkr/Trainer/const.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';

class CrudMethods {
  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: prefs.getString('id'),
        )
        .getDocuments();
  }
}

class GroupsList extends StatefulWidget {
  final String currentUserId;

  GroupsList({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => GroupsListState(currentUserId: currentUserId);
}

class GroupsListState extends State<GroupsList> {
  GroupsListState({Key key, @required this.currentUserId});

  final String currentUserId;

  TrainerUser _trainerUser;

  QuerySnapshot documentCurrentUser;

  Future _getData;

  bool isLoading = true;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  CrudMethods crudObj = new CrudMethods();

  @override
  void initState() {
    super.initState();
    _getData = crudObj.getData();
  }

  Widget buildItem(BuildContext context, int index) {
    if (_trainerUser != null) {
      if (_trainerUser.groups[index] == null) {
        return Container();
      } else {
        String groupId = _trainerUser.groups[index][0].userId;
        for (int i = 1; i < _trainerUser.groups[index].length; i++) {
          groupId = groupId + "-" + _trainerUser.groups[index][i].userId;
        }
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
                            'Nickname: group${index + 1}',
                            style: TextStyle(color: primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                        Container(
                          child: Text(
                            'Not available',
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
              List<String> lista = List();
              for (int i = 0; i < _trainerUser.groups[index].length; i++) {
                lista.add(_trainerUser.groups[index][i].userId);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChat(
                    peerIds: lista,
                    peerAvatar: _trainerUser.photoUrl,
                  ),
                ),
              );
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
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
          future: _getData,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
                color: Colors.white.withOpacity(0.8),
              );
            }

            _trainerUser = TrainerUser(snapshot.data.documents[0]);

            return Container(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  return Slidable(
                    actionExtentRatio: 0.20,
                    delegate: SlidableDrawerDelegate(),
                    child: buildItem(context, index),
                    actions: <Widget>[
                      IconSlideAction(
                        icon: Icons.clear,
                        caption: 'Cleared',
                        color: Colors.redAccent,
                        onTap: () async {
                          int counter = 0;
                          bool semafor = true;
                          counter = _trainerUser.groups[index].length;
                          for (int i = 0; i < counter; i++) {
                            QuerySnapshot query = await Firestore.instance
                                .collection('clientUsers')
                                .where('id',
                                    isEqualTo:
                                        _trainerUser.groups[index][i].userId)
                                .getDocuments();

                            if (query.documents[0]['role'] == 'client') {
                              ClientUser _clientGroupMember =
                                  ClientUser(query.documents[0]);
                              for (int j = 1;
                                  j <= _clientGroupMember.groupCounter;
                                  j++) {
                                if (_trainerUser.groups[index].length ==
                                    _clientGroupMember.groups[j].length) {
                                  for (int k = 0; k < counter; k++) {
                                    if (_trainerUser.groups[index][k].userId !=
                                        _clientGroupMember
                                            .groups[j][k].userId) {
                                      semafor = false;
                                    }
                                  }
                                  if (semafor == true) {
                                    Firestore.instance
                                        .collection('clientUsers')
                                        .document(_clientGroupMember.id)
                                        .updateData(
                                            {'group$j': FieldValue.delete()});
                                    Firestore.instance
                                        .collection('clientUsers')
                                        .document(
                                          prefs.getString('id'),
                                        )
                                        .updateData(
                                      {'group$index': FieldValue.delete()},
                                    );
                                  }
                                  semafor = true;
                                  setState(() {});
                                }
                              }
                            } else {
                              TrainerUser _trainerGroupMember =
                                  TrainerUser(query.documents[0]);
                              for (int j = 1;
                                  j <= _trainerGroupMember.groupCounter;
                                  j++) {
                                if (_trainerUser.groups[index].length ==
                                    _trainerGroupMember.groups[j].length) {
                                  for (int k = 0; k < counter; k++) {
                                    if (_trainerUser.groups[index][k].userId !=
                                        _trainerGroupMember
                                            .groups[j][k].userId) {
                                      semafor = false;
                                    }
                                  }
                                  if (semafor == true) {
                                    Firestore.instance
                                        .collection('clientUsers')
                                        .document(_trainerGroupMember.id)
                                        .updateData(
                                            {'group$j': FieldValue.delete()});
                                    Firestore.instance
                                        .collection('clientUsers')
                                        .document(
                                          prefs.getString('id'),
                                        )
                                        .updateData(
                                      {'group$index': FieldValue.delete()},
                                    );
                                  }
                                  semafor = true;
                                  setState(() {});
                                }
                              }
                            }
                          }
                        },
                      ),
                    ],
                  );
                },
                itemCount: _trainerUser.groupCounter,
              ),
            );
          }),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
