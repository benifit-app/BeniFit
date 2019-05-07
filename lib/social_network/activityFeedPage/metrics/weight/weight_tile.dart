import 'package:fitapp/social_network/activityFeedPage/metrics/card_tile.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart' show screenAwareSize;
import 'package:flutter/material.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/weight/weight_background.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/weight/weight_slider.dart';

class WeightCard extends StatelessWidget {
  final int initialWeight;
  final ValueChanged<int> onChanged;
  const WeightCard({Key key, this.initialWeight, this.onChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(32.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle("WEIGHT", subtitle: "(Lbs)"),
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
    return WeightBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSlider(
            minValue: 30,
            maxValue: 300,
            value: initialWeight,
            onChanged: (val) => onChanged(val),
            width: constraints.maxWidth,
          );
        },
      ),
    );
  }

}