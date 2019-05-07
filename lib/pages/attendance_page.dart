import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AttendancePage extends StatefulWidget {
  @override
  AttendancePageState createState(){
    return AttendancePageState();
  }
}

class AttendancePageState extends State<AttendancePage> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  int attendance;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.data['todo']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text('Update todo', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed:  () => deleteData(doc),
                  child: Text('Delete'),
                )
              ],
            )
          ],
        )
      )
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),  //InputDecoration
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );  //TextFormField
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Page'),
      ),  //AppBar
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: createData,
          child: Text('Create', style: TextStyle(color: Colors.black.withOpacity(0.6))),
          color: Colors.green,
        ),
        RaisedButton(
          onPressed:  id != null ? readData : null,
          child: Text('Read', style: TextStyle(color: Colors.black.withOpacity(0.6))),
          color: Colors.blue,
        )
      ],
    ),
          StreamBuilder<QuerySnapshot> (
            stream: db.collection('AttendancePage').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              }
              else {
                return SizedBox();
              }
            }
          )
        ],
      ),  //ListView
    ); //Scaffold
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('AttendancePage').add({'name': '$name', 'todo': randomTodo()});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('AttendancePage').document(id).get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db.collection('AttendancePage').document(doc.documentID).updateData({'todo': 'please'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('AttendancePage').document(doc.documentID).delete();
    setState(() => id = null);
  }

  void addAttendance(DocumentSnapshot doc) async {
    await db.collection('AttendancePage').document("attendanceValue").updateData(["currAttendance": FieldValue.increment(1)]);
  }
}

  void _incrementCounter() async {
    await db.collection('AttendancePage').document((doc.documentID).updateData({))
    int counter = (prefs.getInt('_AttendanceValue') ?? 0) + 1;
    value = "$counter";
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  String randomTodo() {
    final randomNumber = Random().nextInt(4);
    String todo;
    switch (randomNumber) {
      case 1:
        todo = 'Yea. Keep coming each day!';
        break;
      case 2:
        todo = 'Welcome to the club!';
        break;
      case 3:
        todo = 'Invite someone with you next time!';
        break;
      default:
        todo = 'We\'re glad you are here!';
        break;
    }
    return todo;
  }
}

/*
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
}*/