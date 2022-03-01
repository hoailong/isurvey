import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/appbar.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/models/ticket.dart';
import 'package:flutter_isurvey/screens/checkin-checkout-screen.dart';
import 'package:flutter_isurvey/services/api-service.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  static const String routerName = '/SignatureScreen';

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Ticket ticket;
  SignatureController controller;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String customer;

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.white,
    );

    Future.delayed(Duration.zero, () {
      setState(() {
        Map<String, Ticket> arguments =
            ModalRoute.of(context).settings.arguments;
        ticket = arguments['ticket'];
        _dropdownMenuItems = buildDropdownMenuItems(
            ticket.accessInfo.guests.map((e) => e.fullName).toList());
        customer = _dropdownMenuItems[0].value;
      });
    });
  }

  onChangeDropdownItem(String selectedCustomer) {
    setState(() {
      customer = selectedCustomer;
    });
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List customers) {
    List<DropdownMenuItem<String>> items = List();
    for (String customer in customers) {
      items.add(
        DropdownMenuItem(
          value: customer,
          child: Text(customer),
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    controller.dispose();
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
              height: 4,
            ),
            Text(
              'hi_customer',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ).tr(),
            SizedBox(
              height: 4,
            ),
            DropdownButton(
              value: customer,
              items: _dropdownMenuItems,
              onChanged: onChangeDropdownItem,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor),
              underline: Container(
                height: 2,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'please_sign',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ).tr(),
            SizedBox(
              height: 30,
            ),
            SignatureBox(controller: controller),
            SizedBox(
              height: 30,
            ),
            ActionBox(
                controller: controller, ticket: ticket, customer: customer),
          ],
        ),
      ),
    );
  }
}

class ActionBox extends StatelessWidget {
  final Ticket ticket;
  final String customer;

  const ActionBox({
    Key key,
    @required this.controller,
    @required this.ticket,
    @required this.customer,
  }) : super(key: key);

  final SignatureController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
          child: SvgPicture.asset(
            "assets/icons/close.svg",
            color: Colors.red,
            height: 30,
            width: 30,
          ),
          width: 100,
          onTap: () {
            controller.clear();
          },
        ),
        SizedBox(
          width: 10,
        ),
        ButtonWidget(
          child: SvgPicture.asset(
            "assets/icons/check.svg",
            color: Colors.green,
            height: 30,
            width: 30,
          ),
          width: 100,
          onTap: () async {
            if (controller.isNotEmpty) {
              // ApiService.checkinTicket(ticket.id).then((ticket) {
              //   Navigator.of(context).pushReplacementNamed(
              //       CheckinCheckoutScreen.routerName,
              //       arguments: {'ticket': ticket});
              // });
              final signatureEncoded = await exportSignature();
              try {
                Map<String, dynamic> params = Map<String, dynamic>();
                params["ticket_id"] = ticket.id.toString();
                params["fullName"] = customer;
                params["signature_img"] =
                    "data:image/png;base64," + signatureEncoded;
                final saved = await ApiService.saveSignatureTicket(params);
                if (saved) {
                  final checkinTicket = await ApiService.checkinTicket(ticket.id);
                  Navigator.of(context).pushReplacementNamed(
                    CheckinCheckoutScreen.routerName,
                    arguments: {'ticket': checkinTicket});
                }
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
                  ),
                ));
                print(error.toString());
              }
              // await Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) =>
              //         SignaturePreviewScreen(signature: signature)));
            }
          },
        ),
      ],
    );
  }

  Future<String> exportSignature() async {
    final exportController = SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.transparent,
        points: controller.points);

    final signature = await exportController.toPngBytes();
    final signatureEncoded = base64.encode(signature);
    exportController.dispose();

    return signatureEncoded;
  }
}

class SignaturePreviewScreen extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewScreen({Key key, this.signature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Signature Preview'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          child: Center(
        child: Image.memory(signature),
      )),
    );
  }
}

class SignatureBox extends StatelessWidget {
  const SignatureBox({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final SignatureController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 600,
          height: 300,
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
          child: Signature(
            controller: controller,
            width: 600,
            height: 300,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
