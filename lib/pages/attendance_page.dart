import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      return _AttendanceValue;
  }

    /*@override
    Widget build(BuildContext context) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.greenAccent,
            title: const Text("EFFIT - I'm Here", textAlign: TextAlign.center),
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
              ]
            ),
          ),
        ),

      );
    }*/

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
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new showAttendancePage(attendanceValue: _AttendanceValue),
              );
              Navigator.of(context).push(route);
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
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new showAttendancePage(attendanceValue: _AttendanceValue),
                );
                Navigator.of(context).push(route);
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

class showAttendancePage extends StatefulWidget {
  final String attendanceValue;

  showAttendancePage({Key key, this.attendanceValue}) : super (key: key);


  @override
  _showAttendancePageState createState() => new _showAttendancePageState();
}

class _showAttendancePageState extends State<showAttendancePage> {
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
                    new Text("Look there is\n ${widget.attendanceValue}",
                      style: new TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))
          ],
        )
    );

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("Current Attendnce"),
      ),
      body: new ListView(
        children: <Widget>[
          displayAttendance
          buildDecrementButton
          /*child: new Center(
            child: new Text("Look there is:\n ${widget.attendanceValue}"),*/
        ],
      ),
    );
  }
}