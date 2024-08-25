import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomTooltip extends StatelessWidget {
  final TooltipBehavior tooltipBehavior;

  CustomTooltip({required this.tooltipBehavior});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        tooltipBehavior: tooltipBehavior,
        // Chart configuration
      ),
    );
  }
}
