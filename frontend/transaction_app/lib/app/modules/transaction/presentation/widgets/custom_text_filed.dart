import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool isMoney;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextFiled({
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.isMoney = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardType =
        isMoney
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text;

    return TextField(
      onChanged: onChanged ?? (value) {},
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
