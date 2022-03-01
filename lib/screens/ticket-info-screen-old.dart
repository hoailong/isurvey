import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/appbar.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/models/ticket.dart';
import 'package:flutter_isurvey/screens/signature-screen.dart';

class TicketInfoScreen extends StatefulWidget {
  static const String routerName = '/TicketInfoScreen';

  @override
  _TicketInfoScreenState createState() => _TicketInfoScreenState();
}

class _TicketInfoScreenState extends State<TicketInfoScreen> {
  Timer _timer;
  Ticket ticket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        Map<String, Ticket> arguments =
            ModalRoute.of(context).settings.arguments;
        ticket = arguments['ticket'];
      });
    });
    _timer = new Timer.periodic(Duration(seconds: 30), (Timer timer) {
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
    Map<String, Ticket> arguments = ModalRoute.of(context).settings.arguments;
    this.ticket = arguments['ticket'];
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
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
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
                child: TicketInfo(
                  ticket: ticket,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
              text: "confirm".tr(),
              onTap: () {
                // ApiService.checkinTicket(ticket.id).then((ticket) {
                Navigator.of(context).pushReplacementNamed(
                    SignatureScreen.routerName,
                    arguments: {'ticket': ticket});
                _timer.cancel();
                // });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TicketInfo extends StatelessWidget {
  final Ticket ticket;

  const TicketInfo({
    Key key,
    this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size);
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'ticket_information',
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ).tr(),
          SizedBox(
            height: 10,
          ),
          Text(
            'ticket_infor_dear',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ).tr(),
          Divider(
            height: 24,
            color: Colors.white,
            thickness: 2,
            indent: 480,
            endIndent: 480,
          ),
          SizedBox(
            height: 10,
          ),
          DefaultTextStyle(
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            child: Container(
              padding: EdgeInsets.only(left: 300, right: 200),
              child: Column(
                children: [
                  InfoRow(
                    title: 'ticket_id:'.tr(),
                    desc: '${ticket.ticketId}',
                  ),
                  InfoRow(
                    title: 'request:'.tr(),
                    desc: '${ticket.title}',
                  ),
                  InfoRow(
                    title: 'location:'.tr(),
                    desc: '${ticket.location}',
                  ),
                  InfoRow(
                    title: 'branch:'.tr(),
                    desc: '${ticket.branch}',
                  ),
                  InfoRow(
                    title: 'request_type:'.tr(),
                    desc: '',
                  ),
                  InfoRow(
                    title: 'service_type:'.tr(),
                    desc: '${ticket.serviceType}',
                  ),
                  InfoRow(
                    title: 'customer_type:'.tr(),
                    desc: '${ticket.cusType}',
                  ),
                  InfoRow(
                    title: 'input_information:'.tr(),
                    desc: '${ticket.issueName}',
                  ),
                  InfoRow(
                    title: 'reason:'.tr(),
                    desc: '',
                  ),
                  InfoRow(
                    title: 'note:'.tr(),
                    desc: '',
                  ),
                  InfoRow(
                    title: 'created_date:'.tr(),
                    desc: '${ticket.createdDate}',
                  ),
                  InfoRow(
                    title: 'required_date:'.tr(),
                    desc: '${ticket.requiredDate}',
                  ),
                  InfoRow(
                    title: 'division_name:'.tr(),
                    desc: '${ticket.divisionName}',
                  ),
                  InfoRow(
                    title: 'level:'.tr(),
                    desc: '${ticket.cricLev}',
                  ),
                  InfoRow(
                    title: 'processing_status:'.tr(),
                    desc: '',
                  ),
                  InfoRow(
                    title: 'processing_staff',
                    desc: '',
                  ),
                  InfoRow(
                    title: 'phone:'.tr(),
                    desc: '${ticket.foundMobile}',
                  ),
                  InfoRow(
                    title: 'ip_number:'.tr(),
                    desc: '${ticket.foundIpPhone}',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String desc;

  const InfoRow({
    Key key,
    this.title,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(title),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(child: Text(desc))
        ],
      ),
    );
  }
}
