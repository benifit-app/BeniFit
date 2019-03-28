import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_pedometer/flutter_pedometer.dart';

class Pedometer extends StatefulWidget {
  @override
  _PedometerState createState() => new _PedometerState();
}

class _PedometerState extends State<Pedometer> {
  String _stepCountValue = '0';
  StreamSubscription<int> _subscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FlutterPedometer pedometer = new FlutterPedometer();
    _subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onData(int stepCountValue) async {
    print(stepCountValue);

    setState(() {
      _stepCountValue = "$stepCountValue";
    });
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text("EFFIT - Let's Walk", textAlign: TextAlign.center),
        ),
        backgroundColor: Colors.blueGrey,
        body: new Center(
          child: new Text("Keep walking, you're only at: $_stepCountValue\n",
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5),
              textAlign: TextAlign.center
          )
        ),
      ),
    );
  }
}