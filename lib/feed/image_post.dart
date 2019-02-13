import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitapp/main.dart';
import 'dart:async';
import 'package:fitapp/pages/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitapp/feed/comment_screen.dart';

class ImagePost extends StatefulWidget {
  const ImagePost(
      {this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId,
      this.ownerId});

  factory ImagePost.fromDocument(DocumentSnapshot document) {
    return new ImagePost(
      username: document['username'],
      location: document['location'],
      mediaUrl: document['mediaUrl'],
      likes: document['likes'],
      description: document['description'],
      postId: document.documentID,
      ownerId: document['ownerId'],
    );
  }

  factory ImagePost.fromJSON(Map data) {
    return new ImagePost(
      username: data['username'],
      location: data['location'],
      mediaUrl: data['mediaUrl'],
      likes: data['likes'],
      description: data['description'],
      ownerId: data['ownerId'],
      postId: data['postId'],
    );
  }
  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
// issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final likes;
  final String postId;
  final String ownerId;

  _ImagePost createState() => new _ImagePost(
        mediaUrl: this.mediaUrl,
        username: this.username,
        location: this.location,
        description: this.description,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
        ownerId: this.ownerId,
        postId: this.postId,
      );
}

class _ImagePost extends State<ImagePost> {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  Map likes;
  int likeCount;
  final String postId;
  bool liked;
  final String ownerId;

  bool showHeart = false;

  TextStyle boldStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  var reference = Firestore.instance.collection('insta_posts');

  _ImagePost(
      {this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId,
      this.likeCount,
      this.ownerId});

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.purpleAccent;
      icon = Icons.fitness_center;
    } else {
      icon = FontAwesomeIcons.heart;
    }

    return new GestureDetector(
        child: new Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost(postId);
        });
  }

  GestureDetector buildLikeableImage() {
    return new GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          new FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: mediaUrl),
        mediaUrl.toString().startsWith("https://")
        ?  new ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0)),
            child: new CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.fill,
              placeholder: loadingPlaceHolder,
              errorWidget: new Icon(Icons.error),
            ),
          ) :
        new Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.grey[100],
                Colors.grey[400],
                Colors.grey[400],
                Colors.grey[100],
              ],
            ),
          ),
            width: double.infinity,
            height: 150.0,
            padding: EdgeInsets.all(0.0),
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            mediaUrl,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Bangers",
                              color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                )
              ],
            )
          ),
          showHeart
              ? new Positioned(
                  child: new Opacity(
                      opacity: 0.85,
                      child: new Icon(
                        Icons.fitness_center,
                        size: 80.0,
                        color: Colors.white,
                      )),
                )
              : new Container(),
        ],
      ),
    );
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return new Text("owner error");
    }

    return new FutureBuilder(
        future: Firestore.instance
            .collection('insta_users')
            .document(ownerId)
            .get(),
        builder: (context, snapshot) {
          String imageUrl = " ";
          String username = "  ";

          if (snapshot.data != null) {
            imageUrl = snapshot.data.data['photoUrl'];
            username = snapshot.data.data['username'];
          }
          return Container(
              //margin: new EdgeInsets.only(bottom: 5.0),
              decoration: new BoxDecoration(
                gradient:  LinearGradient(
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),

              ),
            child:  new ListTile(
              leading: new CircleAvatar(
                backgroundImage: new CachedNetworkImageProvider(imageUrl),
                backgroundColor: Colors.grey,
              ),
              title: new GestureDetector(
                child: new Text(username, style: boldStyle),
                onTap: () {
                  openProfile(context, ownerId);
                },
              ),
              subtitle: new Text(this.location),
              trailing: const Icon(Icons.more_vert),
            )
          );
        });
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: new Center(child: new CircularProgressIndicator()),
  );

  @override
  Widget build(BuildContext context) {
    liked = (likes[googleSignIn.currentUser.id.toString()] == true);

    return new Container (
      margin: EdgeInsets.only(top: 20.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
      ),
        child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(ownerId: ownerId),
          buildLikeableImage(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
              buildLikeIcon(),
              new Padding(padding: const EdgeInsets.only(right: 20.0)),
              new GestureDetector(
                child: const Icon(
                  FontAwesomeIcons.comment,
                  size: 25.0,
                ),
                onTap: () {
                  goToComments(
                      context: context,
                      postId: postId,
                      ownerId: ownerId,
                      mediaUrl: mediaUrl);
                }),
          ],
        ),
        new Row(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: new Text(
                "$likeCount likes",
                style: boldStyle,
              ),
            )
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: new Text(
                  "$username ",
                  style: boldStyle,
                )
            ),
            new Expanded(child: new Text(description)),
          ],
        )
      ],
    )
    );
  }

  void _likePost(String postId2) {
    var userId = googleSignIn.currentUser.id;
    bool _liked = likes[userId] == true;

    if (_liked) {
      print('removing like');
      reference.document(postId).updateData({
        'likes.$userId': false
        //firestore plugin doesnt support deleting, so it must be nulled / falsed
      });

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        likes[userId] = false;
      });

      removeActivityFeedItem();
    }

    if (!_liked) {
      print('liking');
      reference.document(postId).updateData({'likes.$userId': true});

      addActivityFeedItem();

      setState(() {
        likeCount = likeCount + 1;
        liked = true;
        likes[userId] = true;
        showHeart = true;
      });
      new Timer(const Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  void addActivityFeedItem() {
    Firestore.instance
        .collection("insta_a_feed")
        .document(ownerId)
        .collection("items")
        .document(postId)
        .setData({
      "username": currentUserModel.username,
      "userId": currentUserModel.id,
      "type": "like",
      "userProfileImg": currentUserModel.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": new DateTime.now().toString(),
      "postId": postId,
    });
  }

  void removeActivityFeedItem() {
    Firestore.instance
        .collection("insta_a_feed")
        .document(ownerId)
        .collection("items")
        .document(postId)
        .delete();
  }
}

class ImagePostFromId extends StatelessWidget {
  final String id;

  const ImagePostFromId({this.id});

  getImagePost() async {
    var document =
        await Firestore.instance.collection('insta_posts').document(id).get();
    return new ImagePost.fromDocument(document);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: getImagePost(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: new CircularProgressIndicator());
          return snapshot.data;
        });
  }
}

void goToComments(
    {BuildContext context, String postId, String ownerId, String mediaUrl}) {
  Navigator.of(context)
      .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
    return new CommentScreen(
      postId: postId,
      postOwner: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
