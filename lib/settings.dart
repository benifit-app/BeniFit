import 'package:fitapp/social_network/main/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fitapp/main.dart';
import 'package:fitapp/social_network/pages/profile_page.dart';
import 'package:fitapp/Themes.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Settings",
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
        title: Text('Theme Selector'),
        onTap: () => Navigator.push(context,
          MaterialPageRoute(
          builder: (BuildContext context) => Themes(),
          ),
        ),
      ),
    ],
  );
}