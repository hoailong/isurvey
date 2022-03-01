import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ISurveyHeading extends StatelessWidget {
  final double size;
  final bool iSurvey;
  const ISurveyHeading({
    Key key, this.size = 60, this.iSurvey = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text: iSurvey ? 'iSurvey' : 'service_quality_assessment'.tr(),
      colors: <Color>[Color(0xFFF37132), Color(0xFFF69359)],
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}