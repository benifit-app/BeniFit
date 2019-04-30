import 'package:flutter/material.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart' show screenAwareSize;

double _circleSize(BuildContext context) => screenAwareSize(80.0, context);

class GenderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _circleSize(context),
      height: _circleSize(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(244, 244, 244, 1.0),
      ),
    );
  }
}