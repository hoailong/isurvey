import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/appbar.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/models/guest.dart';
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
            'accessor_information',
            style: TextStyle(
                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ).tr(),
          SizedBox(
            height: 10,
          ),
          Text(
            'accessor_information_dear',
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
            height: 20,
          ),
          DefaultTextStyle(
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('ticket_id:').tr(),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${ticket.ticketId}')
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data Center:'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${ticket.accessInfo.datacenters.join('\n')}')
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rack:'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${ticket.accessInfo.racks.join('\n')}')
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Row(
                      children: [
                        Text('U:'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${ticket.accessInfo.u}')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Table(
            defaultColumnWidth: IntrinsicColumnWidth(),
            border: TableBorder.all(
                color: Colors.white, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [
                  Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 62),
                      alignment: Alignment.center,
                      child: Text('no',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)).tr())
                ]),
                Column(children: [
                  Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                      alignment: Alignment.center,
                      child: Text('full_name',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                          .tr())
                ]),
                Column(children: [
                  Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                      alignment: Alignment.center,
                      child: Text('id_card',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                          .tr())
                ]),
                Column(children: [
                  Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                      alignment: Alignment.center,
                      child: Text('guest_card',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                          .tr())
                ]),
              ]),
              for (var i = 0; i < ticket.accessInfo.guests.length; i++)
                TableRow(children: [
                  Column(children: [
                    Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                        alignment: Alignment.center,
                        child: Text('${i + 1}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)))
                  ]),
                  Column(children: [
                    Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                        alignment: Alignment.center,
                        child: Text('${ticket.accessInfo.guests[i].fullName}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)))
                  ]),
                  Column(children: [
                    Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                        alignment: Alignment.center,
                        child: Text('${ticket.accessInfo.guests[i].cmnd}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)))
                  ]),
                  Column(children: [
                    Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                        alignment: Alignment.center,
                        child: Text('${ticket.accessInfo.guests[i].cardNo.join('\n')}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)))
                  ]),
                ])
            ],
          ),
        ],
      ),
    );
  }
}
