import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isurvey/constants.dart';

class SlideDot extends StatelessWidget {
  bool isActive;

  SlideDot(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? kPrimaryColor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}
