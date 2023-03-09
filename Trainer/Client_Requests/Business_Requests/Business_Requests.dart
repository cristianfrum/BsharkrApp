import 'package:Bsharkr/Trainer/Client_Requests/Client_Profile/ClientProfileFinal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:flutter_svg/svg.dart';

bool restart2 = false;

class BusinessRequests extends StatefulWidget {
  final int index;
  final TrainerUser actualTrainer;
  BusinessRequests({this.actualTrainer, this.index});
  @override
  State createState() => BusinessRequestsState();
}

class BusinessRequestsState extends State<BusinessRequests>
    with AutomaticKeepAliveClientMixin<BusinessRequests> {
  check() async {
    bool bigBool = false;
    List<DocumentSnapshot> auxi = [];
    List<String> auuxx = [];
    int firstNumber = 0;
    widget.actualTrainer.clients.forEach((element) {
      if (element.clientAccepted == false) {
        firstNumber++;
      }
    });
    if (firstNumber > verifyIds.length) {
      widget.actualTrainer.clients.forEach((element) async {
        bool flag = false;
        if (element.clientAccepted == false) {
          verifyIds.forEach((element1) {
            if (element1 == element.clientId) {
              flag = true;
            }
          });
          if (flag == false) {
            QuerySnapshot query = await Firestore.instance
                .collection('clientUsers')
                .where('id', isEqualTo: element.clientId)
                .getDocuments();
            bool ultimulFlag = false;
            _clients.forEach((elementx) {
              if (ClientUser(elementx).id == element.clientId) {
                ultimulFlag = true;
              }
            });
            if (ultimulFlag == false && query.documents.length != 0) {
              if (mounted) {
                setState(() {
                  _clients.insert(0, query.documents[0]);
                  verifyIds.insert(0, element.clientId);
                });
              }
            }
          }
        }
      });
    }
    if (firstNumber < verifyIds.length) {
      verifyIds.forEach((element1) async {
        bool flag = false;
        widget.actualTrainer.clients.forEach((element) {
          if (element1 == element.clientId && element.clientAccepted == false) {
            flag = true;
          }
        });
        if (flag == false) {
          bool omgFlag = false;
          _clients.forEach((element) {
            if (ClientUser(element).id == element1) {
              omgFlag = true;
            }
          });
          if (omgFlag == true) {
            bigBool = true;
            auuxx.add(element1);
            auxi.add(_clients
                .where((element) => ClientUser(element).id == element1)
                .toList()[0]);
          }
        }
      });
      auuxx.forEach((element) {
        verifyIds.remove(element);
      });
      setState(() {
        for (int i = 0; i < auxi.length; i++) {
          _clients.remove(auxi[i]);
        }
      });
    }
  }

  List<String> verifyIds = [];
  @override
  void initState() {
    super.initState();
    _getClients();
    widget.actualTrainer.clients.forEach((element) {
      if (element.clientAccepted == false) {
        verifyIds.add(element.clientId);
      }
    });
  }

  bool _loadingClients = false;
  List<DocumentSnapshot> _clients = [];

  _getClients() async {
    if (mounted) {
      setState(() {
        _loadingClients = true;
      });
    }
    List<String> actualClients = [];
    List<BusinessRequestDateList> dateList = [];
    for (int i = 0;
        i < widget.actualTrainer.businessRequestDateList.length;
        i++) {
      dateList.add(BusinessRequestDateList(
          widget.actualTrainer.businessRequestDateList[i].id,
          widget.actualTrainer.businessRequestDateList[i].time));
    }
    int counter = 0;
    for (int i = 0; i < dateList.length - 1; i++) {
      for (int j = i + 1; j < dateList.length; j++) {
        if (dateList[i].time.toDate().isBefore(dateList[j].time.toDate()) ==
            true) {
          BusinessRequestDateList aux = dateList[j];
          dateList[j] = dateList[i];
          dateList[i] = aux;
        }
      }
    }
    dateList.forEach((element) {
      bool flag = false;
      widget.actualTrainer.clients.forEach((element1) { 
        if(element1.clientId == element.id && element1.clientAccepted == false){
          flag = true;
        }
      });
      if (flag == true) {
        actualClients.add(element.id);
        counter++;
      }
    });
    int auxCounter = counter;
    counter = 0;
    while (counter < auxCounter) {
      QuerySnapshot q = await Firestore.instance
          .collection('clientUsers')
          .where('id', isEqualTo: actualClients[counter])
          .getDocuments();
      _clients.add(q.documents[0]);
      counter++;
    }
    if (mounted) {
      setState(() {
        _loadingClients = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.actualTrainer.newBusinessRequest != null && widget.index == 0) {
      Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData(
        {'newBusinessRequest': FieldValue.delete()},
      );
    }
    check();
    return widget.actualTrainer.clients
                .where((element) => element.clientAccepted == false)
                .length !=
            0
        ? SingleChildScrollView(
            child: Container(
                color: backgroundColor,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Column(
                      children: _clients.map(
                        (client) {
                          return buildResultCard(ClientUser(client));
                        },
                      ).toList(),
                    ),
                    _loadingClients == true
                        ? Align(
                            alignment: Alignment.center,
                            child: _loadingClients == true
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        mainColor),
                                    backgroundColor: backgroundColor,
                                  )
                                : Container(),
                          )
                        : Container()
                  ],
                )),
          )
        : Container(
            color: backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/requestf1.svg',
                    width: 300.0 * prefs.getDouble('width'),
                    height: 150.0 * prefs.getDouble('height'),
                  ),
                  SizedBox(height: 32 * prefs.getDouble('height')),
                  Text("No collaboration requests",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.75,
                          fontSize: 20 * prefs.getDouble('height'),
                          color: Colors.white)),
                  SizedBox(height: 16 * prefs.getDouble('height')),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 32 * prefs.getDouble('width')),
                    width: 375 * prefs.getDouble('width'),
                    child: Text(
                      "You have a free contact request each day. Use it to interact with potential clients. You can also bring your existing clients into the app.",
                      style: TextStyle(
                          letterSpacing: 0.75,
                          fontSize: 13 * prefs.getDouble('height'),
                          color: Color.fromARGB(200, 255, 255, 255),
                          fontFamily: 'Roboto'),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void goToNextPage(BuildContext context, dynamic data) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => ClientProfileFinalSetState(
            data.id, prefs.getString('id'), data, widget.actualTrainer, null),
      ),
    );
  }

  Widget buildResultCard(client) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          10.0 * prefs.getDouble('width'),
          5.0 * prefs.getDouble('height'),
          10.0 * prefs.getDouble('width'),
          0.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0 * prefs.getDouble('height')),
              color: secondaryColor),
          height: 128.0 * prefs.getDouble('height'),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    goToNextPage(context, client);
                  },
                  child: Container(
                    height: 128 * prefs.getDouble('height'),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 30.0 * prefs.getDouble('width'),
                        ),
                        ClipOval(
                          child: Container(
                            padding:
                                EdgeInsets.all(2.0 * prefs.getDouble('height')),
                            color: backgroundColor,
                            child: client.photoUrl == null
                                ? ClipOval(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255,
                                              client.colorRed,
                                              client.colorGreen,
                                              client.colorBlue),
                                          shape: BoxShape.circle,
                                        ),
                                        height:
                                            (96 * prefs.getDouble('height')),
                                        width: (96 * prefs.getDouble('height')),
                                        child: Center(
                                          child: Text(
                                            client.firstName[0],
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontSize: 50 *
                                                    prefs.getDouble('height')),
                                          ),
                                        )),
                                  )
                                : Material(
                                    child: Container(
                                      width: 96 * prefs.getDouble('height'),
                                      height: 96 * prefs.getDouble('height'),
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          shape: BoxShape.circle),
                                      child: Image.network(
                                        client.photoUrl,
                                        fit: BoxFit.cover,
                                        scale: 1.0,
                                        loadingBuilder: (BuildContext ctx,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(mainColor),
                                                backgroundColor:
                                                    backgroundColor,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(77.5),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0 * prefs.getDouble('width'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  client.firstName,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(200, 255, 255, 255),
                                      fontSize: 17 * prefs.getDouble('height')),
                                ),
                                SizedBox(
                                  width: 4.0 * prefs.getDouble('width'),
                                ),
                                Text(
                                  client.lastName,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(200, 255, 255, 255),
                                      fontSize: 17 * prefs.getDouble('height')),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Age: ",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(100, 255, 255, 255),
                                    fontSize: 15 * prefs.getDouble('height'),
                                  ),
                                ),
                                Text(
                                  client.age.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    color: Color.fromARGB(100, 255, 255, 255),
                                    fontSize: 15 * prefs.getDouble('height'),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0 * prefs.getDouble('width'),
                                ),
                                Text(
                                  "|",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize:
                                          15.0 * prefs.getDouble('height'),
                                      color:
                                          Color.fromARGB(100, 255, 255, 255)),
                                ),
                                SizedBox(
                                  width: 5.0 * prefs.getDouble('width'),
                                ),
                                client.gender != 'none'
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            client.gender == 'male'
                                                ? 'Male'
                                                : 'Female',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  100, 255, 255, 255),
                                              fontSize: 15 *
                                                  prefs.getDouble('height'),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                            SizedBox(
                              height: 15.0 * prefs.getDouble('height'),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 90.0 * prefs.getDouble('width'),
                                  height: 30.0 * prefs.getDouble('height'),
                                  child: Material(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        var db = Firestore.instance;
                                        var batch = db.batch();

                                        batch.updateData(
                                          db
                                              .collection('clientUsers')
                                              .document(prefs.getString('id')),
                                          {
                                            'trainerMap.${client.id}': true,
                                            'friendsMap.${client.id}':
                                                FieldValue.delete(),
                                            'newClient': true,
                                          },
                                        );
                                        batch.updateData(
                                          db
                                              .collection('clientUsers')
                                              .document(client.id),
                                          {
                                            'trainersMap.${prefs.getString('id')}':
                                                true,
                                            'friendsMap.${prefs.getString('id')}':
                                                FieldValue.delete(),
                                            'newBusiness': true
                                          },
                                        );

                                        batch.setData(
                                          db
                                              .collection(
                                                  'clientAcceptedCollaboration')
                                              .document(client.id),
                                          {
                                            'idFrom': prefs.getString('id'),
                                            'idTo': client.id,
                                            'pushToken': client.pushToken
                                          },
                                        );
                                        batch.commit();
                                      },
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 11.0 *
                                                prefs.getDouble('height'),
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0 * prefs.getDouble('width'),
                                ),
                                Container(
                                  width: 90.0 * prefs.getDouble('width'),
                                  height: 30.0 * prefs.getDouble('height'),
                                  child: Material(
                                    color: Color(0xff57575E),
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            DeletePermissionPopup(
                                                clientUser: client,
                                                parent: this));
                                      },
                                      child: Text(
                                        'Refuse',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 11.0 *
                                                prefs.getDouble('height'),
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class DeletePermissionPopup extends PopupRoute<void> {
  DeletePermissionPopup({this.clientUser, this.parent});
  final BusinessRequestsState parent;
  final ClientUser clientUser;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      DeletePermission(clientUser: clientUser, parent: parent);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission extends StatefulWidget {
  final BusinessRequestsState parent;
  final ClientUser clientUser;

  DeletePermission({Key key, @required this.clientUser, @required this.parent})
      : super(key: key);

  @override
  State createState() => DeletePermissionState(clientUser: clientUser);
}

class DeletePermissionState extends State<DeletePermission> {
  final ClientUser clientUser;
  DeletePermissionState({Key key, @required this.clientUser});

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 310 * prefs.getDouble('width'),
          height: 280 * prefs.getDouble('height'),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0 * prefs.getDouble('height')),
              color: backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Warning",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(200, 255, 255, 255),
                    fontSize: 20 * prefs.getDouble('height')),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16 * prefs.getDouble('height'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16 * prefs.getDouble('width')),
                child: Text(
                  "Are you sure you want to refuse the training partnership with ${clientUser.firstName} ${clientUser.lastName}? The friendship will be deleted as well.",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(120, 255, 255, 255),
                    fontSize: 12 * prefs.getDouble('height'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 32 * prefs.getDouble('height'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 15.0 * prefs.getDouble('height')),
                child: Container(
                  width: 150.0 * prefs.getDouble('width'),
                  height: 50.0 * prefs.getDouble('height'),
                  child: Material(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () async {
                        Firestore.instance
                            .collection('clientUsers')
                            .document(prefs.getString('id'))
                            .updateData(
                          {
                            'trainerMap.${clientUser.id}': FieldValue.delete(),
                            'friendsMap.${clientUser.id}': FieldValue.delete()
                          },
                        );

                        Firestore.instance
                            .collection('clientUsers')
                            .document(clientUser.id)
                            .updateData(
                          {
                            'trainersMap.${prefs.getString('id')}':
                                FieldValue.delete(),
                            'friendsMap.${prefs.getString('id')}':
                                FieldValue.delete()
                          },
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Refuse',
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
              SizedBox(
                height: 8 * prefs.getDouble('height'),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 32 * prefs.getDouble('height'),
                  width: 150 * prefs.getDouble('width'),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17 * prefs.getDouble('height'),
                          letterSpacing: -0.408,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class BusinessRequestDateList {
  String id;
  Timestamp time;

  BusinessRequestDateList(String id, Timestamp time) {
    this.id = id;
    this.time = time;
  }
}
