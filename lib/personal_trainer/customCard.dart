import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class testCard extends StatelessWidget{
  //declare final variables
  final String Exercise_Name;
  final String Muscle_Group;
  final String Difficulty;
  final String Spotter;
  final String Exercise_Type;
  final String Mechanic;
  final String Equipment_Needed;
  final String Description;

  //class constructor
  testCard(this.Exercise_Name, this.Muscle_Group, this.Difficulty, this.Spotter, this.Exercise_Type, this.Mechanic, this.Equipment_Needed, this.Description);

  //actually building the card
  @override
  Widget build(BuildContext context){
    return ExpandablePanel(
      //header: Text("Header" style: Theme.of(context).textTheme.body2,),
      header:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <
              Widget>[ //NOTE to future Alex: put all the text in containers so you can pad it
            Container(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(Exercise_Name),

            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                    alignment: Alignment.center,
                    child: Text(Muscle_Group),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        alignment: Alignment.centerLeft,
                        child: Text(Difficulty),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerRight,
                        child: Text(Spotter),
                      ),
                    ],
                  )
                ]
            ),
          ],
        ),
      expanded:
        Column(
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(Exercise_Type),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                      alignment: Alignment.center,
                      child: Text(Mechanic),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                      alignment: Alignment.centerRight,
                      child: Text(Equipment_Needed),
                    )
                  ]
              ),
              Container(
                  padding: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(Description)
              )
            ]
        ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );
  }
}