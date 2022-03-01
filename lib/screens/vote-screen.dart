import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_isurvey/components/appbar.dart';
import 'package:flutter_isurvey/components/button.dart';
import 'package:flutter_isurvey/components/drawer-setting.dart';
import 'package:flutter_isurvey/components/hero_dialog_route.dart';
import 'package:flutter_isurvey/components/other-idea-popup.dart';
import 'package:flutter_isurvey/components/support-idea-popup.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/models/ticket.dart';
import 'package:flutter_isurvey/screens/vote-success-screen.dart';
import 'package:flutter_isurvey/services/api-service.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class VoteScreen extends StatefulWidget {
  static const String routerName = '/VoteScreen';

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  Timer _timer;
  Ticket ticket;
  double star = 5;
  String supportStaff = 'infrastructure';

  var _supportIdeaController = TextEditingController(text: '');
  var _otherIdeaController = TextEditingController(text: '');

  void _onSelectSupportStaff(String _supportStaff) {
    setState(() {
      supportStaff = _supportStaff;
    });
    if (_supportStaff == 'other')
      Navigator.of(context).push(HeroDialogRoute(builder: (context) {
        return SupportIdeaPopupCard(controller: _supportIdeaController);
      }));
  }

  void _onRated(double _star) {
    if(_star == 0) _star = 1;
    setState(() {
      star = _star;
    });
  }

  void _onOtherIdeaTap(bool send) async {
    try {
      if (star < 5 &&
          _supportIdeaController.text.isEmpty &&
          _otherIdeaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Text(
            'enter_unsatisfied_comments',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ).tr(),
        ));
      } else {
        Map<String, dynamic> params = Map<String, dynamic>();
        params["star"] = star.toString();
        params["supportStaff"] = supportStaff;
        params["supportIdea"] = _supportIdeaController.text;
        params["otherIdea"] = send ? _otherIdeaController.text : '';
        await ApiService.reviewTicket(ticket.id, params);
        Navigator.of(context)
            .pushReplacementNamed(VoteSuccessScreen.routerName);
        _timer.cancel();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: Text(
          'something_was_error'.tr() + " \"" + error.message + "\"",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ).tr(),
      ));
    }
  }

  void _onSubmit() {
    if (star < 5 &&
        supportStaff == 'other' &&
        _supportIdeaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        content: Text(
          'enter_unsatisfied_comments',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ).tr(),
      ));
    } else {
      Navigator.of(context).push(HeroDialogRoute(builder: (context) {
        return OtherIdeaPopupCard(
          controller: _otherIdeaController,
          onTab: _onOtherIdeaTap,
        );
      }));
    }
  }
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
    Map<String, Ticket> arguments = ModalRoute.of(context).settings.arguments;
    this.ticket = arguments['ticket'];
    return Scaffold(
      endDrawer: DrawerSetting(),
      body: Padding(
        padding: kAppPadding,
        child: Column(
          children: [
            Appbar(
              vote: true,
            ),
            SizedBox(
              height: 20,
            ),
            Rating(star: star, onRated: _onRated),
            SizedBox(
              height: 10,
            ),
            if (star < 5)
              ServiceList(
                spStaff: supportStaff,
                onTab: _onSelectSupportStaff,
              ),
            SizedBox(
              height: 50,
            ),
            ButtonWidget(
              text: "send_review".tr(),
              onTap: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class Rating extends StatelessWidget {
  final double star;
  final Function onRated;

  const Rating({
    Key key,
    this.star = 5,
    this.onRated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
        allowHalfRating: false,
        onRated: onRated,
        starCount: 5,
        rating: star ?? 5,
        size: 120.0,
        color: Color(0xFFF79421),
        borderColor: Color(0xFFF79421),
        spacing: 10.0);
  }
}

class ServiceList extends StatelessWidget {
  final String spStaff;
  final Function onTab;

  const ServiceList({Key key, this.spStaff, this.onTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'service_not_satisfied',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ).tr(),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ServiceItem(
              iconAsset: 'assets/images/process.svg',
              name: 'procedure'.tr(),
              isActive: spStaff == 'procedure',
              onTab: () => onTab('procedure'),
            ),
            ServiceItem(
              iconAsset: 'assets/images/servers.svg',
              name: 'infrastructure'.tr(),
              isActive: spStaff == 'infrastructure',
              onTab: () => onTab('infrastructure'),
            ),
            ServiceItem(
              iconAsset: 'assets/images/support.svg',
              name: 'service'.tr(),
              isActive: spStaff == 'service',
              onTab: () => onTab('service'),
            ),
            ServiceItem(
              iconAsset: 'assets/images/info.svg',
              name: 'other_idea'.tr(),
              isActive: spStaff == 'other',
              onTab: () => onTab('other'),
            ),
          ],
        ),
      ],
    );
  }
}

class ServiceItem extends StatelessWidget {
  final bool isActive;
  final String iconAsset;
  final String name;
  final Function onTab;

  const ServiceItem({
    Key key,
    this.isActive,
    this.iconAsset,
    this.name,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTab,
          customBorder: new CircleBorder(),
          child: Container(
            width: 220,
            height: 220,
            padding: EdgeInsets.all(36),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: kBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                    color: isActive ? Color(0xFFFF6666) : Color(0xFFD1D1D1),
                    width: 10),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      spreadRadius: 4)
                ]),
            child: SvgPicture.asset(
              iconAsset,
              color: isActive ? Color(0xFFFF6666) : Color(0xFFD1D1D1),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: onTab,
          child: Container(
            width: 160,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [Color(0xFFFF6666), Color(0xffFF8686)])
                    : LinearGradient(
                        colors: [Color(0xFFC1C1C1), Color(0xFFD1D1D1)]),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
