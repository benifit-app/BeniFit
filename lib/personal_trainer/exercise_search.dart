import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:fitapp/main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//import for the custom firestore query dart file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/personal_trainer/customCard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/personal_trainer/expandCard.dart';

//video for search bar:  https://www.youtube.com/watch?v=FPcl1tu0gDs


class exerciseSearchPage extends StatefulWidget {
  _exerciseSearchPage createState() => new _exerciseSearchPage();
}

class _exerciseSearchPage extends State<exerciseSearchPage> {
  Future<QuerySnapshot> queryResults;

  buildSearchField() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Form(
        child: new TextFormField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(labelText: 'Search for an exercise'),
          onFieldSubmitted: submit,
        ),
      ),
      leading: BackButton(color: Colors.black,),
      //leading: FlatButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
    );
  }

  buildSearchFieldIOS(){
    return new CupertinoNavigationBar(
      leading: BackButton(color: Colors.black,),
      middle: new CupertinoTextField(
        keyboardType: TextInputType.text,
        clearButtonMode: OverlayVisibilityMode.editing,
        placeholder: "Search for an exercise...",
        onSubmitted: submit,
      ),
    );

  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<expandCard> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      var entry = new expandCard(doc.data['Exercise_Name'],
                               doc.data['Muscle_Group'],
                               doc.data['Difficulty'],
                               doc.data['Spotter_Recommended'],
                               doc.data['Exercise_Type'],
                               doc.data['Mechanics'],
                               doc.data['Equipment_Needed'],
                               doc.data['Description']);
      userSearchItems.add(entry);

      //textList.add(new Text("Added to Doc"));

      //User user = new User.fromDocument(doc);
      //UserSearchItem searchItem = new UserSearchItem(user);
      //userSearchItems.add(searchItem);
    });

    return new ListView(
      children: userSearchItems,
    );
  }

  ListView buildSearchResultsALT(List<DocumentSnapshot> docs) {
    List<expandableCard> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      var entry = new expandableCard(doc.data['Exercise_Name'],
          doc.data['Muscle_Group'],
          doc.data['Difficulty'],
          doc.data['Spotter_Recommended'],
          doc.data['Exercise_Type'],
          doc.data['Mechanics'],
          doc.data['Equipment_Needed'],
          doc.data['Description']);

      userSearchItems.add(entry);

      //textList.add(new Text("Added to Doc"));

      //User user = new User.fromDocument(doc);
      //UserSearchItem searchItem = new UserSearchItem(user);
      //userSearchItems.add(searchItem);
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
    /*Future<QuerySnapshot> searchFuture;
    var query = Firestore.instance.collection('NewExerciseDB');
    var searchbuilder;
    
    for(var i = 0; i < searchValue.length; i++){
      searchbuilder = searchbuilder + searchValue[i];
      query = query.where('Exercise_Name', isGreaterThanOrEqualTo: searchbuilder);
    }

    searchFuture = query.getDocuments();*/
    var fullLength = searchValue.length;

    Future<QuerySnapshot> searchFuture = Firestore.instance
        .collection("NewExerciseDB")
        .where('Exercise_Name',  isGreaterThanOrEqualTo: searchValue[0])
        //.where('Exercise_Name', isLessThanOrEqualTo: searchValue[fullLength-1])
        //.where('Muscle_Group', isEqualTo: searchValue)
        .getDocuments();

    setState(() {
      queryResults = searchFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          }),
    );
  }
}

//class UserSearchItem extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    TextStyle boldStyle = new TextStyle(
//      color: Colors.black,
//      fontWeight: FontWeight.bold,
//    );
//
//    /*return new GestureDetector(
//        child: new ListTile(
//          leading: new CircleAvatar(
//            backgroundImage: new NetworkImage(user.photoUrl),
//            backgroundColor: Colors.grey,
//          ),
//          title: new Text(user.username, style: boldStyle),
//          subtitle: new Text(user.displayName),
//        ),
//        onTap: () {
//          openProfile(context, user.id);
//        });*/
//  }
//}
