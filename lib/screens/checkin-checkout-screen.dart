import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/appbar.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/models/ticket.dart';
import 'package:flutter_isurvey/screens/vote-screen.dart';
import 'package:flutter_isurvey/services/api-service.dart';

class CheckinCheckoutScreen extends StatefulWidget {
  static const String routerName = '/CheckinCheckoutScreen';

  @override
  _CheckinCheckoutScreenState createState() => _CheckinCheckoutScreenState();
}

class _CheckinCheckoutScreenState extends State<CheckinCheckoutScreen> {
  Timer _timer;
  Ticket ticket;
  bool showCheckout;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        Map<String, dynamic> arguments =
            ModalRoute.of(context).settings.arguments;
        ticket = arguments['ticket'];
      });
    });
    _timer = new Timer.periodic(Duration(seconds: 10), (Timer timer) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      _timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    this.ticket = arguments['ticket'];
    this.showCheckout = arguments['showCheckout'] ?? true;
    return Scaffold(
      endDrawer: DrawerSetting(),
      body: Padding(
        padding: kAppPadding,
        child: Column(
          children: [
            Appbar(),
            SizedBox(
              height: 6,
            ),
            Text(
              'hi_customer',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ).tr(),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/server-status-amico.svg',
                  width: 400,
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StatusBox(
                      time: ticket.checkin,
                      isCheckOut: false,
                    ),
                    if (ticket.status > 1)
                      StatusBox(
                        time: ticket.checkout,
                        isCheckOut: true,
                      ),
                  ],
                )
              ],
            )),
            SizedBox(
              height: 20,
            ),
            if (ticket.status == 1 && showCheckout == true)
              ButtonWidget(
                text: "CHECK OUT",
                onTap: () {
                  ApiService.checkoutTicket(ticket.id).then((ticket) {
                    if (ticket.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        content: Text(
                          'something_was_error'.tr() +
                              " \"" +
                              ticket.error +
                              "\"",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ).tr(),
                      ));
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                          CheckinCheckoutScreen.routerName,
                          arguments: {'ticket': ticket});
                      _timer.cancel();
                    }
                  });
                },
              ),
            if (ticket.status == 2)
              ButtonWidget(
                text: "service_review".tr(),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                      VoteScreen.routerName,
                      arguments: {'ticket': ticket});
                  _timer.cancel();
                },
              ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBox extends StatelessWidget {
  final bool isCheckOut;
  final String time;

  const StatusBox({
    Key key,
    this.isCheckOut = false,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = new DateFormat('dd-MM-yyyy HH:mm:ss');
    return Container(
      margin: EdgeInsets.only(top: isCheckOut ? 40 : 0),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCheckOut ? 'checkout_success' : 'checkin_success',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff626262),
                ),
              ).tr(),
              SizedBox(
                height: 10,
              ),
              Text(
                df.format(DateTime.parse(time).add(Duration(hours: 7))),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff28AF14),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
