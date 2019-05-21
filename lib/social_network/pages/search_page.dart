import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import "package:fitapp/social_network/pages/profile_page.dart"; // needed to import for User Class

class SearchPage extends StatefulWidget {
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  Future<QuerySnapshot> userDocs;

  buildSearchField() {
    return new AppBar(
      backgroundColor: Colors.grey,
      title: new Form(
        child: new TextFormField(
          decoration: new InputDecoration(
              labelText: 'Search for a user...',
              labelStyle: new TextStyle (
                color: Colors.white,
              ),
          ),
          keyboardType: TextInputType.text,
          onFieldSubmitted: submit,
        ),
      ),
    );
  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<UserSearchItem> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      User user = new User.fromDocument(doc);
      UserSearchItem searchItem = new UserSearchItem(user);
      userSearchItems.add(searchItem);
    });

    return new ListView(
      children: userSearchItems,
    );
  }

  void submit(String searchValue) async {


    Future<QuerySnapshot> users = Firestore.instance
        .collection("insta_users")
        .where('displayName', isGreaterThanOrEqualTo: searchValue)
        .getDocuments();

    setState(() {
      userDocs = users;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildSearchField(),
      body: userDocs == null
          ? new Text("")
          : new FutureBuilder<QuerySnapshot>(
              future: userDocs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
  final User user;

  const UserSearchItem(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return new GestureDetector(
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
        });
  }
}
