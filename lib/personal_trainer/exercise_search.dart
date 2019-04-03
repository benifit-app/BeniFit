import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:fitapp/main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitapp/feed/floating_action_bar.dart';
import 'package:fitapp/pages/upload_page.dart';
import 'package:fitapp/feed/upload_text.dart';

//import for the custom firestore query dart file
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/personal_trainer/firestore_query_functions.dart';
import 'package:fitapp/personal_trainer/customCard.dart';
import 'package:expandable/expandable.dart';

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
    );
  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<testCard> userSearchItems = [];
    List<Text> textList = [];

    docs.forEach((DocumentSnapshot doc) {
      var entry = new testCard(doc.data['Exercise_Name'], doc.data['Muscle_Group'], doc.data['Difficulty'], doc.data['Spotter_Recommended'], doc.data['Exercise_Type'], doc.data['Mechanics'], doc.data['Equipment_Needed'], doc.data['Description']);
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

  void submit(String searchValue) async {
    Future<QuerySnapshot> searchFuture = Firestore.instance
        .collection("NewExerciseDB")
        .where('Muscle_Group', isEqualTo: searchValue)
        .getDocuments();

    setState(() {
      queryResults = searchFuture;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildSearchField(),
      body: queryResults == null
          ? new Text("Results are null")
          : new FutureBuilder<QuerySnapshot>(
          future: queryResults,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              new Text("Snapshot has data");
              return buildSearchResults(snapshot.data.documents);
            } else {
              return new Container(
                  alignment: FractionalOffset.center,
                  child: new CircularProgressIndicator());
            }
          }),
    );
  }
}

class UserSearchItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    /*return new GestureDetector(
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundImage: new NetworkImage(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: new Text(user.username, style: boldStyle),
          subtitle: new Text(user.displayName),
        ),
        onTap: () {
          openProfile(context, user.id);
        });*/
  }
}
