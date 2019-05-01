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
  _routineBuilderBuilder createState() => new _routineBuilderBuilder();
}

class _routineBuilderBuilder extends State<routineBuilderBuilder>{
  validDays _selectDays;
  validEquipment _selectEquipment;
  validType _selectType;
  validDifficulty _selectDifficulty;
  validRoutine _selectRoutine;


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

  QuestionOne(){
    return ListView(
      children: <Widget>[

      ],
    );
  }

  //builder for the page
  Widget build(BuildContext context){

  }
}