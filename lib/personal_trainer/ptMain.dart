import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/personal_trainer/menu_Card.dart';
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

class ptMainPage extends StatefulWidget{
  _ptMainPage createState() => new _ptMainPage();
}

class _ptMainPage extends State<ptMainPage>{

  buildNavigationBarIOS(){
    return new CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: buildListView()
    );
  }

  buildNavigationBarAndroid(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildListView(),
    );
  }

  buildListView(){
    return ListView(
      children: <Widget>[
        new menuCard("Routine Builder", 250, "assets/images/checklist.jpg", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
        new menuCard("Exercise Search", 250, "assets/images/search.png", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
      ],
    );
  }

  //builder for the page
  Widget build(BuildContext context){
    return Platform.isIOS ? buildNavigationBarIOS() : buildNavigationBarAndroid();

  }
}