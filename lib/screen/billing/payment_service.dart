import 'dart:convert';
import 'package:enavatek_mobile/screen/billing/payment_screen.dart';
import 'package:enavatek_mobile/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final String testKey =
      '32b8b1494d36ef0d1280d32bbd7009702e43651d3b23d8f26e97865a9ccdf732';

  // final String liveKey =
  //     "86090d1bf34f0657fa48d382686d635717bcb0e3a69e579d7d9c19a498e0ee2e";

  String testUrl = "https://api.sandbox.hit-pay.com/v1/payment-requests";
  // String liveUrl = "https://api.hit-pay.com/v1/payment-requests";

  Future<void> createPaymentRequest(
    BuildContext context,
    double amount,
    List<String> deviceId,
    String month,
    String currencyCode,
  ) async {
    final url = Uri.parse(testUrl);

    final headers = {
      'Content-Type': 'application/json',
      'X-BUSINESS-API-KEY': testKey,
    };

    final body = jsonEncode({
      "amount": amount.toString(),
      "currency": currencyCode,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final paymentUrl = responseData['url'];
        final paymentId = responseData['id'];
        print("PAYMENT ID: $paymentId");
        if (paymentUrl != null) {
          _redirectToPaymentUrl(
              context, paymentUrl, paymentId, deviceId, month);
        }
      } else {
        print("Failed to create payment request: ${response.statusCode}");
        print(response.body);
        SnackbarHelper.showSnackBar(
            context, "Failed to create payment request ${response.body}");
      }
    } catch (e) {
      print("Error creating payment request: $e");
    }
  }

  void _redirectToPaymentUrl(BuildContext context, String url, String paymentId,
      List<String> deviceId, String month) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          paymentUrl: url,
          paymentId: paymentId,
          deviceId: deviceId,
          month: month,
        ),
      ),
    );
  }
}
