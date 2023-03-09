import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/IconSlide.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

class ClientsThatJoined extends StatefulWidget {
  ClientsThatJoined({this.imTrainer, this.title, this.index});
  final int index;
  final TrainerUser imTrainer;
  final String title;
  @override
  _ClientsThatJoinedState createState() => _ClientsThatJoinedState();
}

class _ClientsThatJoinedState extends State<ClientsThatJoined> {
  Widget buildItem(BuildContext context, int index) {
    bool trainingFlag = false;
    widget.imTrainer.clients.forEach((element) {
      if (element.clientId ==
          widget.imTrainer.classes[widget.index].occupiedSpots[index].id) {
        trainingFlag = true;
      }
    });
    return Container(
      padding: EdgeInsets.fromLTRB(
          10.0 * prefs.getDouble('width'),
          5.0 * prefs.getDouble('height'),
          10.0 * prefs.getDouble('width'),
          5.0 * prefs.getDouble('height')),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(8.0 * prefs.getDouble('height')),
        ),
        child: Container(
          width: 343 * prefs.getDouble('width'),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(-1.0, -1.0),
              stops: [0.0, 0.85],
              colors: [
                trainingFlag == true
                    ? mainColor.withOpacity(1.0)
                    : secondaryColor,
                trainingFlag == true
                    ? mainColor.withOpacity(0.0)
                    : secondaryColor,
              ],
            ),
            border: Border.all(
              color: trainingFlag == true ? mainColor : secondaryColor,
              width: 2 * prefs.getDouble('height'),
            ),
            borderRadius:
                BorderRadius.circular(8.0 * prefs.getDouble('height')),
          ),
          height: 105.0 * prefs.getDouble('height'),
          child: Center(
            child: Container(
              height: 100 * prefs.getDouble('height'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 30.0 * prefs.getDouble('width'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor,
                    ),
                    padding: EdgeInsets.all(2.0 * prefs.getDouble('height')),
                    child: widget.imTrainer.classes[widget.index]
                                .clientsPhotoUrl[index].photoUrl ==
                            null
                        ? ClipOval(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                    255,
                                    int.parse(widget
                                        .imTrainer
                                        .classes[widget.index]
                                        .clientsColorRed[index]
                                        .colorRed),
                                    int.parse(widget
                                        .imTrainer
                                        .classes[widget.index]
                                        .clientsColorGreen[index]
                                        .colorGreen),
                                    int.parse(widget
                                        .imTrainer
                                        .classes[widget.index]
                                        .clientsColorBlue[index]
                                        .colorBlue),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                height: (60 * prefs.getDouble('height')),
                                width: (60 * prefs.getDouble('height')),
                                child: Center(
                                  child: Text(
                                    widget.imTrainer.classes[widget.index]
                                        .clientsFirstName[index].firstName[0],
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize:
                                            35 * prefs.getDouble('height'),
                                        color: Colors.white),
                                  ),
                                )),
                          )
                        : Material(
                            child: Container(
                              width: 60 * prefs.getDouble('height'),
                              height: 60 * prefs.getDouble('height'),
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.circle),
                              child: Image.network(
                                widget.imTrainer.classes[widget.index]
                                    .clientsPhotoUrl[index].photoUrl,
                                fit: BoxFit.cover,
                                scale: 1.0,
                                loadingBuilder: (BuildContext ctx, Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                mainColor),
                                        backgroundColor: backgroundColor,
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
                  SizedBox(
                    width: 15.0 * prefs.getDouble('width'),
                  ),
                  Container(
                    width: 230 * prefs.getDouble('width'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150 * prefs.getDouble('width'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 20 * prefs.getDouble('height'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      widget.imTrainer.classes[widget.index]
                                          .clientsFirstName[index].firstName,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontSize:
                                              17 * prefs.getDouble('height')),
                                    ),
                                    SizedBox(
                                      width: 4.0 * prefs.getDouble('width'),
                                    ),
                                    Text(
                                      widget.imTrainer.classes[widget.index]
                                          .clientsLastName[index].lastName,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              200, 255, 255, 255),
                                          fontSize:
                                              17 * prefs.getDouble('height')),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3.0 * prefs.getDouble('height'),
                              ),
                              Container(
                                height: 20 * prefs.getDouble('height'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Age: ",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color:
                                            Color.fromARGB(100, 255, 255, 255),
                                        fontSize:
                                            15 * prefs.getDouble('height'),
                                      ),
                                    ),
                                    Text(
                                      widget.imTrainer.classes[widget.index]
                                          .clientsAge[index].age
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        color:
                                            Color.fromARGB(100, 255, 255, 255),
                                        fontSize:
                                            15 * prefs.getDouble('height'),
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
                                          color: Color.fromARGB(
                                              100, 255, 255, 255)),
                                    ),
                                    SizedBox(
                                      width: 5.0 * prefs.getDouble('width'),
                                    ),
                                    widget.imTrainer.classes[widget.index]
                                                .clientsGender[index].gender !=
                                            'none'
                                        ? Row(
                                            children: <Widget>[
                                              Text(
                                                widget
                                                            .imTrainer
                                                            .classes[
                                                                widget.index]
                                                            .clientsGender[
                                                                index]
                                                            .gender ==
                                                        'male'
                                                    ? "Male"
                                                    : "Female",
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
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: 75 * prefs.getDouble('width'),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 25 * prefs.getDouble('height'),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "${((double.parse(widget.imTrainer.classes[widget.index].clientsRating[index].vote).toStringAsFixed(2)))}",
                                          style: TextStyle(
                                              fontSize: 17.0 *
                                                  prefs.getDouble('height'),
                                              fontWeight: FontWeight.w700,
                                              color: mainColor),
                                        ),
                                        SizedBox(
                                          width: 5.0 * prefs.getDouble('width'),
                                        ),
                                        Icon(
                                          Icons.star,
                                          size:
                                              24.0 * prefs.getDouble('height'),
                                          color: mainColor,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 25 * prefs.getDouble('height'),
                                  )
                                ]))
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'),
        ),
      ),
      body: widget.imTrainer.classes[widget.index].occupiedSpots.length != 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount:
                  widget.imTrainer.classes[widget.index].occupiedSpots.length,
              itemBuilder: (_, int index) => Slidable(
                  actionExtentRatio: 0.20,
                  delegate: SlidableDrawerDelegate(),
                  secondaryActions: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10 * prefs.getDouble('height')),
                      child: IconSlideActionModifiedRight(
                        icon: Icons.cancel,
                        color: Colors.red,
                        onTap: () {
                          Navigator.push(
                            context,
                            DeletePermissionPopup(
                                index: widget.index,
                                imTrainer: widget.imTrainer,
                                id: widget.imTrainer.classes[widget.index]
                                    .occupiedSpots[index].id,
                                firstName: widget
                                    .imTrainer
                                    .classes[widget.index]
                                    .clientsFirstName[index]
                                    .firstName,
                                lastName: widget.imTrainer.classes[widget.index]
                                    .clientsLastName[index].lastName),
                          );
                        },
                      ),
                    ),
                  ],
                  child: buildItem(context, index)),
            )
          : Center(
              child: Container(
                height: 500 * prefs.getDouble('height'),
                color: backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/phCalendarf1.svg',
                        width: 350.0 * prefs.getDouble('width'),
                        height: 150.0 * prefs.getDouble('height'),
                      ),
                      SizedBox(height: 32 * prefs.getDouble('height')),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 64 * prefs.getDouble('width')),
                          child: Text("No clients in class",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.75,
                                  fontSize: 20 * prefs.getDouble('height'),
                                  color: Colors.white),
                              textAlign: TextAlign.center)),
                      SizedBox(height: 32 * prefs.getDouble('height')),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 48 * prefs.getDouble('width')),
                        width: 375 * prefs.getDouble('width'),
                        child: Text(
                          "Inviting your clients will help you scaling up your business faster.",
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
              ),
            ),
    );
  }
}

class DeletePermissionPopup extends PopupRoute<void> {
  DeletePermissionPopup(
      {this.id, this.firstName, this.lastName, this.imTrainer, this.index});
  final int index;
  final String id;
  final String firstName;
  final String lastName;
  final TrainerUser imTrainer;
  @override
  Color get barrierColor => Color.fromARGB(255, 8, 8, 13).withOpacity(0.98);

  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => "Close";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      DeletePermission(
          id: id,
          firstName: firstName,
          lastName: lastName,
          imTrainer: imTrainer,
          index: index);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class DeletePermission extends StatefulWidget {
  final int index;
  final String id;
  final String firstName;
  final String lastName;

  final TrainerUser imTrainer;
  DeletePermission(
      {Key key,
      @required this.id,
      @required this.firstName,
      @required this.lastName,
      @required this.imTrainer,
      @required this.index})
      : super(key: key);

  @override
  State createState() => DeletePermissionState(
      id: id,
      firstName: firstName,
      lastName: lastName,
      imTrainer: imTrainer,
      index: index);
}

class DeletePermissionState extends State<DeletePermission> {
  final int index;
  final String id;
  final String firstName;
  final String lastName;
  final TrainerUser imTrainer;
  DeletePermissionState(
      {Key key,
      @required this.id,
      @required this.firstName,
      @required this.lastName,
      @required this.imTrainer,
      @required this.index});

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
                  "Are you sure you want to kick $firstName $lastName out?",
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
                    borderRadius: BorderRadius.circular(90.0),
                    child: MaterialButton(
                      onPressed: () async {
                        QuerySnapshot query2 = await Firestore.instance
                            .collection('clientUsers')
                            .where('id', isEqualTo: id)
                            .getDocuments();
                        var db = Firestore.instance;
                        int classIndex;
                        var batch = db.batch();
                        ClientUser actualClient =
                            ClientUser(query2.documents[0]);
                        for (int i = 0;
                            i < actualClient.counterClassesClient;
                            i++) {
                          if (actualClient.classes[i].dateAndTime ==
                                  widget.imTrainer.classes[widget.index]
                                      .dateAndTime &&
                              actualClient.classes[i].dateAndTimeDateTime ==
                                  widget.imTrainer.classes[widget.index]
                                      .dateAndTimeDateTime &&
                              actualClient.classes[i].duration ==
                                  widget.imTrainer.classes[widget.index]
                                      .duration &&
                              actualClient.classes[i].firstName ==
                                  widget.imTrainer.firstName &&
                              actualClient.classes[i].lastName ==
                                  widget.imTrainer.lastName &&
                              actualClient.classes[i].trainerId ==
                                  widget.imTrainer.id) {
                            classIndex = i;
                          }
                        }

                        if (classIndex != null) {
                          if (classIndex == 0 &&
                              actualClient.counterClassesClient == 1) {
                            batch.updateData(
                              db
                                  .collection('clientUsers')
                                  .document(actualClient.id),
                              {
                                'deletedClient': true,
                                'class1': FieldValue.delete(),
                                'counterClassesClient': 0
                              },
                            );
                          } else {
                            if (classIndex !=
                                actualClient.counterClassesClient - 1) {
                              for (int i = classIndex + 1;
                                  i < actualClient.counterClassesClient;
                                  i++) {
                                batch.updateData(
                                  db
                                      .collection('clientUsers')
                                      .document(actualClient.id),
                                  {
                                    'class$i.public':
                                        actualClient.classes[i].public,
                                    'class$i.classLevel':
                                        actualClient.classes[i].classLevel,
                                    'class$i.locationName':
                                        actualClient.classes[i].locationName,
                                    'class$i.locationDistrict': actualClient
                                        .classes[i].locationDistrict,
                                    'class$i.individualPrice':
                                        actualClient.classes[i].individualPrice,
                                    'class$i.memberPrice':
                                        actualClient.classes[i].memberPrice,
                                    'class$i.spots':
                                        actualClient.classes[i].spots,
                                    'class$i.type':
                                        actualClient.classes[i].type,
                                    'class$i.dateAndTime':
                                        actualClient.classes[i].dateAndTime,
                                    'class$i.dateAndTimeDateTime': actualClient
                                        .classes[i].dateAndTimeDateTime,
                                    'class$i.duration':
                                        actualClient.classes[i].duration,
                                    'class$i.occupiedSpots':
                                        actualClient.classes[i].occupiedSpots,
                                    'class$i.locationStreet':
                                        actualClient.classes[i].locationStreet,
                                    'class$i.number': i,
                                    'class$i.trainerFirstName':
                                        actualClient.classes[i].firstName,
                                    'class$i.trainerId':
                                        actualClient.classes[i].trainerId,
                                    'class$i.trainerLastName':
                                        actualClient.classes[i].lastName
                                  },
                                );
                              }
                            }
                            batch.updateData(
                              db
                                  .collection('clientUsers')
                                  .document(actualClient.id),
                              {
                                'deletedClient': true,
                                'class${actualClient.counterClassesClient}':
                                    FieldValue.delete(),
                                'counterClassesClient':
                                    actualClient.counterClassesClient - 1
                              },
                            );
                          }

                          batch.updateData(
                            db
                                .collection('clientUsers')
                                .document(widget.imTrainer.id),
                            {
                              'class${widget.index + 1}.occupiedSpots.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsAge.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsGender.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsFirstName.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsLastName.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsPhotoUrl.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsColorRed.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsColorGreen.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsColorBlue.${actualClient.id}':
                                  FieldValue.delete(),
                              'class${widget.index + 1}.clientsRating.${actualClient.id}':
                                  FieldValue.delete(),
                            },
                          );

                          await Firestore.instance
                              .collection('deletedClient')
                              .document(actualClient.id)
                              .setData(
                            {
                              'idFrom': prefs.getString('id'),
                              'idTo': actualClient.id,
                              'pushToken': actualClient.pushToken,
                              'firstName': widget.imTrainer.firstName
                            },
                          );
                          batch.commit();
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Stop training',
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
