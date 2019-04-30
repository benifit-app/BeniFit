import 'package:fitapp/social_network/activityFeedPage/metrics/height/slider_circle.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/height/slider_label.dart';
import 'package:flutter/material.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/height/sliderline.dart';

class HeightSlider extends StatelessWidget {
  final int height;

  const HeightSlider({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SliderLabel(height: height),
          Row(
            children: <Widget>[
              SliderCircle(),
              Expanded(child: SliderLine()),
            ],
          ),
        ],
      ),
    );
  }
}