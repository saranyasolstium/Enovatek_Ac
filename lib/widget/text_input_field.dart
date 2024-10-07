import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CustomTextInputField extends StatefulWidget {
  final String? value;

  const CustomTextInputField({required this.value});

  @override
  _CustomTextInputFieldState createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  late TextEditingController _controller;
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> selectMonthYear(BuildContext context) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    );

    if (selected != null) {
      setState(() {
        _selected = selected;
        _controller.text = "${selected.month}/${selected.year}";
      });
      // Print the selected date after updating the text field
      print('Selected date: ${_controller.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FocusScope( // Wrap with FocusScope for tab handling
        child: InkWell(
          onTap: () {
            print('saranya');
            selectMonthYear(context);
          },
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Select Date',
            ),
          ),
        ),
      ),
    );
  }
}