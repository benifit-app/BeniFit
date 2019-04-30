import 'package:fitapp/social_network/main/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/main.dart';



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
    return new Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Text(
                "Shows Posts On Feed"
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new RaisedButton(
              child: pressed ?
              new Text(
                'ON',
                style: TextStyle(color: Colors.white)
              ) : new Text(
                'OFF',
                style: TextStyle(color:Colors.black),
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
                  ? Colors.teal
                  : Colors.black12,
              splashColor: Colors.blueGrey,
            )
          ],
        ),
      ],
    );
  }

}