import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/social_network/main/home_page.dart';

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
          primaryIconTheme: new IconThemeData(color: Colors.black)
      ),
      home: new HomePage(title: 'EFfit'),
    );
  }
}
