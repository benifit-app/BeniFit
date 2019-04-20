import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class menuCard extends StatelessWidget{
  //declare final variables
  final String menuName;
  final double containerHeight;
  final String imageName;
  final BoxFit imageFit;
  final Alignment imageAlignment;
  final BorderRadius cardBorderRadius;

  //class constructor
  menuCard(this.menuName, this.containerHeight, this.imageName, this.imageFit, this.imageAlignment, this.cardBorderRadius);

  //actually building the card
  @override
  Widget build(BuildContext context){
    return Container(
      //screen width with a height of:
      height: containerHeight,

      //child is a card
      child: Card(
        //adjust Card properties
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        elevation: 5,

        //Inkwell to make it clickable
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(imageName),
                fit: imageFit,
                alignment: imageAlignment,
            )
          ),
          child: Text(menuName),
        ),
      ),
    );
  }
}