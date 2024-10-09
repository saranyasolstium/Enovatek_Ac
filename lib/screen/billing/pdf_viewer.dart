import 'dart:async';
import 'dart:io';
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
import 'package:external_path/external_path.dart';

class PDFViewerScreen extends StatefulWidget {
  final String? paymentId;

  PDFViewerScreen({required this.paymentId});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? _pdfPath;

  @override
  void initState() {
    super.initState();
    downloadInvoice();
  }

  Future<void> downloadInvoice() async {
    Response response = await RemoteServices.downloadInvoice(widget.paymentId);
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
    try {
      Response response =
          await RemoteServices.downloadInvoice(widget.paymentId);

      if (response.statusCode == 200) {
        String customFolderPath =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);

        Directory customDir = Directory(customFolderPath);
        if (!customDir.existsSync()) {
          customDir.createSync(recursive: true);
        }

        String fileName = 'download_Invoice.pdf';
        String filePath = '$customFolderPath/$fileName';

        await File(filePath).writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('PDF downloaded successfully. File saved at: $filePath'),
          ),
        );
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error while downloading PDF: $error');
      // Show a snackbar to indicate download failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download PDF. Error: $error'),
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          ImgPath.pngArrowBack,
                          height: 22,
                          width: 22,
                          color: ConstantColors.appColor,
                        ),
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
                ),
              ],
            ),
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
