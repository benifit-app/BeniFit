import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitapp/pages/attendance_page.dart';

class showAttendancePage extends StatefulWidget {
  final String attendanceValue;
  const showAttendancePage({this.attendanceValue});
  _showAttendancePageState createState() => new _showAttendancePageState(this.attendanceValue);
}

class _showAttendancePageState extends State<showAttendancePage> {

  _showAttendancePageState(this.currAttenValue);
  final String currAttenValue;

  String cValue;

  @override
  void initState() {
    super.initState();
    cValue = currAttenValue;
  }

  _decrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('_AttendanceValue') ?? 0) - 1;
    cValue = "$counter";
    print('There is $counter left.');
    await prefs.setInt('counter', counter);
  }

  @override
  Widget build(BuildContext context){

    Widget displayAttendance = new Container(
        padding: const EdgeInsets.all(30.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text("Look there is\n ${this.cValue}",
                      style: new TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))
          ],
        )
    );

    Widget buildDecrementButton(IconData icon, String buttonTitle) {
      final Color tintColor = Colors.blue;
      return new Column(
        children: <Widget>[
          new IconButton(
            icon: new Icon(icon, color: tintColor,),
            iconSize: 70.0,
            onPressed: ()  {
              _decrementCounter();
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

    Widget moreButtonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildDecrementButton(Icons.assignment_late, "I am not here!"),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Current Attendnce"),
      ),
      body: new ListView(
        children: <Widget>[
          displayAttendance,
          moreButtonSection,
          /*child: new Center(
            child: new Text("Look there is:\n ${widget.attendanceValue}"),*/
        ],
      ),
    );
  }
}