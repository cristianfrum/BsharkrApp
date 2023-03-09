import 'package:Bsharkr/Client/Classes/AvailablePrivateClasses.dart';
import 'package:Bsharkr/Client/Classes/enrolledClasses.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/models/clientUser.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class AllClasses extends StatefulWidget {
  final bool deletedClient;
  final bool newPrivateClass;
  final MyAppState parent;
  AllClasses(
      {this.imClient, this.parent, this.newPrivateClass, this.deletedClient});
  final ClientUser imClient;
  @override
  _AllClassesState createState() => _AllClassesState();
}

TabController controller;
int initialIndex = 0;

class _AllClassesState extends State<AllClasses>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
   

    if (widget.newPrivateClass != null) {
      controller = TabController(vsync: this, length: 2, initialIndex: 1);
    } else {
      if (widget.deletedClient != null) {
        controller = TabController(vsync: this, length: 2, initialIndex: 0);
      } else {
        controller =
            TabController(vsync: this, length: 2, initialIndex: initialIndex);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0 * prefs.getDouble('height')),
        child: AppBar(
          backgroundColor: secondaryColor,
          bottom: TabBar(
              indicatorColor: mainColor,
              controller: controller,
              tabs: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 16 * prefs.getDouble('height')),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Enrolled",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 8 * prefs.getDouble('width')),
                      Icon(
                        Icons.brightness_1,
                        color: widget.imClient.deletedClient == true
                            ? mainColor
                            : Colors.transparent,
                        size: 12.0 * prefs.getDouble('height'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 16 * prefs.getDouble('height')),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.brightness_1,
                        color: widget.imClient.newPrivateClass == true
                            ? mainColor
                            : Colors.transparent,
                        size: 14.0 * prefs.getDouble('height'),
                      ),
                      SizedBox(width: 8 * prefs.getDouble('width')),
                      Text(
                        "Available private classes",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12 * prefs.getDouble('height'),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
      body: TabBarView(controller: controller, children: <Widget>[
        EnrolledClasses(
          parent: widget.parent,
          imClient: widget.imClient,
        ),
        AvailablePrivateClasses(
          parent: widget.parent,
          imClient: widget.imClient,
        )
      ]),
    );
  }
}
