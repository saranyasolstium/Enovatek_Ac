import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class AlertHelper {
  static void showMessage(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    final icon = isSuccess ? Icons.check_circle : Icons.error;
    final color = isSuccess ? Colors.green : Colors.red;

    showDialog(
      context: context,
      barrierDismissible: false, // prevent tap outside to close
      builder: (ctx) {
        Future.delayed(duration, () {
          if (Navigator.of(ctx).canPop()) {
            Navigator.of(ctx).pop();
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          content: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
