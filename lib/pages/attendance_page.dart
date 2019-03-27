import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  _AttendancePage createState() => new _AttendancePage();
}

class _AttendancePage extends State<AttendancePage> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    AttendancePage attendancePage = new AttendancePage();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _incrementCounter() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = (prefs.getInt('counter') ?? 0) + 1;
      print('Pressed $counter times.');
      await prefs.setInt('counter', counter);
    }

    @override
    Widget build(BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.greenAccent,
            title: const Text("EFFIT - Let's Walk", textAlign: TextAlign.center),
          ),
          backgroundColor: Colors.blueGrey,
          body: Center(
            child: RaisedButton(
              onPressed: _incrementCounter,
              child: Text('Increment Counter'),
            ),
          ),
        ),
      )
      );
    }
  }