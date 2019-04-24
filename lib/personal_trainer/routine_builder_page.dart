import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fitapp/personal_trainer/menu_Card.dart';
import 'package:fitapp/personal_trainer/exercise_search.dart';
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


class routineBuilderPage extends StatefulWidget{
  _routineBuilderPage createState() => new _routineBuilderPage();
}

class _routineBuilderPage extends State<routineBuilderPage>{

  buildTopBarAndroid() {
    return new AppBar(
      backgroundColor: Colors.white,
      title: new Form(
        child: new TextFormField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(labelText: 'Search for an exercise'),
          onFieldSubmitted: submit,
        ),
      ),
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
        new GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => new exerciseSearchPage())
            );
          },
          child: new menuCard("New Routine", 250, "assets/images/checklist.jpg", BoxFit.cover, Alignment.center, BorderRadius.circular(20)),
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

  }
}