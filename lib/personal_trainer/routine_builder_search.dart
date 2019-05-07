import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';

//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/personal_trainer/routine_Card.dart';
import 'package:flutter/cupertino.dart';

class routineSearchPage extends StatefulWidget {
_routineSearchPage createState() => new _routineSearchPage();
}

class _routineSearchPage extends State<routineSearchPage> {
  Future<QuerySnapshot> queryResults;

  buildSearchField() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Form(
        child: new TextFormField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(labelText: 'Search for a routine'),
          onFieldSubmitted: submit,
        ),
      ),
      leading: BackButton(color: Colors.black,),
    );
  }

  buildSearchFieldIOS(){
    return new CupertinoNavigationBar(
      leading: BackButton(color: Colors.black,),
      middle: new CupertinoTextField(
        keyboardType: TextInputType.text,
        clearButtonMode: OverlayVisibilityMode.editing,
        placeholder: "Search for a routine...",
        onSubmitted: submit,
      ),
    );
  }

  ListView buildSearchResultsALT(List<DocumentSnapshot> docs) {
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

  void submit(String searchValue) async {
    Future<QuerySnapshot> searchFuture = Firestore.instance
        .collection("Routines")
    //.where('Exercise_Name',  isGreaterThanOrEqualTo: searchValue[0])
    //.where('Exercise_Name', isLessThanOrEqualTo: searchValue[fullLength-1])
        .where('Routine Name', isEqualTo: searchValue)
        .getDocuments();

    setState(() {
      queryResults = searchFuture;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: Platform.isIOS ? buildSearchFieldIOS() : buildSearchField(),
      body: queryResults == null
          ? new Text("")
          : new FutureBuilder<QuerySnapshot>(
          future: queryResults,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              new Text("Snapshot has data");
              //return buildSearchResults(snapshot.data.documents);
              return buildSearchResultsALT(snapshot.data.documents);
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