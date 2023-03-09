import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';

class PersonalInfo extends StatefulWidget {
  State createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String gender = "";
  bool flag = false;
  bool marked = false;
  String hinttText1 = "";
  String hinttText2 = "";

  String labelText1 = "Enter First Name";
  String labelText2 = "Enter Last Name";

  @override
  void initState() {
   
    super.initState();
    if (prefs.getString('firstName') != null) {
      hinttText1 = prefs.getString('firstName');
      labelText1 = prefs.getString('firstName');
    }
    if (prefs.getString('lastName') != null) {
      hinttText2 = prefs.getString('lastName');
      labelText2 = prefs.getString('lastName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
              height: 150.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                    image: AssetImage('assets/ezgif.com-gif-maker-user.png'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 60.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
            ),
            Container(
              color: Colors.white,
              height: 60.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
              width: 280.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
              child: TextField(
                         keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
              fontFamily: 'Roboto',
                    fontSize: 15.0 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w700),
                decoration: new InputDecoration(
                  hintText: hinttText1,
                  labelText: labelText1,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(
                        25.0 * prefs.getDouble('height')),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                onChanged: (String str) {
                  hinttText1 = str;
                  prefs.setString('firstName', str);
                },
              ),
            ),
            SizedBox(
              height: 10.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
            ),
            Container(
              color: Colors.white,
              height: 60.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
              width: 280.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
              child: TextField(
                         keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
              fontFamily: 'Roboto',
                    fontSize: 15.0 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w700),
                decoration: new InputDecoration(
                  hintText: hinttText2,
                  labelText: labelText2,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(
                        25.0 * prefs.getDouble('height')),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                onChanged: (String str) {
                  hinttText2 = str;
                  prefs.setString('lastName', str);
                },
              ),
            ),
            SizedBox(
              height: 40.0 *
                  Curves.easeOut
                      .transform(prefs.getDouble('scalePersonalInfo')) *
                  prefs.getDouble('height'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  elevation: 8.0 * prefs.getDouble('height'),
                  onPressed: () async {
                    await prefs.setString('gender', 'male');
                    gender = "male";
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0 * prefs.getDouble('height')),
                    width: 60.0 *
                        Curves.easeOut
                            .transform(prefs.getDouble('scalePersonalInfo')) *
                        prefs.getDouble('height'),
                    height: 60.0 *
                        Curves.easeOut
                            .transform(prefs.getDouble('scalePersonalInfo')) *
                        prefs.getDouble('height'),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/mars.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0 *
                      Curves.easeOut
                          .transform(prefs.getDouble('scalePersonalInfo')),
                ),
                RaisedButton(
                  color: Colors.white,
                  elevation: 8.0 * prefs.getDouble('height'),
                  onPressed: () async {
                    await prefs.setString('gender', 'female');
                    gender = "female";
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0 * prefs.getDouble('height')),
                    width: 60.0 *
                        Curves.easeOut
                            .transform(prefs.getDouble('scalePersonalInfo')) *
                        prefs.getDouble('height'),
                    height: 60.0 *
                        Curves.easeOut
                            .transform(prefs.getDouble('scalePersonalInfo')) *
                        prefs.getDouble('height'),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/female-gender-symbol.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.0 * prefs.getDouble('height'),
            ),
            Text(
              "Gender: " + gender,
              style: TextStyle(
              fontFamily: 'Roboto',
                  fontSize: 19.0 * prefs.getDouble('height'),
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
