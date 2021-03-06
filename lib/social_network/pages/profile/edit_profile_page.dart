import 'package:fitapp/social_network/activityFeedPage/metrics/gender/original_gender/gender.dart';
import 'package:fitapp/social_network/activityFeedPage/metrics/metrics.dart';
import 'package:fitapp/social_network/main/home_page.dart';
import "package:flutter/material.dart";
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/social_network/pages/profile_page.dart'; //for the user class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitapp/social_network/activityFeedPage/view_user_post.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
String currentUserId = googleSignIn.currentUser.id;


Future<Null> signOutWithGoogle() async {
  // Sign out with firebase
  await auth.signOut();
  // Sign out with google
  await googleSignIn.signOut();
  await googleSignIn.disconnect();
}

goToHome(BuildContext context){
  Future.delayed(Duration(seconds: 2), (){
    print(_googleSignIn.currentUser);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  });
}

class EditProfilePage extends StatelessWidget {

  TextEditingController nameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  TextEditingController heightController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();
  TextEditingController bmiController = new TextEditingController();
  TextEditingController bodyFatController = new TextEditingController();
  TextEditingController prBenchController = new TextEditingController();
  TextEditingController prSquatController = new TextEditingController();
  Gender gender;
  int height;
  int weight;
  int age;

  void onMultiSelectStarted(int inputHeight, int inputWeight, int inputAge, Gender inputGender) {
     height = inputHeight;
     weight = inputWeight;
     age = inputAge;
     gender = inputGender;
  }

  changeProfilePhoto(BuildContext Context) {
    return showDialog(
      context: Context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Change Photo'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                    'Changing your profile photo has not been implemented yet'
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  applyChanges() {
    Firestore.instance
        .collection('insta_users')
        .document(currentUserModel.id)
        .updateData({
      "height": height,
      "weight": weight,
      "displayName": nameController.text,
      "bio": bioController.text,
      "bmi": bmiController.text,
      "bodyFat": bodyFatController.text,
      "prBench": prBenchController.text,
      "prSquat": prSquatController.text,
      "age": age,
    });
  }


  Widget buildTextField({String name, TextEditingController controller, TextInputType keyboard}) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: new TextStyle(color: Colors.grey),
          ),
        ),
        new TextField(
          keyboardType: keyboard,
          controller: controller,
          decoration: new InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Firestore.instance
            .collection('insta_users')
            .document(currentUserModel.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return new Container(
                alignment: FractionalOffset.center,
                child: new CircularProgressIndicator()
            );

          User user = new User.fromDocument(snapshot.data);

          nameController.text = user.displayName;
          bioController.text = user.bio;
          height = user.height;
          weight = user.weight;
          age = user.age;


          return new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: new CircleAvatar(
                  backgroundImage: NetworkImage(currentUserModel.photoUrl),
                  radius: 50.0,
                ),
              ),
              new FlatButton(
                  onPressed: () {
                    changeProfilePhoto(context);
                  },
                  child: new Text(
                    "Change Photo",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Column(
                  children: <Widget>[
                    buildTextField(name: "Name", controller: nameController),
                    buildTextField(name: "Bio", controller: bioController),
                    buildTextField(name: "PR Bench", controller: prBenchController, keyboard: TextInputType.numberWithOptions()),
                    buildTextField(name: "PR Squat", controller: prSquatController, keyboard: TextInputType.numberWithOptions()),
                    new Container(
                      child: new InputPage(
                        multiSeleceted: onMultiSelectStarted,
                        height: height,
                        weight: weight,
                        age: age,
                        gender: gender,
                      ),
                    )
//                    buildTextField(name: "Height", controller: heightController),
//                    buildTextField(name: "Weight", controller: weightController),,
//                    buildTextField(name: "BMI", controller: bmiController),
//                    buildTextField(name: "Body Fat", controller: bodyFatController),
                  ],
                ),
              ),
              new FlatButton(
                  onPressed: () {
                    signOutWithGoogle();
                    goToHome(context);
                  },
                  child: new Text(
                    "Log Out",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                color: Colors.grey,
              ),
              ViewUserPosts()
            ],
          );
        });
  }
}

