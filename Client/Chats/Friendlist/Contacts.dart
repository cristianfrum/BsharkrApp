import 'package:Bsharkr/Client/Chats/Friendlist/Friends.dart';
import 'package:Bsharkr/Client/Chats/Friendlist/Requests.dart';
import 'package:Bsharkr/Client/Chats/Friendlist/Trainers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/models/clientUser.dart';

import '../../../main.dart';

int selectedBarIndex1 = 0;

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class MyTabsFriends extends StatefulWidget {
  final MyAppState parent;
  final bool seenFlagFriends;
  final bool seenFlagTrainers;
  final bool newFriend;
  final bool newTrainer;
  final bool trainerRequestedClient;
  final ClientUser imClient;
  int selectedBarIndex;
  MyTabsFriends(
      {this.selectedBarIndex,
      this.imClient,
      this.newFriend,
      this.newTrainer,
      this.seenFlagFriends,
      this.seenFlagTrainers,
      this.trainerRequestedClient, this.parent});
  @override
  MyTabsFriendsState createState() => new MyTabsFriendsState();
}

class MyTabsFriendsState extends State<MyTabsFriends>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
        vsync: this,
        length: 3,
        initialIndex: widget.selectedBarIndex == null
            ? selectedBarIndex1
            : widget.selectedBarIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedBarIndex == null) {
      widget.selectedBarIndex = selectedBarIndex1;
    } else {
      selectedBarIndex1 = widget.selectedBarIndex;
    }
    return AppBarNavigation(
        seenFlagFriends: widget.seenFlagFriends,
        seenFlagTrainers: widget.seenFlagTrainers,
        newFriend: widget.newFriend,
        newTrainer: widget.newTrainer,
        selectedBarIndex: widget.selectedBarIndex,
        parent: this,
        imClient: widget.imClient,
        trainerRequestedClient: widget.trainerRequestedClient,
        controller: controller);
  }
}

class AppBarNavigation extends StatefulWidget {
  final bool trainerRequestedClient;
  final bool seenFlagFriends;
  final bool seenFlagTrainers;
  final bool newFriend;
  final bool newTrainer;
  final ClientUser imClient;
  final MyTabsFriendsState parent;
  final TabController controller;
  int selectedBarIndex;
  AppBarNavigation(
      {this.selectedBarIndex,
      this.parent,
      this.imClient,
      this.newFriend,
      this.newTrainer,
      this.seenFlagFriends,
      this.seenFlagTrainers,
      this.trainerRequestedClient,
      this.controller});
  final List<BarItem> barItems = [
    BarItem(
      text: "Requests",
      iconData: Icons.group_add,
      color: Colors.white,
    ),
    BarItem(
      text: "Friends",
      iconData: Icons.person,
      color: Colors.white,
    ),
    BarItem(
      text: "Trainers",
      iconData: Icons.assignment_ind,
      color: Colors.white,
    ),
  ];

  @override
  State createState() => AppNavigationState();
}

class AppNavigationState extends State<AppBarNavigation> {
  List<int> listGroupCounter;
  List<String> listEdit = [];

  bool edit = false;
  int counterNewMembers = 0;

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  List<DocumentSnapshot> initFriendsList = [];
  List<int> deletedTrainerFriends = List<int>.filled(50, 0, growable: true);
  int deletedCounter = 0;
  ClientUser imClient;
  bool seenFlagClients;

  @override
  Widget build(BuildContext context) {
    listEdit = [];
    listGroupCounter = [];
    counterNewMembers = 0;
    return Scaffold(
        backgroundColor: prefix0.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.0 * prefs.getDouble('height')),
          child: AppBar(
            backgroundColor: secondaryColor,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0 * prefs.getDouble('height')),
              child: AnimatedTopBar(
                  barStyle: BarStyle(
                      fontSize: 20.0 * prefs.getDouble('height'),
                      fontWeight: FontWeight.w400,
                      iconSize: 30.0 * prefs.getDouble('height')),
                  barItems: widget.barItems,
                  animationDuration: const Duration(milliseconds: 200),
                  trainerRequestedClient: widget.trainerRequestedClient,
                  newClientMessage: widget.seenFlagTrainers,
                  newFriendMessage: widget.seenFlagFriends,
                  seenFlagFriends: widget.newFriend,
                  seenFlagClients: widget.newTrainer,
                  selectedBarIndex: widget.selectedBarIndex,
                  onBarTap: (index) {
                    widget.parent.setState(() {
                      widget.parent.widget.selectedBarIndex = index;
                      setState(() {
                        widget.selectedBarIndex = index;
                        selectedBarIndex1 = index;
                        widget.controller.animateTo(widget.selectedBarIndex);
                      });
                    });
                  }),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: widget.controller,
          children: <Widget>[
            Requests(
              clientUser: widget.imClient,
                      parent: widget.parent.widget.parent, index: widget.selectedBarIndex
            ),
            Friends(
              clientUser: widget.imClient,
              newFriend: widget.newFriend,
              parent: widget.parent.widget.parent, index: widget.selectedBarIndex
            ),
            Trainers(
                newTrainer: widget.newTrainer, clientUser: widget.imClient, parent:widget.parent.widget.parent, index:widget.selectedBarIndex),
          ],
        ));
  }
}

class AnimatedTopBar extends StatefulWidget {
  int selectedBarIndex;
  final bool trainerRequestedClient;
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  final bool seenFlagFriends;
  final bool seenFlagClients;
  final bool newFriendMessage;
  final bool newClientMessage;

  AnimatedTopBar(
      {this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTap,
      this.barStyle,
      this.seenFlagFriends,
      this.seenFlagClients,
      this.selectedBarIndex,
      this.newFriendMessage,
      this.newClientMessage,
      this.trainerRequestedClient});
  @override
  _AnimatedTopBarState createState() => _AnimatedTopBarState();
}

class _AnimatedTopBarState extends State<AnimatedTopBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Material(
        color: secondaryColor,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 18.0 * prefs.getDouble('height'),
              top: 0.0 * prefs.getDouble('height'),
              left: 16.0 * prefs.getDouble('width'),
              right: 16.0 * prefs.getDouble('width')),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: _buildBarItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      if (i == 0) {
        BarItem item = widget.barItems[i];
        bool isSelected = widget.selectedBarIndex == i;
        _barItems.add(InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              widget.selectedBarIndex = i;
              widget.onBarTap(widget.selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0 * prefs.getDouble('width'),
                vertical: 8.0 * prefs.getDouble('height')),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
                color: isSelected ? mainColor : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Row(
              children: <Widget>[
                widget.trainerRequestedClient == true
                    ? Stack(
                        children: <Widget>[
                          Icon(
                            item.iconData,
                            color: isSelected
                                ? item.color
                                : Color.fromARGB(150, 255, 255, 255),
                            size: widget.barStyle.iconSize,
                          ),
                          Positioned(
                            left: 14.0 * prefs.getDouble('width'),
                            child: Icon(
                              Icons.brightness_1,
                              color: isSelected == false
                                  ? mainColor
                                  : Colors.transparent,
                              size: 11.0 * prefs.getDouble('height'),
                            ),
                          )
                        ],
                      )
                    : Icon(
                        item.iconData,
                        color: isSelected
                            ? item.color
                            : Color.fromARGB(150, 255, 255, 255),
                        size: widget.barStyle.iconSize,
                      ),
                SizedBox(
                  width: 10.0,
                ),
                AnimatedSize(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  vsync: this,
                  child: Text(
                    isSelected ? item.text : "",
                    style: TextStyle(
                        color: item.color,
                        fontWeight: widget.barStyle.fontWeight,
                        fontSize: widget.barStyle.fontSize),
                  ),
                )
              ],
            ),
          ),
        ));
      } else {
        if (i == 1) {
          BarItem item = widget.barItems[i];
          bool isSelected = widget.selectedBarIndex == i;
          _barItems.add(InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                widget.selectedBarIndex = i;
                widget.onBarTap(widget.selectedBarIndex);
              });
            },
            child: AnimatedContainer(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * prefs.getDouble('width'),
                  vertical: 8.0 * prefs.getDouble('height')),
              duration: widget.animationDuration,
              decoration: BoxDecoration(
                  color: isSelected ? mainColor : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: <Widget>[
                  (widget.seenFlagFriends == true || widget.newFriendMessage)
                      ? Stack(
                          children: <Widget>[
                            Icon(
                              item.iconData,
                              color: isSelected
                                  ? item.color
                                  : Color.fromARGB(150, 255, 255, 255),
                              size: widget.barStyle.iconSize,
                            ),
                            Positioned(
                              left: 14.0 * prefs.getDouble('width'),
                              child: Icon(
                                Icons.brightness_1,
                                color: isSelected == false
                                    ? mainColor
                                    : Colors.transparent,
                                size: 11.0 * prefs.getDouble('height'),
                              ),
                            )
                          ],
                        )
                      : Icon(
                          item.iconData,
                          color: isSelected
                              ? item.color
                              : Color.fromARGB(150, 255, 255, 255),
                          size: widget.barStyle.iconSize,
                        ),
                  SizedBox(
                    width: 10.0,
                  ),
                  AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    vsync: this,
                    child: Text(
                      isSelected ? item.text : "",
                      style: TextStyle(
                          color: item.color,
                          fontWeight: widget.barStyle.fontWeight,
                          fontSize: widget.barStyle.fontSize),
                    ),
                  )
                ],
              ),
            ),
          ));
        } else {
          BarItem item = widget.barItems[i];
          bool isSelected = widget.selectedBarIndex == i;
          _barItems.add(InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                widget.selectedBarIndex = i;
                widget.onBarTap(widget.selectedBarIndex);
              });
            },
            child: AnimatedContainer(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0 * prefs.getDouble('width'),
                  vertical: 8.0 * prefs.getDouble('height')),
              duration: widget.animationDuration,
              decoration: BoxDecoration(
                  color: isSelected ? mainColor : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: <Widget>[
                  (widget.seenFlagClients == true ||
                          widget.newClientMessage == true)
                      ? Stack(
                          children: <Widget>[
                            Icon(
                              item.iconData,
                              color: isSelected
                                  ? item.color
                                  : Color.fromARGB(150, 255, 255, 255),
                              size: widget.barStyle.iconSize,
                            ),
                            Positioned(
                              left: 14.0 * prefs.getDouble('width'),
                              child: Icon(
                                Icons.brightness_1,
                                color: isSelected == false
                                    ? mainColor
                                    : Colors.transparent,
                                size: 11.0 * prefs.getDouble('height'),
                              ),
                            )
                          ],
                        )
                      : Icon(
                          item.iconData,
                          color: isSelected
                              ? item.color
                              : Color.fromARGB(150, 255, 255, 255),
                          size: widget.barStyle.iconSize,
                        ),
                  SizedBox(
                    width: 10.0,
                  ),
                  AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    vsync: this,
                    child: Text(
                      isSelected ? item.text : "",
                      style: TextStyle(
                          color: item.color,
                          fontWeight: widget.barStyle.fontWeight,
                          fontSize: widget.barStyle.fontSize),
                    ),
                  )
                ],
              ),
            ),
          ));
        }
      }
    }
    return _barItems;
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fontSize = 18.0,
      this.iconSize = 32,
      this.fontWeight = FontWeight.w700});
}

class BarItem {
  String text;
  IconData iconData;
  Color color;
  BarItem({this.text, this.iconData, this.color});
}
