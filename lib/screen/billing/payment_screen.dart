import 'dart:async';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:enavatek_mobile/value/path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;

  PaymentPage({required this.paymentUrl});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF)) // Set background to white
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true; // Show loading indicator
            });
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() {
              _isLoading = false; // Hide loading indicator
            });
            // Handle completion of payment
            if (url.contains('completed')) {
              Timer(const Duration(seconds: 5), () {
                Navigator.pop(context);
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
            setState(() {
              _isLoading = false; // Hide loading indicator on error
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.liveBgColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
                        'Payment',
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
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller), // WebView to load the payment page
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(), // Loading indicator
            ),
        ],
      ),
    );
  }
}
