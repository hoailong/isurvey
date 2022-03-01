import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isurvey/screens/loading-ticket-screen.dart';
import 'package:flutter_isurvey/screens/slide-screen.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/screens/check-ticket-screen.dart';
import 'package:flutter_isurvey/screens/checkin-checkout-screen.dart';
import 'package:flutter_isurvey/screens/qr-scanner-screen.dart';
import 'package:flutter_isurvey/screens/signature-screen.dart';
import 'package:flutter_isurvey/screens/ticket-info-screen.dart';
import 'package:flutter_isurvey/screens/vote-screen.dart';
import 'package:flutter_isurvey/screens/vote-success-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/langs',
      fallbackLocale: Locale('en', 'US'),
      startLocale: Locale('vi', 'VN'),
      // startLocale: Locale('en', 'US'),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
            primaryColor: kPrimaryColor, backgroundColor: Color(0xFFF1F1F1)),
        initialRoute: SlideScreen.routerName,
        routes: <String, WidgetBuilder>{
          SlideScreen.routerName: (BuildContext context) => new SlideScreen(),
          CheckTicketScreen.routerName: (BuildContext context) =>
              new CheckTicketScreen(),
          // QrScannerScreen.routerName: (BuildContext context) =>
          //     new QrScannerScreen(),
          TicketInfoScreen.routerName: (BuildContext context) =>
              new TicketInfoScreen(),
          LoadingTicketScreen.routerName: (BuildContext context) =>
              new LoadingTicketScreen(),
          SignatureScreen.routerName: (BuildContext context) =>
              new SignatureScreen(),
          CheckinCheckoutScreen.routerName: (BuildContext context) =>
              new CheckinCheckoutScreen(),
          VoteScreen.routerName: (BuildContext context) => new VoteScreen(),
          VoteSuccessScreen.routerName: (BuildContext context) =>
              new VoteSuccessScreen(),
        });
  }
}
