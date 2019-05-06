import 'package:flutter/material.dart';



class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Settings",
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,

        )
      )
    )
  }

}