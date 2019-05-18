import 'package:fitapp/social_network/activityFeedPage/metrics/age/age_slider.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/card_tile.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart' show screenAwareSize;
import 'package:flutter/material.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/age/age_background.dart';

class AgeCard extends StatelessWidget {
  final int age;
  final ValueChanged<int> onChanged;
  const AgeCard({Key key, this.age = 25, this.onChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(32.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle("AGE"),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _drawSlider(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawSlider() {
    return AgeBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : AgeSlider(
            minValue: 1,
            maxValue: 100,
            value: age,
            onChanged: (val) => onChanged(val),
            width: constraints.maxWidth,
          );
        },
      ),
    );
  }

}