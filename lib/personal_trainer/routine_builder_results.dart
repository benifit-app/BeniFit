import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';

//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/personal_trainer/routine_Card.dart';
import 'package:flutter/cupertino.dart';

class routineResultsPage extends StatefulWidget {
  final String parameter;
  final int searchType;

  routineResultsPage({Key key, @required this.parameter, this.searchType}) : super(key: key);

  @override
  _routineResultsPage createState() => new _routineResultsPage();
}

class _routineResultsPage extends State<routineResultsPage> {

  Future<QuerySnapshot> queryResults;

  buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.white,
      leading: BackButton(color: Colors.black,),
      title: Text("My Routines"),
    );
  }

  buildAppBarIOS(){
    return new CupertinoNavigationBar(
      leading: BackButton(color: Colors.black,),
      middle: Text("My Routines"),
    );
  }

  ListView buildResults(List<DocumentSnapshot> docs) {
    List<routineCard> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      var entry = new routineCard(doc);

      userSearchItems.add(entry);
    });

    return new ListView(
      children: userSearchItems.map((w) {
        return Padding(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15,),
          child: w,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: Platform.isIOS ? buildAppBarIOS() : buildAppBar(),
      body: new FutureBuilder<QuerySnapshot>(
          future: queryResults = widget.searchType == 1 ? Firestore.instance.collection("Routines").where('username', isEqualTo: widget.parameter).getDocuments() : Firestore.instance.collection("Routines").where('Routine Name', isEqualTo: widget.parameter).getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              new Text("Snapshot has data");
              //return buildSearchResults(snapshot.data.documents);
              return buildResults(snapshot.data.documents);
            } else {
              return new Container(
                  alignment: FractionalOffset.center,
                  child: Platform.isIOS ? new CupertinoActivityIndicator() : new CircularProgressIndicator());
            }
          }
      ),
    );
  }
}