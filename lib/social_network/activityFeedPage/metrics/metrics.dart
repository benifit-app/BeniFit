import 'package:fitapp/social_network/activityFeedPage/metrics/age/age_tile.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/gender/gender_card_.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/gender/original_gender/gender.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/height/height_tile.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/screenAware.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/weight/weight_tile.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  final Gender gender;
  final int height;
  final int weight;
  final int age;
  final Function multiSeleceted;

  InputPage({Key key, this.multiSeleceted, this.gender, this.height, this.weight, this.age})
      : super(key: key);

  @override
  InputPageState createState() => new InputPageState(this.weight, this.height, this.age, this.gender);
}

class InputPageState extends State<InputPage> {
  final int inputAge;
  final int inputHeight;
  final Gender inputGender;
  final int inputWeight;

  InputPageState(this.inputWeight, this.inputHeight, this.inputAge, this.inputGender);

  Gender gender = Gender.other;
  int height = 170;
  int weight = 70;
  int age = 99;

  @override
  void initState() {
    super.initState();
    this.gender = inputGender;
    this.age = inputAge;
    this.height = inputHeight;
    this.weight = inputWeight;
  }

  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InputSummaryCard(
            age: age,
            gender: gender,
            weight: weight,
            height: height,
          ),
        _buildCards(context),
        ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Expanded(
                child: new Container(
                  child: GenderCard_(
                    initialGender: gender,
                    onChanged: (val) => setState(() {
                      widget.multiSeleceted(this.height, this.weight, this.age, this.gender);
                      return gender = val;
                    }),
                  ),
                  height: 250,
                ))
          ],
        ),
        new Row(
          children: <Widget>[
            new Expanded(
                child: new Container(
                  child: WeightCard(
                    initialWeight: weight,
                    onChanged: (val) => setState(() {
                      widget.multiSeleceted(this.height, this.weight, this.age, this.gender);
                      return weight = val;
                    }),
                  ),
                  height: 200,
                )
            ),
            new Expanded(
                child: new Container(
                  child: AgeCard(
                    age: age,
                    onChanged: (val) => setState(() {
                      widget.multiSeleceted(this.height, this.weight, this.age, this.gender);
                      return age = val;
                    }),
                  ),
                  height: 200,
                )
            ),
          ],
        ),
        new Row(
          children: <Widget>[
            new Expanded(
                child: new Container(
                  child: HeightCard(
                    height: height,
                    onChanged: (val) => setState(() {
                      widget.multiSeleceted(this.height, this.weight, this.age, this.gender);
                      return height = val;
                    }),
                  ),
                  height: 500,
                ))
          ],
        ),
      ],
    );
  }
}

class InputSummaryCard extends StatelessWidget {
  final Gender gender;
  final int height;
  final int weight;
  final int age;

  const InputSummaryCard({Key key, this.gender, this.height, this.weight, this.age})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(screenAwareSize(16.0, context)),
      child: SizedBox(
        height: screenAwareSize(32.0, context),
        child: Row(
          children: <Widget>[
            Expanded(child: _genderText()),
            _divider(),
            Expanded(child: _text("${weight} lbs ")),
            _divider(),
            Expanded(child: _text("${age} years")),
            _divider(),
            Expanded(child: _text(cmToFeetAndInches(height))),
          ],
        ),
      ),
    );
  }

  Widget _genderText() {
    String genderText = gender == Gender.other
        ? '-'
        : (gender == Gender.male ? 'Male' : 'Female');
    return _text(genderText);
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(143, 144, 156, 1.0),
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _divider() {
    return Container(
      width: 1.0,
      color: Color.fromRGBO(151, 151, 151, 0.1),
    );
  }

  String cmToFeetAndInches (int cm){
    int inches = (cm / 2.54).round();
    double number = inches / 12;
    int remain = inches % 12;
    return number.round().toString()+"'"+remain.round().toString()+'"';
  }
}