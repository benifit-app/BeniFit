import 'dart:ui';

import 'package:fitapp/activityFeedPage/metrics/screenAware.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/gender.dart';
import 'package:fitapp/activityFeedPage/metrics/card_tile.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/tap_handler.dart';

import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class GenderCard_ extends StatefulWidget {
  final Gender initialGender;

  const GenderCard_({Key key, this.initialGender}) : super(key: key);

  @override
  _GenderCardState createState() => _GenderCardState();
}

class _GenderCardState extends State<GenderCard_> {

  Gender selectedGender;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(8.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CardTitle("GENDER"),
              Padding(
                padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
                child: _drawMainStack(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawMainStack() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Row(
            children: <Widget>[
              _drawGenderCharacters("Female", Gender.female, true),
              _drawGenderCharacters("  Male", Gender.male, true)
            ],
          )
        ],
      ),
    );
  }

  Widget _drawNimaCharacter(Gender gender, String nimaLocation) {
    String _nimaLocation;

    if (gender == Gender.male){
      _nimaLocation = "assets/flexin.nma";
    }
    else if (gender == Gender.female){
      _nimaLocation = "assets/Flexer.nma";
    }

    return Container(
      padding: EdgeInsets.only(left:10.0, right:10.0),
      height: 150,
      child: new NimaActor(
          _nimaLocation,
          paused: true,
          alignment:Alignment.center,
          fit:BoxFit.contain,
          animation:"Untitled"
      ),
    );
  }

  Widget _drawGenderCharacters(String text, Gender gender, bool selected) {

    bool Selected = selected;

    return Expanded(
        flex: 5,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _drawNimaCharacter(gender, null),
                Text(text),
              ],
            ),
            (Selected) ?
            Divider() :
            _blurCharacter()
          ],
        )
    );
  }

  Widget _blurCharacter() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: new Container(
            height: 197.2,
            width: double.infinity,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
                color: Colors.black.withOpacity(0.1)
            ),
          ),
        ),
      ],
    );
  }

  void _setSelectedGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  getGender () {
    return selectedGender;
  }
}