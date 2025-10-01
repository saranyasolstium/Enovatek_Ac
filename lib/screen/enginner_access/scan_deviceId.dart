import 'dart:developer';
import 'dart:io';

import 'package:enavatek_mobile/screen/add_device/basic_detail_screen.dart';
import 'package:enavatek_mobile/screen/enginner_access/add_device_AppCtrl.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:enavatek_mobile/widget/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner_with_effect/qr_scanner_with_effect.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isComplete = false; // used to dim the effect & show buttons state
  bool hasPermissionDeniedMessageShown = false;
  bool _navigated = false; // prevents double navigation

  String? _scannedCode;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  void onQrScannerViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // debounce multiple fires
      if (_navigated) return;

      result = scanData;
      await controller.pauseCamera();
      await Future<void>.delayed(const Duration(milliseconds: 150));

      final code = result?.code;
      if (code != null && code.isNotEmpty) {
        manageQRData(code);
      } else {
        await controller.resumeCamera();
      }
    });
  }

  void manageQRData(String myQrCode) async {
    setState(() {
      _scannedCode = myQrCode;
      isComplete = true;
    });

    // Auto navigate once detected
    _navigateNext(myQrCode);
  }

  void _navigateNext(String? serial) {
    if (_navigated) return;
    _navigated = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddDeviceAppCtrlScreen(
          serialID: serial! ?? "",
        ),
      ),
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
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final cutOutSize = (MediaQuery.of(context).size.width < 300 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: ConstantColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: ConstantColors.backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Image.asset(
                      ImgPath.pngArrowBack,
                      height: 22,
                      width: 22,
                      color: ConstantColors.appColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'QR Scanner',
                      style: GoogleFonts.roboto(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.appColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // BODY with scanner and buttons BELOW
        body: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // camera + overlay effect
                          Positioned.fill(
                            child: QrScannerWithEffect(
                              isScanComplete: isComplete,
                              qrKey: qrKey,
                              onQrScannerViewCreated: onQrScannerViewCreated,
                              qrOverlayBorderColor: Colors.redAccent,
                              cutOutSize: cutOutSize,
                              onPermissionSet: (ctrl, p) =>
                                  onPermissionSet(context, ctrl, p),
                              effectGradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1],
                                colors: [Colors.redAccent, Colors.redAccent],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- Buttons & info BELOW scanner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_scannedCode != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        'Detected: $_scannedCode',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  Row(
                    children: [
                      RoundedButton(
                        onPressed: () {
                          _navigateNext("");
                        },
                        text: "Skip",
                        backgroundColor: ConstantColors.whiteColor,
                        textColor: ConstantColors.borderButtonColor,
                      ),
                      Spacer(),
                      RoundedButton(
                        onPressed: isComplete
                            ? () async {
                                // reset and scan again
                                setState(() {
                                  isComplete = false;
                                  _scannedCode = null;
                                  _navigated = false;
                                });
                                await controller?.resumeCamera();
                              }
                            : () {},
                        text: "Scan Again",
                        backgroundColor: ConstantColors.borderButtonColor,
                        textColor: ConstantColors.whiteColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
