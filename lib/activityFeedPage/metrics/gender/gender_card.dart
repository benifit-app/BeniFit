import 'package:fitapp/activityFeedPage/metrics/card_tile.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/gender.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/gender_circle.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/gender_icon.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/gender_arrow.dart';
import 'package:fitapp/activityFeedPage/metrics/gender/tap_handler.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fitapp/activityFeedPage/metrics/screenAware.dart' show screenAwareSize;

const double _defaultGenderAngle = math.pi / 4;
const Map<Gender, double> _genderAngles = {
  Gender.female: -_defaultGenderAngle,
  Gender.other: 0.0,
  Gender.male: _defaultGenderAngle,
};

class GenderCard extends StatefulWidget {
  final Gender initialGender;

  const GenderCard({Key key, this.initialGender}) : super(key: key);

  @override
  _GenderCardState createState() => _GenderCardState();
}

class _GenderCardState extends State<GenderCard> with SingleTickerProviderStateMixin{
  AnimationController _arrowAnimationController;
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

  @override
  void initState() {
    selectedGender = widget.initialGender ?? Gender.other;
    _arrowAnimationController = new AnimationController(
      vsync: this,
      lowerBound: -_defaultGenderAngle,
      upperBound: _defaultGenderAngle,
      value: _genderAngles[selectedGender],
    );
    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  Widget _drawMainStack() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _drawCircleIndicator(),
          GenderIconTranslated(gender: Gender.female),
          GenderIconTranslated(gender: Gender.other),
          GenderIconTranslated(gender: Gender.male),
          _drawGestureDetector(),
        ],
      ),
    );
  }

  Widget _drawCircleIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GenderCircle(),
        GenderArrow(listenable: _arrowAnimationController),
      ],
    );
  }

  _drawGestureDetector() {
    return Positioned.fill(
      child: TapHandler(
        onGenderTapped: _setSelectedGender,
      ),
    );
  }

  void _setSelectedGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });

    _arrowAnimationController.animateTo(
      _genderAngles[gender],
      duration: Duration(milliseconds: 150),
    );
  }

  getGender () {
    return selectedGender;
  }
}

