import 'package:fitapp/pages/profile_page.dart';
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/main.dart';
import 'package:fitapp/feed/image_post.dart';
import 'dart:async';
import 'package:fitapp/activityFeedPage/edit_profile_page.dart';


class Feed extends StatefulWidget {
  const Feed({this.userId});
  final String userId;
  _Feed createState() => new _Feed(this.userId);
}

class _Feed extends State<Feed> {

  final String profileId;
  String currentUserId = googleSignIn.currentUser.id;
  String view = "feed"; // default view
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  _Feed(this.profileId);

  TextEditingController myController = new TextEditingController();

  List<ImagePost> feedData;

  @override
  void initState() {
    super.initState();
    this._loadFeed();
  }

  Container buildUserPosts() {
    Future<List<ImagePost>> getPosts() async {
      List<ImagePost> posts = [];
      var snap = await Firestore.instance
          .collection('insta_posts')
          .where('ownerId', isEqualTo: profileId)
          .orderBy("timestamp")
          .getDocuments();
      for (var doc in snap.documents) {
        posts.add(new ImagePost.fromDocument(doc));
      }
      setState(() {
        postCount = snap.documents.length;
      });

      return posts.reversed.toList();
    }

    return new Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.teal[100],
              Colors.purple[200],
              Colors.teal[500],
              Colors.teal[600],
            ],
          ),
        ),
        child: new FutureBuilder<List<ImagePost>>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return new Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 0.0),
                  child: new CircularProgressIndicator());
            else if (view == "grid") {
              // build the grid
              return new GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
//                    padding: const EdgeInsets.all(0.5),
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data.map((ImagePost imagePost) {
                    return new GridTile(child: new ImageTile(imagePost));
                  }).toList());
            } else if (view == "feed") {
              return new Column(
                  children: snapshot.data.map((ImagePost imagePost) {
                    return imagePost;
                  }).toList());
            }
          },
        ));
  }

  buildFeed() {
    if (feedData != null) {
      return new Container(
        padding: EdgeInsets.only(top: 5.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundImage: NetworkImage(currentUserModel.photoUrl),
                  radius: 30.0,
                ),
                title: new TextField(
                  controller: myController,
                  maxLines: 2,
                  scrollPadding: EdgeInsets.all(5.0),
                  decoration: InputDecoration(
                      hintText: "Waddup?"
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.send), 
                    onPressed: (){Future.delayed(Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TextUpload(title: myController.text)),
                      );
                    });
                    },
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.teal
                ),
                boxShadow: [new BoxShadow(
                  color: Colors.black,
                  blurRadius: 20.0,
                ),],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              height: 80.0,
              padding: EdgeInsets.only(top: 5.0),
            ),
            new Flexible(
                child: new ListView(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Column(
                        children: <Widget>[
                        ],
                      ),
                    ),
                    buildUserPosts(),
                  ],
                  padding: EdgeInsets.all(10.0),
                  scrollDirection: Axis.vertical,
                )
            )
          ],
        )
      );
    } else {
      return new Container(
          alignment: FractionalOffset.center,
          child: new CircularProgressIndicator()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
        title: const Text('EFFit',
            style: const TextStyle(
                fontFamily: "Bangers", color: Colors.white, fontSize: 35.0
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: new RefreshIndicator(
        onRefresh: _refresh,
        child: new Container(
            decoration: BoxDecoration(
            color: Colors.white
          ),
          child: buildFeed()
        ),
      ),
//      floatingActionButton: FancyFab(),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Future<Null> _refresh() async {
    await _getFeed();
    setState(() {
    });
    return;
  }

  _loadFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("feed");
    print(json);

    if (json != null) {
      List<Map<String, dynamic>> data =
          jsonDecode(json).cast<Map<String, dynamic>>();
      List<ImagePost> listOfPosts = _generateFeed(data);
      setState(() {
        feedData = listOfPosts;
      });
    } else {
      _getFeed();
    }
  }

  void reFeed(BuildContext context, String userId) {
    Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Feed(userId: userId);
    }));
  }

  _getFeed() async {
    List<ImagePost> posts = [];
    var snap = await Firestore.instance
        .collection('insta_posts')
        .where('ownerId', isEqualTo: profileId)
        .orderBy("timestamp")
        .getDocuments();
    for (var doc in snap.documents) {
      posts.add(new ImagePost.fromDocument(doc));
    }
    setState(() {
      postCount = snap.documents.length;
    });

    return posts.reversed.toList();
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      listOfPosts.add(new ImagePost.fromJSON(postData));
    }

    return listOfPosts;
  }
}
