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
    List<Widget> listOfDays = List();

    for(int i = 0; i < amountOfDays; i++){
      listOfDays.add(
        Column(
          children: <Widget>[
            //container for establishing what day it is
            Container(
              alignment: Alignment.center,
              child: Text("Day " + (i+1).toString(), softWrap: true,)
            ),

            //construct all exercises for the day
            constructDayExercises(i+1),
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
    List<Widget> exerciseElement = List();

    dayExercises.forEach((k,v) => listOfExercises.add(v));

    for(int i = 0; i < listOfExercises.length; i++){
      var nestedList = listOfExercises[i];

      //print(nestedList);

      String ExerciseName = nestedList[0];
      String MuscleGroup = nestedList[1];
      var Sets = nestedList[2];
      var Reps = nestedList[3];

      exerciseElement.add(
        Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              //Container for the Exercise Name
              Container(
                padding: const EdgeInsets.only(top: 7.0, bottom: 7.0, right: 5.0),
                alignment: Alignment.center,
                //color: Colors.indigo[100],
                width: 200.0,
                child: AutoSizeText(ExerciseName, softWrap: true, textAlign: TextAlign.center,),
              ),

              //Container for the amount of Sets
              Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                alignment: Alignment.center,
                //color: Colors.indigo[100],
                //width: MediaQuery.of(context).size.width * .30,
                child: AutoSizeText("Sets: " + Sets.toString(), softWrap: true,),
              ),

              //Container for the amount of Reps
              Container(
                //padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                alignment: Alignment.center,
                //color: Colors.indigo[100],
                //width: MediaQuery.of(context).size.width * .298,
                child: AutoSizeText("Reps: " + Reps.toString(), softWrap: true,),
              )
            ],
          )
        )
      );
    }

    return Column(children: exerciseElement);
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
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * .40,
                  child: Container(child: Text(passDoc["Routine Name"], softWrap: true,),),
                ),

                //Container for ROUTINE CREATOR
                Container(
                  alignment: Alignment.centerRight,
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      alignment: Alignment.center,
                      child: Container(child: Text(passDoc["Routine Description"] ,softWrap: true,),)
                  ),

                  //Number of days for the routine
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Container(child: Text("Days: " + passDoc["Days"].toString(),softWrap: true,),)
                  ),

                  //exercises in the days
                  Container(
                      alignment: Alignment.center,
                      child: ListView(children: constructDays(), shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),),
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