import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';

class routineCard extends StatelessWidget{
  //declare final variables
  final DocumentSnapshot passDoc;

  //class constructor
  routineCard(this.passDoc);

  //function for constructing all of the days and nested exercises
  constructDays(){
    int amountOfDays = passDoc["Days"];
    List<Widget> listOfDays;

    for(int i = 0; i < amountOfDays; i++){
      listOfDays.add(
        Column(
          children: <Widget>[
            //container for establishing what day it is
            Container(
              alignment: Alignment.center,
              child: Text("Day " + i.toString(), softWrap: true,)
            ),

            //construct all exercises for the day
            constructDayExercises(i),
          ]
        )
      );
    }

    return listOfDays;
  }

  //function for generating the elements of the Days
  constructDayExercises(int day){
    String currentDay = "Day " + day.toString();
    Map dayExercises = passDoc[currentDay];
    var listOfExercises = [];
    List<Widget> exerciseElement;

    dayExercises.forEach((k,v) => listOfExercises.add('${v}'));

    for(int i = 0; i < listOfExercises.length; i++){
      String ExerciseName = listOfExercises[i][0];
      String MuscleGroup = listOfExercises[i][1];
      int Sets = listOfExercises[i][2];
      int Reps = listOfExercises[i][3];

      exerciseElement.add(
        Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              //Container for the Exercise Name
              Container(
                //padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                alignment: Alignment.center,
                //color: Colors.indigo[100],
                width: MediaQuery.of(context).size.width * .30,
                child: AutoSizeText(ExerciseName, softWrap: true,),
              ),

              //Container for the amount of Sets
              Container(
                //padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                alignment: Alignment.center,
                //color: Colors.indigo[100],
                width: MediaQuery.of(context).size.width * .30,
                child: AutoSizeText("Sets: " + Sets.toString(), softWrap: true,),
              ),

              //Container for the amount of Reps
              Container(
                //padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                alignment: Alignment.center,
                //color: Colors.indigo[100],
                width: MediaQuery.of(context).size.width * .298,
                child: AutoSizeText("Reps: " + Reps.toString(), softWrap: true,),
              )
            ],
          )
        )
      );
    }

    return exerciseElement;

  }

  //actually building the card
  @override
  Widget build(BuildContext context){
    return Card(
      child: Column(
        children: <Widget>[
          ExpansionTile(
            //TITLE OF EXPANDABLE CARD
            title: Row(
              children: <Widget>[
                //Container for ROUTINE NAME
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .40,
                  child: Container(child: Text(passDoc["Routine Name"], softWrap: true,),),
                ),

                //Container for ROUTINE CREATOR
                Container(
                  alignment: Alignment.center,
                  child: Container(child: Text("By: " + passDoc["username"] ,softWrap: true,),)
                ),
              ],
            ),

            //BODY OF EXPANDABLE CARD
            children: <Widget>[
              //Column for Description and Days
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Description of the exercise
                  Container(
                      alignment: Alignment.center,
                      child: Container(child: Text(passDoc["Routine Description"] ,softWrap: true,),)
                  ),

                  //Number of days for the routine
                  Container(
                      alignment: Alignment.center,
                      child: Container(child: Text("Days: " + passDoc["Days"],softWrap: true,),)
                  ),

                  //exercises in the days
                  Container(
                      alignment: Alignment.center,
                      child: ListView(children: <Widget>[constructDays()],),
                  ),

                ],
              ),
            ],
          )
        ],
      ),
    );
  }

}