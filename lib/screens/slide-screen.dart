import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isurvey/constants.dart';
import 'package:flutter_isurvey/globals.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:path/path.dart' as p;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_isurvey/components/slide-dot.dart';
import 'package:flutter_isurvey/screens/check-ticket-screen.dart';
import '../components/video-player.dart';
import 'package:flutter_isurvey/services/api-service.dart';
import 'package:flutter_isurvey/config.dart';
import 'package:flutter_isurvey/models/ticket.dart';
import 'package:flutter_isurvey/screens/checkin-checkout-screen.dart';
import 'package:flutter_isurvey/screens/ticket-info-screen.dart';

class SlideScreen extends StatefulWidget {
  static const String routerName = '/';

  const SlideScreen({Key key}) : super(key: key);

  @override
  _SlideScreenState createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  Socket socket;
  Ticket ticket;
  Timer timer;
  List<dynamic> sliders = [];
  int _currentPage = 0;
  bool _onScreen = true;
  Glob _glob = Glob();

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    _startTimer();
  }

  Future<void> initPlatformState() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _glob.model = androidInfo.model;
        _glob.deviceID = androidInfo.androidId;
        print('Running on ${androidInfo.model} - ID: ${androidInfo.androidId}');
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _glob.model = iosInfo.utsname.machine;
        _glob.deviceID = iosInfo.identifierForVendor;
        print(
            'Running on ${iosInfo.utsname.machine} - ID: ${iosInfo.identifierForVendor}');
      }
      _glob.imei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      print('Can not get Imei!');
      _glob.imei = "0";
    } finally {
      initSocket();
      _fetchSlides();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cancelTimer();
    if (socket != null) {
      socket.disconnect();
    }
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    if (!timer.isActive && !_isVideoFile(sliders[index])) _startTimer();
    setState(() {
      _currentPage = index;
    });
  }

  void _fetchSlides() async {
    final _sliders = await ApiService.fetchSliders();
    // final _sliders = [];
    setState(() {
      sliders = _sliders;
    });
  }

  void initSocket() {
    print(_glob.imei);
    socket = io(
        SERVER_URL,
        OptionBuilder()
            .setTransports(['websocket']) // fo
            .disableAutoConnect() // r Flutter or Dart VM
            .build());
    socket.connect();
    socket.onConnect((data) => print('Connected'));
    socket.on('send-ticket', (data) {
      List<dynamic> imeis = data['imeis'];
      List<dynamic> deviceIDs = data['deviceIDs'];
      if (deviceIDs.contains(_glob.deviceID)) {
        ticket = Ticket.fromJson(data['ticket']);
        Map<String, dynamic> params = Map<String, dynamic>();
        params["imei"] = _glob.imei;
        params["deviceID"] = _glob.deviceID;
        params["msg"] = "App đã nhận ticket!";
        socket.emit("app-received-ticket", params);
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   Navigator.pushNamed(
        //       context,
        //       ticket.status == 0
        //           ? TicketInfoScreen.routerName
        //           : CheckinCheckoutScreen.routerName,
        //       arguments: {'ticket': ticket});
        // });
        Future.delayed(Duration(milliseconds: 1000)).then((_) async {
          if (_onScreen) {
            setState(() {
              _onScreen = false;
            });
            final check = await Navigator.pushNamed(
                context,
                ticket.status == 0
                    ? TicketInfoScreen.routerName
                    : CheckinCheckoutScreen.routerName,
                arguments: {'ticket': ticket});
            setState(() {
              if (_isVideoFile(sliders[_currentPage])) {
                _nextSlide();
              }
              _onScreen = true;
            });
          } else {
            Navigator.pushNamed(
                context,
                ticket.status == 0
                    ? TicketInfoScreen.routerName
                    : CheckinCheckoutScreen.routerName,
                arguments: {'ticket': ticket});
          }
        });
      }
    });
  }

  void _onTabSlide() async {
    setState(() {
      _onScreen = false;
    });
    final check =
        await Navigator.pushNamed(context, CheckTicketScreen.routerName);
    setState(() {
      if (_isVideoFile(sliders[_currentPage])) {
        _nextSlide();
      }
      _onScreen = true;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (sliders.length > 0 && _onScreen) {
        if (!_isVideoFile(sliders[_currentPage])) {
          if (_currentPage < sliders.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          if (_pageController.hasClients) {
            _pageController.animateToPage(_currentPage,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          }
        } else {
          timer.cancel();
        }
      }
    });
  }

  void _cancelTimer() {
    timer.cancel();
  }

  void _nextSlide() {
    _startTimer();
    if (_currentPage < sliders.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    if (_pageController.hasClients) {
      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  bool _isVideoFile(file) {
    final types = ['.mp4', '.mov', '.avi', '.m4v'];
    final String ext = p.extension(file);
    return types.contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
            onTap: _onTabSlide,
            child: Center(
                child: sliders.length == 0 && _onScreen
                    ? Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      )
                    : Stack(
                        children: [
                          PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            itemCount: sliders.length,
                            itemBuilder: (context, index) => _isVideoFile(
                                    sliders[_currentPage])
                                ? VideoPlayBackground(
                                    playVideo: _onScreen,
                                    videoAssset:
                                        '${SERVER_URL}${sliders[_currentPage]}',
                                    onVideoEnded: _nextSlide,
                                    onTab: _onTabSlide)
                                : Image.network(
                                    '${SERVER_URL}${sliders[_currentPage]}',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),
                            // null
                            // : Image.memory(
                            //     base64Decode(
                            //       sliders[_currentPage],
                            //     ),
                            //     fit: BoxFit.cover,
                            //     height: double.infinity,
                            //     width: double.infinity,
                            //     alignment: Alignment.center,
                            //   ),
                          ),
                          Positioned(
                              bottom: 20,
                              right: 0,
                              left: 0,
                              child: Container(
                                // margin: EdgeInsets.only(bottom: 35),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < sliders.length; i++)
                                      if (i == _currentPage)
                                        SlideDot(true)
                                      else
                                        SlideDot(false)
                                  ],
                                ),
                              ))
                        ],
                      ))));
  }
}
