import 'package:enavatek_mobile/model/device_ac_dc_data.dart';
import 'package:enavatek_mobile/widget/circular_bar.dart';
import 'package:flutter/material.dart';

class MeterACBars extends StatelessWidget {
  final MeterAC meterAC;

  const MeterACBars({
    Key? key,
    required this.meterAC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularBar(
          label: 'Voltage',
          value: meterAC.voltage.value,
          unit: meterAC.voltage.unit,
          color: Colors.blue,
        ),
        CircularBar(
          label: 'Current',
          value: meterAC.current.value,
          unit: meterAC.current.unit,
          color: Colors.green,
        ),
        CircularBar(
          label: 'Power',
          value: meterAC.power.value,
          unit: meterAC.power.unit,
          color: Colors.orange,
        ),
        CircularBar(
          label: 'Frequency',
          value: meterAC.frequency.value,
          unit: meterAC.frequency.unit,
          color: Colors.red,
        ),
        CircularBar(
          label: 'Power Factor',
          value: meterAC.pf * 100, // Convert pf to percentage
          unit: '',
          color: Colors.purple,
        ),
        CircularBar(
          label: 'Energy',
          value: meterAC.energy.value,
          unit: meterAC.energy.unit,
          color: Colors.yellow,
        ),
      ],
    );
  }
}
