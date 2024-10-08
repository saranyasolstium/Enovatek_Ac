import 'dart:convert';
import 'package:enavatek_mobile/screen/billing/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final String apiKey = '32b8b1494d36ef0d1280d32bbd7009702e43651d3b23d8f26e97865a9ccdf732';

  Future<void> createPaymentRequest(BuildContext context, double amount,List<String> deviceId,String month) async {
    final url = Uri.parse('https://api.sandbox.hit-pay.com/v1/payment-requests');

    final headers = {
      'Content-Type': 'application/json',
      'X-BUSINESS-API-KEY': apiKey,
    };

    final body = jsonEncode({
      "amount": amount.toString(),
      "currency": "SGD",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final paymentUrl = responseData['url'];
        final paymentId = responseData['id']; 

        if (paymentUrl != null) {
          _redirectToPaymentUrl(context, paymentUrl,paymentId,deviceId,month);
        }
      } else {
        print("Failed to create payment request: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("Error creating payment request: $e");
    }
  }

  void _redirectToPaymentUrl(BuildContext context, String url,String paymentId,List<String> deviceId,String month) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(paymentUrl: url,paymentId: paymentId,deviceId: deviceId,month: month,),
      ),
    );
  }
}

