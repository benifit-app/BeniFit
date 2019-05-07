import 'package:fitapp/personal_trainer/ptMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/social_network/pages/feed/direct_text.dart';
import 'package:fitapp/social_network/pages/feed.dart';
import 'package:fitapp/social_network/pages/upload_page.dart';
import 'package:fitapp/social_network/feed/bottom_app_bar.dart';
import 'package:fitapp/social_network/feed/floating_action_button.dart';
import 'package:fitapp/social_network/feed/util_overlay.dart';
import 'package:fitapp/social_network/feed/upload_text.dart';
import 'package:fitapp/social_network/pages/profile_page.dart';
import 'package:fitapp/social_network/pages/search_page.dart';
import 'package:fitapp/social_network/pages/activity_feed.dart';
import 'package:fitapp/social_network/main/create_account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitapp/Activity_Locator_Page/Map_App.dart';

import 'dart:io' show Platform;

//for accessing functions in other .dart files

final auth = FirebaseAuth.instance;
final googleSignIn = new GoogleSignIn();
final ref = Firestore.instance.collection('insta_users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

User currentUserModel;

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
          )
      ),
    );

    if (userName != null || userName.length != 0) {
      ref.document(user.id).setData({
        "id": user.id,
        "username": userName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "age": 5,
        "gender": "",
        "height": 170,
        "weight": 100,
        "bmi": 0,
        "bodyFat": "",
        "prBench": "",
        "prSquat": "",
        "bio": "",
        "followers": {},
        "following": {},
      });
    }
  }

  currentUserModel = new User.fromDocument(userRecord);
}

PageController pageController;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _HomePageState createState() => new _HomePageState(this.title);
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  _HomePageState(this.title);

  final String title;


  int _page = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;
  ScrollController feedScroll = new ScrollController(initialScrollOffset: 0.0);
  TabController _tabController;
  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
    navigationTapped(index);
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
    if(_lastSelected == 'FAB: 0'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TextUpload()),
      );
    }
    else if(_lastSelected == 'FAB: 1'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Uploader()),
      );
    }
    else if (_lastSelected == 'FAB: 2'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    }
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
    if(page == 0 && feedScroll.hasClients){
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
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }


  Scaffold buildLoginPage() {
    return new Scaffold(
      extendBody: true,
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
                bottom: TabBar(
                  controller: _tabController,
                  tabs: <Tab>[
                    Tab(icon: Icon(Icons.map)),
                    Tab(icon: Platform.isIOS ? Icon(Icons.phone_iphone) : Icon(Icons.phone_android)),
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
                  extendBody: true,
                  floatingActionButton:  _tabController.index != 1 ?
                  null : _buildFab(context),
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
                  bottomNavigationBar: _tabController.index != 1 ?
                  new BottomAppBar() :
                  new FABBottomAppBar(
                    color: Colors.grey,
                    selectedColor: Colors.black,
                    notchedShape: CircularNotchedRectangle(),
                    onTabSelected: _selectedTab,
                    items: [
                      FABBottomAppBarItem(iconData: Icons.home),
                      FABBottomAppBarItem(iconData: Icons.search),
                      FABBottomAppBarItem(iconData: Icons.star),
                      FABBottomAppBarItem(iconData: Icons.person),
                    ],
                  ),
                ),
                //Personal Trainer Tab
                new ptMainPage()
              ],
//              controller: _tabController,
            )
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [ Icons.text_fields, Icons.camera_alt, Icons.message];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        heroTag: 0,
        onPressed: () { },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }

}

