import 'package:flutter/material.dart';
import 'package:flutter_isurvey/globals.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/constants.dart';

class DrawerSetting extends StatelessWidget {
  Glob _glob = new Glob();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'language',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      ).tr(),
                      Divider(
                        // height: 24,
                        color: kPrimaryColor,
                        thickness: 2,
                        // indent: 40,
                        // endIndent: 40,
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () {
                          context.setLocale(Locale('en', 'US'));
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/english.svg',
                              width: 40,),
                            SizedBox(width: 10,),
                            Text('english', style: TextStyle(
                                fontSize: 20
                            ),).tr()
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () {
                          context.setLocale(Locale('vi', 'VN'));
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/vietnamese.svg',
                            width: 40,),
                            SizedBox(width: 10,),
                            Text('vietnamese', style: TextStyle(
                              fontSize: 20
                            ),).tr()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text('iSurvey v2.0.0 - NOC AST', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey
                ),),
                Text('Device ID: ${_glob.deviceID}', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                ),),
              ],
            ),
          )),
    );
  }
}
