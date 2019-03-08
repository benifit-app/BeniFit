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
          itemCount:  2,
          itemBuilder: (BuildContext context, int i) {
            return Card(
              margin:
              const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
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
                    new Container(
                        padding:
                        const EdgeInsets.only(left: 15.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          'list-$i',
                        )),
                    body: new Container(child: new Text('content-$i'),),),
                ],
              ),
            );
          }),
    );
  }
}