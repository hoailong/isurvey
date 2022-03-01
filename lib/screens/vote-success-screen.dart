import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/appbar-img.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/constants.dart';

class VoteSuccessScreen extends StatefulWidget {
  static const String routerName = '/VoteSuccessScreen';
  @override
  _VoteSuccessScreenState createState() => _VoteSuccessScreenState();
}

class _VoteSuccessScreenState extends State<VoteSuccessScreen> {
  Timer _timer;

  @override
  void initState() {
    _timer = new Timer.periodic(Duration(seconds: 10), (Timer timer) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      _timer.cancel();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerSetting(),
      body: Padding(
        padding: kAppPadding,
        child: Column(
          children: [
            AppbarImage(
              title: true,
            ),
            SvgPicture.asset(
              'assets/images/thanks.svg',
              height: 444,
            ),
            Container(
              width: 820,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                  color: Color(0xffAFFFB2).withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/checked.svg',
                    width: 50,
                    height: 50,
                    color: Color(0xff28AF14),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'success_review',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff28AF14),
                        ),
                      ).tr(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'acknowledged_contributions',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff28AF14),
                        ),
                      ).tr(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
