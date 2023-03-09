
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/const.dart';
import 'package:Bsharkr/Client/Chats/Groups/Chat/GroupChat.dart';
import 'package:Bsharkr/Client/globals.dart';

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

  CrudMethods crudObj = CrudMethods();

  Future _getData;

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    _getData = crudObj.getData();
  }

  Widget buildItem(BuildContext context, int index, DocumentSnapshot snapshot) {
    if (snapshot != null) {
      if (snapshot.data['group${index + 1}'] == null) {
        return Container();
      } else {
        String groupId = snapshot.data['group${index + 1}']['0'];
        for (int i = 1; i < snapshot.data['group${index + 1}'].length; i++) {
          groupId = groupId + "-" + snapshot.data['group${index + 1}']['$i'];
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
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
            onPressed: () {
              List<String> lista = List();
              for (int i = 0;
                  i < snapshot.data['group${index + 1}'].length;
                  i++) {
                lista.add(snapshot.data['group${index + 1}']['${i}']);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChat(
                        peerIds: lista,
                        peerAvatar: snapshot.data['photoUrl'],
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: FutureBuilder(
              future: _getData,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, index, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents[0].data['groupCounter'],
                );
              },
            ),
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
          )
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
