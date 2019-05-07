import 'package:fitapp/social_network/activityFeedPage/metrics/height/height_styles.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart';
import 'package:flutter/material.dart';


class SliderLabel extends StatelessWidget {
  final int height;

  const SliderLabel({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(4.0, context),
        bottom: screenAwareSize(2.0, context),
      ),
      child: Text(
        "$height" + "  (" + cmToFeetAndInches(height) + ")",
        style: TextStyle(
          fontSize: selectedLabelFontSize,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String cmToFeetAndInches (int cm){
    double inches = (cm / 2.54);
    double number = inches / 12;
    int remain = (inches % 12).round();
    return number.toInt().toString()+"'"+remain.round().toString()+'"';
  }
}