import 'package:fitapp/social_network/activityFeedPage/metrics/card_tile.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/height/height_picker.dart';
import 'package:flutter/material.dart';

class HeightCard extends StatelessWidget {
  final int height;
  final ValueChanged<int> onChanged;

  const HeightCard({Key key, this.height = 170, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle("HEIGHT", subtitle: "(cm and feet)"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: screenAwareSize(8.0, context)),
                child: LayoutBuilder(builder: (context, constraints) {
                  return HeightPicker(
                    widgetHeight: constraints.maxHeight,
                    height: height,
                    onChange: (val) => onChanged(val),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}