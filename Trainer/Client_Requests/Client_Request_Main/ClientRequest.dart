import 'package:Bsharkr/models/trainerUser.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Client_Requests/Business_Requests/Business_Requests.dart';
import 'package:Bsharkr/Trainer/Client_Requests/Friends_Requests/Friends_Requests.dart';
import 'package:Bsharkr/colors.dart';

int selectedBarIndex1 = 0;

class ClientRequestPage extends StatefulWidget {
  int selectedBarIndex;
  final bool friendsNotif;
  final bool businessNotif;
  final TrainerUser actualTrainer;
  ClientRequestPage(
      {this.friendsNotif,
      this.businessNotif,
      this.actualTrainer,
      this.selectedBarIndex});
  @override
  _ClientRequestPageState createState() => new _ClientRequestPageState();
}

class _ClientRequestPageState extends State<ClientRequestPage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(
        vsync: this,
        length: 2,
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
    return new Scaffold(
      backgroundColor: backgroundColor,
      body: AppBarNavigationRequest(
        friendsNotif: widget.friendsNotif,
        businessNotif: widget.businessNotif,
        actualTrainer: widget.actualTrainer,
        selectedBarIndex: widget.selectedBarIndex,
        parent: this,
        controller: controller,
      ),
    );
  }
}

class AppBarNavigationRequest extends StatefulWidget {
  final _ClientRequestPageState parent;
  final TabController controller;
  int selectedBarIndex;
  final bool friendsNotif;
  final bool businessNotif;
  final TrainerUser actualTrainer;
  AppBarNavigationRequest(
      {this.friendsNotif,
      this.businessNotif,
      this.actualTrainer,
      this.selectedBarIndex,
      this.parent,
      this.controller});
  final List<BarItem> barItems = [
    BarItem(
      text: "Clients",
      iconData: Icons.assignment_ind,
      color: Colors.white,
    ),
    BarItem(
      text: "Friends",
      iconData: Icons.person,
      color: Colors.white,
    ),
  ];

  @override
  State createState() => AppNavigationRequestState();
}

class AppNavigationRequestState extends State<AppBarNavigationRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.0 * prefs.getDouble('height')),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: secondaryColor,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0 * prefs.getDouble('height')),
              child: AnimatedTopBarRequest(
                  barStyle: BarStyle(
                      fontSize: 20.0 * prefs.getDouble('height'),
                      fontWeight: FontWeight.w400,
                      iconSize: 30.0 * prefs.getDouble('height')),
                  barItems: widget.barItems,
                  animationDuration: const Duration(milliseconds: 200),
                  friendsNotif: widget.friendsNotif,
                  businessNotif: widget.businessNotif,
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
            BusinessRequests(
              actualTrainer: widget.actualTrainer,
              index:widget.selectedBarIndex
            ),
            FriendsRequests(
              actualTrainer: widget.actualTrainer,
              index:widget.selectedBarIndex
            )
          ],
        ));
  }
}

class AnimatedTopBarRequest extends StatefulWidget {
  final bool friendsNotif;
  final bool businessNotif;
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  int selectedBarIndex;
  AnimatedTopBarRequest(
      {this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTap,
      this.barStyle,
      this.friendsNotif,
      this.businessNotif,
      this.selectedBarIndex});
  @override
  _AnimatedTopBarRequestState createState() => _AnimatedTopBarRequestState();
}

class _AnimatedTopBarRequestState extends State<AnimatedTopBarRequest>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
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
                widget.friendsNotif == true
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
                widget.businessNotif == true
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
