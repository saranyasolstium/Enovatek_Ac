import 'dart:async';
import 'dart:io';
import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewerScreen extends StatefulWidget {
  final String? paymentId;

  const PDFViewerScreen({super.key, required this.paymentId});

  @override
  PDFViewerScreenState createState() => PDFViewerScreenState();
}

class PDFViewerScreenState extends State<PDFViewerScreen> {
  String? _pdfPath;

  @override
  void initState() {
    super.initState();
    downloadInvoice();
  }

  Future<void> downloadInvoice() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    Response response =
        await RemoteServices.downloadInvoice(widget.paymentId, authToken!);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String pdfPath = '$tempPath/download_Invoice.pdf';
      await File(pdfPath).writeAsBytes(response.bodyBytes);

      setState(() {
        _pdfPath = pdfPath;
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> _downloadPdf() async {
    String? authToken = await SharedPreferencesHelper.instance.getAuthToken();

    try {
      // Request Storage Permission (Only needed for Android < 11)
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Storage permission is required to download the PDF')),
          );
          return;
        }
      }

      // Fetch the PDF from API
      http.Response response =
          await RemoteServices.downloadInvoice(widget.paymentId, authToken!);

      if (response.statusCode == 200) {
        Directory? directory;

        if (Platform.isAndroid) {
          directory = await getDownloadsDirectory();
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          throw Exception("Unsupported platform");
        }

        if (!directory!.existsSync()) {
          directory.createSync(recursive: true);
        }

        String fileName = 'download_Invoice.pdf';
        String filePath = '${directory.path}/$fileName';

        // Write file
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved at: $filePath')),
        );

        print("PDF saved at: $filePath");

        // Open the file
      } else {
        print('Download failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Download failed. Status: ${response.statusCode}')),
        );
      }
    } catch (error) {
      print('Error while downloading PDF: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF. Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.liveBgColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.liveBgColor,
        automaticallyImplyLeading: false,
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
                  Text(
                    'PDF Viewer',
                    style: GoogleFonts.roboto(
                      fontSize: 18.dynamic,
                      fontWeight: FontWeight.bold,
                      color: ConstantColors.appColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              _downloadPdf();
            },
          ),
        ],
      ),
      body: _pdfPath != null
          ? PDFView(filePath: _pdfPath!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
