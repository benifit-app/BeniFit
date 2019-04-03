import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Get the entire collection of the database
DocumentReference documentReference = Firestore.instance.collection('ExerciseDB').document('Muscle Groups');
var oneExerciseReference = documentReference.collection('Abdominals').document('Ab Crunch Machine');

String getOneExercise(){
  var OneExercise;
  String desc;
  String diff;
  String eqNeed;
  String exType;
  String exName;
  String mech;
  String msGroup;
  String spot;


  oneExerciseReference.get().then((documentSnapshot){
    if (documentSnapshot.exists) {
      // do something with the data
      var snapData = documentSnapshot.data;

      desc = snapData['Description'].toString();
      diff = snapData['Difficulty'].toString();
      eqNeed = snapData['Equipment_Needed'].toString();
      exType = snapData['Exercise_Type'].toString();
      exName = snapData['Exercise_Name'].toString();
      mech = snapData['Mechanics'].toString();
      msGroup = snapData['Muscle_Group'].toString();
      spot = snapData['Spotter_Recommended'].toString();

      OneExercise = [desc, diff, eqNeed, exType, exName, mech, msGroup, spot];
    } else {
      OneExercise = ["there", "was", "an", "error", "null", "notworking", "bad", "no"];
    }
  });

  return OneExercise;
}