import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:fitapp/main.dart';
import 'package:fitapp/uploader/location.dart';
import 'package:geocoder/geocoder.dart';

class TextUpload extends StatefulWidget {
  _TextUpload createState() => new _TextUpload();
}

class _TextUpload extends State<TextUpload> {
  //Strings required to save address
  Address address;

  Map<String, double> currentLocation = new Map();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();

  bool uploading = false;
  bool promted = false;

  @override
  initState() {
    if (promted == false && pageController.page == 2) {
      setState(() {
        promted = true;
      });
    }
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState(); //method to call location
    super.initState();
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await getUserLocation();
    setState(() {
      address = first;
    });
  }

  Widget build(BuildContext context) {

        return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          backgroundColor: Colors.grey,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: cleartext),
          title: new Center(
            child: const Text(
              'EFFit',
              style: const TextStyle(
                  fontFamily: "Bangers", color: Colors.white, fontSize: 35.0
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                onPressed: posttext,
                child: new Text(
                  "Post",
                  style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ))
          ],
        ),
        body: new ListView(
          children: <Widget>[
            new PostForm(
              descriptionController: descriptionController,
              locationController: locationController,
              loading: uploading,
            ),
            new Divider(), //scroll view where we will show location to users
            (address == null)
                ? Container()
                : new SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(right: 5.0, left: 5.0),
              child: Row(
                children: <Widget>[
                  buildLocationButton(address.featureName),
                  buildLocationButton(address.subLocality),
                  buildLocationButton(address.locality),
                  buildLocationButton(address.subAdminArea),
                  buildLocationButton(address.adminArea),
                  buildLocationButton(address.countryName),
                ],
              ),
            ),
            (address == null) ? Container() : Divider(),
          ],
        ));
  }

  //method to build buttons with location.
  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: new Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: new BoxDecoration(
              color: Colors.grey[200],
              borderRadius: new BorderRadius.circular(5.0),
            ),
            child: new Center(
              child: new Text(
                locationName,
                style: new TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void cleartext() {
    new Future.delayed(Duration(seconds: 0),
            () {Navigator.pop(context);
        });
  }

  void posttext() {
    setState(() {
      uploading = true;
    });
      postToFireStore(
          mediaUrl: descriptionController.text,
          description: "Read It, Like It, Do It",
          location: locationController.text);
      setState(() {
        uploading = false;
      });
    new Future.delayed(Duration(seconds: 0),
            () {Navigator.pop(context);
        });
  }
}

class PostForm extends StatelessWidget {
  final textFile;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final bool loading;
  PostForm(
      {this.textFile,
        this.descriptionController,
        this.loading,
        this.locationController});

  Widget build(BuildContext context) {

    return new Column(
      children: <Widget>[
        loading
            ? new LinearProgressIndicator()
            : new Padding(padding: new EdgeInsets.only(top: 10.0)),
        new Divider(),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircleAvatar(
              radius: 50.0,
              backgroundImage: new NetworkImage(currentUserModel.photoUrl),
            ),
          ],
        ),
        new Divider(
          height: 30.0,
          color: Colors.grey,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: new BoxDecoration(
                  ),
                  width: 350.0,
                  height: 250.0,
                  child: new TextField(
                    scrollPadding: EdgeInsets.all(10.0),
                    maxLines: 10,
                    controller: descriptionController,
                    decoration: new InputDecoration(
                        hintText: 'Waddup Doe?',
                        border: InputBorder.none),
                  ),
                ),
              ],
            )
          ],
        ),
        new Divider(
          color: Colors.grey,
        ),
        new ListTile(
          leading: new Icon(Icons.pin_drop),
          title: new Container(
            width: 250.0,
            child: new TextField(
              controller: locationController,
              decoration: new InputDecoration(
                  hintText: "Where you at doe?",
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    );
  }
}

void postToFireStore(
    {String mediaUrl, String location, String description}) async {
  var reference = Firestore.instance.collection('insta_posts');

  reference.add({
    "username": currentUserModel.username,
    "location": location,
    "likes": {},
    "mediaUrl": mediaUrl,
    "description": description,
    "ownerId": googleSignIn.currentUser.id,
    "timestamp": new DateTime.now().toString(),
  }).then((DocumentReference doc) {
    String docId = doc.documentID;
    reference.document(docId).updateData({"postId": docId});
  });
}
