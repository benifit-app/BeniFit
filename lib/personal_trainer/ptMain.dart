import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/personal_trainer/menu_Card.dart';
import 'package:fitapp/personal_trainer/exercise_search.dart';
import 'package:fitapp/personal_trainer/routine_builder_page.dart';
import 'dart:io';

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
        //wrap cards in gesture detector to make them clickable
        new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => new routineBuilderPage())
            );
          },
          child: new menuCard("Routine Builder", 250,  "assets/images/checklist.jpg", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
        ),

        new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => new exerciseSearchPage())
            );
          },
          child: new menuCard("Exercise Search", 250, "assets/images/search.png", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
        )
      ],
    );
  }

  //builder for the page
  Widget build(BuildContext context){
    return Platform.isIOS ? buildNavigationBarIOS() : buildNavigationBarAndroid();
  }
}