import 'package:flutter/material.dart';
import 'package:flutter_isurvey/screens/slide-screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_isurvey/components/isurvey-heading.dart';

class Appbar extends StatelessWidget {
  final bool vote;

  const Appbar({
    Key key,
    this.vote = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            icon: SvgPicture.asset(
              'assets/icons/logout.svg',
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              // Navigator.pushNamed(context, SlideScreen.routerName);
            }),
        ISurveyHeading(
          size: 42,
          iSurvey: !vote,
        ),
        IconButton(
            icon: SvgPicture.asset(
              'assets/icons/right-menu-bars.svg',
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            })
      ],
    );
  }
}
