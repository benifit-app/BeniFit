import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/personal_trainer/menu_Card.dart';
import 'package:fitapp/personal_trainer/exercise_search.dart';
import 'package:fitapp/personal_trainer/routine_builder_search.dart';
import 'dart:async';
import 'dart:io';


class routineBuilderPage extends StatefulWidget{
  final String currentDisplayName;

  routineBuilderPage({Key key, @required this.currentDisplayName}) : super(key: key);

  @override
  _routineBuilderPage createState() => new _routineBuilderPage();
}

class _routineBuilderPage extends State<routineBuilderPage>{

  buildTopBarAndroid() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: Text("Routine Builder"),
      leading: BackButton(color: Colors.black,),
      //leading: FlatButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),
    );
  }

  buildTopBarIOS(){
    return new CupertinoNavigationBar(
      leading: BackButton(color: Colors.black,),
      middle: Text("Routine Builder"),
    );
  }

  buildListView(){
    return ListView(
      children: <Widget>[
        //wrap cards in gesture detector to make them clickable
        //Card for showing the user's routines
        new GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => new exerciseSearchPage())
            );
          },
          child: new menuCard("My Routines", 250, "assets/images/checklist.jpg", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
        ),

        new GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => new exerciseSearchPage())
            );
          },
          child: new menuCard("Random Routine", 250, "assets/images/question.png", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
        ),

        new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => new routineSearchPage())
            );
          },
          child: new menuCard("Routine Search", 250, "assets/images/search.png", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
        )
      ],
    );
  }

  //builder for the page
  Widget build(BuildContext context){
      return Scaffold(
        appBar: Platform.isIOS ? buildTopBarIOS() : buildTopBarAndroid(),
        body: buildListView(),
      );
  }
}