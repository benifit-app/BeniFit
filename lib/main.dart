import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/social_network/main/home_page.dart';
import 'package:fitapp/Themes.dart';
import 'package:fitapp/social_network/pages/profile_page.dart';

Future<void> main() async {
  await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(new fitapp());
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
      theme: currentTheme,

      home: new HomePage(title: 'EFfit'),
    );
  }
}
