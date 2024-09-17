import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final Function(String) onScanned;

  QRScannerPage({required this.onScanned});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Extract the UID part from the scanned data
      final uid = _extractUID(scanData.code);
      if (uid != null) {
        widget.onScanned(uid);
        Navigator.pop(context);  // Close the scanner page
      }
    });
  }

  String? _extractUID(String? scannedData) {
    if (scannedData != null && scannedData.length >= 21) {
      return scannedData.substring(9, 21);  // Extract 10th to 21st characters
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a QR code to extract UID'),
            ),
          ),
        ],
      ),
    );
  }
}
