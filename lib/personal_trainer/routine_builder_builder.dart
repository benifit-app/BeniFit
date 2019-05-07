import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/personal_trainer/menu_Card.dart';
import 'package:fitapp/personal_trainer/exercise_search.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:fitapp/main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum validDays {three, four, five, six}
enum validEquipment {yes, no}
enum validType {endurance, strength, balance, flexibility, aerobic, anerobic}
enum validDifficulty {beginner, intermediate, advanced}
enum validRoutine{pushpull, pushpulllegs, brosplit}

class routineBuilderBuilder extends StatefulWidget{
  final String currentDisplayName;

  routineBuilderBuilder({Key key, @required this.currentDisplayName}) : super(key: key);

  @override
  _routineBuilderBuilder createState() => new _routineBuilderBuilder();
}

class _routineBuilderBuilder extends State<routineBuilderBuilder>{
  validDays _selectDays;
  validEquipment _selectEquipment;
  validType _selectType;
  validDifficulty _selectDifficulty;
  validRoutine _selectRoutine;

  //global variables
  String routineName;
  int totalDays;

  //
  questionRadioTile(passRadioPrompt, passGroupValue){
    return RadioListTile(title: passRadioPrompt, value: -1, groupValue: passGroupValue, onChanged: null);
  }

  buildTopBarAndroid() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: Text("Routine Builder"),
      leading: BackButton(color: Colors.black,),
      //leading: FlatButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
    );
  }

  buildTopBarIOS(){
    return new CupertinoNavigationBar(
      leading: BackButton(color: Colors.black,),
      middle: Text("Routine Builder"),
    );
  }

  Question(){
    return ListView(
      children: <Widget>[

      ],
    );
  }

  buildSearchField() {
    return new TextFormField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(labelText: 'Name Your Routine...'),
          onFieldSubmitted: submit,
        );
  }

  buildSearchFieldIOS(){
    return new CupertinoTextField(
        keyboardType: TextInputType.text,
        clearButtonMode: OverlayVisibilityMode.editing,
        placeholder: "Name your routine...",
        onSubmitted: submit,
      );
  }

  void submit(String passRoutineName) async {
    //Set routine name = whatever was in the text field
    routineName = passRoutineName;
  }

  //builder for the page
  Widget build(BuildContext context){
      return Scaffold(
        appBar: Platform.isIOS ? buildTopBarIOS() : buildTopBarAndroid(),
        body: Column(
          children: <Widget>[
            Container(
                child: Text("How Many Days would you like the Routine to be?")
            ),

            //Questions with the radio buttons
            Question(),

            //Container for the Routine
            Container(
              child: Platform.isIOS ? buildSearchFieldIOS() : buildSearchField(),
            ),

            //Container for the Submit Button
            Container(
              // https://medium.com/flutter-community/flutter-push-pop-push-1bb718b13c31
              child: new GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => new exerciseSearchPage())
                  );
                },
                //child: button,
              ),
            ),
          ],
        )
      );
  }
}