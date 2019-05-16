import 'package:flutter/material.dart';
import 'package:fitapp/activityFeedPage/metrics/screenAware.dart' show screenAwareSize;

class GenderLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: screenAwareSize(6.0, context),
        top: screenAwareSize(8.0, context),
      ),
      child: Container(
        height: screenAwareSize(8.0, context),
        width: 1.0,
        color: Colors.black,
      ),
    );
  }
}