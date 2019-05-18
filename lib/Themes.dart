import 'package:fitapp/social_network/main/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'settings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitapp/social_network/pages/profile_page.dart';

final ThemeData defaultTheme = new ThemeData(
      primaryColor: Colors.grey,
      accentColor: Colors.teal,
      buttonColor: Colors.white,

);

final ThemeData redTheme = new ThemeData(
  primaryColor: Colors.red,
  accentColor: Colors.grey,
  buttonColor: Colors.white,

);

num getTheme() {
  if(currentUserModel != null) {
    return currentUserModel.theme;
  }
  else {return null;
  }
}

ThemeData themeSwitch() {
  if(getTheme() == 1){
    return defaultTheme;
  }
   if(getTheme() == 2){
  return redTheme;
  }
   if(getTheme() == null){
     return defaultTheme;
   }
}

var currentTheme = themeSwitch();


class Themes extends StatefulWidget {
  @override
  _ThemesState createState() => new _ThemesState();
}

class _ThemesState extends State<Themes> {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Theme Selector",
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override
  BodyState createState() => new BodyState();
}

class BodyState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return settingsListView(context);
  }
}

Widget settingsListView(BuildContext context) {
  return ListView(
      children: <Widget>[
        ListTile(
            title: Text('Default Theme'),
            onTap: () => Firestore.instance
                            .collection('insta_users')
                            .document(currentUserModel.id)
                            .updateData({
                              "theme": 1,
                            }
                            )

        ),
        ListTile(
          title: Text('Red Theme'),
          onTap: () => Firestore.instance
              .collection('insta_users')
              .document(currentUserModel.id)
              .updateData({
                "theme": 2,
          }
          )
        ),

      ]
  );
}