import 'package:flutter/material.dart';
import 'package:flutter_isurvey/screens/slide-screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_isurvey/components/isurvey-heading.dart';
import 'package:flutter_isurvey/constants.dart';

class AppbarImage extends StatelessWidget {
  final bool title;

  const AppbarImage({
    Key key,
    this.title = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // Navigator.pushNamed(context, SlideScreen.routerName);
            Navigator.of(context).popUntil((route) => route.isFirst);
            // Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          child: Image.asset(
            'assets/images/logo.png',
            width: 180,
          ),
        ),
        if (title)
          Center(
            child: ISurveyHeading(size: 42),
          ),
        Row(
          children: [
            SizedBox(
              width: 120,
            ),
            IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/right-menu-bars.svg',
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                  // _onShowBottomSheet(context);
                }),
          ],
        )
      ],
    );
  }

  _onShowBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cài đặt ngôn ngữ',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    ),
                    Row(
                      children: [],
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
