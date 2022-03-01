// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// class QrScannerScreen extends StatefulWidget {
//   static const String routerName = '/QrScannerScreen';
//
//   @override
//   _QrScannerScreenState createState() => _QrScannerScreenState();
// }
//
// class _QrScannerScreenState extends State<QrScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode result;
//   QRViewController controller;
//
//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller.resumeCamera();
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//           title: Text('Quét mã QR'),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.flip_camera_ios),
//               onPressed: () async {
//                 await controller.flipCamera();
//               })
//         ],
//       ),
//       body:
//       Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//                 key: qrKey,
//                 formatsAllowed: [BarcodeFormat.qrcode],
//                 onQRViewCreated: _onQRViewCreated,
//                 overlay: QrScannerOverlayShape(
//                   borderColor: Colors.orange,
//                   borderRadius: 0,
//                   borderLength: 12,
//                   borderWidth: 8,
//                   cutOutSize: MediaQuery.of(context).size.width * 0.8,
//                   overlayColor: Colors.black54,
//                 )),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: (result != null)
//                   ? Text(
//                   'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
//                   : Text('Scan a code'),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }
// }
