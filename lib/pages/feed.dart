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

//for accessing functions in other pages
import 'package:fitapp/test.dart';
import 'package:fitapp/personal_trainer/exercise_card.dart';


class Feed extends StatefulWidget {
  _Feed createState() => new _Feed();
}

class _Feed extends State<Feed> {

  TextEditingController myController = new TextEditingController();

  List<ImagePost> feedData;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._loadFeed();
  }

  buildFeed(){
    if (feedData != null) {
      return new Container(
        padding: EdgeInsets.only(top: 0.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                child: new ListView(
                  padding: EdgeInsets.all(0.0),
                  children: feedData,
                  controller: _scrollController,
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

  //Build for the material app with tabs
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: new Scaffold(
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: new FancyFab(),
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: const Text('Effit',
                style: const TextStyle(
                  fontFamily: "Bangers", color: Colors.white, fontSize: 35.0
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.grey,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.map)),
                  Tab(icon: Platform.isIOS ? Icon(Icons.phone_iphone) : Icon(Icons.phone_android)),
                  Tab(icon: Icon(Icons.fitness_center))
                ]
              )
            ),
            body: TabBarView(
              children: [
                //Activity locator Tab
                Icon(Icons.map),

                //Effit Tab
                new RefreshIndicator(
                  onRefresh: _refresh,
                  child: new Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.blueGrey[100],
                            Colors.blueGrey[200],
                            Colors.blueGrey[500],
                            Colors.blueGrey[600],
                          ],
                        ),
                      ),
                      child: buildFeed()
                  ),
                ),

                //Personal Trainer Tab
                //Icon(Icons.fitness_center)
                new ptExerciseCard(),
              ]
            )
//      floatingActionButton: FancyFab(),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
      ),
    );
  }

  //Default build
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      resizeToAvoidBottomPadding: false,
//        appBar: new AppBar(
//        title: const Text('Effit',
//            style: const TextStyle(
//                fontFamily: "Bangers", color: Colors.white, fontSize: 35.0
//            )
//        ),
//          //centerTitle: true,
//          backgroundColor: Colors.grey,
//        ),
//      floatingActionButton: FancyFab(),
//      body: new RefreshIndicator(
//        onRefresh: _refresh,
//        child: new Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.topRight,
//              end: Alignment.bottomLeft,
//              // Add one stop for each color. Stops should increase from 0 to 1
//              stops: [0.1, 0.5, 0.7, 0.9],
//              colors: [
//                // Colors are easy thanks to Flutter's Colors class.
//                Colors.blueGrey[100],
//                Colors.blueGrey[200],
//                Colors.blueGrey[500],
//                Colors.blueGrey[600],
//              ],
//            ),
//          ),
//          child: buildFeed()
//        ),
//      ),
////      floatingActionButton: FancyFab(),
////      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//    );
//  }


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

  _getFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = googleSignIn.currentUser.id.toString();
    var url =
        'https://us-central1-effit-51aa5.cloudfunctions.net/getFeed?uid=' + userId;
    var httpClient = new HttpClient();

    List<ImagePost> listOfPosts;
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        String json = await response.transform(utf8.decoder).join();
        prefs.setString("feed", json);
        List<Map<String, dynamic>> data =
        jsonDecode(json).cast<Map<String, dynamic>>();
        listOfPosts = _generateFeed(data);
      } else {
        result =
            'Error getting a feed:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result =
          'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);

    setState(() {
      feedData = listOfPosts;
    });
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      listOfPosts.add(new ImagePost.fromJSON(postData));
    }

    return listOfPosts;
  }

  void scrollToTop(){
    _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

}
