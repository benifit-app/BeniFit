import 'package:flutter/material.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:fitapp/main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


//import for the custom firestore query dart file
import 'package:fitapp/personal_trainer/firestore_query_functions.dart';


class ptExerciseCard extends StatefulWidget {
  @override
  _ptExerciseCardState createState() => _ptExerciseCardState();
}

class _ptExerciseCardState extends State<ptExerciseCard> {
  //attrubutes from firestore query
  var testString = getOneExercise();
  
  int _activeMeterIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount:  1,  //amount of cards you want in a class
          itemBuilder: (BuildContext context, int i) {
            return Card(
              margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
              child: new ExpansionPanelList(
                  expansionCallback: (int index, bool status) {
                    setState(() {
                      _activeMeterIndex = _activeMeterIndex == i ? null : i;
                    });
                  },
                  children: [
                    new ExpansionPanel(
                        isExpanded: _activeMeterIndex == i,
                        headerBuilder: (BuildContext context,
                            bool isExpanded) =>
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <
                                  Widget>[ //NOTE to future Alex: put all the text in containers so you can pad it
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 20.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(testString[4]),

                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                                        alignment: Alignment.center,
                                        child: Text('Muscle Group'),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            alignment: Alignment.centerLeft,
                                            child: Text('Difficulty'),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            alignment: Alignment.centerRight,
                                            child: Text('Spotter'),
                                          ),
                                        ],
                                      )
                                    ]
                                ),
                              ],
                            ),
                        body:
                        Column(
                            children: <Widget>[
                              Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text('Exercise Type'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                      alignment: Alignment.center,
                                      child: Text('Mechanic'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                                      alignment: Alignment.centerRight,
                                      child: Text('Equipment Needed'),
                                    )
                                  ]
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Description')
                              )
                            ]
                        )
                    )
                  ] //Children
              ),
            );
          }
      ),
    );
  }
}