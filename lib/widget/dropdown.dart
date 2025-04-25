import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final bool readOnly;

  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  CustomDropdownButtonState createState() => CustomDropdownButtonState();
}

class CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

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
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: Text(
                    item.child is Text ? (item.child as Text).data ?? '' : '',
                    style: TextStyle(
                      fontSize:
                          isTablet ? screenWidth * 0.02 : screenWidth * 0.035,
                    ),
                  ),
                );
              }).toList(),
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
              disabledHint: Text(dropdownValue ?? '',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
