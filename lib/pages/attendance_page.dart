import 'package:flutter/material.dart';
import 'package:fitapp/main.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitapp/pages/attendance_display.dart';

class AttendancePage extends StatefulWidget {
  final String attendanceValue;
  const AttendancePage({this.attendanceValue});
  _AttendancePage createState() => new _AttendancePage(this.attendanceValue);
}

class _AttendancePage extends State<AttendancePage> {
  _AttendancePage(this.aValue);
  final String aValue;

  String value;
  //StreamSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();
    value = aValue;
  }

    _incrementCounter() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = (prefs.getInt('_AttendanceValue') ?? 0) + 1;
      value = "$counter";
      print('Pressed $counter times.');
      await prefs.setInt('counter', counter);
    }

  _showCounter() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = (prefs.getInt('_AttendanceValue'));
      value = "$counter";
      print('Pressed $counter times.');
      await prefs.setInt('counter', counter);
      return value;
  }

    @override
    Widget build(BuildContext context)
    {

      //Increment Button
      Widget buildHereButton(IconData icon, String buttonTitle) {
        final Color tintColor = Colors.blue;
        return new Column(
          children: <Widget>[
            new IconButton(
              icon: new Icon(icon, color: tintColor,),
            iconSize: 70.0,
            onPressed: ()  {
              _incrementCounter();
              Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => showAttendancePage(attendanceValue: value),
              )
              );
            },
            ),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(buttonTitle,
                style: new TextStyle(
                  fontSize: 30.0, fontWeight: FontWeight.w600),),
            )
          ],
        );
      };

      //Attendance page navigation button
      Widget buildNextButton(IconData icon, String buttonTitle) {
        final Color tintColor = Colors.blue;
        return new Column(
          children: <Widget>[
            new IconButton(
              icon: new Icon(icon, color: tintColor,),
              iconSize: 70.0,
              onPressed: ()  {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => showAttendancePage(attendanceValue: value),
                )
                );
              },
            ),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(buttonTitle, style: new TextStyle(
                  fontSize: 30.0, fontWeight: FontWeight.w600),),
            )
          ],
        );
      };

      //function calls
      Widget twoButtonSection = new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildHereButton(Icons.assignment_ind, "I am here!"),
            buildNextButton(Icons.accessibility_new, "Just look at\n who is here\n for now"),
          ],
        ),
      );
      return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.greenAccent,
          title: new Text("EFFIT - I'm Here"),
        ),
        body: new ListView(
          children: <Widget>[
            twoButtonSection
          ],
        )
      );
    }
}