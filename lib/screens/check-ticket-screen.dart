import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_isurvey/screens/loading-ticket-screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/components/appbar-img.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/components/isurvey-heading.dart';
import 'package:flutter_isurvey/screens/checkin-checkout-screen.dart';

// import 'package:flutter_isurvey/screens/qr-scanner-screen.dart';
import 'package:flutter_isurvey/screens/ticket-info-screen.dart';
import 'package:flutter_isurvey/services/api-service.dart';

class CheckTicketScreen extends StatefulWidget {
  static const String routerName = '/CheckTicketScreen';

  const CheckTicketScreen({
    Key key,
  }) : super(key: key);

  @override
  _CheckTicketScreenState createState() => _CheckTicketScreenState();
}

class _CheckTicketScreenState extends State<CheckTicketScreen> {
  Timer _timer;
  String _error = "";

  // var _controller = TextEditingController(text: 'HT1307210903');

  var _controller = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = new Timer.periodic(Duration(seconds: 60), (Timer timer) {
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
    return Scaffold(
      endDrawer: DrawerSetting(),
      body: Padding(
        padding: kAppPadding,
        child: Column(
          children: [
            AppbarImage(),
            ISurveyHeading(),
            SizedBox(
              height: 50,
            ),
            TextField(
                controller: _controller,
                onChanged: (v) {
                  if (_error != null && _error.isNotEmpty)
                    setState(() {
                      _error = "";
                    });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kPrimaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.2),
                  ),
                  hintText: 'ticket_id'.tr(),
                  hintStyle: TextStyle(
                      fontSize: 24.0, color: Colors.grey.withOpacity(0.5)),
                ),
                style: TextStyle(
                    fontSize: 24, letterSpacing: 1, color: Colors.black)),
            SizedBox(
              height: 14,
            ),
            if (_error != null && _error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            SizedBox(
              height: 15,
            ),
            ButtonWidget(
              text: "check".tr(),
              onTap: () {
                try {
                  ApiService.fetchTicketById(_controller.text).then((ticket) {
                    if (ticket.error != null) {
                      setState(() {
                        _error = ticket.error;
                      });
                    } else if (ticket.ticketId != null) {
                      Navigator.pushNamed(
                          context,
                          ticket.status == 0
                              ? ticket.accessInfo == null
                                  ? LoadingTicketScreen.routerName
                                  : TicketInfoScreen.routerName
                              : CheckinCheckoutScreen.routerName,
                          arguments: {'ticket': ticket});
                    }
                  });
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    content: Text(
                      'something_was_error'.tr() + " \"" + error.message + "\"",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ).tr(),
                  ));
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
              child: SvgPicture.asset(
                "assets/icons/qr-code-scan.svg",
                height: 40,
                width: 40,
              ),
              width: 56,
              onTap: () {
                // Navigator.pushNamed(context, QrScannerScreen.routerName);
              },
            ),
            SizedBox(
              height: 20,
            ),
            IconButton(
                icon: SvgPicture.asset('assets/icons/qr-code-scan.svg'),
                color: kPrimaryColor,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
