import 'package:flutter/material.dart';
import 'package:flutter_isurvey/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final double width;
  final Widget child;
  final Function onTap;

  const ButtonWidget({
    Key key,
    this.text,
    this.child,
    this.width = double.infinity,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: text != null ? 18 : 8),
          decoration: BoxDecoration(
              gradient: kPrimaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: text != null
              ? Text(text,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white))
              : child,
        ),
      ),
    );
  }
}