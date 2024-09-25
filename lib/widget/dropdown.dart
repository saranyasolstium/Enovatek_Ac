import 'package:enavatek_mobile/screen/device_details/power_statistics.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/value/dynamic_font.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final bool readOnly;

  CustomDropdownButton({
    required this.value,
    required this.items,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey[400] ?? Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: ConstantColors.borderColor, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              items: widget.items,
              onChanged: widget.readOnly
                  ? null
                  : (newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                      widget.onChanged(newValue);
                    },
              icon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                color: ConstantColors.appColor,
              ),
              iconSize: 24,
              elevation: 2,
              isExpanded: true,
              disabledHint: Text(dropdownValue ?? ''),
            ),
          ),
        ),
      ),
    );
  }
}
