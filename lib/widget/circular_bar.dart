import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';

class CircularBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final String unit;
  final String label;
  final Color color;

  const CircularBar({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the progress ratio as percentage
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    double progress = (value / maxValue) * 100;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: isTablet ? screenWidth * 0.03 : screenWidth * 0.04,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: isTablet ? 200 : 120,
          height: isTablet ? 200 : 120,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                showLabels: false,
                showTicks: false,
                startAngle: 270,
                endAngle: 270,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.15,
                  color: ConstantColors.unSelectColor,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: progress,
                    width: 0.15,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: color,
                    enableAnimation: true,
                    animationDuration: 1000,
                    animationType: AnimationType.ease,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: isTablet
                                ? screenWidth * 0.03
                                : screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor: 0.1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
