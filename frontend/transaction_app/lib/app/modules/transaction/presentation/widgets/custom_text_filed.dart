import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFiled extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool isMoney;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final List<TextInputFormatter> inputFormatters;
  final int? maxLength;

  const CustomTextFiled({
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.isMoney = false,
    this.controller,
    this.onChanged,
    this.inputFormatters = const [],
    this.maxLength
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
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
      ),
    );
  }
}
