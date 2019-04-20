import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:auto_size_text/auto_size_text.dart';


class expandableCard extends StatelessWidget{
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
  expandableCard(this.Exercise_Name, this.Muscle_Group, this.Difficulty, this.Spotter, this.Exercise_Type, this.Mechanic, this.Equipment_Needed, this.Description);

  //actually building the card
  @override
  Widget build(BuildContext context){
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ExpansionTile(
              title: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[ //NOTE to future Alex: put all the text in containers so you can pad it
                  Container(
                    //padding: const EdgeInsets.only(left: 0.0, right: 20.0, top: 0.0, bottom: 10.0),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .40,
                    color: Colors.amber,
                    //constraints: ,
                    child: Container(child: Text(Exercise_Name, textAlign: TextAlign.center, softWrap: true,)),
                  ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * .25,
                        color: Colors.brown[100],
                        //child: Text(Muscle_Group, softWrap: true,),
                        child: Container(child: Text(Muscle_Group, textAlign: TextAlign.center, softWrap: true,)),
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * .50,
                            color: Colors.lightBlueAccent,
                            child: AutoSizeText(Difficulty, maxLines: 1,),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                            alignment: Alignment.center,
                            color: Colors.greenAccent,
                            child: Text(Spotter, softWrap: true,),
                          ),
                        ],
                      )
                    ]
                  ),
                ],
              ),
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          //padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                          alignment: Alignment.center,
                          color: Colors.indigo[100],
                          width: MediaQuery.of(context).size.width * .30,
                          child: Text(Exercise_Type, softWrap: true,),
                        ),
                        Container(
                          //padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                          alignment: Alignment.center,
                          color: Colors.tealAccent,
                          width: MediaQuery.of(context).size.width * .30,
                          child: Text(Mechanic, softWrap: true,),
                        ),
                        Container(
                          //padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                          alignment: Alignment.center,
                          color: Colors.lime,
                          width: MediaQuery.of(context).size.width * .298,
                          child: Text(Equipment_Needed, softWrap: true,),
                        )
                      ]
                    ),
                    Container(
                      //padding: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 10),
                      alignment: Alignment.centerLeft,
                      color: Colors.deepPurpleAccent[100],
                      child: Text(Description, softWrap: true,)
                    )
                  ]
                ),
              ]
            )
          ],
        )
    );

    /*return ExpandablePanel(
      //header: Text("Header" style: Theme.of(context).textTheme.body2,),
      header:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[ //NOTE to future Alex: put all the text in containers so you can pad it
            Container(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(Exercise_Name, softWrap: true,),

            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                    alignment: Alignment.center,
                    child: Text(Muscle_Group, softWrap: true,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        alignment: Alignment.centerLeft,
                        child: Text(Difficulty, softWrap: true,),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerRight,
                        child: Text(Spotter, softWrap: true,),
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
                      child: Text(Exercise_Type, softWrap: true,),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                      alignment: Alignment.center,
                      child: Text(Mechanic, softWrap: true,),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                      alignment: Alignment.centerRight,
                      child: Text(Equipment_Needed, softWrap: true,),
                    )
                  ]
              ),
              Container(
                  padding: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(Description, softWrap: true,)
              )
            ]
        ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );*/
  }
}