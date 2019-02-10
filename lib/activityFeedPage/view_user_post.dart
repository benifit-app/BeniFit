import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/main.dart';
import 'package:fitapp/feed/image_post.dart';
import 'dart:async';
import 'package:fitapp/activityFeedPage/edit_profile_page.dart';



class ViewUserPosts extends StatefulWidget {
  _ViewUserPosts createState() => new _ViewUserPosts();
}

class _ViewUserPosts extends State<ViewUserPosts> {

  String currentUserId = googleSignIn.currentUser.id;

  followSelf() {
    print('following self');

    Firestore.instance.document("insta_users/$currentUserId").updateData({
      'following.$currentUserId': true
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });
  }

  unfollowSelf() {

    Firestore.instance.document("insta_users/$currentUserId").updateData({
      'following.$currentUserId': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });
    print(currentUserId);
  }

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return               new Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text(
                'User posts on Feed',
                style: pressed
                    ? TextStyle(color: Colors.black)
                    : TextStyle(color:Colors.white),
              ),
              onPressed: () {
                setState(() {
                  pressed = !pressed;
                });
                pressed ?
                followSelf() :
                unfollowSelf();
              },
              color: pressed
                  ? Colors.blueGrey
                  : Colors.teal,
            )
          ],
        )
      ],
    );
  }

}