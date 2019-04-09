import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/pages/feed.dart';
import 'package:fitapp/pages/upload_page.dart';
import 'package:fitapp/feed/floating_action_bar.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/pages/profile_page.dart';
import 'package:fitapp/pages/search_page.dart';
import 'package:fitapp/pages/activity_feed.dart';
import 'package:fitapp/main/create_account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

//for accessing functions in other .dart files
import "pages/feed.dart";

final auth = FirebaseAuth.instance;
final googleSignIn = new GoogleSignIn();
final ref = Firestore.instance.collection('insta_users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

User currentUserModel;

Future<void> main() async {
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(new fitapp());
}

Future<Null> _ensureLoggedIn(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) {
    user = await googleSignIn.signInSilently();
  }
  if (user == null) {
    await googleSignIn.signIn().then((_) {
      tryCreateUserRecord(context);
    });
  }

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
  }
}

Future<Null> _setUpNotifications() async {
  if (Platform.isAndroid) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: " + token);

      Firestore.instance
          .collection("insta_users")
          .document(currentUserModel.id)
          .updateData({"androidNotificationToken": token});
    });
  }
}

Future<Null> _silentLogin(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signInSilently().then((_) {
      tryCreateUserRecord(context);
    });
  }

  if (await auth.currentUser() == null && user != null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
  }
}

tryCreateUserRecord(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) {
    return null;
  }
  DocumentSnapshot userRecord = await ref.document(user.id).get();
  if (userRecord.data == null) {
    // no user record exists, time to create

    String userName = await Navigator.push(
      context,
      // We'll create the SelectionScreen in the next step!
      new MaterialPageRoute(
          builder: (context) => new Center(
                child: new Scaffold(
                    appBar: new AppBar(
                      leading: new Container(),
                      title: new Text('Fill out missing data',
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.white,
                    ),
                    body: new ListView(
                      children: <Widget>[
                        new Container(
                          child: new CreateAccount(),
                        ),
                      ],
                    )),
              )),
    );

    if (userName != null || userName.length != 0) {
      ref.document(user.id).setData({
        "id": user.id,
        "username": userName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "followers": {},
        "following": {},
      });
    }
  }

  currentUserModel = new User.fromDocument(userRecord);
}

class fitapp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'fitapp',
      routes: <String, WidgetBuilder>{
        '/home': (_) => new HomePage(), // Home Page
      },
      theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.teal,
          buttonColor: Colors.blueGrey,
          primaryIconTheme: new IconThemeData(color: Colors.black)),
      home: new HomePage(title: 'EFfit'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

PageController pageController;

class _HomePageState extends State<HomePage> {
  int _page = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;
  ScrollController feedScroll = new ScrollController();


  Scaffold buildLoginPage() {
    return new Scaffold(
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.only(top: 240.0),
          child: new Column(
            children: <Widget>[
              new Text(
                'EFFIT',
                style: new TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Bangers",
                    color: Colors.black),
              ),
              new Padding(padding: const EdgeInsets.only(bottom: 100.0)),
              new GestureDetector(
                onTap: login,
                child: new Image.asset(
                  "assets/images/google_signin_button.png",
                  width: 225.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (triedSilentLogin == false) {
      silentLogin(context);
    }

    if (setupNotifications == false) {
      setUpNotifications();
    }

    return googleSignIn.currentUser == null
        ? buildLoginPage()
        : new Scaffold(
            floatingActionButton: new FancyFab(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            body: new PageView(
              children: [
                new Container(
                    color: Colors.white,
                    child: new Feed(scrolly: feedScroll),
                ),
                new Container(
                    color: Colors.white,
                    child: new SearchPage()
                ),
                new Container(
                    color: Colors.white,
                    child: new Uploader(),
                ),
                new Container(
                    color: Colors.white,
                    child: new ActivityFeedPage()
                ),
                new Container(
                    color: Colors.white,
                    child: new ProfilePage(userId: googleSignIn.currentUser.id,)
                ),
              ],
              controller: pageController,
              physics: new NeverScrollableScrollPhysics(),
              onPageChanged: onPageChanged,
            ),
            bottomNavigationBar:
            new CupertinoTabBar(
              activeColor: Colors.orange,
              items: <BottomNavigationBarItem>[
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.home, color: (_page == 0) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.search, color: (_page == 1) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.add_circle, color: (_page == 2) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.star, color: (_page == 3) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.person, color: (_page == 4) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          );
  }

  void login() async {
    await _ensureLoggedIn(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  void setUpNotifications() {
    _setUpNotifications();
    setState(() {
      setupNotifications = true;
    });
  }

  void silentLogin(BuildContext context) async {
    await _silentLogin(context);
    setState(() {});
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
    if(page == 0){
      feedScroll.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut
      );
    }
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
<<<<<<< HEAD


  Scaffold buildLoginPage() {
    return new Scaffold(
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.only(top: 240.0),
          child: new Column(
            children: <Widget>[
              new Text(
                'EFFIT',
                style: new TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Bangers",
                    color: Colors.black),
              ),
              new Padding(padding: const EdgeInsets.only(bottom: 100.0)),
              new GestureDetector(
                onTap: login,
                child: new Image.asset(
                  "assets/images/google_signin_button.png",
                  width: 225.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (triedSilentLogin == false) {
      silentLogin(context);
    }

    if (setupNotifications == false) {
      setUpNotifications();
    }

    return googleSignIn.currentUser == null
        ? buildLoginPage() :
    new MaterialApp(
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
                title: const Text('Effit',
                  style: const TextStyle(
                      fontFamily: "Bangers", color: Colors.white, fontSize: 35.0
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.grey,
                bottom: Platform.isIOS
                  ? CupertinoTabBar(
                      activeColor: Colors.orange,
                      currentIndex: 1,
                      items: [
                        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),),
                        BottomNavigationBarItem(icon: Icon(CupertinoIcons.phone),),
                        BottomNavigationBarItem(icon: Icon(CupertinoIcons.time),),
                      ]
                    )
                  : TabBar(
                    controller: _tabController,
                    tabs: <Tab>[
                      Tab(icon: Icon(Icons.map)),
                      Tab(icon: Icon(Icons.phone_android)),
                      Tab(icon: Icon(Icons.fitness_center)),
                    ],
//                  controller: _tabController,
                    )
             ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget> [
                //Activity locator Tab
                new MapApp(),
                //Effit Tab
                new Scaffold(
                  floatingActionButton: new FancyFab(),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  body: new PageView(
                    children: [
                      new Container(
                        color: Colors.white,
                        child: new Feed(scrolly: feedScroll),
                      ),
                      new Container(
                          color: Colors.white,
                          child: new SearchPage()
                      ),
                      new Container(
                        color: Colors.white,
                        child: new Uploader(),
                      ),
                      new Container(
                          color: Colors.white,
                          child: new ActivityFeedPage()
                      ),
                      new Container(
                          color: Colors.white,
                          child: new ProfilePage(userId: googleSignIn.currentUser.id,)
                      ),
                    ],
                    controller: pageController,
                    physics: new NeverScrollableScrollPhysics(),
                    onPageChanged: onPageChanged,
                  ),
                  bottomNavigationBar:
                  _tabController.index != 1 ?
                  new BottomAppBar() :
                  new CupertinoTabBar(
                    activeColor: Colors.orange,
                    items: <BottomNavigationBarItem>[
                      new BottomNavigationBarItem(
                          icon: new Icon(Icons.home, color: (_page == 0) ? Colors.black : Colors.grey),
                          title: new Container(height: 0.0),
                          backgroundColor: Colors.white),
                      new BottomNavigationBarItem(
                          icon: new Icon(Icons.search, color: (_page == 1) ? Colors.black : Colors.grey),
                          title: new Container(height: 0.0),
                          backgroundColor: Colors.white),
                      new BottomNavigationBarItem(
                          icon: new Icon(Icons.add_circle, color: (_page == 2) ? Colors.black : Colors.grey),
                          title: new Container(height: 0.0),
                          backgroundColor: Colors.white),
                      new BottomNavigationBarItem(
                          icon: new Icon(Icons.star, color: (_page == 3) ? Colors.black : Colors.grey),
                          title: new Container(height: 0.0),
                          backgroundColor: Colors.white),
                      new BottomNavigationBarItem(
                          icon: new Icon(Icons.person, color: (_page == 4) ? Colors.black : Colors.grey),
                          title: new Container(height: 0.0),
                          backgroundColor: Colors.white),
                    ],
                    onTap: navigationTapped,
                    currentIndex: _page,
                  ),
                ),
                //Personal Trainer Tab
                new exerciseSearchPage()
              ],
//              controller: _tabController,
            )
        ),
      ),
    );
  }

=======
>>>>>>> parent of 716e9e1... Merge branch 'master' into Alex-Branch
}
