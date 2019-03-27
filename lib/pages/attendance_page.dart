import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  _AttendancePage createState() => new _AttendancePage();
}

class _AttendancePage extends State<AttendancePage> {
  String _AttendanceValue = '0';
  //StreamSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    AttendancePage attendancePage = new AttendancePage();
    /*_subscription = attendancePage(_incrementCounter,
        onError: _onError, onDone: _onDone, cancelOnError: true);*/

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  /*void _onDone() {}

  void _onError(error) {
    print("Attendance error: $error");
  }*/

    _incrementCounter() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = (prefs.getInt('_AttendanceValue') ?? 0) + 1;
      _AttendanceValue = "$counter";
      print('Pressed $counter times.');
      await prefs.setInt('counter', counter);
    }

  _decrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('_AttendanceValue') ?? 0) - 1;
    _AttendanceValue = "$counter";
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  _showCounter() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = (prefs.getInt('_AttendanceValue'));
      _AttendanceValue = "$counter";
      print('Pressed $counter times.');
      await prefs.setInt('counter', counter);
  }

    @override
    Widget build(BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.greenAccent,
            title: const Text("EFFIT - Let's Clock In", textAlign: TextAlign.center),
          ),
          backgroundColor: Colors.blueGrey,
          body: new Container(
            child: new Row(

              children: <Widget>[
                new RaisedButton(
                    onPressed: _incrementCounter,
                  child: new Text('Press to show Attendance!',),
                ),

                new RaisedButton(
                    onPressed: _decrementCounter,
                  child: new Text('Press to remove Attendance!',),
                ),

                new RaisedButton(
                  onPressed: _showCounter,
                  child: new Text('Current Attendace is: $_AttendanceValue people', ),
                )
              ]
            ),
          ),
        ),
      );
    }
  }