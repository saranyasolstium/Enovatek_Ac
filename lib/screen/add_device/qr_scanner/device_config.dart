import 'package:enavatek_mobile/screen/add_device/basic_detail_screen.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner_with_effect/qr_scanner_with_effect.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  final int buildingID;
  final String buildingName;
  const QRScannerScreen(
      {super.key, required this.buildingID, required this.buildingName});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isComplete = false;
  bool hasPermissionDeniedMessageShown = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      // Handle the denied permission case.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
    } else if (status.isPermanentlyDenied) {
      // Open app settings to allow the user to enable permission.
      await openAppSettings();
    }
  }

  void onQrScannerViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.pauseCamera();

      await Future<void>.delayed(const Duration(milliseconds: 300));

      String? myQrCode = result?.code;
      if (myQrCode != null && myQrCode.isNotEmpty) {
        manageQRData(myQrCode);
      }
    });
  }

  void manageQRData(String myQrCode) async {
    controller?.stopCamera();
    setState(() {
      isComplete = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'QR Code Scanned',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text('Device Serial No: $myQrCode'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BasicDetailScreen(
                            buildingID: widget.buildingID,
                            buildingName: widget.buildingName,
                            deviceSerialNo: myQrCode,
                          )),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
    super.reassemble();
  }

  @override
  void dispose() {
    controller?.dispose();
    controller?.stopCamera();
    super.dispose();
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p && !hasPermissionDeniedMessageShown) {
      hasPermissionDeniedMessageShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: ConstantColors.backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Stack(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        ImgPath.pngArrowBack,
                        height: 22,
                        width: 22,
                        color: ConstantColors.appColor,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'QR Scanner',
                            style: GoogleFonts.roboto(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                              color: ConstantColors.appColor,
                            ),
                          )),
                    ],
                  )),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return QrScannerWithEffect(
              isScanComplete: isComplete,
              qrKey: qrKey,
              onQrScannerViewCreated: onQrScannerViewCreated,
              qrOverlayBorderColor: Colors.redAccent,
              cutOutSize: (MediaQuery.of(context).size.width < 300 ||
                      MediaQuery.of(context).size.height < 400)
                  ? 250.0
                  : 300.0,
              onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
              effectGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1],
                colors: [
                  Colors.redAccent,
                  Colors.redAccent,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
