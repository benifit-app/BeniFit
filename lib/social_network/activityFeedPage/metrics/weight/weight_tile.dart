import 'package:fitapp/social_network/activityFeedPage/metrics/card_tile.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart' show screenAwareSize;
import 'package:flutter/material.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/weight/weight_background.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/weight/weight_slider.dart';

class WeightCard extends StatefulWidget {
  final int initialWeight;
  const WeightCard({Key key, this.initialWeight}) : super(key: key);

  @override
  _WeightCardState createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  int weight;

  @override
  void initState() {
    super.initState();
    weight = widget.initialWeight ?? 70;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(32.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle("WEIGHT", subtitle: "(KG)"),
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
            value: weight,
            onChanged: (val) => setState(() => weight = val),
            width: constraints.maxWidth,
          );
        },
      ),
    );
  }
}