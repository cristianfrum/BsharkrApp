import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/globals.dart';
import 'package:Bsharkr/Trainer/Main_Menu/MainTrainer.dart';
import 'package:Bsharkr/colors.dart';

class PersonalInfo extends StatefulWidget {
  State createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String gender = "";
  bool marked = false;
  String hinttText1 = "";
  String hinttText2 = "";

  String labelText1 = "Enter First Name";
  String labelText2 = "Enter Last Name";
  bool validateAndSave() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }

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
    prefs.setString('email', "");
    prefs.setString('password1', "");
    prefs.setString('password2', "");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
          child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: 250.0,
                  height: 180.0,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20.0 * prefs.getDouble('height')),
                    image: DecorationImage(
                        image: AssetImage('assets/temporary.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  height: 65,
                  width: 300,
                  child: TextFormField(
                         keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 10,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    decoration: new InputDecoration(
                      fillColor: Color.fromARGB(255, 88, 88, 94),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: mainColor,
                              style: BorderStyle.solid,
                              width: 2)),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Color.fromARGB(255, 152, 152, 157),
                      ),
                      hintStyle: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal),
                      border: InputBorder.none,
                      hintText: prefs.getString('email') != null
                          ? prefs.getString('email')
                          : 'Email',
                    ),
                    onSaved: (String str) {
                      hinttText1 = str;
                      prefs.setString('email', str);
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 65,
                  width: 300,
                  child: TextFormField(
                         keyboardAppearance: Brightness.dark,
                    obscureText: true,
                    maxLength: 10,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    decoration: new InputDecoration(
                      fillColor: Color.fromARGB(255, 88, 88, 94),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: mainColor,
                              style: BorderStyle.solid,
                              width: 2)),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Color.fromARGB(255, 152, 152, 157),
                      ),
                      hintStyle: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal),
                      border: InputBorder.none,
                      hintText: prefs.getString('password1') != null
                          ? prefs.getString('password1')
                          : 'Parola',
                    ),
                    onSaved: (String str) {
                      hinttText1 = str;
                      prefs.setString('password1', str);
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 65,
                  width: 300,
                  child: TextField(
                         keyboardAppearance: Brightness.dark,
                    obscureText: true,
                    maxLength: 10,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    decoration: new InputDecoration(
                      fillColor: Color.fromARGB(255, 88, 88, 94),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: mainColor,
                              style: BorderStyle.solid,
                              width: 2)),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Color.fromARGB(255, 152, 152, 157),
                      ),
                      hintStyle: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal),
                      border: InputBorder.none,
                      hintText: prefs.getString('password2') != null
                          ? prefs.getString('password2')
                          : 'Parola',
                    ),
                    onChanged: (String str) {
                      hinttText2 = str;
                      prefs.setString('password2', str);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0* prefs.getDouble('height')),
                  child: Container(
                    width: 150.0,
                    height: 50.0,
                    child: Material(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(30.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (validateAndSave()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainTrainer()),
                            );
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
