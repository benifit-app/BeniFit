import 'package:flutter/material.dart';
import 'package:fitapp/feed/image_post.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:fitapp/main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitapp/feed/floating_action_bar.dart';
import 'package:fitapp/pages/upload_page.dart';
import 'package:fitapp/feed/upload_text.dart';


class ptExerciseCard extends StatefulWidget {
  @override
  _ptExerciseCardState createState() => _ptExerciseCardState();
}

class _ptExerciseCardState extends State<ptExerciseCard> {
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
                    new Container(  //container for building the header
                        padding: const EdgeInsets.only(left: 5.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          'Child inside Container',
                        )),
                    body: new Container(
                      padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                      alignment: Alignment.centerLeft,
                      child: new Text('Text inside child inside new container inside body test for wrap'),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}