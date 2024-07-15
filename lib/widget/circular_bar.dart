import 'package:flutter/material.dart';

class CircularBar extends StatelessWidget {
  final double value;
  final String unit;
  final String label;
  final Color color;

  const CircularBar({
    Key? key,
    required this.value,
    required this.unit,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                strokeWidth: 12,
                value: value / 300, // Adjust max value if necessary

                valueColor: AlwaysStoppedAnimation<Color>(color),
                backgroundColor: Colors.grey,
              ),
            ),
            Text(
              '${value.toStringAsFixed(2)} $unit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
